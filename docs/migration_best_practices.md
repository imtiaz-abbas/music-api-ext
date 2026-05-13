# Migration Best Practices

This project uses the [`strong_migrations`](https://github.com/ankane/strong_migrations) gem to catch unsafe database operations at migration time, before they can cause table locks or downtime in production.

## Why migrations can go wrong

PostgreSQL acquires locks when altering tables. On a small or idle database migrations look instant, but on a live table with millions of rows and concurrent reads/writes, the same operation can lock the entire table for seconds or minutes — blocking every query until it finishes.

`strong_migrations` raises an error (in development and CI) the moment you write such an operation, explains the danger, and shows the safe alternative.

## Safety classification of this project's migrations

| Migration | Operation | Safe? | Reason |
|---|---|---|---|
| `create_artists` | `create_table` | Safe | Brand-new table; no existing rows or locks |
| `create_songs` | `create_table` | Safe | Same |
| `create_playlists` | `create_table` | Safe | Same |
| `create_playlist_songs` | `create_table` | Safe | Same |
| `add_unique_index_to_playlist_songs` | `add_index` | Safe | Uses `algorithm: :concurrently` + `disable_ddl_transaction!` |

## Patterns to follow

### Adding an index on an existing table

Never use a plain `add_index` on a table that already has data — it holds a write lock for the entire build.

```ruby
# Unsafe
def change
  add_index :songs, :artist_id
end

# Safe
disable_ddl_transaction!

def change
  add_index :songs, :artist_id, algorithm: :concurrently
end
```

`algorithm: :concurrently` builds the index without blocking reads or writes. It requires `disable_ddl_transaction!` because concurrent index builds cannot run inside a transaction.

### Adding a column with a default value (Rails < 11 / Postgres < 11)

On older stacks, adding a NOT NULL column with a default rewrites every row. On modern Postgres (11+) and Rails 7.1+ this is handled safely via a metadata-only operation — but `strong_migrations` will warn you if your stack version makes it unsafe.

```ruby
# Potentially unsafe on older stacks
add_column :songs, :plays, :integer, default: 0, null: false

# Safe on any version: add nullable first, backfill, then add constraint
add_column :songs, :plays, :integer
change_column_default :songs, :plays, 0
# backfill in batches if needed
change_column_null :songs, :plays, false
```

### Removing a column

Active Record caches column information. If you remove a column in a migration before deploying code that no longer references it, queries in the old code will reference the now-missing column and raise errors.

```
Deploy order: (1) code that ignores the column → (2) migration that removes it
```

In Rails 7.1+ you can use `ignored_columns` on the model temporarily until the column is gone.

### Renaming a table or column

Renames are not atomic from the application's point of view. The safe path is:

1. Add the new column/table.
2. Write to both old and new in code.
3. Backfill the new column.
4. Switch reads to the new column.
5. Drop the old column in a later migration.

### Changing a column type

Type changes often require a full table rewrite in Postgres. Use the same multi-step approach above (new column → backfill → swap → drop old).

## Running `strong_migrations` locally

It activates automatically — no initializer needed. Run any migration and it will raise `StrongMigrations::UnsafeMigration` if the operation is unsafe, with a message explaining why and showing the safe alternative.

```
bundle exec rails db:migrate
```

To bypass it in a one-off situation where you are certain it is safe (e.g. a dev-only seed migration):

```ruby
class MyMigration < ActiveRecord::Migration[8.1]
  def change
    safety_assured { remove_column :table, :column }
  end
end
```

Only use `safety_assured` when you have explicitly reasoned through the lock implications. Never add it just to silence the warning.

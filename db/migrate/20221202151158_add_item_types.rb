class AddItemTypes < ActiveRecord::Migration[7.0]
  def change
    add_column :items, :item_type, :integer # enum: {book, movie, game, other}

    # columns are null if item is of different type
    # book
    add_column :items, :isbn, :integer
    add_column :items, :author, :string             # also for game
    add_column :items, :release_date, :date         # also for movie
    add_column :items, :genre, :string              # also for movie
    add_column :items, :language, :string           # also for movie, game
    add_column :items, :number_of_pages, :integer
    add_column :items, :publisher, :string          # also for game
    add_column :items, :edition, :integer

    # movie
    add_column :items, :director, :string
    add_column :items, :format, :string # {DVD, Blueray, mp4}
    add_column :items, :fsk, :integer

    # game
    add_column :items, :illustrator, :string
    add_column :items, :number_of_players, :integer
    add_column :items, :playing_time, :integer

    # other
    add_column :items, :category, :string
  end
end

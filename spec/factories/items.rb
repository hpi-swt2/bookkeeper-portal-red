FactoryBot.define do
  factory :item do

    name { "Item Name" }
    description { "Item Description" }

  end

  factory :book, class: 'Item' do
    item_type { "book" }
    name { "The communist manifesto" }
    description { "A book to rule them all" }

    isbn { 1_234_567_890_123 }
    author { "Karl Marx, Friedrich Engels" }
    release_date { "1848-02-21" }
    genre { "politics" }
    language { "english" }
    number_of_pages { 150 }
    publisher { "Burghard" }
    edition { 1 }
  end

  factory :movie, class: 'Item' do
    item_type { "movie" }
    name { "Harry Potter" }
    description { "Dumbledore and friends" }

    director { "Chris Columbus" }
    release_date { "2001-02-21" }
    format { "dvd" }
    genre { "fantasy" }
    language { "english" }
    fsk { 6 }
  end

  factory :game, class: 'Item' do
    item_type { "game" }
    name { "Skat" }
    description { "Classic card game" }

    author { "A Legend" }
    illustrator { "A Myth" }
    publisher { "Brockhaus" }
    number_of_players { 3 }
    playing_time { 60 }
    language { "english" }
  end

  factory :other, class: 'Item' do
    item_type { "other" }
    name { "Mars" }
    description { "Elon Musk's dream" }

    category { "Planet" }
  end
end

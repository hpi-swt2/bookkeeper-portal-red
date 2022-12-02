FactoryBot.define do
  factory :item do

    name { "Item Name" }
    description { "Item Description" }

  end

  factory :book, class: Item do
    item_type { "book" }
    name { "The communist manifesto" }
    description { "A book to rule them all" }
    
    isbn { 1234567890123 }
    author { "Karl Marx, Friedrich Engels" }
    release_date { "1848-02-21" }
    genre { "politics" }
    language { "english" }
    number_of_pages { 150 }
    publisher { "Burghard" }
    edition { 1 }

  end
end

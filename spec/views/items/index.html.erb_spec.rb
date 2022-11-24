require 'rails_helper'

RSpec.describe "items/index", type: :view do
  before do
    assign(:items, [
             Item.create!(
               name: "Communist Manifesto",
               description: "A book about communism, brought to you by Karl Marx, Friedrich Engels and Team Red"
             ),
             Item.create!(
               name: "The Hitchhikers Guide to the Galaxy",
               description: "A science fiction comedy adventure"
             )
           ])
  end

  pending "test rendered html"
end

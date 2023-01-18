require 'rails_helper'

RSpec.describe ItemsController, type: :controller do
  describe "GET export_csv" do
    it "returns a csv file" do
      # create some items to export
      item1 = FactoryBot.create(:item, name: 'Item 1')
      item2 = FactoryBot.create(:item, name: 'Item 2')
      item3 = FactoryBot.create(:item, name: 'Item 3')
      items = [item1, item2, item3]
      # make a GET request to the export_csv action
      get :export_csv, format: :csv

      # check that the response has the correct content type
      expect(response.content_type).to eq "text/csv"

      # parse the csv file and check that it includes the expected data
      csv_data = CSV.parse(response.body)
      expect(csv_data.length).to eq items.length + 2 # +2 for the header row and the categorie name
      expect(csv_data[0]).to eq ["Item type: other"]
      expect(csv_data[1]).to eq %w[name description max_borrowing_days max_reservation_days category]
      items.each_with_index do |item, i|
        expect(csv_data[i + 2]).to eq [item.name.to_s, item.description.to_s, item.max_borrowing_days.to_s,
                                       item.max_reservation_days.to_s, item.category]
      end
    end
  end
end

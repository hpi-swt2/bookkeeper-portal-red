json.extract! item, :id, :name, :description, :created_at, :updated_at, :lat, :lng
json.url item_url(item, format: :json)

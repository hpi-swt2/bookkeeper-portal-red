# Export items to CSV file
class CsvExport
  def self.to_csv(items)
    csv_string = []
    items.group_by(&:item_type).each do |type, items_of_type|
      csv_data = CSV.generate(headers: true) do |csv|
        add_entries_to_csv(csv, type, items_of_type)
      end
      csv_string << csv_data
    end
    csv_string.join
  end

  def self.add_entries_to_csv(csv, type, items_of_type)
    csv << ["Item type: #{type}"]
    csv << Item.attributes(type).map(&:to_s)
    items_of_type.each do |item|
      csv << Item.attributes(type).map { |attr| item.send(attr) }
    end
  end
end

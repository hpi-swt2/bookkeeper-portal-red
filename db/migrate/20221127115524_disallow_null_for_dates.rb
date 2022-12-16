class DisallowNullForDates < ActiveRecord::Migration[7.0]
  def change
    change_column_null(:lendings, :started_at, false)
    change_column_null(:lendings, :due_at, false)

    change_column_null(:reservations, :starts_at, false)
    change_column_null(:reservations, :ends_at, false)
  end
end

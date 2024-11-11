class FixEmployeeRegisteredColumnName < ActiveRecord::Migration[7.1]
  def change
    rename_column :employees, :resgistered, :registered
  end
end

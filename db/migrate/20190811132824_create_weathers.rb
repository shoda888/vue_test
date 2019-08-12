class CreateWeathers < ActiveRecord::Migration[5.1]
  def change
    create_table :weathers do |t|
      t.string :area
      t.string :temp
      t.string :description
      t.string :max_temp
      t.string :min_temp
      t.string :humidity

      t.timestamps
    end
  end
end

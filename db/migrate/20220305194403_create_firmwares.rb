class CreateFirmwares < ActiveRecord::Migration[7.0]
  def change
    create_table :firmwares do |t|
      t.integer :firmware_repository_id
      t.integer :version_number
      t.string :release_type
      t.boolean :for_release
      t.string :path_to_bin
      t.boolean :is_hidden

      t.timestamps
    end
  end
end

class CreateFirmwareRepositories < ActiveRecord::Migration[7.0]
  def change
    create_table :firmware_repositories do |t|
      t.string :project
      t.string :description

      t.timestamps
    end
  end
end

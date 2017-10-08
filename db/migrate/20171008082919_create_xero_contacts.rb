class CreateXeroContacts < ActiveRecord::Migration[5.1]
  def change
    enable_extension 'pgcrypto'
    create_table :xero_contacts, id: :uuid do |t|
      t.string :name
      t.string :status
      t.json :data, null: false, default: {}

      t.timestamps
    end
  end
end

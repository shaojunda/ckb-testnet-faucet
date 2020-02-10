class CreateAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :accounts do |t|
      t.string :address_hash
      t.decimal :balance, precision: 30, default: 0

      t.timestamps
    end
  end
end

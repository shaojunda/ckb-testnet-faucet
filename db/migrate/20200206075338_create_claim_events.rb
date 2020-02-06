class CreateClaimEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :claim_events do |t|
      t.string :address_hash
      t.integer :capacity
      t.integer :created_at_unixtimestamp
      t.integer :status, limit: 1, default: "0"
      t.bigint :ckb_transaction_id
      t.inet :ip_addr
      t.decimal :fee, precision: 20
      t.string :tx_hash
      t.integer :tx_status, limit: 1, default: "0"

      t.timestamps
    end
  end
end

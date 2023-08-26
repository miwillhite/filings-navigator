class CreateFilers < ActiveRecord::Migration[7.0]
  def change
    create_table :filings do |t|
      t.timestamp :return_timestamp, null: false
      t.timestamp :tax_period_start, null: false
      t.timestamp :tax_period_end, null: false
      t.timestamps
    end

    create_table :filers do |t|
      t.string :ein, null: false, index: { unique: true }
      t.string :business_name, null: false
      t.references :filing, foreign_key: true
      t.timestamps
    end

    create_table :recipients do |t|
      t.string :ein
      t.references :filing, foreign_key: true
      t.string :business_name, null: false
      t.timestamps
    end

    create_table :awards do |t|
      t.references :recipient, foreign_key: true
      t.string :purpose
      t.integer :amount_in_dollars
      t.timestamps
    end

    create_table :addresses do |t|
      t.string :street1, null: false
      t.string :street2
      t.string :city, null: false
      t.string :state, null: false
      t.string :postal_code, null: false
      t.references :addressable, polymorphic: true
      t.timestamps
    end
  end
end

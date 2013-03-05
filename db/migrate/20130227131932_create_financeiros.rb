class CreateFinanceiros < ActiveRecord::Migration
  def self.up
    create_table :financeiros do |t|
      t.references :unidade
      t.datetime :data
      t.string :descricao
      t.decimal :credito
      t.decimal :debito
      t.string :obs

      t.timestamps
    end
  end

  def self.down
    drop_table :financeiros
  end
end

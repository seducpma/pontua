class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table "users", :force => true do |t|
      t.references :unidade
      t.references :obreiro
      t.string   :login,                     :limit => 40
      t.string   :name,                      :limit => 100, :default => '', :null => true
      t.string   :email,                     :limit => 100
      t.string   :crypted_password,          :limit => 40
      t.string   :salt,                      :limit => 40
      t.datetime :created_at
      t.datetime :updated_at
      t.string   :remember_token,            :limit => 40
      t.datetime :remember_token_expires_at
      t.string   :password_reset_code,       :limit => 255
      t.string   :activation_code,           :limit => 40
      t.datetime :activated_at

    end
    add_index :users, :login, :unique => true
    User.create :login => 'admin', :email => 'naorgarciaf@hotmai.com',:password => 's3inf09', :password_confirmation => 's3inf09'
  end

  def self.down
    drop_table "users"
  end
end

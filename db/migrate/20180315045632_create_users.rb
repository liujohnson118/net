class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :email
      t.string :age
      t.string :phone
      t.string :admin
      t.string :password_digest

      t.timestamps
    end
  end
end

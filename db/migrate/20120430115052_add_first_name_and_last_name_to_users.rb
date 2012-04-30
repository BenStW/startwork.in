class AddFirstNameAndLastNameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    
    User.all.each do |u|
      u.first_name = u.name
      u.save
    end
  end
end

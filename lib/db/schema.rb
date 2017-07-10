ActiveRecord::Schema.define do

  def exists? table_name
    ActiveRecord::Base.connection.data_source_exists? table_name
  end

  create_table :users do |t|
    t.string :name
    t.string :contact_method
    t.string :phone
    t.string :email
    t.string :contact_time
  end unless exists? :users

  create_table :lines do |t|
    t.references :user
    t.string :text
  end unless exists? :lines

end

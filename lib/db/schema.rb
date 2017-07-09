ActiveRecord::Schema.define do

  create_table "users" do |t|
    t.string :name
    t.string :contact_method
    t.string :phone
    t.string :email
    t.string :contact_time
  end

  create_table "lines" do |t|
    t.references :user
    t.string :text
  end

end

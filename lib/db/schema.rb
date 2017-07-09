ActiveRecord::Schema.define do

  unless ActiveRecord::Base.connection.data_source_exists? "users"
    create_table "users" do |t|
      t.string :name
      t.string :contact_method
      t.string :phone
      t.string :email
      t.string :contact_time
    end
  end

  unless ActiveRecord::Base.connection.data_source_exists? "lines"
    create_table "lines" do |t|
      t.references :user
      t.string :text
    end
  end

end

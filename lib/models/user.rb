class User < ActiveRecord::Base

  has_many :lines

  def add_line line
    lines.create(text: line)
  end

  def last_line
    lines.last.text
  end

end

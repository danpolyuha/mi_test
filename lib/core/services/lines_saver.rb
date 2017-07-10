class LinesSaver

  def initialize user
    self.user = user
  end

  def user_line text
    if text
      text = format_user_line(text)
      user.add_line(text)
    end
  end

  def bot_line text
    if text
      text = format_bot_line(text)
      user.add_line(text)
    end
  end

  private

  attr_accessor :user

  def format_user_line text
    "USER: #{text}"
  end

  def format_bot_line text
    "BOT: #{text}"
  end

end

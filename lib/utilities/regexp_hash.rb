class RegexpHash < Hash

  def match string
    return nil unless string.is_a?(String)

    regex = regexp_keys.find{|key| key =~ string}

    return regex ? self[regex] : nil
  end

  private

  def regexp_keys
    keys.select{|key| key.is_a?(Regexp)}
  end

end

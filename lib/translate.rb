module TRANSLATE
  def translate(position)
    [translate_x(position[0]), translate_y(position[1])]
  end

  def translate_x(position)
    position.ord - 'a'.ord
  end

  def translate_y(position)
    (position.to_i - 8).abs
  end

  def translate_x_back(number)
    (number + 'a'.ord).chr
  end

  def translate_y_back(number)
    (number - 8).abs
  end

  def translate_back(position)
    "#{translate_x_back(position[0])}#{translate_y_back(position[1])}"
  end
end

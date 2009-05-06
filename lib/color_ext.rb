class Color::RGB
  Mauve = Color::RGB.new(0xe0, 0xb0, 0xff)
  Mauve.freeze

  def relative_red_p=(p)
    self.red_p = self.calculate_new_p(self.red_p, p)
  end

  def relative_green_p=(p)
    self.green_p = self.calculate_new_p(self.green_p, p)
  end

  def relative_blue_p=(p)
    self.blue_p = self.calculate_new_p(self.blue_p, p)
  end

  protected
  def calculate_new_p(absolute_p, relative_p)
    relative_p = 100 if relative_p > 100
    relative_p = -100 if relative_p < -100
    
    new_p = absolute_p + relative_p
    new_p = 100 if new_p > 100
    new_p = 0 if new_p < 0
    
    new_p
  end

  class << self
    def from_param(name)
      color = Color::RGB.from_constant_name(name)
      color ||= Color::RGB.from_html_or_nil(name)
      color ||= Color::RGB::White
      color = Color::RGB.new(color.red, color.green, color.blue) if color.frozen?
      color
    end

    def from_html_or_nil(name)
      begin
        Color::RGB.from_html(name)
      rescue ArgumentError
        return nil
      end
    end

    def from_constant_name(name)
      # TODO: Make this handle humpy color names
      begin
        rgb_name = "Color::RGB::#{name.capitalize}"
        if Object.module_eval("defined?(#{rgb_name})")
          Object.module_eval("#{rgb_name}")
        else
          return nil
        end
      rescue SyntaxError
        return nil
      end
    end
  end
end

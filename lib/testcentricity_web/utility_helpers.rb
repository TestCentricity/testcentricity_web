class Object
  def blank?
    respond_to?(:empty?) ? empty? : !self
  end

  def present?
    !blank?
  end

  def boolean?
    [true, false].include? self
  end
end


class String
  def to_bool
    return true if self == true || self =~ (/(true|t|yes|y|x|1)$/i)
    return false if self == false || self.blank? || self =~ (/(false|f|no|n|0)$/i)
    raise ArgumentError.new("invalid value for Boolean: \"#{self}\"")
  end

  def string_between(marker1, marker2)
    self[/#{Regexp.escape(marker1)}(.*?)#{Regexp.escape(marker2)}/m, 1]
  end

  def format_date_time(date_time_format)
    return if self.blank?
    new_date = DateTime.parse(self)
    if ENV['LOCALE'] && date_time_format.is_a?(Symbol)
      I18n.l(new_date, format: date_time_format)
    else
      new_date.strftime(date_time_format)
    end
  end

  def titlecase
    "#{self.split.each{ |text| text.capitalize! }.join(' ')}"
  end

  def is_int?
    Integer(self) && true rescue false
  end

  def is_float?
    Float(self) && true rescue false
  end
end

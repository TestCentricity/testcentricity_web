class Object
  def blank?
    respond_to?(:empty?) ? empty? : !self
  end

  def present?
    !blank?
  end
end


class String
  def to_bool
    return true  if self == true  || self =~ (/(true|t|yes|y|x|1)$/i)
    return false if self == false || self.blank? || self =~ (/(false|f|no|n|0)$/i)
    raise ArgumentError.new("invalid value for Boolean: \"#{self}\"")
  end

  def format_date_time(date_time_format)
    return if self.blank?
    new_date = DateTime.parse(self)
    new_date.strftime(date_time_format)
  end
end

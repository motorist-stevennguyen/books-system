class DatetimeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add attribute, "is missing on required field" if value.blank?
    date_time = DateTime.strptime("#{value}", "%Y-%m-%d")
    record.errors.add attribute, "must be before current date" if Time.new(date_time.to_s).after?(Time.now)
  end
end

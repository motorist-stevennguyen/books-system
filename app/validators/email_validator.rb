class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value.blank?
      record.errors.add attribute, " is empty!"
      return
    end
    if !URI::MailTo::EMAIL_REGEXP.match?(value)
      record.errors.add attribute, " is not valid!"
    end
  end
end

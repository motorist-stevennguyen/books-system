class PasswordValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value.blank?
      record.errors.add attribute, " is empty!"
      nil
    end
  end
end

class RegisterValidator < ActiveModel::Validator
  def validate(record)
    record.errors.add :username, "is requirement field" if record.username.blank?
    record.errors.add :confirmation_password, "is requirement field" if record.confirmation_password.blank?

    if record.confirmation_password != record.password
      record.errors.add :confirmation_password, "dose not match!"
    end
  end
end

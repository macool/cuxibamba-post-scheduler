class FutureValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if record[attribute] < (Time.zone.now.beginning_of_day - 1.day)
      record.errors[attribute] << (options[:message] || "debe ser una fecha en el futuro")
    end
  end
end

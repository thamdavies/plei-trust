module ApplicationHelper
  def json_validations_for(model, field)
    validations_hash = {}

    validators = model.class.validators_on(field)
    validators.each do |validator|
      validator_name = validator.class.name.demodulize.underscore.to_sym

      if validator_name == :length_validator
        options = validator.options.dup
        validations_hash[:length] = { min: options[:minimum].present? ? options[:minimum] : 1,
        max: options[:maximum].present? ? options[:maximum] : 1000 }
      end

      validations_hash[:presence] = true if validator_name == :presence_validator
      validations_hash[:numericality] = true if validator_name == :numericality_validator
    end

    validations_hash[:strong_password] = true if field == :password
    validations_hash[:email] = true if field == :email

    validations = validations_hash.map do |key, value|
      { key.to_s => value }
    end

    validations.to_json.html_safe
  end
end

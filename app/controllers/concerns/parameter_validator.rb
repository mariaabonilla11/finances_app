module ParameterValidator
  extend ActiveSupport::Concern

  # Valida que los parámetros requeridos estén presentes
  # @param required_fields [Array] Lista de campos requeridos como símbolos o strings
  # @param source [Hash] Hash de parámetros a validar (por defecto params)
  # @return [Boolean] true si todos los campos están presentes, false caso contrario
  def validate_required_params(required_fields, source = params)
    missing_fields = []

    required_fields.each do |field|
      if source[field].blank?
        missing_fields << field.to_s
      end
    end

    if missing_fields.any?
      result = render_missing_params_error(missing_fields)
      return {result: result, valid: false}
    end

    {result: nil, valid: true}
  end

  def render_missing_params_error(missing_fields)
    errors = missing_fields.map do |field|
      {
        field: field,
        message: "El campo '#{field}' es requerido",
      }
    end
  end

  # Valida que la fecha tenga formato ISO8601 (ejemplo: "2035-09-09T14:34:15Z")
  def validate_date_format(date_string)
    DateTime.iso8601(date_string)
    true
  rescue ArgumentError, TypeError
    false
  end
end
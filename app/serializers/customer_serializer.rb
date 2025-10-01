class CustomerSerializer
  include JSONAPI::Serializer

  attributes :id, :full_name, :national_id, :phone, :national_id_issued_date, :national_id_issued_place, :address
end

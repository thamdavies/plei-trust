json.error do
  json.code @error.fetch(:code)
  json.message @error.fetch(:message)
end

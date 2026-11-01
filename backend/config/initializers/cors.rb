origins = ENV.fetch("FRONTEND_ORIGINS", "http://localhost:5173,http://127.0.0.1:5173")
  .split(",")
  .map(&:strip)
  .reject(&:empty?)

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins(*origins)

    resource "/api/*",
      headers: %w[Authorization Content-Type Accept],
      methods: %i[get post delete options head],
      credentials: true,
      max_age: 600
  end
end

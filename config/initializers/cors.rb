# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin AJAX requests.

# Read more: https://github.com/cyu/rack-cors

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'http://localhost:3001', 'http://127.0.0.1:3000', 'http://127.0.0.1:3001', 'http://localhost:3000',
            'http://192.168.50.104:3000', 'https://nfc-checkin-nextjs-demo.vercel.app', 'https://prod-nfc-checkin-nextjs.vercel.app', 'https://nfc.travel3exp.xyz', 'https://stamp.travel3exp.xyz'

    resource '*',
             headers: :any,
             methods: %i[get post put patch delete options head],
             expose: ['Authorization']
  end
end

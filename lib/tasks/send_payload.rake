require 'net/http'
require 'uri'
require 'json'

namespace :send do
    desc 'send post request to report controller'
    task :payload => :environment do
        url = Rails.env.development? ? 'http://localhost:3000/reports' : 'https://wwww.alert-api-app.onrender.com/reports/'
        uri = URI(url)
        payload = JSON.parse(Rails.root.join('lib/payloads.json').read)
        params = payload['payloads'][rand(0..1)]
        response = Net::HTTP.post_form(uri, params)

        puts response.body
    end
end

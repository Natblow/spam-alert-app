require 'net/http'
require 'uri'
require 'json'

namespace :send do
    desc 'send post request to report controller'
    task :payload => :environment do
        uri = URI("http://localhost:3000/reports")
        payload = JSON.parse(Rails.root.join('lib/payloads.json').read)
        params = payload['payloads'][rand(0..1)]
        response = Net::HTTP.post_form(uri, params)

        puts response.body if response.is_a?(Net::HTTPSuccess)
    end
end

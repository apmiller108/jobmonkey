module Astronomania
  class Import
    BASE_URL = {
      staging: 'https://astronomania-api-staging.herokuapp.com/',
      production: 'https://astronomania-api-production.herokuapp.com/'
    }.freeze

    def self.call(environment:)
      new(environment).call
    end

    def initialize(environment)
      @environment = environment
      @conn = Faraday.new
    end

    def call
      return unless authenticate
      res = @conn.post do |req|
        req.url BASE_URL[@environment] + '/admin/jobs'
        req.headers['Content-Type'] = 'application/json'
        req.headers['Authorization'] = "Bearer #{@auth_token}"
        req.body = request_body
      end
      puts res.status
    end

    private

    def authenticate
      response = @conn.post do |req|
        req.url BASE_URL[@environment] + 'users/login'
        req.headers['Content-Type'] = 'application/json'
        req.body = auth_request_body
      end

      return false unless response.status == 200
      @auth_token = JSON.parse(response.body)['auth_token']
    end

    def request_body
      {
        job: {
          job_type: 'import'
        }
      }.to_json
    end

    def auth_request_body
      {
        authenticate: {
          email: ENV['ASTRONOMANIA_CREDENTIALS_EMAIL'],
          password: ENV['ASTRONOMANIA_CREDENTIALS_PASSWORD']
        }
      }.to_json
    end
  end
end

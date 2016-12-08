# frozen_string_literal: true
require 'faraday'
require 'json'

module Gomail
  class Client
    def initialize(base_url, api_key)
      @base_url = base_url
      @api_key = api_key
    end

    def send_email(template_name, to:, model: {})
      to_arr = [to].flatten
      params = {
        to: to_arr,
        model: model
      }
      response = post("/send/#{template_name}", @api_key, params)
    end

    # def render_template(template_name, model = {})
    #   response = post("/render/#{template_name}", @api_key, model: {})
    # end

    private

    def get(url, api_key, params = {})
      response = conn.get url, params do |req|
        req.headers['Content-Type'] = 'application/json'
        req.headers['app-key'] = api_key
      end
      case response.status
      when 200..299
        JSON.parse(response.body, symbolize_names: true)
      else
        raise Error, JSON.parse(response.body, symbolize_names: true)
      end
    end

    def post(url, api_key, params = {})
      response = conn.post url do |req|
        req.headers['Content-Type'] = 'application/json'
        req.headers['app-key'] = api_key
        req.body = params.to_json
      end
      case response.status
      when 200..299
        JSON.parse(response.body, symbolize_names: true)
      when 400
        raise SchemaError, JSON.parse(response.body, symbolize_names: true)
      else
        raise Error, JSON.parse(response.body, symbolize_names: true)
      end
    end

    def conn
      @conn ||= Faraday.new(@base_url) do |b|
        b.adapter :net_http
      end
    end
  end
end

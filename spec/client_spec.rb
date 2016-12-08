# frozen_string_literal: true
require 'spec_helper'

describe Gomail::Client, :vcr do
  let(:client) do
    described_class.new('http://mail.go.intami.pl',
                        api_key)
  end
  let(:api_key) { ENV.fetch('API_KEY', 'some.fake.key') }

  describe '#send_email' do
    it 'works' do
      client.send_email('example01', to: 'tuvshupe@sharklasers.com', model: { foo: 'bar' })
    end
  end
end

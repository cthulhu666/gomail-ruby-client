# frozen_string_literal: true
require 'gomail/version'
require 'gomail/client'

module Gomail
  Error = Class.new(RuntimeError)
  SchemaError = Class.new(Error)
end

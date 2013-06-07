require "effective_pages/engine"
require 'migrant'     # Required for rspec to run properly

module EffectivePages
  mattr_accessor :pages_table_name

  def self.setup
    yield self
  end
end

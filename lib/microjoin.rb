require "microjoin/version"
require "microjoin/join_respondant"

module Microjoin
  def self.call(l, r)
    JoinRespondant.new(l, r)
  end
end

require 'acts_as_decimal'
ActiveRecord::Base.class_eval do
  include Nestegg::Acts::Decimal
end

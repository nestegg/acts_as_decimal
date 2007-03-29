require 'bigdecimal'

module Nestegg #:nodoc:
  module Acts #:nodoc:
    module Decimal #:nodoc:

      def self.append_features(base)
        super
        base.extend(ClassMethods)
      end

      module ClassMethods

        ####################
        # Defines the specified column(s) to be a BigDecimal of the specified precision.
        #
        #   acts_as_decimal :rate, :precision => 4
        #   acts_as_decimal :cost, :sales_price, :retail_price, :precision => 2

        def acts_as_decimal(*args)
          class_eval do
            include InstanceMethods
          end
          prec = 0
          if args.last.is_a? Hash
            options = args.pop
            prec = options[:precision].to_i unless options[:precision].nil?
          end
          args.each do |c|
            class_eval <<-EOV

              def #{c.to_s}
                from_decimal_attribute(:#{c.to_s}, #{prec})
              end

              def #{c.to_s}=(v)
                to_decimal_attribute(:#{c.to_s}, #{prec}, v)
              end

            EOV
          end
        end

      end # ClassMethods


      module InstanceMethods

        ####################
        # integer_to_decimal is the method used to convert from the integer column
        # representation to the BigDecimal representation.
        #
        #  integer_to_decimal(12345, 2) => #<BigDecimal:...,'0.12345E3',8(40)>
        #  integer_to_decimal(12345, 2).to_s => "123.45"

        def integer_to_decimal(i, p)
          BigDecimal.new(i.to_s) / BigDecimal('10').power(p)
        end

        ####################
        # decimal_to_integer is the method used to convert from the decimal to the
        # integer column representation.
        #
        #   f.decimal_to_integer(123, 2) => 12300
        #   f.decimal_to_integer(123.456, 2) => 12345
        #   f.decimal_to_integer("123.456", 2) => 12345
        #   f.decimal_to_integer(BigDecimal.new("123.456"), 2) => 12345

        def decimal_to_integer(d, p)
          (BigDecimal.new(d.to_s) * BigDecimal('10').power(p)).to_i
        end

        private

        def to_decimal_attribute(n, p, v)
          return write_attribute(n, '') if v.nil?
          write_attribute(n, decimal_to_integer(v, p))
        end

        def from_decimal_attribute(n, p)
          return nil if read_attribute(n).nil?
          integer_to_decimal(read_attribute(n), p)
        end

      end # InstanceMethods

    end # Decimal
  end # Acts
end # Nestegg

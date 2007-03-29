$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'test/unit'
ENV['RAILS_ENV'] = 'test'
require File.expand_path(File.join(File.dirname(__FILE__), '../../../../config/environment.rb'))
require 'action_controller/test_process'
require File.join(File.dirname(__FILE__), '../init.rb')

class ActsAsDecimal < ActiveRecord::Base

  acts_as_decimal :a, :precision => 0
  acts_as_decimal :b, :precision => 1
  acts_as_decimal :c, :precision => 2
  acts_as_decimal :d, :precision => 3
  acts_as_decimal :e, :precision => 4
  acts_as_decimal :f, :precision => 5

end

class ActsAsDecimalTest < Test::Unit::TestCase

  def setup
    create_table
    @r = ActsAsDecimal.new
  end

  def test_me
    assert_nil @r.a
    @r.a = 0
    assert_equal '0.0', @r.a.to_s
    assert_instance_of BigDecimal, @r.a
    @r.a = nil
    @r.save
    assert_nil @r.a

    set_all(0)
    check_all('0.0', '0.0', '0.0', '0.0', '0.0', '0.0')
    @r.save
    @r = ActsAsDecimal.find(@r.id)
    check_all('0.0', '0.0', '0.0', '0.0', '0.0', '0.0')

    @r = ActsAsDecimal.new
    set_all('987.654321')
    check_all('987.0', '987.6', '987.65', '987.654', '987.6543', '987.65432')
    @r.save
    @r = ActsAsDecimal.find(@r.id)
    check_all('987.0', '987.6', '987.65', '987.654', '987.6543', '987.65432')

    @r = ActsAsDecimal.new
    set_all(987.654321)
    check_all('987.0', '987.6', '987.65', '987.654', '987.6543', '987.65432')
    @r.save
    @r = ActsAsDecimal.find(@r.id)
    check_all('987.0', '987.6', '987.65', '987.654', '987.6543', '987.65432')

    @r = ActsAsDecimal.new
    set_all(123)
    check_all('123.0', '123.0', '123.0', '123.0', '123.0', '123.0')
    @r.save
    @r = ActsAsDecimal.find(@r.id)
    check_all('123.0', '123.0', '123.0', '123.0', '123.0', '123.0')
  end

  def set_all(v)
    @r.a = v
    @r.b = v
    @r.c = v
    @r.d = v
    @r.e = v
    @r.f = v
  end

  def check_all(a, b, c, d, e, f)
    assert_equal a, @r.a.to_s
    assert_equal b, @r.b.to_s
    assert_equal c, @r.c.to_s
    assert_equal d, @r.d.to_s
    assert_equal e, @r.e.to_s
    assert_equal f, @r.f.to_s
  end

  def create_table
    ActiveRecord::Schema.define(:version => 0) do
      create_table :acts_as_decimals, :force => true do |t|
        t.column :a, :integer, :null => true
        t.column :b, :integer, :null => true
        t.column :c, :integer, :null => true
        t.column :d, :integer, :null => true
        t.column :e, :integer, :null => true
        t.column :f, :integer, :null => true
      end
    end
  end

end

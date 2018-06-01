module Minitest
end
Minitest::Expectation = Struct.new :target, :ctx # :nodoc:

module Kernel
  def describe desc, *additional_desc, &block
    stack = Minitest::Spec.describe_stack
    name  = [stack.last, desc, *additional_desc].compact.join("::")
    sclas = stack.last || if Class === self && kind_of?(Minitest::Spec::DSL) then
                            self
                          else
                            Minitest::Spec
                            # Minitest::Spec.spec_type desc, *additional_desc
                          end

    cls = sclas.create name, desc

    stack.push cls
    cls.class_eval(&block)
    stack.pop
    cls
  end
end

class MTest::Unit::TestCase
  # NOTE: MTest::Unit::TestCase#assert_raise ignores subclassing chain, so copy this from
  # https://github.com/seattlerb/minitest/blob/master/lib/minitest/assertions.rb
  # and use it via must_raise
  def assert_raises *exp
    msg = "#{exp.pop}.\n" if String === exp.last
    exp << StandardError if exp.empty?

    begin
      yield
    rescue *exp => e
      pass # count assertion
      return e
    rescue MTest::Skip
      # don't count assertion
      raise
    rescue Exception => e
      flunk proc {
        exception_details(e, "#{msg}#{mu_pp(exp)} exception expected, not")
      }
    end

    exp = exp.first if exp.size == 1

    flunk "#{msg}#{mu_pp(exp)} expected but nothing was raised."
  end

  def refute_respond_to(obj, meth, msg = nil)
    msg ||= "Expected #{obj.inspect} to not respond to ##{meth}"
    assert_false obj.respond_to?(meth), msg
  end

end

class Minitest::Spec < MTest::Unit::TestCase

  $__minitest_current_spec = nil
  def self.current # :nodoc:
    $__minitest_current_spec
  end

  def initialize name = nil # :nodoc:
    super
    $__minitest_current_spec = self
  end

  ##
  # Oh look! A Minitest::Spec::DSL module! Eat your heart out DHH.

  module DSL

    STACK = []
    def describe_stack
      STACK
    end

    def children # :nodoc:
      @children ||= []
    end

    def nuke_test_methods! # :nodoc:
      self.instance_methods.map(&:to_s).grep(/^test_/).each do |name|
        self.send :undef_method, name
      end
    end

    def before _type = nil, &block
      define_method :setup do
        super()
        self.instance_eval(&block)
      end
    end

    def after _type = nil, &block
      define_method :teardown do
        self.instance_eval(&block)
        super()
      end
    end

    def it desc = "anonymous", &block
      block ||= proc { skip "(no tests defined)" }

      @specs ||= 0
      @specs += 1

      name = "test_%04d_%s" % [ @specs, desc ]

      # undef_klasses = self.children.reject { |c| c.public_method_defined? name }

      define_method name, &block

      # undef_klasses.each do |undef_klass|
      #   undef_klass.send :undef_method, name
      # end

      name
    end

    def let name, &block
      name = name.to_s
      pre, post = "let '#{name}' cannot ", ". Please use another name."
      methods = Minitest::Spec.instance_methods.map(&:to_s) - %w[subject]
      raise ArgumentError, "#{pre}begin with 'test'#{post}" if
        name =~ /\Atest/
      raise ArgumentError, "#{pre}override a method in Minitest::Spec#{post}" if
        methods.include? name

      define_method name do
        @_memoized ||= {}
        @_memoized.fetch(name) { |k| @_memoized[k] = instance_eval(&block) }
      end
    end

    def subject &block
      let :subject, &block
    end

    def create name, desc # :nodoc:
      cls = Class.new(self) do
        @name = name
        @desc = desc

        nuke_test_methods!
      end

      children << cls

      cls
    end

    def name # :nodoc:
      @name ? @name : super
    end

    def to_s # :nodoc:
      name # Can't alias due to 1.8.7, not sure why
    end

    attr_reader :desc # :nodoc:
    alias :specify :it

    module InstanceMethods
      def _ value = nil, &block
        Minitest::Expectation.new block || value, self
      end

      alias value _
      alias expect _

      def before_setup # :nodoc:
        super
        # Thread.current[:current_spec] = self
        $__minitest_current_spec = self
      end
    end

    def self.extended obj # :nodoc:
      obj.send :include, InstanceMethods
    end
  end

  extend DSL

end

module Minitest::Expectations
  UNDEFINED = Object.new # :nodoc:

  def must_be(op, other = UNDEFINED, msg = nil)
    return assert_predicate self, op, msg if UNDEFINED == other
    msg ||= "Expected #{self.inspect} to be #{op} #{other.inspect}"
    assert self.__send__(op, other), msg
  end

  def must_be_empty(msg = nil)
    msg ||= "Expected #{self.inspect} to be empty"
    Minitest::Spec.current.assert_respond_to(self, :empty?)
    Minitest::Spec.current.assert_true(self.empty?, msg)
  end

  def must_equal(exp, msg = nil)
    Minitest::Spec.current.assert_equal(exp, self, msg)
  end

  # def must_be_close_to; end

  # def must_be_within_epsilon; end

  def must_include(obj, msg = nil)
    Minitest::Spec.current.assert_include(self, obj, msg)
  end

  def must_be_instance_of(cls, msg = nil)
    msg ||= "Expected #{self.inspect} to be an instance of #{cls}, not #{self.class}"
    Minitest::Spec.current.assert_true(self.instance_of?(cls), msg)
  end

  def must_be_kind_of(cls, msg = nil)
    msg ||= "Expected #{self.inspect} to be a kind of #{cls}, not #{self.class}"
    Minitest::Spec.current.assert_true(self.kind_of?(cls), msg)
  end

  def must_match(matcher, msg = nil)
    msg ||= "Expected #{matcher.inspect} to match #{self.inspect}"
    Minitest::Spec.current.assert_respond_to(matcher, :"=~")
    matcher = Regexp.new(Regexp.escape(matcher)) if String === matcher
    Minitest::Spec.current.assert_true(matcher =~ self, msg)
  end

  def must_be_nil(msg = nil)
    Minitest::Spec.current.assert_nil(self, msg)
  end

  def must_be(op, obj = UNDEFINED, msg = nil)
    if UNDEFINED == obj
      msg ||= "Expected #{self.inspect} to be #{op}"
      Minitest::Spec.current.assert_true(self.__send__(op), msg)
    else
      msg ||= "Expected #{self.inspect} to be #{op} #{obj.inspect}"
      Minitest::Spec.current.assert_true(self.__send__(op, obj), msg)
    end
  end

  # def must_output; end

  # TODO: move to Proc?
  def must_raise(*exp)
    return unless Proc === self
    Minitest::Spec.current.assert_raises(*exp, &self)
  end

  def must_respond_to(meth, msg = nil)
    Minitest::Spec.current.assert_respond_to(self, meth, msg)
  end

  # def must_be_same_as; end

  # def must_be_silent; end

  def must_throw(sym, msg = nil)
    return unless Proc == self
    Minitest::Spec.current.assert_throws(sym, msg, &self)
  end

  def wont_be_empty(msg = nil)
    msg ||= "Expected #{self.inspect} to not be empty"
    Minitest::Spec.current.assert_respond_to(self, :empty?)
    Minitest::Spec.current.assert_false(self.empty?, msg)
  end

  def wont_equal(exp, msg = nil)
    Minitest::Spec.current.assert_not_equal(exp, self, msg)
  end

  # def wont_be_close_to; end

  # def wont_be_within_epsilon; end

  def wont_include(obj, msg = nil)
    Minitest::Spec.current.assert_not_include(self, obj, msg)
  end

  def wont_be_instance_of(cls, msg = nil)
    msg ||= "Expected #{self.inspect} to not be an instance of #{cls}"
    Minitest::Spec.current.assert_false(self.instance_of?(cls), msg)
  end

  def wont_be_kind_of(cls, msg = nil)
    msg ||= "Expected #{self.inspect} to not be a kind of #{cls}"
    Minitest::Spec.current.assert_false(self.kind_of?(cls), msg)
  end

  def wont_match(matcher, msg = nil)
    msg ||= "Expected #{matcher.inspect} to not match #{self.inspect}"
    Minitest::Spec.current.assert_respond_to(matcher, :"=~")
    matcher = Regexp.new(Regexp.escape(matcher)) if String === matcher
    Minitest::Spec.current.refute(matcher =~ self, msg)
  end

  def wont_be_nil(msg = nil)
    msg ||= "Expected #{self.inspect} to not be nil"
    diff = Minitest::Spec.current.assertion_diff(nil, self)
    Minitest::Spec.current.assert_false(self.nil?, msg, diff)
  end

  def wont_be(op, obj = UNDEFINED, msg = nil)
    if UNDEFINED == obj
      msg ||= "Expected #{self.inspect} to not be #{op}"
      Minitest::Spec.current.assert_false(self.__send__(op), msg)
    else
      msg ||= "Expected #{self.inspect} to not be #{op} #{obj.inspect}"
      Minitest::Spec.current.assert_false(self.__send__(op, obj), msg)
    end
  end

  def wont_respond_to(meth, msg = nil)
    Minitest::Spec.current.refute_respond_to(self, meth, msg)
  end

  # def wont_be_same_as; end
end

class Object
  include Minitest::Expectations
end

$mrbtest_verbose = true
require "test/assert.rb"
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
    # FIXME
    # assert(desc) do
      cls.class_eval(&block)
    # end
    stack.pop
    cls
  end
end

class Minitest::Spec
# class Minitest::Spec < Minitest::Test

  $__minitest_current_spec = nil
  def self.current # :nodoc:
    # Thread.current[:current_spec]
    $__minitest_current_spec
  end

  # def initialize name # :nodoc:
  #   super
  #   $__minitest_current_spec = self
  #   # Thread.current[:current_spec] = self
  # end

  ##
  # Oh look! A Minitest::Spec::DSL module! Eat your heart out DHH.

  module DSL
    ##
    # Contains pairs of matchers and Spec classes to be used to
    # calculate the superclass of a top-level describe. This allows for
    # automatically customizable spec types.
    #
    # See: register_spec_type and spec_type

    # TYPES = [[//, Minitest::Spec]]

    ##
    # Register a new type of spec that matches the spec's description.
    # This method can take either a Regexp and a spec class or a spec
    # class and a block that takes the description and returns true if
    # it matches.
    #
    # Eg:
    #
    #     register_spec_type(/Controller$/, Minitest::Spec::Rails)
    #
    # or:
    #
    #     register_spec_type(Minitest::Spec::RailsModel) do |desc|
    #       desc.superclass == ActiveRecord::Base
    #     end

    # def register_spec_type *args, &block
    #   if block then
    #     matcher, klass = block, args.first
    #   else
    #     matcher, klass = *args
    #   end
    #   TYPES.unshift [matcher, klass]
    # end

    ##
    # Figure out the spec class to use based on a spec's description. Eg:
    #
    #     spec_type("BlahController") # => Minitest::Spec::Rails

    # def spec_type desc, *additional
    #   TYPES.find { |matcher, _klass|
    #     if matcher.respond_to? :call then
    #       matcher.call desc, *additional
    #     else
    #       matcher === desc.to_s
    #     end
    #   }.last
    # end

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

    ##
    # Define a 'before' action. Inherits the way normal methods should.
    #
    # NOTE: +type+ is ignored and is only there to make porting easier.
    #
    # Equivalent to Minitest::Test#setup.

    def before _type = nil, &block
      define_method :setup do
        # super() # FIXME: superclass info lost [mruby limitation]?
        self.instance_eval(&block)
      end
    end

    ##
    # Define an 'after' action. Inherits the way normal methods should.
    #
    # NOTE: +type+ is ignored and is only there to make porting easier.
    #
    # Equivalent to Minitest::Test#teardown.

    def after _type = nil, &block
      define_method :teardown do
        self.instance_eval(&block)
        # super() # FIXME: superclass info lost [mruby limitation]?
      end
    end

    ##
    # Define an expectation with name +desc+. Name gets morphed to a
    # proper test method name. For some freakish reason, people who
    # write specs don't like class inheritance, so this goes way out of
    # its way to make sure that expectations aren't inherited.
    #
    # This is also aliased to #specify and doesn't require a +desc+ arg.
    #
    # Hint: If you _do_ want inheritance, use minitest/test. You can mix
    # and match between assertions and expectations as much as you want.

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

ins = self.new
ins.setup if ins.respond_to? :setup
ins.instance_eval(&block)
ins.teardown if ins.respond_to? :teardown
      name
    end

    ##
    # Essentially, define an accessor for +name+ with +block+.
    #
    # Why use let instead of def? I honestly don't know.

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

    ##
    # Another lazy man's accessor generator. Made even more lazy by
    # setting the name for you to +subject+.

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

    ##
    # Rdoc... why are you so dumb?

    module InstanceMethods
      ##
      # Returns a value monad that has all of Expectations methods
      # available to it.
      #
      # Also aliased to #value and #expect for your aesthetic pleasure:
      #
      #         _(1 + 1).must_equal 2
      #     value(1 + 1).must_equal 2
      #    expect(1 + 1).must_equal 2
      #
      # This method of expectation-based testing is preferable to
      # straight-expectation methods (on Object) because it stores its
      # test context, bypassing our hacky use of thread-local variables.
      #
      # At some point, the methods on Object will be deprecated and then
      # removed.

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

  # TYPES = DSL::TYPES # :nodoc:
end

# require "minitest/expectations"

def assert_match(matcher, obj, msg = nil)
  msg ||= "Expected #{matcher.inspect} to match #{obj.inspect}"
  assert_respond_to matcher, :"=~"
  matcher = Regexp.new Regexp.escape matcher if String === matcher
  assert_true matcher =~ obj, msg
end

def assert_respond_to(obj, meth, msg = nil)
  msg ||= "Expected #{obj.inspect} (#{obj.class}) to respond to ##{meth}"
  assert_true obj.respond_to?(meth), msg
end

def refute_respond_to(obj, meth, msg = nil)
  msg ||= "Expected #{obj.inspect} to not respond to ##{meth}"
  assert_false obj.respond_to?(meth), msg
end

module Minitest::Expectations
  UNDEFINED = Object.new # :nodoc:

  def must_be_empty(msg = nil)
    msg ||= "Expected #{self.inspect} to be empty"
    assert_respond_to(self, :empty?)
    assert_true(self.empty?, msg)
  end

  def must_equal(exp, msg = nil)
    assert_equal(exp, self, msg)
  end

  # def must_be_close_to; end

  # def must_be_within_epsilon; end

  def must_include(obj, msg = nil)
    assert_include(self, obj, msg)
  end

  def must_be_instance_of(cls, msg = nil)
    msg ||= "Expected #{self.inspect} to be an instance of #{cls}, not #{self.class}"
    assert_true(self.instance_of?(cls), msg)
  end

  def must_be_kind_of(cls, msg = nil)
    msg ||= "Expected #{self.inspect} to be a kind of #{cls}, not #{self.class}"
    assert_true(self.kind_of?(cls), msg)
  end

  def must_match(matcher, msg = nil)
    msg ||= "Expected #{matcher.inspect} to match #{self.inspect}"
    assert_respond_to(matcher, :"=~")
    matcher = Regexp.new(Regexp.escape(matcher)) if String === matcher
    assert_true(matcher =~ self, msg)
  end

  def must_be_nil(msg = nil)
    assert_nil(self, msg)
  end

  def must_be(op, obj = UNDEFINED, msg = nil)
    if UNDEFINED == obj
      msg ||= "Expected #{self.inspect} to be #{op}"
      assert_true(self.__send__(op), msg)
    else
      msg ||= "Expected #{self.inspect} to be #{op} #{obj.inspect}"
      assert_true(self.__send__(op, obj), msg)
    end
  end

  # def must_output; end

  # TODO: move to Proc?
  def must_raise(*exp)
    if Proc === self
      assert_raise(*exp, &self)
    end
  end

  def must_respond_to(meth, msg = nil)
    assert_respond_to(self, meth, msg)
  end

  # def must_be_same_as; end

  # def must_be_silent; end

  # def must_throw; end

  def wont_be_empty(msg = nil)
    msg ||= "Expected #{self.inspect} to not be empty"
    assert_respond_to(self, :empty?)
    assert_false(self.empty?, msg)
  end

  def wont_equal(exp, msg = nil)
    assert_not_equal(exp, self, msg)
  end

  # def wont_be_close_to; end

  # def wont_be_within_epsilon; end

  def wont_include(obj, msg = nil)
    assert_not_include(self, obj, msg)
  end

  def wont_be_instance_of(cls, msg = nil)
    msg ||= "Expected #{self.inspect} to not be an instance of #{cls}"
    assert_false(self.instance_of?(cls), msg)
  end

  def wont_be_kind_of(cls, msg = nil)
    msg ||= "Expected #{self.inspect} to not be a kind of #{cls}"
    assert_false(self.kind_of?(cls), msg)
  end

  def wont_match(matcher, msg = nil)
    msg ||= "Expected #{matcher.inspect} to not match #{obj.inspect}"
    assert_respond_to(matcher, :"=~")
    matcher = Regexp.new(Regexp.escape(matcher)) if String === matcher
    assert_false(matcher =~ obj, msg)
  end

  def wont_be_nil(msg = nil)
    msg ||= "Expected #{self.inspect} to not be nil"
    diff = assertion_diff(nil, self)
    assert_false(self.nil?, msg, diff)
  end

  def wont_be(op, obj = UNDEFINED, msg = nil)
    if UNDEFINED == obj
      msg ||= "Expected #{self.inspect} to not be #{op}"
      assert_false(self.__send__(op), msg)
    else
      msg ||= "Expected #{self.inspect} to not be #{op} #{obj.inspect}"
      assert_false(self.__send__(op, obj), msg)
    end
  end

  def wont_respond_to(meth, msg = nil)
    refute_respond_to(self, meth, msg)
  end

  # def wont_be_same_as; end
end

class Object
  include Minitest::Expectations
end

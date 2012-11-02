require 'thread_variables'
require 'test/unit'
require File.expand_path('../colorized_test_output', __FILE__)

class ThreadVariablesTest < Test::Unit::TestCase

  def test_symbol_setter_and_getter
    t = Thread.new { Thread.current.thread_variable_set :foo, 42 }
    t.join
    assert_equal 42, t.thread_variable_get(:foo)
  end

  def test_string_setter_and_getter
    t = Thread.new { Thread.current.thread_variable_set "foo", 42 }
    t.join
    assert_equal 42, t.thread_variable_get("foo")
  end

  def test_string_setter_and_smybol_getter
    t = Thread.new { Thread.current.thread_variable_set "foo", 42 }
    t.join
    assert_equal 42, t.thread_variable_get(:foo)
  end

  def test_symbol_setter_and_string_getter
    t = Thread.new { Thread.current.thread_variable_set :foo, 42 }
    t.join
    assert_equal 42, t.thread_variable_get("foo")
  end

  def test_listing_keys
    t = Thread.new do
      Thread.current.thread_variable_set :foo, 42
      Thread.current.thread_variable_set "bar", 815
    end
    t.join
    vs = t.thread_variables
    assert_equal 2, vs.size
    assert vs.include?(:foo)
    assert vs.include?(:bar)
  end

  def test_ckecking_keys
    t = Thread.new do
      Thread.current.thread_variable_set :foo, 42
      Thread.current.thread_variable_set "bar", 815
    end
    t.join
    assert t.thread_variable?(:foo)
    assert t.thread_variable?(:bar)
  end

  # official tests
  # see http://bugs.ruby-lang.org/attachments/3149/thread_variables.patch

  def test_main_thread_variable_in_enumerator
    assert_equal Thread.main, Thread.current

    Thread.current.thread_variable_set :foo, "bar"

    thread, value = Fiber.new {
      Fiber.yield [Thread.current, Thread.current.thread_variable_get(:foo)]
    }.resume

    assert_equal Thread.current, thread
    assert_equal Thread.current.thread_variable_get(:foo), value
  end if RUBY_VERSION >= "1.9"

  def test_thread_variable_in_enumerator
    Thread.new {
      Thread.current.thread_variable_set :foo, "bar"

      thread, value = Fiber.new {
        Fiber.yield [Thread.current, Thread.current.thread_variable_get(:foo)]
      }.resume

      assert_equal Thread.current, thread
      assert_equal Thread.current.thread_variable_get(:foo), value
    }.join
  end if RUBY_VERSION >= "1.9"

  def test_thread_variables
    assert_equal [], Thread.new { Thread.current.thread_variables }.join.value

    t = Thread.new {
      Thread.current.thread_variable_set(:foo, "bar")
      Thread.current.thread_variables
    }
    assert_equal [:foo], t.join.value
  end

  def test_thread_variable?
    assert !Thread.new { Thread.current.thread_variable?("foo") }.join.value
    t = Thread.new {
      Thread.current.thread_variable_set("foo", "bar")
    }.join

    assert t.thread_variable?("foo")
    assert t.thread_variable?(:foo)
    assert !t.thread_variable?(:bar)
  end

  def test_thread_variable_strings_and_symbols_are_the_same_key
    t = Thread.new {}.join
    t.thread_variable_set("foo", "bar")
    assert_equal "bar", t.thread_variable_get(:foo)
  end

  def test_thread_variable_frozen
    t = Thread.new { }.join
    t.freeze
    exception_class = RUBY_VERSION < "1.9" ? TypeError : RuntimeError
    assert_raises(exception_class) do
      t.thread_variable_set(:foo, "bar")
    end
  end

  def test_thread_variable_security
    t = Thread.new { sleep }

    assert_raises(SecurityError) do
      Thread.new { $SAFE = 4; t.thread_variable_get(:foo) }.join
    end

    assert_raises(SecurityError) do
      Thread.new { $SAFE = 4; t.thread_variable_set(:foo, :baz) }.join
    end
  end if RUBY_VERSION > "1.9.3"

end

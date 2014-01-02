# colorized output for Test::Unit / MiniTest
begin
  if RUBY_VERSION < "1.9"
    require 'redgreen'
  elsif RUBY_VERSION < "2.1"
    require "test/unit/testcase"
    class MiniTest::Unit::TestCase
      alias :run_without_colors :run
      require 'ansi/code'
      ANSI_COLOR_MAPPING = Hash.new(:white).merge!('.' => :green, 'S' => :magenta, 'F' => :yellow, 'E' => :red )
      def run(*args)
        r = run_without_colors(*args)
        ANSI.ansi(r, ANSI_COLOR_MAPPING[r])
      end
    end
    class MiniTest::Unit
      def status(io = @@out)
        format = "%d tests, %d assertions, %d failures, %d errors, %d skips"
        color = (errors + failures) > 0 ? :red : :green
        io.puts ANSI.ansi(format % [test_count, assertion_count, failures, errors, skips], color)
      end
    end
  else
    require "ansi"
  end
rescue LoadError => e
  # do nothing
end if $stdout.tty?

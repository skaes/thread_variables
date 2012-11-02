require "thread_variables/version"
require "thread"

class Thread
  if RUBY_VERSION < "1.9"

    alias :thread_variable_get :[]
    alias :thread_variable_set :[]=
    alias :thread_variables :keys
    alias :thread_variable? :key?

  elsif !instance_methods.include?(:thread_variables)

    def thread_variables
      (locals = @locals) ? locals.keys : []
    end

    def thread_variable?(k)
      (locals = @locals) && locals.include?(k.to_sym)
    end

    def thread_variable_get(k)
      (locals = @locals) ? locals[k.to_sym] : nil
    end

    def thread_variable_set(k,v)
      (@locals ||= {})[k.to_sym] = v
    end

  end
end

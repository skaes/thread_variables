require "thread_variables"

module ThreadVariables
  class AccessProxy < (RUBY_VERSION >= "1.9" ? BasicObject : Object)
    def initialize(thread)
      @thread = thread
    end

    def [](k)
      @thread.thread_variable_get(k)
    end

    def []=(k,v)
      @thread.thread_variable_set(k,v)
    end

    def key?(k)
      @thread.thread_variable?(k)
    end

    def keys
      @thread.thread_variables
    end
  end
end

class Thread
  def locals
    @thread_variables_access_proxy ||= ThreadVariables::AccessProxy.new(self)
  end
end

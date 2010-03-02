require 'active_record'

ActiveRecord::Base.class_eval do
  def self.object_id_attr(symbol, klass)
    module_eval %{
      def #{symbol}
        if @#{symbol}.nil? or (@old_#{symbol}_id != #{symbol}_id)
          @old_#{symbol}_id = #{symbol}_id
          klass = #{klass}.descendents.find { |d| d.#{symbol}_name == #{symbol}_id }
          klass ||= #{klass}
          @#{symbol} = klass.new
        else
          @#{symbol}
        end
      end
    }
  end
end

ActiveRecord::Observer.class_eval do
  protected
  alias_method :original_add_observer!, :add_observer!

  # monkeypatch to fix observers for before_* callbacks
  def add_observer!(klass)
    super

    # Check if a notifier callback was already added to the given class. If
    # it was not, add it.
    self.class.observed_methods.each do |method|
      callback = :"_notify_observers_for_#{method}"
      if (klass.instance_methods & [callback, callback.to_s]).empty?
        klass.class_eval "def #{callback}; notify_observers(:#{method}); true; end"
        klass.send(method, callback)
      end
    end
  end
end

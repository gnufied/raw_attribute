class ActiveRecord::Base
  IGNORE_ATTRIBUTES = ["id", "created_at", "updated_at"]

  def self.raw_attribute(*args)
    options = args.extract_options!

    case args.first
      when :all then attrs = self.new.attribute_names
      else           attrs = args
    end

    attrs -= options[:except] if options.has_key? :except
    attrs -= IGNORE_ATTRIBUTES

    attrs.each do |a|
      class_eval <<-STR, __FILE__,__LINE__ + 1
        def #{a}
          read_attribute('#{a}'.to_sym).to_s.html_safe
        end
      STR
    end
  end
end


module RawHtml
  class Base
    def self.raw(str)
      str.to_s.html_safe
    end
  end
end


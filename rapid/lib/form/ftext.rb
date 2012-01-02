module Rapid
    class Ftext < FormItem
        FormItem.add_tag "ftext", self

        def self.build name, extra_attrs, value = nil
            do_build "text", name, extra_attrs, value
        end
    end
end
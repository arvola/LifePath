module Rapid
    class Fpassword < FormItem
        FormItem.add_tag "fpassword", self

        def self.build name, extra_attrs, value = nil
            do_build "password", name, extra_attrs, value
        end
    end
end
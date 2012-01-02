module Rapid
    class Ftextarea < FormItem
        FormItem.add_tag "ftextarea", self

        def self.tag
            "textarea"
        end
        def self.build name, extra_attrs, value = nil
            attributes = attrs nil, name
            attributes += extra_attrs unless extra_attrs.nil?
            ele = element attributes
            ele << value unless value.nil?
            ele
        end
    end
end
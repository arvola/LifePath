module Rapid
    class Fform < FormItem
        FormItem.add_tag "fform", self

        def self.tag
            "form"
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
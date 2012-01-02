module Rapid
    class FormItem
        attr_accessor :type, :name

        def FormItem.items
            @tags ||= {}
        end

        def FormItem.add_tag tag, klass
            FormItem.items[tag] = klass
        end

        def FormItem.has_tag? tag
            FormItem.items.has_key? tag
        end

        def FormItem.get tag
            FormItem.items[tag]
        end

        def self.tag
            'input'
        end

        def self.attrs type, name
            arr = [:html, :attrs]
            arr << [:html, :attr, "type", [:static, type]] unless type.nil?
            arr << [:html, :attr, "name", [:static, name]] unless name.nil?
            arr
        end

        def self.val value
            [:html, :attr, "value", value]
        end

        def self.element attributes
            [:html, :tag, tag, attributes]
        end

        def self.do_build type, name, extra_attrs, value
            attributes = attrs type, name
            attributes << val(value) unless value.nil?
            attributes += extra_attrs unless extra_attrs.nil?
            element attributes
        end
    end

    module FormMixin
        def self.included(base)
            base.extend(FormMixinBase)
        end
    end

    module FormMixinBase
        attr_accessor :valid
        def validators
            @validators ||= {}
        end

        def validator name
            unless validators.has_key? name
                validators[name] = ValidatorList.new
            end
            validators[name]
        end

        def form_item name
            validator name
        end

        def remember? name
            !validators.has_key?(name) || validators[name].remember
        end

        def validate values
            messages = []
            validators.each do |k, v|
                val = values.has_key?(k) ? values[k] : ""
                temp = v.validate val
                messages += temp
            end
            messages
        end
    end
end
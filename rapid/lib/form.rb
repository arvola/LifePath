# LifePath
#
# Author:: Mikael Arvola
# License:: MIT

require 'awesome_print'
require 'form/form_mixin'
require 'form/ftext'
require 'form/fpassword'
require 'form/ftextarea'
require 'form/validators'

module Rapid
    module FormTools
        def form_value name, form
            post(name)
            if respond_to?(:post) && !post(name).nil? && post(name).to_s.length > 0
                post(name)
            elsif Form.has_default?(form, name)
                Form.forms[form].validators[name].def
            else
                ""
            end
        end
    end

    class Form
        include FormMixin

        def items
            self.class.items
        end

        def Form.descendants
            result = []
            ObjectSpace.each_object(Class) do |klass|
                result = result << klass if klass < self
            end
            result
        end

        def Form.forms
            @forms ||= {}
        end

        def Form.active
            @active || nil
        end

        def Form.active= val
            if val.is_a?(String) && forms.has_key?(val)
                @active = forms[val]
            else
                @active = val
            end
        end

        def Form.has_default? form, name
            forms.has_key?(form) && forms[form].validators.has_key?(name) && !forms[form].validators[name].def.nil?
        end
    end

    Dir.glob ($BASE_PATH + "/apps/forms/*.rb") do |file|
        require file
    end
    Form.descendants.each { |v| Form.forms[v.to_s] = v }

    class RapidFilter < Temple::HTML::Filter
        def on_multi *exps
            result = [:multi]

            exps.each do |exp|
                if exp[0] == :html && FormItem.has_tag?(exp[2])
                    attrs, name, value, append = parse_instruction exp

                    if append.length > 2
                        value = append[2][1]
                    end

                    if !Form.active.nil? && Form.active.remember?(name.to_sym)
                        value = [:escape, true, [:dynamic, "form_value(:#{name}, '#{Form.active.to_s}')"]]
                    end

                    result << FormItem.get(exp[2]).build(name, attrs, value)
                elsif exp[0] == :html && exp[2] == "fform"
                    attrs, name, value, append = parse_instruction exp
                    new_attrs = [:html, :attrs, [:html, :attr, "id", [:static, name]], [:html, :attr, "method", [:static, "post"]]]
                    new_attrs += attrs

                    Form.active = name

                    result << [:html, :tag, "form", new_attrs, compile(append)]
                    Form.active = nil
                else
                    result << compile(exp)
                end

            end

            result
        end

        private
        def parse_instruction exp
            attrs = nil
            name = nil
            value = nil
            append = []

            exp.each_with_index do |v, i|
                if v.is_a?(Array) && v[0] == :html && v[1] == :attrs
                    attrs = v
                elsif i > 2
                    append += v
                end
            end

            unless attrs.nil?
                if attrs.length > 2
                    name = attrs.slice!(2)[2]
                end
                attrs.slice!(0, 2)
            end

            [attrs, name, value, append]
        end
    end
end
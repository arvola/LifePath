# LifePath
#
# Author:: Mikael Arvola
# License:: MIT

module Rapid
    module FormTools
        def form id
            Form.new @template, id
        end

        class Form
            def initialize template, id
                @template = template
                @id = id
            end

            def to_s
                "<form method=\"post\" id=\"form-#{@id}\" >"
            end
        end
    end
end
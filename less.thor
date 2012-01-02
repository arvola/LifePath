
require "open4"
require "awesome_print"

class Less < Thor

    desc "compile", "Compile LESS"
    def compile()
        stdout = `cd style;lessc main.less`
        ap stdout
        file = File.new("public/css/style.css", "w")
        file.write(stdout)
        file.close
    end
end
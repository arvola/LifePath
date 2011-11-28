require 'template-inheritance'

TemplateInheritance::Template.paths << ($BASE_PATH + '/templates')

# Methods for creating pages from templates
module Pages
  def render(template, data = {})
    @template = TemplateInheritance::Template.new(template)
    @render = @template.render data
  end
end
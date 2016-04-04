module TestCentricity
  class FileField < UIElement
    def initialize(parent, locator, context)
      @parent  = parent
      @locator = locator
      @context = context
      @type    = :filefield
      @alt_locator = nil
    end

    def attach_file(file_path)
      Capybara.ignore_hidden_elements = false
      page.attach_file(@locator, file_path)
      Capybara.ignore_hidden_elements = true
    end
  end
end

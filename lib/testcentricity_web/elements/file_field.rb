module TestCentricity
  class FileField < UIElement
    def initialize(parent, locator, context)
      @parent  = parent
      @locator = locator
      @context = context
      @type    = :filefield
      @alt_locator = nil
    end

    def file_attach(file_path)
      Capybara.ignore_hidden_elements = false
      page.attach_file(@locator, file_path)
      Capybara.ignore_hidden_elements = true
    end

    def drop_files(files)
      js_script = "fileList = Array();"
      files.count.times do |i|
        # generate a fake input selector
        page.execute_script("if ($('#seleniumUpload#{i}').length == 0) { seleniumUpload#{i} = window.$('<input/>').attr({id: 'seleniumUpload#{i}', type:'file'}).appendTo('body'); }")
        # attach file to the fake input selector through Capybara
        attach_file("seleniumUpload#{i}", files[i])
        # create the fake js event
        js_script = "#{js_script} fileList.push(seleniumUpload#{i}.get(0).files[0]);"
      end
      # trigger the fake drop event
      page.execute_script("#{js_script} e = $.Event('drop'); e.originalEvent = {dataTransfer : { files : fileList } }; $('#{@locator}').trigger(e);")
    end
  end
end

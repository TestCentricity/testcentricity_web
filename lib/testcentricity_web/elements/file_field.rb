module TestCentricity
  class FileField < UIElement
    def initialize(name, parent, locator, context)
      super
      @type = :filefield
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

    def ng_drop_file(file_path)
      # generate a fake input selector
      page.execute_script("fakeFileInput = window.$('<input/>').attr({ id: 'fileFileInput', type: 'file' }).appendTo('body');")
      # attach file to the fake input selector through Capybara
      page.attach_file('fakeFileInput', file_path)
      # create the fake js event
      js_script = "var scope = angular.element('#{@locator}').scope();"
      js_script = "#{js_script} scope.files = [fakeFileInput.get(0).files[0]];"
      # trigger the fake drop event
      page.execute_script(js_script)
    end
  end
end

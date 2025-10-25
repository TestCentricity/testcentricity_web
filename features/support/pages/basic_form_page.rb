# Page Object class definition for Basic HTML Form page

class BasicFormPage < BaseTestPage
  trait(:page_url)         { '/basic_test_page.html' }
  trait(:navigator)        { header_nav.open_form_page }
  trait(:page_title)       { 'Basic HTML Form'}
  trait(:tab_order)        {
    [
      header_nav.form_link,
      header_nav.media_link,
      header_nav.indexed_sections_link,
      header_nav.custom_controls_link,
      username_field,
      password_field,
      max_length_field,
      read_only_field,
      number_int_field,
      number_flt_field,
      date_field,
      date_field,
      date_time_field,
      date_time_field,
      month_field,
      month_field,
      email_field,
      color_picker,
      slider,
      comments_field,
      upload_file,
      check_1,
      check_2,
      check_3,
      radio_1,
      [
        radio_2,
        radio_3
      ],
      multi_select,
      drop_down_select,
      link_1,
      link_2,
      cancel_button,
      submit_button
    ]
  }
  trait(:chrome_tab_order) {
    [
      header_nav.form_link,
      header_nav.media_link,
      header_nav.indexed_sections_link,
      header_nav.custom_controls_link,
      username_field,
      password_field,
      max_length_field,
      read_only_field,
      number_int_field,
      number_flt_field,
      date_field,
      date_field,
      date_field,
      date_field,
      date_time_field,
      date_time_field,
      date_time_field,
      date_time_field,
      date_time_field,
      date_time_field,
      date_time_field,
      month_field,
      month_field,
      month_field,
      email_field,
      color_picker,
      slider,
      comments_field,
      upload_file,
      check_1,
      check_2,
      check_3,
      radio_1,
      [
        radio_2,
        radio_3
      ],
      multi_select,
      drop_down_select,
      link_1,
      link_2,
      cancel_button,
      submit_button
    ]
  }
  trait(:firefox_order)    {
    [
      header_nav.form_link,
      header_nav.media_link,
      header_nav.indexed_sections_link,
      header_nav.custom_controls_link,
      username_field,
      password_field,
      max_length_field,
      read_only_field,
      number_int_field,
      number_flt_field,
      date_field,
      date_field,
      date_field,
      date_field,
      date_time_field,
      date_time_field,
      date_time_field,
      date_time_field,
      date_time_field,
      date_time_field,
      date_time_field,
      month_field,
      email_field,
      color_picker,
      slider,
      comments_field,
      upload_file,
      check_1,
      check_2,
      check_3,
      radio_1,
      [
        radio_2,
        radio_3
      ],
      multi_select,
      drop_down_select,
      link_1,
      link_2,
      cancel_button,
      submit_button
    ]
  }
  trait(:safari_tab_order) {
    [
      username_field,
      password_field,
      max_length_field,
      read_only_field,
      number_int_field,
      number_flt_field,
      date_field,
      date_field,
      date_field,
      date_time_field,
      date_time_field,
      date_time_field,
      date_time_field,
      date_time_field,
      date_time_field,
      month_field,
      email_field,
      comments_field,
      multi_select,
      drop_down_select
    ]
  }

  attr_accessor :action_element

  def verify_page_ui
    super

    verify_page_contains(page_title)
    image_1.wait_until_loaded(5)
    username_field.scroll_to(:center) if username_field.obscured?
    ui = {
      username_label => { visible: true, caption: 'Username:' },
      username_field => {
        name: 'username',
        exists: true,
        displayed: true,
        obscured: false,
        visible: true,
        hidden: false,
        enabled: true,
        disabled: false,
        required: true,
        aria_required: true,
        draggable: false,
        value: '',
        placeholder: 'User name',
        aria_label: 'User name',
        aria_labelledby: 'username',
        title: 'User Name',
        badInput: false,
        customError: false,
        patternMismatch: false,
        rangeOverflow: false,
        rangeUnderflow: false,
        stepMismatch: false,
        tooLong: false,
        tooShort: false,
        typeMismatch: false,
        valid: false,
        valueMissing: true
      },
      password_label => { visible: true, caption: 'Password:' },
      password_field => {
        name: 'password',
        visible: true,
        displayed: true,
        obscured: false,
        focused: false,
        enabled: true,
        required: true,
        aria_required: true,
        draggable: false,
        value: '',
        placeholder: 'Password',
        aria_label: 'Password',
        aria_labelledby: 'password',
        title: 'Password'
      },
      max_length_label => { visible: true, caption: 'Max Length:' },
      max_length_field => {
        visible: true,
        obscured: false,
        enabled: true,
        focused: false,
        placeholder: 'up to 64 characters',
        aria_label: 'up to 64 characters',
        aria_labelledby: 'maxlength',
        value: '',
        maxlength: 64
      },
      read_only_label => { visible: true, caption: 'Read Only:' },
      read_only_field => {
        visible: true,
        enabled: true,
        readonly: true,
        aria_readonly: true,
        value: 'I am a read only text field'
      },
      number_int_label => { visible: true, caption: 'Number (Integer):' },
      number_int_field => {
        visible: true,
        enabled: true,
        value: '41',
        min: 10,
        max: 1024,
        step: 1,
        validation_message: ''
      },
      number_flt_label => { visible: true, caption: 'Number (Float):' },
      number_flt_field => {
        visible: true,
        enabled: true,
        value: '3.5',
        min: 0.5,
        max: 10.5,
        step: 0.25,
        validation_message: ''
      },
      color_label => { visible: true, caption: 'Color:' },
      color_picker => { visible: true, enabled: true, value: '#000000' },
      slider_label => { visible: true, caption: 'Range:' },
      slider => {
        visible: true,
        enabled: true,
        value: 25,
        min: 0,
        max: 50,
        role: 'slider',
        aria_orientation: 'horizontal',
        aria_valuenow: 25,
        aria_valuemin: 0,
        aria_valuemax: 50
      },
      comments_label => { visible: true, caption: 'TextArea:' },
      comments_field => {
        visible: true,
        enabled: true,
        aria_multiline: true,
        value: '' },
      filename_label => { visible: true, caption: 'Filename:' },
      upload_file => { visible: true, enabled: true, value: '' },
      checkboxes_label => { visible: true, caption: { translate_titlecase: 'base_form_page.check_label' } },
      check_1 => {
        exists: true,
        visible: true,
        hidden: false,
        enabled: true,
        disabled: false,
        checked: false,
        aria_checked: false,
        indeterminate: false,
        draggable: false,
        caption: { translate_downcase: 'base_form_page.checkbox1' }
      },
      check_2 => {
        exists: true,
        visible: true,
        hidden: false,
        enabled: true,
        disabled: false,
        checked: false,
        aria_checked: false,
        indeterminate: false,
        caption: { translate_downcase: 'base_form_page.checkbox2' }
      },
      check_3 => {
        exists: true,
        visible: true,
        hidden: false,
        enabled: true,
        disabled: false,
        checked: false,
        aria_checked: false,
        indeterminate: false,
        caption: { translate_downcase: 'base_form_page.checkbox3' }
      },
      check_4 => {
        exists: true,
        visible: true,
        hidden: false,
        enabled: false,
        disabled: true,
        checked: false,
        aria_checked: false,
        indeterminate: false,
        caption: { translate_downcase: 'base_form_page.checkbox4' }
      },
      radios_label => { visible: true, caption: { translate_titlecase: 'base_form_page.radio_label' } },
      radio_1 => {
        exists: true,
        visible: true,
        hidden: false,
        enabled: true,
        disabled: false,
        selected: false,
        aria_checked: false,
        draggable: false,
        caption: { translate_upcase: 'base_form_page.radio1' }
      },
      radio_2 => {
        exists: true,
        visible: true,
        hidden: false,
        enabled: true,
        disabled: false,
        selected: false,
        aria_checked: false,
        caption: { translate_upcase: 'base_form_page.radio2' }
      },
      radio_3 => {
        exists: true,
        visible: true,
        hidden: false,
        enabled: true,
        disabled: false,
        selected: false,
        aria_checked: false,
        caption: { translate_upcase: 'base_form_page.radio3' }
      },
      radio_4 => {
        exists: true,
        visible: true,
        hidden: false,
        enabled: false,
        disabled: true,
        selected: false,
        aria_checked: false,
        caption: { translate_upcase: 'base_form_page.radio4' }
      },
      multiselect_label => { visible: true, caption: 'Multiple Select Values:' },
      multi_select => {
        visible: true,
        enabled: true,
        draggable: false,
        optioncount: 4,
        aria_multiselectable: true,
        options: ['Selection Item 1', 'Selection Item 2', 'Selection Item 3', 'Selection Item 4'],
        selected: ''
      },
      dropdown_label => { visible: true, caption: 'Dropdown:' },
      drop_down_select => {
        visible: true,
        enabled: true,
        optioncount: 6,
        options: ['Drop Down Item 1', 'Drop Down Item 2', 'Drop Down Item 3', 'Drop Down Item 4', 'Drop Down Item 5', 'Drop Down Item 6'],
        selected: 'Drop Down Item 1'
      },
      link_label => { visible: true, caption: 'Links:' },
      links_list => {
        visible: true,
        enabled: true,
        draggable: false,
        itemcount: 3,
        items: ['Open Media Page in same window/tab', 'Open Media Page in a new window/tab', 'Disabled Link'],
        { item: 1 } => ['Open Media Page in same window/tab'],
        { item: 3 } => ['Disabled Link']
      },
      link_1 => {
        visible: true,
        aria_disabled: false,
        role: 'link',
        href: { ends_with: 'media_page.html' },
        caption: 'Open Media Page in same window/tab'
      },
      link_2 => {
        visible: true,
        aria_disabled: false,
        role: 'link',
        href: { ends_with: 'media_page.html' },
        caption: 'Open Media Page in a new window/tab'
      },
      link_3 => {
        visible: true,
        aria_disabled: true,
        role: 'link',
        caption: 'Disabled Link'
      },
      table_label => { visible: true, caption: 'Table:' },
      static_table => {
        visible: true,
        draggable: false,
        columncount: 3,
        rowcount: 4,
        column_headers: %w[Company Contact Country],
        { row: 1 } => [['Alfreds Futterkiste', 'Maria Anders', 'Germany']],
        { row: 2 } => [['Centro comercial Moctezuma', 'Francisco Chang', 'Mexico']],
        { row: 3 } => [['Ernst Handel', 'Roland Mendel', 'Austria']],
        { row: 4 } => [['Island Trading', 'Helen Bennett', 'UK']],
        { cell: [1, 3] } => ['Germany'],
        { cell: [2, 3] } => ['Mexico'],
        { column: 3 } => [['Germany', 'Mexico', 'Austria', 'UK']]
      },
      images_label => { visible: true, caption: 'Images:' },
      image_1 => {
        visible: true,
        loaded: true,
        broken: false,
        src: { ends_with: 'images/Wilder.jpg' },
        alt: "It's alive",
        width: 225,
        height: 225
      },
      image_2 => {
        visible: true,
        loaded: true,
        broken: false,
        src: { ends_with: 'images/You_Betcha.jpg' },
        alt: 'You Betcha'
      },
      image_3 => {
        visible: true,
        broken: true,
        src: { ends_with: 'wrongname.gif' },
        alt: 'A broken image'
      },
      image_4 => {
        visible: true,
        loaded: true,
        broken: false,
        src: { ends_with: 'images/TinyViolin.png' },
        alt: 'Tiny Violin',
        style: { contains: 'border-radius: 50%;' }
      },
      cancel_button => {
        visible: true,
        enabled: true,
        caption: { translate_capitalize: 'base_form_page.cancel_button' }
      },
      submit_button => {
        visible: true,
        enabled: true,
        caption: { translate_capitalize: 'base_form_page.submit_button' }
      }
    }
    verify_ui_states(ui)

    # tests to enhance coverage of TestCentricity:ExceptionQueue.enqueue_comparison method
    ui = {
      slider => {
        value: { less_than_or_equal: 25 },
        max: { greater_than_or_equal: 50 },
      },
      static_table => {
        columncount: { less_than: 8 },
        rowcount:  { greater_than: 2 }
      },
      image_2 => { alt: { is_like: 'you betcha' } },
      image_3 => { alt: { does_not_contain: 'Waffles' } },
      image_4 => { alt: { not_equal: 'Cowabunga' } }
    }
    verify_ui_states(ui)
    # verify table row data
    row_data = static_table.get_row_data(1)
    ExceptionQueue.enqueue_assert_equal('Alfreds Futterkiste Maria Anders Germany', row_data, 'Table Row 1')
    # verify that a screenshot can be taken
    ExceptionQueue.enqueue_screenshot
    reports_path = "#{Dir.pwd}/reports"
    ExceptionQueue.enqueue_exception("#{reports_path} folder was not created") unless Dir.exist?(reports_path)
  end

  def form_data
    data = form_data_source.read_form_data

    if Environ.platform == :mobile
      file_path = nil
      file_name = ''
      color_value = '#000000'
    else
      file_path = "#{Dir.pwd}/test_site/images/#{data.image_filename}"
      file_name = data.image_filename
      color_value = Faker::Color.hex_color
    end
    {
      username:     data.username,
      password:     data.password,
      maxlength:    Faker::Marketing.buzzwords,
      number_int:   Faker::Number.between(from: 10, to: 1024),
      number_flt:   Faker::Number.between(from: 1.25, to: 9.75),
      color:        color_value,
      slider:       50,
      comments:     Faker::Hipster.paragraph,
      filepath:     file_path,
      filename:     file_name,
      check1:       data.check1,
      check2:       data.check2,
      check3:       data.check3,
      radio_select: data.radio_select,
      multi_select: data.multi_select,
      drop_select:  data.drop_down_item
    }
  end

  def populate_form
    # toggle checks and radios and verify
    check_2.check
    check_2.verify_check_state(true)
    check_2.uncheck
    check_2.verify_check_state(false)
    radio_2.select
    radio_2.unselect
    # clear text fields
    username_field.clear
    comments_field.clear
    number_int_field.clear
    # populate fields and controls with externally sourced data
    @data = form_data
    fields = {
      username_field   => @data[:username],
      password_field   => @data[:password],
      max_length_field => @data[:maxlength],
      number_int_field => @data[:number_int],
      number_flt_field => @data[:number_flt],
      color_picker     => @data[:color],
      slider           => @data[:slider],
      comments_field   => @data[:comments],
      upload_file      => @data[:filepath],
      check_1          => @data[:check1],
      check_2          => @data[:check2],
      check_3          => @data[:check3],
      radio_1          => @data[:radio_select] == 1,
      radio_2          => @data[:radio_select] == 2,
      radio_3          => @data[:radio_select] == 3,
      multi_select     => @data[:multi_select],
      drop_down_select => @data[:drop_select]
    }
    populate_data_fields(fields)
  end

  def verify_form_data
    ui = {
      username_field   => { value: @data[:username] },
      password_field   => { value: @data[:password] },
      max_length_field => { value: @data[:maxlength] },
      number_int_field => { value: @data[:number_int].to_s },
      number_flt_field => { value: @data[:number_flt].to_s },
      color_picker     => { value: @data[:color] },
      slider           => { value: @data[:slider] },
      comments_field   => { value: @data[:comments] },
      upload_file      => { value: { ends_with: @data[:filename] } },
      check_1          => { checked: @data[:check1] },
      check_2          => { checked: @data[:check2] },
      check_3          => { checked: @data[:check3] },
      radio_1          => { selected: @data[:radio_select] == 1 },
      radio_2          => { selected: @data[:radio_select] == 2 },
      radio_3          => { selected: @data[:radio_select] == 3 },
      multi_select     => { selected: @data[:multi_select] },
      drop_down_select => { selected: @data[:drop_select] }
    }
    upload_ui = if Environ.platform == :mobile
                  { image_upload => { exists: false} }
                else
                  {
                    image_upload => {
                      visible: true,
                      loaded: true,
                      broken: false
                    }
                  }
                end
    verify_ui_states(upload_ui.merge(ui))
  end

  def perform_action(action)
    case action
    when :submit
      submit_button.click
    when :cancel
      cancel_button.click
    else
      raise "#{action} is not a valid selector"
    end
  end

  def verify_tab_order
    order = case Environ.browser
            when :chrome, :chrome_headless
              chrome_tab_order
            when :safari
              safari_tab_order
            when :firefox, :firefox_headless
              firefox_order
            else
              tab_order
            end
    verify_focus_order(order)
  end

  def choose_options_by(method)
    case method.downcase.to_sym
    when :index
      multi_select.choose_option(index: 2)
      drop_down_select.choose_option(index: 3)
    when :value
      multi_select.choose_option(value: 'ms2')
      drop_down_select.choose_option(value: 'dd3')
    when :text
      multi_select.choose_option(text: 'Selection Item 2')
      drop_down_select.choose_option(text: 'Drop Down Item 3')
    else
      raise "#{method} is not a valid selector"
    end
  end

  def verify_chosen_options
    ui = {
      multi_select     => { selected: 'Selection Item 2' },
      drop_down_select => { selected: 'Drop Down Item 3' }
    }
    verify_ui_states(ui)
  end

  def invalid_data_entry(reason)
    # populate fields and controls with externally sourced data
    @data = form_data
    fields = {
      username_field   => @data[:username],
      password_field   => @data[:password],
      number_int_field => @data[:number_int]
    }
    populate_data_fields(fields)

    case reason.gsub(/\s+/, '_').downcase.to_sym
    when :blank_username
      username_field.clear
    when :blank_password
      password_field.clear
    when :number_too_low
      number_int_field.set(3)
    when :number_too_high
      number_int_field.set(4132)
    when :invalid_email
      email_field.set('bob')
    else
      raise "#{reason} is not a valid selector"
    end
  end

  def verify_entry_error(reason)
    ui = case reason.gsub(/\s+/, '_').downcase.to_sym
         when :blank_username
           { username_field => { valid: false, valueMissing: true } }
         when :blank_password
           { password_field => { valid: false, valueMissing: true } }
         when :number_too_low
           { number_int_field => { valid: false, rangeUnderflow: true } }
         when :number_too_high
           { number_int_field => { valid: false, rangeOverflow: true } }
         when :invalid_email
           { email_field => { valid: false, typeMismatch: true } }
         else
           raise "#{reason} is not a valid selector"
         end
    # verify correct error message is displayed
    verify_ui_states(ui)
  end

  def element_action(action, element)
    @action_element = case element.gsub(/\s+/, '_').downcase.to_sym
                    when :image_1
                      image_1
                    when :image_2
                      image_2
                    when :image_3
                      image_3
                    when :image_4
                      image_4
                    else
                      raise "#{element} is not a valid selector"
                      end
    @action_element.wait_until_exists(2)
    @action_element.scroll_to(:bottom)

    case action.gsub(/\s+/, '_').downcase.to_sym
    when :hover_over
      @action_element.hover
    when :hover_outside
      @action_element.hover_at(-1, -1)
    when :double_click
      @action_element.double_click
    when :right_click
      @action_element.right_click
    when :click_at
      @action_element.click_at(30, 50)
    else
      raise "#{action} is not a valid selector"
    end
  end

  def verify_tooltip(state)
    tooltip = case @action_element
              when image_1
                tip_text =  "It's alive"
                tooltip_1
              when image_2
                tip_text = 'You Betcha'
                tooltip_2
              when image_4
                tip_text = 'Cry Me A River'
                tooltip_3
              else
                raise "#{element} is not a valid selector"
              end

    ui = if state
           {
             tooltip => {
               visible: true,
               caption: tip_text
             }
           }
         else
           { tooltip => { visible: false } }
         end
    verify_ui_states(ui)
  end
end

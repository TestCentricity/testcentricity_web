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
      number_field,
      date_field,
      date_time_field,
      email_field,
      month_field,
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
      number_field,
      date_field,
      date_field,
      date_field,
      date_time_field,
      date_time_field,
      date_time_field,
      date_time_field,
      date_time_field,
      date_time_field,
      email_field,
      month_field,
      month_field,
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
      username_field,
      password_field,
      max_length_field,
      read_only_field,
      number_field,
      date_field,
      date_field,
      date_field,
      date_time_field,
      date_time_field,
      date_time_field,
      date_time_field,
      date_time_field,
      date_time_field,
      email_field,
      month_field,
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
      number_field,
      date_field,
      date_field,
      date_field,
      date_time_field,
      date_time_field,
      date_time_field,
      date_time_field,
      date_time_field,
      date_time_field,
      email_field,
      month_field,
      comments_field,
      multi_select,
      drop_down_select
    ]
  }

  def verify_page_ui
    super

    verify_page_contains(page_title)
    image_1.wait_until_loaded(5)
    username_field.scroll_to(:center) if username_field.obscured?
    ui = {
      username_label    => { visible: true, caption: 'Username:' },
      username_field    => {
        name: 'username',
        exists: true,
        displayed: true,
        obscured: false,
        visible: true,
        hidden: false,
        enabled: true,
        disabled: false,
        required: true,
        value: '',
        placeholder: 'User name'
      },
      password_label    => { visible: true, caption: 'Password:' },
      password_field    => {
        name: 'password',
        visible: true,
        displayed: true,
        obscured: false,
        focused: false,
        enabled: true,
        required: true,
        value: '',
        placeholder: 'Password'
      },
      max_length_label  => { visible: true, caption: 'Max Length:' },
      max_length_field  => {
        visible: true,
        obscured: false,
        enabled: true,
        focused: false,
        placeholder: 'up to 64 characters',
        value: '',
        maxlength: 64
      },
      read_only_label   => { visible: true, caption: 'Read Only:' },
      read_only_field   => {
        visible: true,
        enabled: true,
        readonly: true,
        value: 'I am a read only text field'
      },
      number_label      => { visible: true, caption: 'Number:' },
      number_field      => {
        visible: true,
        enabled: true,
        value: '41',
        min: 10,
        max: 1024,
        step: 1
      },
      color_label       => { visible: true, caption: 'Color:' },
      color_picker      => { visible: true, enabled: true, value: '#000000' },
      slider_label      => { visible: true, caption: 'Range:' },
      slider            => {
        visible: true,
        enabled: true,
        value: 25,
        min: 0,
        max: 50,
      },
      comments_label    => { visible: true, caption: 'TextArea:' },
      comments_field    => { visible: true, enabled: true, value: '' },
      filename_label    => { visible: true, caption: 'Filename:' },
      upload_file       => { visible: true, enabled: true, value: '' },
      checkboxes_label  => { visible: true, caption: 'Checkbox Items:' },
      check_1           => {
        exists: true,
        visible: true,
        hidden: false,
        enabled: true,
        disabled: false,
        checked: false,
        indeterminate: false
      },
      check_2           => {
        exists: true,
        visible: true,
        hidden: false,
        enabled: true,
        disabled: false,
        checked: false,
        indeterminate: false
      },
      check_3           => {
        exists: true,
        visible: true,
        hidden: false,
        enabled: true,
        disabled: false,
        checked: false,
        indeterminate: false
      },
      check_4           => {
        exists: true,
        visible: true,
        hidden: false,
        enabled: false,
        disabled: true,
        checked: false,
        indeterminate: false
      },
      radios_label      => { visible: true, caption: 'Radio Items:' },
      radio_1           => {
        exists: true,
        visible: true,
        hidden: false,
        enabled: true,
        disabled: false,
        selected: false
      },
      radio_2           => {
        exists: true,
        visible: true,
        hidden: false,
        enabled: true,
        disabled: false,
        selected: false
      },
      radio_3           => {
        exists: true,
        visible: true,
        hidden: false,
        enabled: true,
        disabled: false,
        selected: false
      },
      radio_4           => {
        exists: true,
        visible: true,
        hidden: false,
        enabled: false,
        disabled: true,
        selected: false
      },
      multiselect_label => { visible: true, caption: 'Multiple Select Values:' },
      multi_select      => {
        visible: true,
        enabled: true,
        optioncount: 4,
        options: ['Selection Item 1', 'Selection Item 2', 'Selection Item 3', 'Selection Item 4'],
        selected: ''
      },
      dropdown_label    => { visible: true, caption: 'Dropdown:' },
      drop_down_select  => {
        visible: true,
        enabled: true,
        optioncount: 6,
        options: ['Drop Down Item 1', 'Drop Down Item 2', 'Drop Down Item 3', 'Drop Down Item 4', 'Drop Down Item 5', 'Drop Down Item 6'],
        selected: 'Drop Down Item 1'
      },
      link_label        => { visible: true, caption: 'Links:' },
      links_list        => {
        visible: true,
        enabled: true,
        itemcount: 3,
        items: ['Open Media Page in same window/tab', 'Open Media Page in a new window/tab', 'Disabled Link']
      },
      link_1            => {
        visible: true,
        href: { ends_with: 'media_page.html' },
        caption: 'Open Media Page in same window/tab'
      },
      link_2            => {
        visible: true,
        href: { ends_with: 'media_page.html' },
        caption: 'Open Media Page in a new window/tab'
      },
      link_3            => {
        visible: true,
        aria_disabled: true,
        role: 'link',
        caption: 'Disabled Link'
      },
      table_label       => { visible: true, caption: 'Table:' },
      static_table      => {
        visible: true,
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
      images_label      => { visible: true, caption: 'Images:' },
      image_1           => {
        visible: true,
        loaded: true,
        broken: false,
        src: { ends_with: 'images/Wilder.jpg' },
        alt: "It's alive"
      },
      image_2           => {
        visible: true,
        loaded: true,
        broken: false,
        src: { ends_with: 'images/You_Betcha.jpg' },
        alt: 'You Betcha'
      },
      image_3           => {
        visible: true,
        broken: true,
        src: { ends_with: 'wrongname.gif' },
        alt: 'A broken image'
      },
      cancel_button     => { visible: true, enabled: true, caption: 'Cancel' },
      submit_button     => { visible: true, enabled: true, caption: 'Submit' }
    }
    verify_ui_states(ui)
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
      number:       Faker::Number.between(from: 10, to: 1024),
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
    # populate fields and controls with externally sourced data
    @data = form_data
    fields = {
      username_field   => @data[:username],
      password_field   => @data[:password],
      max_length_field => @data[:maxlength],
      number_field     => @data[:number],
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
      number_field     => { value: @data[:number].to_s },
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
    verify_ui_states(ui)
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
            when :firefox
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
end

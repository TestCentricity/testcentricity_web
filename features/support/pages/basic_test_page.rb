# Page Object class definition for Basic HTML Test page

class BasicTestPage < BaseTestPage
  trait(:page_url)         { '/basic_test_page.html' }
  trait(:navigator)        { header_nav.open_form_page }
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
      comments_field,
      multi_select,
      drop_down_select
    ]
  }

  def verify_page_ui
    ui = {
      self              => { exists: true, secure: false, title: 'Basic HTML Form' },
      header_label      => { visible: true, caption: 'Basic HTML Form Example' },
      username_label    => { visible: true, caption: 'Username:' },
      username_field    => { visible: true, enabled: true, required: true, value: '', placeholder: 'User name' },
      password_label    => { visible: true, caption: 'Password:' },
      password_field    => { visible: true, enabled: true, required: true, value: '', placeholder: 'Password' },
      max_length_label  => { visible: true, caption: 'Max Length:' },
      max_length_field  => {
        visible: true,
        enabled: true,
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
      check_1           => { visible: true, enabled: true, checked: false },
      check_2           => { visible: true, enabled: true, checked: false },
      check_3           => { visible: true, enabled: true, checked: false },
      check_4           => { visible: true, enabled: false, checked: false },
      radios_label      => { visible: true, caption: 'Radio Items:' },
      radio_1           => { visible: true, enabled: true, selected: false },
      radio_2           => { visible: true, enabled: true, selected: false },
      radio_3           => { visible: true, enabled: true, selected: false },
      radio_4           => { visible: true, enabled: false, selected: false },
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
        { row: 4 } => [['Island Trading', 'Helen Bennett', 'UK']]
      },
      images_label      => { visible: true, caption: 'Images:' },
      image_1           => {
        visible: true,
        broken: false,
        src: { ends_with: 'images/Wilder.jpg' },
        alt: "It's alive"
      },
      image_2           => {
        visible: true,
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
    if Environ.platform == :mobile
      file_path = nil
      file_name = ''
      color_value = '#000000'
    else
      file_path = "#{Dir.pwd}/test_site/images/Wilder.jpg"
      file_name = 'Wilder.jpg'
      color_value = Faker::Color.hex_color
    end
    {
      username:     Faker::Name.name,
      password:     'T0p_Sekrit',
      maxlength:    Faker::Marketing.buzzwords,
      number:       Faker::Number.between(from: 10, to: 1024),
      color:        color_value,
      slider:       50,
      comments:     Faker::Hipster.paragraph,
      filepath:     file_path,
      filename:     file_name,
      check1:       true,
      check2:       true,
      check3:       false,
      radio1:       false,
      radio2:       true,
      radio3:       false,
      multi_select: 'Selection Item 2',
      drop_select:  'Drop Down Item 5'
    }
  end

  def populate_form
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
      radio_1          => @data[:radio1],
      radio_2          => @data[:radio2],
      radio_3          => @data[:radio3],
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
      radio_1          => { selected: @data[:radio1] },
      radio_2          => { selected: @data[:radio2] },
      radio_3          => { selected: @data[:radio3] },
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
            when :safari
              safari_tab_order
            when :firefox
              firefox_order
            else
              tab_order
            end
    verify_focus_order(order)
  end
end

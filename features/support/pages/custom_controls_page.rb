# Page Object class definition for Custom Controls page with CSS locators

class CustomControlsPage < BaseTestPage
  trait(:page_name)    { 'Custom Controls' }
  trait(:page_locator) { 'div.custom-controls-page-body' }
  trait(:page_url)     { '/custom_controls_page.html' }
  trait(:navigator)    { header_nav.open_custom_controls_page }
  trait(:page_title)   { 'Custom Controls Page'}
  trait(:divisions)    {
    ['NFC EAST',
     'NFC NORTH',
     'NFC SOUTH',
     'NFC WEST',
     'AFC EAST',
     'AFC NORTH',
     'AFC SOUTH',
     'AFC WEST']
  }
  trait(:teams)        {
    ['Dallas Cowboys',
     'New York Giants',
     'Philadelphia Eagles',
     'Washington Redskins',
     'Chicago Bears',
     'Detroit Lions',
     'Green Bay Packers',
     'Minnesota Vikings',
     'Atlanta Falcons',
     'Carolina Panthers',
     'New Orleans Saints',
     'Tampa Bay Buccaneers',
     'Arizona Cardinals',
     'St. Louis Rams',
     'San Francisco 49ers',
     'Seattle Seahawks',
     'Buffalo Bills',
     'Miami Dolphins',
     'New England Patriots',
     'New York Jets',
     'Baltimore Ravens',
     'Cincinnati Bengals',
     'Cleveland Browns',
     'Pittsburgh Steelers',
     'Houston Texans',
     'Indianapolis Colts',
     'Jacksonville Jaguars',
     'Tennessee Titans',
     'Denver Broncos',
     'Kansas City Chiefs',
     'Oakland Raiders',
     'San Diego Chargers']
  }
  trait(:countries)    { ['United Kingdom', 'Tonga', 'Sweden', 'Peru', 'Belize', 'Mali', 'Ireland'] }

  # Custom Controls page UI elements
  selectlists country_select: 'div#country_chosen',
              team_select:    'div#team_chosen'
  checkboxes  pork_check:     'label[for="check1"]',
              beef_check:     'label[for="check2"]',
              chicken_check:  'label[for="check3"]',
              shrimp_check:   'label[for="check4"]'
  radios      mild_radio:     'label[for="radio1"]',
              spicey_radio:   'label[for="radio2"]',
              hot_radio:      'label[for="radio3"]',
              flaming_radio:  'label[for="radio4"]'
  tables      custom_table:   'div#resp-table'
  elements    drop_1:         'div#droppable1',
              drop_2:         'div#droppable2',
              drag_1:         'div#draggable1',
              drag_2:         'div#draggable2'
  section     :weather_embed, WeatherEmbed

  attr_accessor :selected_country
  attr_accessor :selected_team
  attr_accessor :selected_checks
  attr_accessor :selected_radio
  attr_accessor :drag_x
  attr_accessor :drag_y

  def initialize
    super
    # define the custom list element components for the Country and Team Chosen selectlists
    list_spec = {
      selected_item: 'li[class*="result-selected"]',
      list_item:     'li[class*="active-result"]',
      text_field:    'input.chosen-search-input',
      options_list:  'ul.chosen-results',
      group_item:    'li.group-result',
      group_heading: 'li.group-result'
    }
    country_select.define_list_elements(list_spec)
    team_select.define_list_elements(list_spec)
    # define the custom element components for the checkboxes
    check_spec = { input: 'input[type="checkbox"]' }
    pork_check.define_custom_elements(check_spec)
    beef_check.define_custom_elements(check_spec)
    chicken_check.define_custom_elements(check_spec)
    shrimp_check.define_custom_elements(check_spec)
    # define the custom element components for the radios
    radio_spec = { input: 'input[type="radio"]' }
    mild_radio.define_custom_elements(radio_spec)
    spicey_radio.define_custom_elements(radio_spec)
    hot_radio.define_custom_elements(radio_spec)
    flaming_radio.define_custom_elements(radio_spec)
    # define the custom element components for the table
    table_spec = {
      table_header:  'div.resp-table-header',
      header_row:    'div.resp-table-row',
      header_column: 'div.table-header-cell',
      table_body:    'div.resp-table-body',
      table_row:     'div.resp-table-row',
      table_column:  'div.table-body-cell'
    }
    custom_table.define_table_elements(table_spec)
  end

  def verify_page_ui
    super

    ui = {
      country_select => {
        exists: true,
        visible: true,
        enabled: true,
        optioncount: 251
      },
      team_select => {
        exists: true,
        visible: true,
        enabled: true,
        optioncount: 32,
        options: teams,
        groupcount: 8,
        group_headings: divisions
      },
      pork_check => {
        exists: true,
        visible: true,
        enabled: true,
        checked: true,
        caption: 'Pork'
      },
      beef_check => {
        exists: true,
        visible: true,
        enabled: true,
        checked: false,
        caption: 'Beef'
      },
      chicken_check => {
        exists: true,
        visible: true,
        enabled: true,
        checked: false,
        caption: 'Chicken'
      },
      shrimp_check => {
        exists: true,
        visible: true,
        enabled: true,
        checked: false,
        caption: 'Shrimp'
      },
      mild_radio => {
        exists: true,
        visible: true,
        enabled: true,
        selected: true,
        caption: 'Mild'
      },
      spicey_radio => {
        exists: true,
        visible: true,
        enabled: true,
        selected: false,
        caption: 'Spicey'
      },
      hot_radio => {
        exists: true,
        visible: true,
        enabled: true,
        selected: false,
        caption: 'Hot'
      },
      flaming_radio => {
        exists: true,
        visible: true,
        enabled: true,
        selected: false,
        caption: 'Flaming'
      },
      drop_1 => {
        visible: true,
        draggable: false,
        caption: 'Drop here'
      },
      drop_2 => {
        visible: true,
        draggable: false,
        caption: 'No Drop here'
      },
      drag_1 => {
        visible: true,
        caption: 'Drag me'
      },
      drag_2 => {
        visible: true,
        caption: 'Drag me'
      },
      custom_table => {
        visible: true,
        columncount: 4,
        rowcount: 3,
        column_headers: ['Header 1', 'Header 2', 'Header 3', 'Header 4'],
        { row: 1 } => [['Cell 1–1', 'Cell 1–2', 'Cell 1–3', 'Cell 1–4']],
        { row: 2 } => [['Cell 2–1', 'Cell 2–2', 'Cell 2–3', 'Cell 2–4']],
        { row: 3 } => [['Cell 3–1', 'Cell 3–2', 'Cell 3–3', 'Cell 3–4']],
        { cell: [1, 3] } => ['Cell 1–3'],
        { cell: [2, 4] } => ['Cell 2–4'],
        { column: 3 } => [['Cell 1–3', 'Cell 2–3', 'Cell 3–3']]
      }
    }
    verify_ui_states(ui)
    team_select.verify_options(teams)
    weather_embed.wait_until_exists(5)
    weather_embed.verify_embed unless Environ.device_os == :ios
  end

  def populate_form
    @selected_country = countries.sample
    @selected_team = teams.sample
    @selected_checks = [:chicken, :shrimp]
    @selected_radio = 3
    fields = {
      country_select => @selected_country,
      team_select    => @selected_team,
      pork_check     => @selected_checks.include?(:pork),
      beef_check     => @selected_checks.include?(:beef),
      chicken_check  => @selected_checks.include?(:chicken),
      shrimp_check   => @selected_checks.include?(:shrimp),
      mild_radio     => @selected_radio == 1,
      spicey_radio   => @selected_radio == 2,
      hot_radio      => @selected_radio == 3,
      flaming_radio  => @selected_radio == 4
    }
    populate_data_fields(fields)
  end

  def set_select_options
    @selected_checks = [:pork]
    @selected_radio = 1
    @selected_country = countries.sample
    @selected_team = teams.sample
    country_select.set(@selected_country)
    team_select.set(@selected_team)
  end

  def verify_form_data
    ui = {
      country_select => { selected: @selected_country },
      team_select    => { selected: @selected_team },
      pork_check     => { checked: @selected_checks.include?(:pork) },
      beef_check     => { checked: @selected_checks.include?(:beef) },
      chicken_check  => { checked: @selected_checks.include?(:chicken) },
      shrimp_check   => { checked: @selected_checks.include?(:shrimp) },
      mild_radio     => { selected: @selected_radio == 1 },
      spicey_radio   => { selected: @selected_radio == 2 },
      hot_radio      => { selected: @selected_radio == 3 },
      flaming_radio  => { selected: @selected_radio == 4 }
    }
    verify_ui_states(ui)
  end

  def choose_options_by(method)
    case method.downcase.to_sym
    when :index
      country_select.choose_option(index: 56)
      team_select.choose_option(index: 20)
    when :text
      country_select.choose_option('Costa Rica')
      team_select.choose_option('Seattle Seahawks')
    else
      raise "#{method} is not a valid selector"
    end
  end

  def verify_chosen_options
    ui = {
      country_select => { selected: 'Costa Rica' },
      team_select    => { selected: 'Seattle Seahawks' }
    }
    verify_ui_states(ui)
  end

  def drag_to_drop_zone(drag_object, drop_zone)
    drag_obj = case drag_object.downcase.to_sym
               when :first
                 drag_1
               when :second, :last
                 drag_2
               else
                 raise "#{drag_object} is not a valid selector"
               end
    drop_obj = case drop_zone.downcase.to_sym
               when :first
                 drop_1
               when :second, :last
                 drop_2
               else
                 raise "#{drop_zone} is not a valid selector"
               end
    # force drag and drop objects to be found to prevent stale object reference exceptions
    drag_obj.reset_mru_cache
    drop_obj.reset_mru_cache
    # scroll drop zone into view
    drop_obj.scroll_to(:bottom)
    # save drag object's start location before drag
    @drag_x = drag_obj.x
    @drag_y = drag_obj.y
    drag_obj.drag_and_drop(drop_obj)
    sleep(1)
  end

  def verify_dropped(drag_object, drop_zone, result)
    drag_obj = case drag_object.downcase.to_sym
               when :first
                 drag_1
               when :second, :last
                 drag_2
               else
                 raise "#{drag_object} is not a valid selector"
               end
    drop_obj = case drop_zone.downcase.to_sym
               when :first
                 drop_1
               when :second, :last
                 drop_2
               else
                 raise "#{drop_zone} is not a valid selector"
               end
    response = case result.downcase.to_sym
               when :accept, :contain
                 'Dropped!'
               when :reject
                 'Get Off Me!'
               else
                 raise "#{result} is not a valid selector"
               end
    drop = {
      drag_obj => {
        x: { not_equal: @drag_x },
        y: { not_equal: @drag_y }
      },
      drop_obj => { caption: response }
    }
    verify_ui_states(drop)
  end

  def drag_by(drag_object, direction)
    drag_obj = case drag_object.downcase.to_sym
               when :first
                 drag_1
               when :second, :last
                 drag_2
               else
                 raise "#{drag_object} is not a valid selector"
               end
    h_offset = case direction.downcase.to_sym
               when :right
                 75
               when :left
                 -75
               else
                 raise "#{direction} is not a valid selector"
               end
    drag_obj.reset_mru_cache
    # save drag object's start location before drag
    @drag_x = drag_obj.x
    @drag_y = drag_obj.y
    drag_obj.drag_by(h_offset, -30)
    sleep(1)
  end

  def verify_no_drops
    ui = {
      drop_1 => { caption: 'Drop here' },
      drop_2 => { caption: 'No Drop here' }
    }
    verify_ui_states(ui)
  end
end

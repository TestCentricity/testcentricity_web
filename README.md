# TestCentricity™ Web

[![Gem Version](https://badge.fury.io/rb/testcentricity_web.svg)](https://badge.fury.io/rb/testcentricity_web)
[![License (3-Clause BSD)](https://img.shields.io/badge/license-BSD%203--Clause-blue.svg?style=flat-square)](http://opensource.org/licenses/BSD-3-Clause)
![Gem Downloads](https://img.shields.io/gem/dt/testcentricity_web)
![Maintained](https://img.shields.io/maintenance/yes/2023)
[![Docs](https://img.shields.io/badge/docs-rubydoc-blue.svg)](http://www.rubydoc.info/gems/testcentricity_web)


The TestCentricity™ Web core framework for desktop and mobile web browser-based app testing implements a Page Object Model
DSL for use with Cucumber (version 7.x or greater) or RSpec, and Selenium-Webdriver (version 4.14). It also facilitates the
configuration of the appropriate Selenium-Webdriver capabilities required to establish connections with one or more local
or cloud hosted desktop or mobile web browsers.

The TestCentricity™ Web gem supports connecting to, and running automated tests against the following target web browsers:
* locally hosted desktop browsers (Chrome, Edge, Firefox, or Safari)
* locally hosted "headless" Chrome, Firefox, or Edge browsers
* remote desktop and emulated mobile web browsers hosted on Selenium Grid 4 and Dockerized Selenium Grid 4 environments
* mobile Safari browsers on iOS device simulators or physical iOS devices (using Appium and XCode on macOS)
* mobile Chrome or Android browsers on Android Studio virtual device emulators (using Appium and Android Studio)
* cloud hosted desktop (Firefox, Chrome, Safari, IE, or Edge) or mobile (iOS Mobile Safari or Android Chrome) web browsers using the following service:
  * [Browserstack](https://www.browserstack.com/list-of-browsers-and-platforms?product=automate)
  * [Sauce Labs](https://saucelabs.com/platform/cross-browser-testing)
  * [TestingBot](https://testingbot.com/features)
  * [LambdaTest](https://www.lambdatest.com/selenium-automation)
* web portals utilizing JavaScript front end application frameworks like Ember, React, Angular, and GWT
* web pages containing HTML5 Video and Audio objects
* locally hosted emulated iOS Mobile Safari, Android, Windows Phone, or Blackberry mobile browsers (running within a local instance of Chrome)


## What's New

A complete history of bug fixes and new features can be found in the {file:CHANGELOG.md CHANGELOG} file.

The RubyDocs for this gem can be found [here](https://www.rubydoc.info/gems/testcentricity_web).

An example project that demonstrates the implementation of a page object model framework using Cucumber and TestCentricity™ Web
can be found [here](https://github.com/TestCentricity/tc_web_sample).


## Installation

TestCentricity Web version 4.4 and above requires Ruby version 3.0.0 or later. To install the TestCentricity Web gem, add
this line to your automation project's `Gemfile`:

    gem 'testcentricity_web'

And then execute:

    $ bundle

Or install it yourself using:

    $ gem install testcentricity_web


## Setup
### Using Cucumber

If you are using Cucumber, you need to require the following in your `env.rb` file:

    require 'capybara/cucumber'
    require 'testcentricity_web'


### Using RSpec

If you are using RSpec instead, you need to require the following in your `spec_helper.rb` file:

    require 'capybara/rspec'
    require 'testcentricity_web'


---
## PageObjects

The **Page Object Model** is a test automation pattern that aims to create an abstraction of your web app's User Interface
that can be used in tests. A **Page Object** represents a single page in your AUT (Application Under Test). **Page Objects**
encapsulate the implementation details of a web page and expose an API that supports interaction with, and validation of
the UI elements on the page.

**Page Objects** makes it easier to maintain automated tests because changes to page UI elements are updated in only one
location - in the **Page Object** class definition. By adopting a **Page Object Model**, Cucumber Feature files and step
definitions are no longer required to hold specific information about a page's UI objects, thus minimizing maintenance
requirements. If any element on, or property of a page changes (URL path, text field attributes, button captions, etc.),
maintenance is performed in the `PageObject` class definition only, typically with no need to update the affected feature
files, scenarios, or step definitions.


### Defining a PageObject

Your `PageObject` class definitions should be contained within individual `.rb` files in the `features/support/pages` folder
of your test automation project. You define new `PageObjects` as shown below:

    class LoginPage < TestCentricity::PageObject
    end


    class HomePage < TestCentricity::PageObject
    end


    class RegistrationPage < TestCentricity::PageObject
    end


    class UserAccountPage < TestCentricity::PageObject
    end


### Adding Traits to a PageObject

Web pages typically have names and URLs associated with them. Web pages also typically have a unique object or attribute
that, when present, indicates that the page's contents have fully loaded.

The `page_name` trait is registered with the `PageManager` object, which includes a `find_page` method that takes a page
name as a parameter and returns an instance of the associated `PageObject`. If you intend to use the `PageManager`, you
must define a `page_name` trait for each `PageObject` to be registered. Refer to [**section 7 (Instantiating Your PageObjects)**](#instantiating-your-pageobjects).


The `page_name` trait is usually a `String` value that represents the name of the page that will be matched by the `PageManager.findpage`
method. `page_name` traits are case and white-space sensitive. For pages that may be referenced with multiple names, the
`page_name` trait may also be an `Array` of `String` values representing those page names.

A `page_locator` trait is defined if a page has a unique object or attribute that exists once the page's contents have fully
loaded. The `page_locator` trait is a CSS or Xpath expression that uniquely identifies the object or attribute. The
`verify_page_exists` method waits for the `page_locator` trait to exist.

An optional `page_url` trait should be defined if a page can be directly loaded using a URL. If you set Capybara's `app_host`,
or specify a base URL when calling the `WebDriverConnect.initialize_web_driver` method, then your `page_url` trait can be the
relative URL slug that will be appended to the base URL specified in `app_host`. Specifying a `page_url` trait is optional,
as not all web pages can be directly loaded via a URL.

You define your page's **Traits** as shown below:

    class LoginPage < TestCentricity::PageObject
      trait(:page_name)    { 'Login' }
      trait(:page_url)     { '/sign_in' }
      trait(:page_locator) { 'body.login-body' }
    end


    class HomePage < TestCentricity::PageObject
      # this page may be referred to as 'Home' or 'Dashboard' page so page_name trait is an Array of Strings
      trait(:page_name)    { ['Home', 'Dashboard'] }
      trait(:page_url)     { '/dashboard' }
      trait(:page_locator) { 'body.dashboard' }
    end


    class RegistrationPage < TestCentricity::PageObject
      trait(:page_name)    { 'Registration' }
      trait(:page_url)     { '/register' }
      trait(:page_locator) { 'body.registration' }
    end


    class UserAccountPage < TestCentricity::PageObject
      trait(:page_name)    { 'User Account' }
      trait(:page_url)     { "/user_account/#{User.current.id}" }
      trait(:page_locator) { 'body.useraccount' }
    end


### Adding UI Elements to a PageObject

Web pages are made up of UI elements like text fields, check boxes, combo boxes, radio buttons, tables, lists, buttons, etc.
**UI Elements** are added to your `PageObject` class definition as shown below:

    class LoginPage < TestCentricity::PageObject
      trait(:page_name)    { 'Login' }
      trait(:page_url)     { '/sign_in' }
      trait(:page_locator) { 'body.login-body' }

      # Login page UI elements
      textfield :user_id_field,       'input#userName'
      textfield :password_field,      'input#password'
      button    :login_button,        'button#login'
      checkbox  :remember_checkbox,   'input#rememberUser'
      label     :error_message_label, 'div#statusBar.login-error'
    end


    class RegistrationPage < TestCentricity::PageObject
      trait(:page_name)    { 'Registration' }
      trait(:page_url)     { '/register' }
      trait(:page_locator) { 'body.registration' }

      # Registration page UI elements
      textfields  first_name_field:    'input#firstName',
                  last_name_field:     'input#lastName',
                  email_field:         'input#email',
                  phone_number_field:  'input#phone',
                  address_field:       'input#streetAddress',
                  city_field:          'input#city',
                  post_code_field:     'input#postalCode',
                  password_field:      'input#password',
                  pword_confirm_field: 'input#passwordConfirmation'
      selectlists title_select:        'select#title',
                  gender_select:       'select#gender',
                  state_select:        'select#stateProvince'
      checkbox    :email_opt_in_check, 'input#marketingEmailsOptIn'
      button      :sign_up_button,     'button#registrationSignUp'
    end


### Adding Methods to a PageObject

It is good practice for your Cucumber step definitions to call high level methods in your your `PageObject` instead of
directly accessing and interacting with a page object's UI elements. You can add high level methods to your `PageObject`
class definition for interacting with the UI to hide implementation details, as shown below:

    class LoginPage < TestCentricity::PageObject
      trait(:page_name)    { 'Login' }
      trait(:page_url)     { '/sign_in' }
      trait(:page_locator) { 'body.login-body' }

      # Login page UI elements
      textfield :user_id_field,        'input#userName'
      textfield :password_field,       'input#password'
      button    :login_button,         'button#login'
      checkbox  :remember_checkbox,    'input#rememberUser'
      label     :error_message_label,  'div#statusBar.login-error'
      link      :forgot_password_link, 'a.forgotPassword'

      # log in to web app
      def login(user_id, password)
        user_id_field.set(user_id)
        password_field.set(password)
        login_button.click
      end

      # set the state of the Remember Me checkbox
      def remember_me(state)
        remember_checkbox.set_checkbox_state(state)
      end

      # verify Login page default UI state
      def verify_page_ui
        ui = {
          self => { title: 'Login' },
          login_button => {
            visible: true,
            caption: 'LOGIN'
          },
          user_id_field => {
            visible: true,
            enabled: true,
            value: '',
            placeholder: 'User name'
          },
          password_field => {
            visible: true,
            enabled: true,
            value: '',
            placeholder: 'Password'
          },
          remember_checkbox => {
            exists: true,
            enabled: true,
            checked: false
          },
          forgot_password_link => {
            visible: true,
            caption: 'Forgot your password?'
          },
          error_message_label => { visible: false }
        }
        verify_ui_states(ui)
      end
    end


    class RegistrationPage < TestCentricity::PageObject
      trait(:page_name)    { 'Registration' }
      trait(:page_url)     { '/register' }
      trait(:page_locator) { 'body.registration' }

      # Registration page UI elements
      textfields  first_name_field:    'input#firstName',
                  last_name_field:     'input#lastName',
                  email_field:         'input#email',
                  phone_number_field:  'input#phone',
                  address_field:       'input#streetAddress',
                  city_field:          'input#city',
                  post_code_field:     'input#postalCode',
                  password_field:      'input#password',
                  pword_confirm_field: 'input#passwordConfirmation'
      selectlists title_select:        'select#title',
                  gender_select:       'select#gender',
                  state_select:        'select#stateProvince'
      checkbox    :email_opt_in_check, 'input#marketingEmailsOptIn'
      buttons     sign_up_button:      'button#registrationSignUp',
                  cancel_button:       'button#registrationCancel'

      # populate Registration page fields with profile data
      def enter_profile_data(profile)
        fields = { title_select        => profile.title,
                   first_name_field    => profile.first_name,
                   last_name_field     => profile.last_name,
                   gender_select       => profile.gender,
                   phone_number_field  => profile.phone,
                   email_field         => profile.email,
                   address_field       => profile.address,
                   city_field          => profile.city,
                   state_select        => profile.state,
                   post_code_field     => profile.postal_code,
                   password_field      => profile.password,
                   pword_confirm_field => profile.confirm_password,
                   email_opt_in_check  => profile.email_opt_in
        }
        populate_data_fields(fields)
        sign_up_button.click
      end
    end



Once your `PageObjects` have been instantiated, you can call your methods as shown below:

    login_page.remember_me(true)
    login_page.login(user_id = 'snicklefritz', password = 'Pa55w0rd')


---
## PageSections

A `PageSection` is a collection of **UI Elements** that may appear in multiple locations on a page, or on multiple pages
in a web app. It is a collection of **UI Elements** that represent a conceptual area of functionality, like a navigation
bar, a search capability, a menu, or a pop-up panel. **UI Elements** and functional behavior are confined to the scope of
a `PageSection` object.

Below is an example of a header navigation bar feature that is common to multiple pages -

![Navigation Header](https://raw.githubusercontent.com/TestCentricity/testcentricity_web/main/.github/images/NavBar1.png "Navigation Header")

 -

![Navigation Header](https://raw.githubusercontent.com/TestCentricity/testcentricity_web/main/.github/images/NavBar2.png "Navigation Header")

Below is an example of a popup Shopping Bag panel associated with a header navigation bar -

![Shopping Bag Popup](https://raw.githubusercontent.com/TestCentricity/testcentricity_web/main/.github/images/ShoppingBagPopUp.png "Shopping Bag Popup")

A `PageSection` may contain other `PageSection` objects.


### Defining a PageSection

Your `PageSection` class definitions should be contained within individual `.rb` files in the `features/support/sections`
folder of your test automation project. You define new `PageSection` as shown below:

    class BagViewPopup < TestCentricity::PageSection
    end


### Adding Traits to a PageSection

A `PageSection` typically has a root node object that encapsulates a collection of `UIElements`. The `section_locator` trait
specifies the CSS or Xpath expression that uniquely identifies that root node object.

You define your section's **Traits** as shown below:

    class BagViewPopup < TestCentricity::PageSection
      trait(:section_locator) { 'aside.ac-gn-bagview' }
      trait(:section_name)    { 'Shopping Bag Popup' }
    end


### Adding UI Elements to a PageSection

`PageSections` are typically made up of UI elements like text fields, check boxes, combo boxes, radio buttons, tables, lists,
buttons, etc. **UI Elements** are added to your `PageSection` class definition as shown below:

    class BagViewPopup < TestCentricity::PageSection
      trait(:section_locator) { 'aside.ac-gn-bagview' }
      trait(:section_name)    { 'Shopping Bag Popup' }

      # Shopping Bag Popup UI elements
      label  :bag_message,     'p[class*="ac-gn-bagview-message"]'
      lists  bag_items_list:   'ul[class*="ac-gn-bagview-bag"]',
             bag_nav_list:     'ul.ac-gn-bagview-nav-list '
      button :checkout_button, 'a[class*="ac-gn-bagview-button-checkout"]'
    end


### Adding Methods to a PageSection

You can add high level methods to your `PageSection` class definition, as shown below:

    class BagViewPopup < TestCentricity::PageSection
      trait(:section_locator) { 'aside.ac-gn-bagview' }
      trait(:section_name)    { 'Shopping Bag Popup' }

      # Shopping Bag Popup UI elements
      label  :bag_message,     'p[class*="ac-gn-bagview-message"]'
      lists  bag_items_list:   'ul[class*="ac-gn-bagview-bag"]',
             bag_nav_list:     'ul.ac-gn-bagview-nav-list '
      button :checkout_button, 'a[class*="ac-gn-bagview-button-checkout"]'

      def item_count
        bag_items_list.visible? ? bag_items_list.item_count : 0
      end

      def perform_action(action)
        case action.gsub(/\s+/, '_').downcase.to_sym
        when :check_out
          checkout_button.click
        when :view_bag
          bag_nav_list.choose_item(1)
        when :saved_items
          bag_nav_list.choose_item(2)
        when :orders
          bag_nav_list.choose_item(3)
        when :account
          bag_nav_list.choose_item(4)
        when :sign_in, :sign_out
          bag_nav_list.choose_item(5)
        else
          raise "#{action} is not a valid selector"
        end
      end
    end


### Adding PageSections to your PageObject

You add a `PageSection` to its associated `PageObject` as shown below:

    class HomePage < TestCentricity::PageObject
      trait(:page_name)    { 'Home' }
      trait(:page_url)     { '/dashboard' }
      trait(:page_locator) { 'body.dashboard' }

      # Home page Section Objects
      section :search_form, SearchForm
    end

Once your `PageObject` has been instantiated, you can call its `PageSection` methods as shown below:

    home_page.search_form.search_for('ocarina')


---
## UIElements

`PageObjects` and `PageSections` are typically made up of UI elements like text fields, check boxes, select lists (combo
boxes), radio buttons, tables, ordered and unordered lists, buttons, images, HTML5 video or audio player objects, etc.
UI elements are declared and instantiated within the class definition of the `PageObject` or `PageSection` in which they
are contained. With TestCentricity Web, all UI elements are based on the `UIElement` class.


### Declaring and Instantiating UIElements

Single `UIElement` declarations have the following format:
                                     
    elementType :elementName, locator

* The `elementName` is the unique name that you will use to refer to the UI element and is specified as a `Symbol`.
* The `locator` is the CSS or XPath attribute that uniquely and unambiguously identifies the `UIElement`.

Multiple `UIElement` declarations for a collection of elements of the same type can be performed by passing a hash table
containing the names and locators of each individual element.

### Example UIElement Declarations

Supported `UIElement` elementTypes and their declarations have the following format:

*Single element declarations:*

    class SamplePage < TestCentricity::PageObject

      button     :button_name, locator
      textfield  :field_name, locator
      checkbox   :checkbox_name, locator
      radio      :radio_button_name, locator
      label      :label_name, locator
      link       :link_name, locator
      selectlist :select_name, locator
      list       :list_name, locator
      table      :table_name, locator
      range      :range_name, locator
      image      :image_name, locator
      video      :video_name, locator
      audio      :audio_name, locator
      filefield  :filefield_name, locator

    end
 
*Multiple element declarations:*

    class SamplePage < TestCentricity::PageObject

      buttons     button_1_name: locator,
                  button_2_name: locator,
                  button_X_name: locator
      textfields  field_1_name: locator,
                  field_2_name: locator,
                  field_X_name: locator
      checkboxes  check_1_name: locator,
                  check_2_name: locator,
                  check_X_name: locator
      radios      radio_1_name: locator,
                  radio_X_name: locator
      labels      label_1_name: locator,
                  label_X_name: locator
      links       link_1_name: locator,
                  link_X_name: locator
      selectlists selectlist_1_name: locator,
                  selectlist_X_name: locator
      lists       list_1_name: locator,
                  list_X_name: locator
      tables      table_1_name: locator,
                  table_X_name: locator
      ranges      range_1_name: locator,
                  range_X_name: locator
      images      image_1_name: locator,
                  image_X_name: locator
      videos      video_1_name: locator,
                  video_X_name: locator
      audios      audio_1_name: locator,
                  audio_X_name: locator
      filefields  filefield_1_name: locator,
                  filefield_X_name: locator

    end


Refer to the Class List documentation for the `PageObject` and `PageSection` classes for details on the class methods used
for declaring and instantiating `UIElements`. Examples of UI element declarations can be found in the ***Adding UI Elements
to your PageObject*** and
***Adding UI Elements to your PageSection*** sections above.


### UIElement Inherited Methods

With TestCentricity, all UI elements are based on the `UIElement` class, and inherit the following methods:

**Action methods:**

    element.click
    element.double_click
    element.right_click
    element.click_at(x, y)
    element.hover
    element.hover_at(x, y)
    element.scroll_to(position)
    element.drag_by(right_offset, down_offset)
    element.drag_and_drop(target, right_offset, down_offset)

**Object state methods:**

    element.exists?
    element.visible?
    element.hidden?
    element.enabled?
    element.disabled?
    element.displayed?
    element.obscured?
    element.focused?
    element.required?
    element.content_editable?
    element.crossorigin
    element.get_value
    element.count
    element.style
    element.title
    element.width
    element.height
    element.x
    element.y
    element.get_attribute(attrib)
    element.get_native_attribute(attrib)

**Waiting methods:**

    element.wait_until_exists(seconds)
    element.wait_until_gone(seconds)
    element.wait_until_visible(seconds)
    element.wait_until_hidden(seconds)
    element.wait_until_enabled(seconds)
    element.wait_until_value_is(value, seconds)
    element.wait_until_value_changes(seconds)
    element.wait_while_busy(seconds)

**WAI-ARIA Object Accessibility (A11y) methods:**

    element.role
    element.tabindex
    element.aria_disabled?
    element.aria_hidden?
    element.aria_expanded?
    element.aria_required?
    element.aria_invalid?
    element.aria_checked?
    element.aria_readonly?
    element.aria_haspopup?
    element.aria_selected?
    element.aria_pressed?
    element.aria_label
    element.aria_labelledby
    element.aria_describedby
    element.aria_live
    element.aria_sort
    element.aria_rowcount
    element.aria_colcount
    element.aria_valuemax
    element.aria_valuemin
    element.aria_valuenow
    element.aria_valuetext
    element.aria_orientation
    element.aria_roledescription
    element.aria_autocomplete
    element.aria_controls
    element.aria_modal?
    element.aria_keyshortcuts
    element.aria_multiline?
    element.aria_multiselectable?
    element.aria_busy?


### Populating a PageObject or PageSection With Data

A typical automated test may be required to perform the entry of test data by interacting with various `UIElements` on your
`PageObject` or `PageSection`. This data entry can be performed using the various object action methods (listed above) for
each `UIElement` that needs to be interacted with.

The `PageObject.populate_data_fields` and `PageSection.populate_data_fields` methods support the entry of test data into a
collection of `UIElements`. The `populate_data_fields` method accepts a hash containing key/hash pairs of `UIElements` and
their associated data to be entered. Data values must be in the form of a `String` for `textfield`, `selectlist`, and `filefield`
controls. For `checkbox` and `radio` controls, data must either be a `Boolean` or a `String` that evaluates to a `Boolean`
value (Yes, No, 1, 0, true, false). For `range` controls, data must be an `Integer`. For `input(type='color')` color picker
controls, which are specified as a `textfield`, data must be in the form of a hex color `String`. For `section` objects,
data values must be a `String`, and the `section` object must have a `set` method defined.

The `populate_data_fields` method verifies that data attributes associated with each `UIElement` is not `nil` or `empty`
before attempting to enter data into the `UIElement`.

The optional `wait_time` parameter is used to specify the time (in seconds) to wait for each `UIElement` to become viable
for data entry (the `UIElement` must be visible and enabled) before entering the associated data value. This option is useful
in situations where entering data, or setting the state of a `UIElement` might cause other `UIElements` to become visible
or active. Specifying a wait_time value ensures that the subsequent `UIElements` will be ready to be interacted with as
states are changed. If the wait time is `nil`, then the wait time will be 5 seconds.

    def enter_data(user_data)
      fields = {
        first_name_field    => user_data.first_name,
        last_name_field     => user_data.last_name,
        email_field         => user_data.email,
        country_code_select => user_data.country_code,
        phone_number_field  => user_data.phone_number,
        time_zone_select    => user_data.time_zone,
        language_select     => user_data.language
      }
      populate_data_fields(fields, wait_time = 2)
    end


### Verifying UIElements on a PageObject or PageSection

A typical automated test executes one or more interactions with the user interface, and then performs a validation to verify
whether the expected state of the UI has been achieved. This verification can be performed using the various object state
methods (listed above) for each `UIElement` that requires verification. Depending on the complexity and number of `UIElements`
to be verified, the code required to verify the presence of `UIElements` and their correct states can become cumbersome.

The `PageObject.verify_ui_states` and `PageSection.verify_ui_states` methods support the verification of multiple properties
of multiple UI elements on a `PageObject` or `PageSection`. The `verify_ui_states` method accepts a hash containing key/hash
pairs of UI elements and their properties or attributes to be verified.

     ui = {
       object1 => { property: state },
       object2 => { property: state, property: state },
       object3 => { property: state }
     }
     verify_ui_states(ui)

The `verify_ui_states` method queues up any exceptions that occur while verifying each object's properties until all `UIElements`
and their properties have been checked, and then posts any exceptions encountered upon completion. Posted exceptions include
a screenshot with a red dashed highlight around the UI element that did not match the expected results.

The `verify_ui_states` method supports the following property/state pairs:

**All Objects:**

    :exists            Boolean
    :enabled           Boolean
    :disabled          Boolean
    :visible           Boolean
    :hidden            Boolean
    :displayed         Boolean
    :obscured          Boolean
    :width             Integer
    :height            Integer
    :x                 Integer
    :y                 Integer
    :class             String
    :value or :caption String
    :attribute         Hash
    :style             String
    :tabindex          Integer
    :required          Boolean
    :crossorigin       String

**Pages:**

    :secure Boolean
    :title  String

**Text Fields:**

    :readonly    Boolean
    :placeholder String
    :maxlength   Integer
    :min         Integer
    :max         Integer
    :step        Integer

  Text Field Constraint Validation

    :validation_message String
    :badInput           Boolean
    :customError        Boolean
    :patternMismatch    Boolean
    :rangeOverflow      Boolean
    :rangeUnderflow     Boolean
    :stepMismatch       Boolean
    :tooLong            Boolean
    :tooShort           Boolean
    :typeMismatch       Boolean
    :valid              Boolean
    :valueMissing       Boolean

**Checkboxes:**

    :checked       Boolean
    :indeterminate Boolean

**Radio Buttons:**

    :selected Boolean

**Links:**

    :href String

**Images**

    :loaded Boolean
    :broken Boolean
    :src    String
    :alt    String

**Lists**

    :items     Array of Strings
    :itemcount Integer
    :item      Hash
    :selected  String

**Select Lists** (ComboBoxes):

    :items or :options         Array of Strings
    :itemcount or :optioncount Integer
    :selected                  String
    :groupcount                Integer
    :group_headings            Array of Strings

**Tables**

    :rowcount      Integer
    :columncount   Integer
    :columnheaders Array of String
    :cell          Hash
    :row           Hash
    :column        Hash

**Audio/Video Media Objects**

    :autoplay              Boolean
    :ended                 Boolean
    :controls              Boolean
    :loop                  Boolean
    :muted                 Boolean
    :default_muted         Boolean
    :paused                Boolean
    :seeking               Boolean
    :src                   String
    :current_time          Float
    :default_playback_rate Float
    :duration              Float
    :playback_rate         Float
    :ready_state           Integer
    :volume                Float
    :preload               String
    :poster                String
    :track_count           Integer
    :active_track          Integer
    :active_track_data     Hash
    :all_tracks_data       Array of Hash
    :track_data            Hash
    :active_track_source   String
    :track_source          String

#### ARIA Accessibility Property/State Pairs

The `verify_ui_states` method supports the following ARIA accessibility property/state pairs:

    :aria_label           String
    :aria_disabled        Boolean
    :aria_labelledby      String
    :aria_describedby     String
    :aria_live            Boolean
    :aria_selected        Boolean
    :aria_hidden          Boolean
    :aria_expanded        Boolean
    :aria_required        Boolean
    :aria_invalid         Boolean
    :aria_checked         Boolean
    :aria_readonly        Boolean
    :aria_pressed         Boolean
    :aria_busy            Boolean
    :aria_haspopup        Boolean
    :aria_sort            String
    :aria_rowcount        String
    :aria_colcount        String
    :aria_valuemax        String
    :aria_valuemin        String
    :aria_valuenow        String
    :aria_valuetext       String
    :aria_orientation     String
    :aria_keyshortcuts    String
    :aria_roledescription String
    :aria_autocomplete    String
    :aria_controls        String
    :aria_modal           String
    :aria_multiline       Boolean
    :aria_multiselectable Boolean
    :content_editable     Boolean
    :role                 String

#### Comparison States

The `verify_ui_states` method supports comparison states using property/comparison state pairs:

    object => { property: { comparison_state: value } }

Comparison States:

    :lt or :less_than                  Integer or String
    :lt_eq or :less_than_or_equal      Integer or String
    :gt or :greater_than               Integer or String
    :gt_eq or :greater_than_or_equal   Integer or String
    :starts_with                       String
    :ends_with                         String
    :contains                          String
    :not_contains or :does_not_contain Integer or String
    :not_equal                         Integer, String, or Boolean

The example below depicts a `verify_changes_saved` method that uses the `verify_ui_states` method to verify that all expected
values appear in the associated text fields after entering data and performing a save operation.

    def verify_changes_saved
      # verify saved user data is correctly displayed
      ui = {
        first_name_field => {
          visible: true,
          aria_invalid: false,
          value: User.current.first_name
        },
        last_name_field => {
          visible: true,
          aria_invalid: false,
          value: User.current.last_name
        },
        email_field => {
          visible: true,
          aria_invalid: false,
          value: User.current.email
        },
        phone_number_field => {
          visible: true,
          aria_invalid: false,
          value: User.current.phone_number
        },
        time_zone_select => {
          visible: true,
          aria_invalid: false,
          value: User.current.time_zone
        },
        language_select => {
          visible: true,
          aria_invalid: false,
          value: User.current.language
        },
        avatar_container => { visible: true },
        avatar_image => {
          visible: true,
          broken: false,
          src: { ends_with: User.current.avatar_file_name },
          alt: "#{User.current.first_name} #{User.current.last_name}",
          style: { contains: 'border-radius: 50%;'}
        },
        error_message_label => { visible: false }
      }
      verify_ui_states(ui)

      # verify avatar src url does not contain /null/ institution id
      verify_ui_states(avatar_image => { src: { does_not_contain: "/null/" } })
    end


#### I18n Translation Validation

The `verify_ui_states` method also supports I18n string translations using property/I18n key name pairs:

    object => { property: { translate_key: 'name of key in I18n compatible .yml file' } }

**I18n Translation Keys:**

    :translate            String
    :translate_upcase     String
    :translate_downcase   String
    :translate_capitalize String
    :translate_titlecase  String

The example below depicts the usage of the `verify_ui_states` method to verify that the captions for a popup Shopping Bag
panel are correctly translated.

![Localized UI](https://raw.githubusercontent.com/TestCentricity/testcentricity_web/main/.github/images/LocalizedUI.png "Localized UI")

    class BagViewPopup < TestCentricity::PageSection
      trait(:section_locator) { 'aside.ac-gn-bagview' }
      trait(:section_name)    { 'Shopping Bag Popup' }

      # Shopping Bag Popup UI elements
      label  :bag_message,     'p[class*="ac-gn-bagview-message"]'
      lists  bag_items_list:   'ul[class*="ac-gn-bagview-bag"]',
             bag_nav_list:     'ul.ac-gn-bagview-nav-list '
      button :checkout_button, 'a[class*="ac-gn-bagview-button-checkout"]'

      def verify_empty_bag_ui
        nav_items = %w[
          BagViewPopup.bag
          BagViewPopup.saved_items
          BagViewPopup.orders
          BagViewPopup.account
          BagViewPopup.sign_in
        ]
        ui = {
          bag_message => {
            visible: true,
            caption: { translate: 'BagViewPopup.bag_is_empty' }
          },
          bag_nav_list => {
            visible: true,
            itemcount: 5,
            items: { translate: nav_items }
          },
          bag_items_list => { visible: false },
          checkout_button => { visible: false }
        }
        verify_ui_states(ui)
      end
    end

I18n `.yml` files contain key/value pairs representing the name of a translated string (key) and the string value. For the
popup Shopping Bag panel example above, the translated strings for English, Spanish, and French are represented in below:

**English** - `en.yml`

    en:
      BagViewPopup:
        bag_is_empty: 'Your Bag is empty.'
        bag: 'Bag'
        saved_items: 'Saved Items'
        orders: 'Orders'
        account: 'Account'
        sign_in: 'Sign in'
        sign_out: 'Sign out'

**Spanish** - `es.yml`

    es:
      BagViewPopup:
        bag_is_empty: 'Tu bolsa está vacía.'
        bag: 'Bolsa'
        saved_items: 'Artículos guardados'
        orders: 'Pedidos'
        account: 'Cuenta'
        sign_in: 'Iniciar sesión'
        sign_out: 'Cerrar sesión'

**French** - `fr.yml`

    fr:
      BagViewPopup:
        bag_is_empty: 'Votre sac est vide.'
        bag: 'Sac'
        saved_items: 'Articles enregistrés'
        orders: 'Commandes'
        account: 'Compte'
        sign_in: 'Ouvrir une session'
        sign_out: 'Fermer la session'


Each supported language/locale combination has a corresponding `.yml` file. I18n `.yml` file naming convention uses
[ISO-639 language codes](https://docs.oracle.com/cd/E13214_01/wli/docs92/xref/xqisocodes.html#wp1252447) and
[ISO-3166 country codes](https://docs.oracle.com/cd/E13214_01/wli/docs92/xref/xqisocodes.html#wp1250799). For example:

| Language (Country)    | File name |
|-----------------------|-----------|
| English               | en.yml    |
| English (Canada)      | en-CA.yml |
| French (Canada)       | fr-CA.yml |
| French                | fr.yml    |
| Spanish               | es.yml    |
| German                | de.yml    |
| Portuguese (Brazil)   | pt-BR.yml |
| Portuguese (Portugal) | pt-PT.yml |

Baseline translation strings are stored in `.yml` files in the `config/locales/` folder.

       📁 my_automation_project/
        ├── 📁 config/
        │   ├── 📁 locales/
        │   │   ├── 📄 en.yml
        │   │   ├── 📄 en-AU.yml
        │   │   ├── 📄 es.yml
        │   │   ├── 📄 de.yml
        │   │   ├── 📄 fr.yml
        │   │   ├── 📄 fr-CA.yml
        │   │   ├── 📄 pt-BR.yml
        │   │   └── 📄 pt-PT.yml
        │   ├── 📁 test_data/
        │   └── 📄 cucumber.yml
        ├── 📁 downloads/
        ├── 📁 features/
        ├── 📄 Gemfile
        └── 📄 README.md


### Working With Custom UIElements

Many responsive and touch-enabled web based user interfaces are implemented using front-end JavaScript libraries for building
user interfaces based on multiple composite UI components. Popular JS libraries include React, Angular, and Ember.js. These
stylized and adorned controls can present a challenge when attempting to interact with them using Capybara and Selenium based
automated tests.

#### Radio and Checkbox UIElements

Sometimes, radio buttons and checkboxes implemented using JS component libraries cannot be interacted with due to other UI
elements being overlaid on top of them, causing the base `input(type='radio')` or `input(type='checkbox')` element to not
receive click actions.

In the screenshot below of an airline flight search and booking page, the **Round-trip**, **One-way**, and **Multi-city**
radio buttons are overlaid with `div` elements that also acts as proxies for their associated `input(type='radio')` elements,
and that intercept the `click` actions that would normally be handled by the `input(type='radio')` elements.

![Custom Radio buttons](https://raw.githubusercontent.com/TestCentricity/testcentricity_web/main/.github/images/CustomRadios.png "Custom Radio buttons")

The checkbox controls on the airline flight search and booking page are also overlaid with `div` elements that intercept
the `click` actions that would normally be handled by the `input(type='checkbox')` elements.

![Custom Checkbox controls](https://raw.githubusercontent.com/TestCentricity/testcentricity_web/main/.github/images/CustomCheckbox.png "Custom Checkbox controls")


The `Radio.define_custom_elements` and `CheckBox.define_custom_elements` methods provide a way to specify the `input`,
`proxy`, and/or `label` elements associated with the `input(type='radio')` and `input(type='checkbox')` elements. The
`define_custom_elements` method should be called from an `initialize` method for the `PageObject` or `PageSection` where
the `radio` or `checkbox` elements are instantiated.

The code snippet below demonstrates the use of the `Radio.define_custom_elements` and `CheckBox.define_custom_elements`
methods to define the multiple UI elements that comprise each radio button and checkbox.

    class FlightBookingPage < TestCentricity::PageObject
      trait(:page_name)    { 'Flight Booking Home' }
      trait(:page_locator) { 'div[class*="bookerContainer"]' }

      # Flight Booking page UI elements
      radios     roundtrip_radio:  'div[role="radiogroup"] > div.ftRadio:nth-of-type(1)',
                 one_way_radio:    'div[role="radiogroup"] > div.ftRadio:nth-of-type(2)',
                 multi_city_radio: 'div[role="radiogroup"] > div.ftRadio:nth-of-type(3)'
      checkboxes use_miles_check:  'div#divAwardReservation',
                 flex_dates_check: 'div#divLowFareCalendar > div.left',
                 near_from_check:  'div#divIncludeNearbyDepartureAirports',
                 near_to_check:    'div#divIncludeNearbyArrivalAirports'

      def initialize
        # define the custom element components for the Round Trip, One Way, and Multi-City radio buttons
        radio_spec = {
          input: 'input[type="radio"]',
          label: 'label.normal'
        }
        roundtrip_radio.define_custom_elements(radio_spec)
        one_way_radio.define_custom_elements(radio_spec)
        multi_city_radio.define_custom_elements(radio_spec)

        # define the custom element components for the checkboxes
        check_spec = {
          input: 'input[type="checkbox"]',
          label: 'label.normal'
        }
        use_miles_check.define_custom_elements(check_spec)
        flex_dates_check.define_custom_elements(check_spec)
        near_from_check.define_custom_elements(check_spec)
        near_to_check.define_custom_elements(check_spec)
      end
    end

#### List UIElements

The basic HTML `list` element is typically composed of the parent `ul` or `ol` object, and one or more `li` elements
representing the items in the list. However, list controls implemented using JS component libraries can be composed of
multiple elements representing the components of a list implementation.

In the screenshots below, an inspection of the **Menu Groups** horizontal scrolling list on a **Restaurant Detail** page
reveals that it is a `div` element that contains multiple `button` elements with `data-testid` attributes of `menu-group`
that represent the list items that can be selected.

![Custom List](https://raw.githubusercontent.com/TestCentricity/testcentricity_web/main/.github/images/CustomList.png "Custom List")

The `List.define_list_elements` method provides a means of specifying the elements that make up the key components of a
`list` control. The method accepts a hash of element designators (key) and a CSS or Xpath expression (value) that expression
that uniquely identifies the element. Valid element designators are `:list_item`and `:selected_item`.

The `RestaurantPage` page object's `initialize` method in the code snippet below demonstrates the use of the `List.define_list_elements`
method to define the common components that make up the **Menu Groups** horizontal scrolling list.

    class RestaurantPage < TestCentricity::PageObject
      trait(:page_name)    { 'Restaurant Detail' }
      trait(:page_locator) { 'div.restaurant-menus-container' }

      # Restaurant Detail page UI elements
      list :menu_groups_list, 'div[class*="menus-and-groups-selector__SliderItems"]'

      def initialize
        super
        # define the custom list element components for the Menu Groupslists
        list_spec = { list_item: 'button[data-testid="menu-group"]' }
        menu_groups_list.define_list_elements(list_spec)
      end
    end


#### SelectList UIElements

The basic HTML `select` element is typically composed of the parent `select` object, and one or more `option` elements
representing the selectable items in the drop-down list. However, `select` type controls implemented using JS component
libraries (React.js, Chosen, GWT, etc.) can be composed of multiple elements representing the various components of a
drop-down style `selectlist` implementation.

![Custom SelectList](https://raw.githubusercontent.com/TestCentricity/testcentricity_web/main/.github/images/CustomSelectList1.png "Custom SelectList")


In the screenshots below, an inspection of the **Football Teams** selector reveals that it is a `div` element that contains
a `textfield` element (outlined in purple) for inputting a selection by typing, a `ul` element (outlined in blue) that
contains the drop-down list, and multiple `li` elements with the `active-result` snippet in their `class` names (outlined
in orange) that represent the list items or options that can be selected. The currently selected item or option can be
identified by an `li` with the `result-selected` snippet in its `class` name. Group headings and items in the drop-down
list are represented by `li` elements with a `class` name of `group-result` (outlined in green).

![Custom SelectList](https://raw.githubusercontent.com/TestCentricity/testcentricity_web/main/.github/images/CustomSelectList.jpg "Custom SelectList")

The `SelectList.define_list_elements` method provides a means of specifying the various elements that make up the key
components of a `selectlist` control. The method accepts a hash of element designators (key) and a CSS or Xpath expression
(value) that uniquely identifies the element. Valid element designators are `:list_item`, `:options_list`, `:list_trigger`,
`:selected_item`, `:text_field`, `:group_heading`, and `:group_item`.

The `CustomControlsPage` page object's `initialize` method in the code snippet below demonstrates the use of the
`SelectList.define_list_elements` method to define the common components that make up the **Teams** drop-down style selector.

    class CustomControlsPage < TestCentricity::PageObject
      trait(:page_name)    { 'Custom Controls' }
      trait(:page_locator) { 'div.custom-controls-page-body' }

      # Custom Controls page UI elements
      selectlists country_select: 'div#country_chosen',
                  team_select:    'div#team_chosen'

      def initialize
        super
        # define the custom list element components for the Team Chosen selectlists
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
      end
    end


#### Table UIElements

The basic HTML `table` element is typically composed of the parent `table` object, a body (`tbody`) containing one or
more rows (`tr`), with each row containing one or more columns (`td`). Tables can also include an optional header (`thead`)
with a header row (`tr`) containing one or more header columns (`th`).

However, custom tables can be implemented using elements other than the standard table components described above. In the
screenshot below, an inspection of the table reveals that it is comprised of `div` elements representing the table, body,
rows, columns, header, header row, and header columns.

![Custom Table](https://raw.githubusercontent.com/TestCentricity/testcentricity_web/main/.github/images/CustomTable.png "Custom Table")

The `Table.define_table_elements` method provides a means of specifying the various elements that make up the key
components of a `table`. The method accepts a hash of element designators (key) and a CSS or Xpath expression (value)
that uniquely identifies the element. Valid element designators are `:table_header`, `:header_row`, `:header_column`,
`:table_body`, `:table_row`, and `:table_column`.

The `CustomControlsPage` page object's `initialize` method in the code snippet below demonstrates the use of the
`Table.define_table_elements` method to define the components that make up the responsive `table`.

    class CustomControlsPage < TestCentricity::PageObject
      trait(:page_name)    { 'Custom Controls' }
      trait(:page_locator) { 'div.custom-controls-page-body' }

      # Custom Controls page UI elements
      table :custom_table, 'div#resp-table'

      def initialize
        super
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
    end


---
## Instantiating Your PageObjects

Before you can call the methods in your `PageObjects` and `PageSections`, you must instantiate the `PageObjects` of your
web application, as well as create instance variables which can be used when calling a `PageObject`'s methods from your
step definitions. There are several ways to instantiate your `PageObjects`.

One common implementation is shown below:

    module WorldPages
      def login_page
        @login_page ||= LoginPage.new
      end

      def home_page
        @home_page ||= HomePage.new
      end

      def registration_page
        @registration_page ||= RegistrationPage.new
      end

      def search_results_page
        @search_results_page ||= SearchResultsPage.new
      end
    end

    World(WorldPages)

The `WorldPages` module above can be defined in your `env.rb` file, or you can define it in a separate `world_pages.rb`
file in the `features/support` folder.

While this approach is effective for small web applications with only a few pages (and hence few `PageObjects`), it quickly
becomes cumbersome to manage if your web application has dozens of `PageObjects` that need to be instantiated and managed.

### Using the PageManager

The `PageManager` class provides methods for supporting the instantiation and management of `PageObjects`. In the code
example below, the `page_objects` method contains a hash table of your `PageObject` instances and their associated
`PageObject` classes to be instantiated by `PageManager`:

    module WorldPages
      def page_objects
        {
          login_page:                LoginPage,
          home_page:                 HomePage,
          registration_page:         RegistrationPage,
          search_results_page:       SearchResultsPage,
          products_grid_page:        ProductsCollectionPage,
          product_detail_page:       ProductDetailPage,
          shopping_basket_page:      ShoppingBasketPage,
          payment_method_page:       PaymentMethodPage,
          confirm_purchase_page:     PurchaseConfirmationPage,
          my_account_page:           MyAccountPage,
          my_order_history_page:     MyOrderHistoryPage,
          my_ship_to_addresses_page: MyShipToAddressesPage,
          terms_conditions_page:     TermsConditionsPage,
          privacy_policy_page:       PrivacyPolicyPage,
          faqs_page:                 FAQsPage,
          contact_us_page:           ContactUsPage
        }
      end
    end

    World(WorldPages)

    
The `WorldPages` module above should be defined in the `world_pages.rb` file in the `features/support` folder.

Include the code below in your `env.rb` file to ensure that your `PageObjects` are instantiated before your Cucumber
scenarios are executed:

    include WorldPages
    WorldPages.instantiate_page_objects

**NOTE:** If you intend to use the `PageManager`, you must define a `page_name` trait for each of the `PageObjects` to
be registered.


### Leveraging the PageManager in Your Cucumber Tests

Many Cucumber based automated tests suites include scenarios that verify that web pages are correctly loaded, displayed,
or can be navigated to by clicking associated links. One such Cucumber navigation scenario is displayed below:

    Scenario Outline:  Verify Home page navigation links
      Given I am on the Home page
      When I click the <page name> navigation link
      Then I expect the <page name> page to be correctly displayed

      Examples:
        |page name          |
        |Registration       |
        |My Account         |
        |Terms & Conditions |
        |Privacy Policy     |
        |FAQs               |
        |Contact Us         |

In the above example, the step definitions associated with the 3 steps might be implemented using a `page_dispatcher`
method using a `case` statement to parse the `page` parameter as in the example below:

    Given(/^I am on the (.*) page$/) do |page_name|
      target_page = page_dispatcher(page_name)
      target_page.load_page
    end

    When(/^I click the (.*) navigation link$/) do |link_name|
      target_page = page_dispatcher(link_name)
      target_page.navigate_to
    end

    Then(/^I expect the (.*) page to be correctly displayed$/) do |page_name|
      target_page = page_dispatcher(page_name)
      target_page.verify_page_exists
      target_page.verify_page_ui
    end

    # this method takes a page name as a parameter and returns an instance of the associated Page Object
      def page_dispatcher(page_name)
        page = case page_name
               when 'Registration'
                 registration_page
               when 'My Account'
                 my_account_page
               when 'Terms & Conditions'
                 terms_conditions_page
               when 'Privacy Policy'
                 privacy_policy_page
               when 'Contact Us'
                 contact_us_page
               when 'FAQs'
                 faqs_page
               end
        raise "No page object defined for page named '#{page_name}'" unless page
        page
      end


While this approach may be effective for small web applications with only a few pages (and hence few `PageObjects`), it
quickly becomes cumbersome to manage if your web application has dozens of `PageObjects` that need to be managed.

The `PageManager` class provides a `find_page` method that replaces the cumbersome and difficult to maintain `case`
statement used in the above example. The `PageManager.current_page` method allows you to set or get an instance of the
currently active Page Object.

To use these `PageManager` methods, include the step definitions and code below in a `page_steps.rb` or `generic_steps.rb`
file in the `features/step_definitions` folder:

    include TestCentricity

    Given(/^I am on the (.*) page$/) do |page_name|
      target_page = PageManager.find_page(page_name)
      target_page.load_page
    end

    When(/^I click the (.*) navigation link$/) do |page_name|
      target_page = PageManager.find_page(page_name)
      target_page.navigate_to
    end

    Then(/^I expect to see the (.*) page$/) do |page_name|
      target_page = PageManager.find_page(page_name)
      target_page.verify_page_exists
    end

    Then(/^I expect the (.*) page to be correctly displayed$/) do |page_name|
      target_page = PageManager.find_page(page_name)
      target_page.verify_page_exists
      target_page.verify_page_ui
    end


---
## Connecting to Web Browsers

Since its inception, TestCentricity has provided support for establishing a single connection to a target desktop or mobile
web browser by instantiating a WebDriver object. **Environment Variables** are used to specify the local, grid, or remote
cloud hosted target web browser, and the various WebDriver capability parameters required to configure the driver object.
The appropriate **Environment Variables** are typically specified in the command line at runtime through the use of profiles
set in a `cucumber.yml` file (Refer to [**section 8.9 (Using Browser Specific Profiles in `cucumber.yml`)**](#using-browser-specific-profiles-in-cucumber-yml) below).

However, for those use cases requiring the instantiation of multiple WebDriver objects within a test case or test scenario,
**Environment Variables** are a less effective means of specifying multiple driver capabilities. And even in those use cases
where only a single WebDriver object is required, there are a growing number of optional Selenium and Appium capabilities
that are being offered by cloud hosted browser service providers (like BrowserStack, Sauce Labs, TestingBot, or LambdaTest)
that **Environment Variables** may not effectively address.

Beginning with TestCentricity version 4.4.0, the `TestCentricity::WebDriverConnect.initialize_web_driver` method accepts
an optional `options` hash for specifying desired capabilities (using the W3C protocol), driver type, driver name, endpoint
URL, device type, and desktop web browser window size information. TestCentricity also now supports the instantiation of
multiple WebDriver objects to establish connections with, and coordinate test execution between multiple desktop and/or
mobile web browser instances.

Some use cases for the verification of real-time multiple user interactions across multiple concurrent browsers or devices are:
  - Chat, Messaging, or Social Media apps/web portals used by one or more users interacting in real time (posts, reposts, likes)
  - Ride Hailing/Sharing Services with separate Rider and Driver experience apps/web portals
  - Food Delivery Services with a Customer app for finding restaurants and ordering food, a Restaurant app for fulfilling
    the food order and coordinating delivery, and a Driver app for ensuring delivery of the order to the customer
  - Learning Management/Student Engagement platforms that allow teachers to monitor student engagement and progress on assigned
    activities and support for remote real-time collaboration between students and teachers

If the optional `options` hash is not provided when calling the `TestCentricity::WebDriverConnect.initialize_web_driver` method,
then **Environment Variables** must be used to specify the target local or remote web browser, and the various webdriver
capability parameters required to establish a connection with a single target web browser.

### Specifying Options and Capabilities in the `options` Hash

For those test scenarios requiring the instantiation of multiple WebDriver objects, or where cumbersome **Environment
Variables** are less than ideal, call the `TestCentricity::WebDriverConnect.initialize_web_driver` method with an `options`
hash that specifies the WebDriver desired capabilities and the driver type, as depicted in the example below:

    options = {
      capabilities: { browserName: :firefox },
      driver: :webdriver
    }
    WebDriverConnect.initialize_web_driver(options)

Additional options that can be specified in an `options` hash include the following:

| Option          | Purpose                                                                                    |
|-----------------|--------------------------------------------------------------------------------------------|
| `browser_size:` | optional desktop web browser window size (width and height)                                |
| `driver_name:`  | optional driver name                                                                       |
| `endpoint:`     | optional endpoint URL for remote grid or cloud hosted browser service providers            |
| `device_type:`  | only used for locally or cloud hosted mobile device browser - set to `:phone` or `:tablet` |

Details on specifying desired capabilities, driver type, endpoint URL, and default driver names are provided in each of the
browser hosting sections below.

#### Specifying the Driver Type

The `driver:` type is a required entry in the `options` hash when instantiating a WebDriver object using the `initialize_web_driver`
method. Valid `driver:` type values are listed in the table below:

| `driver:`       | **Driver Type**                                                                            |
|-----------------|--------------------------------------------------------------------------------------------|
| `:webdriver`    | locally hosted desktop or emulated mobile browser                                          |
| `:grid`         | Selenium Grid 4 hosted browser                                                             |
| `:appium`       | locally hosted native iOS/Android mobile browser using device simulator or physical device |
| `:browserstack` | remote browser hosted on BrowserStack                                                      |
| `:saucelabs`    | remote browser hosted on Sauce Labs                                                        |
| `:testingbot`   | remote browser hosted on TestingBot                                                        |
| `:lambdatest`   | remote browser hosted on LambdaTest                                                        |

#### Specifying a Driver Name

An optional user defined `driver_name:` can be specified in the `options` hash when instantiating a WebDriver object using
the `TestCentricity::WebDriverConnect.initialize_web_driver` method. If a driver name is not specified, the `initialize_web_driver`
method will assign a default driver name comprised of the specified driver type (`driver:`) and the `browserName:` specified
in the `capabilities:` hash. Details on default driver names are provided in each of the browser hosting sections below.

For those test scenarios requiring the instantiation of multiple WebDriver objects, each driver object should be assigned a
unique driver name, which is used when switching between driver contexts. For instance, when performing end-to-end testing
of a Food Delivery Service which consists of separate web portals for the Customer Experience (find, order, and pay for food),
the Restaurant Experience (menu management, order fulfillment, and order delivery dispatch), and the Delivery Driver Experience
(customer location and tracking), 3 driver objects must be instantiated.

Assigning meaningful unique driver names for the 3 driver objects (`:customer_portal`, `:merchant_portal`, `:delivery_portal`)
in the `options` hash when calling `TestCentricity::WebDriverConnect.initialize_web_driver` method reduces confusion when
switching between the driver objects using the `TestCentricity:WebDriverConnect.activate_driver(driver_name)` method, which
expects a driver name, specified as a `Symbol`.

### Setting Desktop Browser Window Size

#### Using `:browser_size` in the `options` Hash

The size (width and height) of a desktop browser window can be specified in the `options` hash for browsers that are hosted
locally, in a Selenium Grid, or by a cloud hosted browser service provider. You cannot set the size of a mobile device web
browser, which is determined by the mobile device's screen size.

To set the size of a desktop browser window in the `options` hash, you specify a `:browser_size` with the desired width and
height in pixels as shown below:

    options = {
      browser_size: [1100, 900],
      capabilities: { browserName: :edge },
      driver: :webdriver
    }
    WebDriverConnect.initialize_web_driver(options)

To maximize a desktop browser window, you specify a `:browser_size` of 'max' as shown below:

    options = {
      browser_size: 'max',
      capabilities: { browserName: :chrome },
      driver: :webdriver
    }
    WebDriverConnect.initialize_web_driver(options)

If a `:browser_size` is not specified, then the default size of a desktop browser window will be set to the size specified
in the `BROWSER_SIZE` Environment Variable (if it has been specified) or to a default width and height of 1650 by 1000 pixels.

#### Using the `BROWSER_SIZE` Environment Variable

To set the size of a desktop browser window without using an `options` hash, you set the `BROWSER_SIZE` Environment Variable
to the desired width and height in pixels as shown below:

    BROWSER_SIZE=1600,1000

To maximize a desktop browser window, you set the `BROWSER_SIZE` Environment Variable to 'max' as shown below:

    BROWSER_SIZE=max

If the `BROWSER_SIZE` Environment Variable is not specified, then the default size of a desktop browser window will be set
to a width and height of 1650 by 1000 pixels.


### Locally Hosted Desktop Web Browsers

For locally hosted desktop web browsers running on macOS, Windows, or Linux platforms, the browser type and driver type
must be specified when calling the `TestCentricity::WebDriverConnect.initialize_web_driver` method. The table below contains
the values that can be used to specify the locally hosted desktop web browser to be instantiated when calling the
`initialize_web_driver` method:

| `browserName:` or `WEB_BROWSER` | **Desktop Platform**                                |
|---------------------------------|-----------------------------------------------------|
| `chrome`                        | macOS, Windows, or Linux                            |
| `chrome_headless`               | macOS, Windows, or Linux (headless - no visible UI) |
| `firefox`                       | macOS, Windows, or Linux                            |
| `firefox_headless`              | macOS, Windows, or Linux (headless - no visible UI) |
| `edge`                          | macOS or Windows                                    |
| `edge_headless`                 | macOS or Windows (headless - no visible UI)         |
| `safari`                        | macOS only                                          |

#### Local Desktop Browser using Environment Variables

If the `options` hash is not provided when calling the `TestCentricity::WebDriverConnect.initialize_web_driver` method, then
the following Environment Variables must be set as described in the table below:

| **Environment Variable** | **Description**                                                   |
|--------------------------|-------------------------------------------------------------------|
| `WEB_BROWSER`            | Must be set to one of the values from the table above             |
| `DRIVER`                 | Must be set to `webdriver`                                        |
| `BROWSER_SIZE`           | [Optional] Set to _'width in pixels, heigh in pixels'_ or _'max'_ |

Refer to [**section 8.9 (Using Browser Specific Profiles in `cucumber.yml`)**](#using-browser-specific-profiles-in-cucumber-yml) below.


#### Local Desktop Browser in the `options` Hash

When using the `options` hash, the following options and capabilities must be specified:
- `driver:` must be set to `:webdriver`
- `browserName:` in the `capabilities:` hash must be set to one of the values from the table above

```
    options = {
      capabilities: { browserName: value_from_table_above },
      driver: :webdriver
    }
    WebDriverConnect.initialize_web_driver(options)
```
ℹ️ If an optional user defined `driver_name:` is not specified in the `options` hash, the default driver name will be set to
`:local_<browserName>` - e.g. `:local_chrome` or `:local_edge_headless`.

Below is an example of an `options` hash for specifying a connection to a locally hosted Firefox desktop web browser. The
`options` hash includes options for specifying the driver name and setting the browser window size.

    options = {
      driver: :webdriver,
      driver_name: :customer_context,
      browser_size: [1400, 1100],
      capabilities: { browserName: :firefox }
    }
    WebDriverConnect.initialize_web_driver(options)


#### Testing File Downloads With Desktop Browsers

File download functionality can be tested with locally hosted instances of Chrome, Edge, or Firefox desktop browsers. Your
automation project must include a `/downloads` folder which is used as the destination for files that are downloaded by
your automated tests. The `/downloads` folder must be at the same level as the `/config` and `/features` folders, as depicted
below:

        📁 my_automation_project/
        ├── 📁 config/
        ├── 📁 downloads/
        ├── 📁 features/
        ├── 📄 Gemfile
        └── 📄 README.md


When running tests in multiple concurrent threads using the `parallel_tests` gem, a new folder will be created within the
`/downloads` folder for each test thread. This is to ensure that files downloaded in each test thread are isolated from tests
running in other parallel threads. An example of the`/downloads` folder structure for 4 parallel threads is depicted below:

        📁 my_automation_project/
        ├── 📁 config/
        ├── 📁 downloads/
        │   ├── 📁 1/
        │   ├── 📁 2/
        │   ├── 📁 3/
        │   └── 📁 4/
        ├── 📁 features/
        ├── 📄 Gemfile
        └── 📄 README.md


When testing file downloads using a local instance of Firefox, you will need to specify the MIME types of the various file
types that your tests will be downloading. This is accomplished by setting the `MIME_TYPES` Environment Variable to a
comma-delimited string containing the list of MIME types to be accepted. The `MIME_TYPES` Environment Variable should be
set before initializing the Firefox web driver. This list of file types is required as it will prevent Firefox from displaying
the File Download modal dialog, which will halt your automated tests. An example of a list of MIME types is depicted below:

    # set list of all supported MIME types for testing file downloads with Firefox
    mime_types = [
      'application/pdf',
      'image/png',
      'image/jpeg',
      'image/gif',
      'text/csv',
      'text/plain'
    ]
    ENV['MIME_TYPES'] = mime_types.join(',')


A detailed list of file MIME types can be found [here](https://www.freeformatter.com/mime-types-list.html).


### Locally Hosted Emulated Mobile Web Browsers

You can run your tests against mobile device browsers that are emulated within a locally hosted instance of a Chrome desktop
browser on macOS or Windows. The specified mobile browser's user agent, CSS screen dimensions, and default screen orientation
will be automatically set within the local Chrome browser instance. You may also specify the emulated device's screen orientation.

⚠️ For best results when testing against mobile web browsers, you should run your tests against iOS and Android simulators
or physical devices, either hosted locally or via a remotely cloud hosted service.

For locally hosted emulated mobile web browsers, the `WEB_BROWSER` Environment Variable must be set to one of the values
from the table below:

| `browserName:` or `WEB_BROWSER` | **CSS Screen Dimensions** | **Default Orientation** | **OS Version**       |
|---------------------------------|---------------------------|-------------------------|----------------------|
| `iphone_11`                     | 414 x 896                 | portrait                | iOS 15.5             |
| `iphone_11_pro`                 | 375 x 812                 | portrait                | iOS 15.5             |
| `iphone_11_pro_max`             | 414 x 896                 | portrait                | iOS 15.5             |
| `iphone_12_mini`                | 375 x 812                 | portrait                | iOS 15.5             |
| `iphone_12`                     | 390 x 844                 | portrait                | iOS 15.5             |
| `iphone_12_pro`                 | 390 x 844                 | portrait                | iOS 15.5             |
| `iphone_12_pro_max`             | 428 x 926                 | portrait                | iOS 15.5             |
| `iphone_13_mini`                | 375 x 812                 | portrait                | iOS 15.5             |
| `iphone_13`                     | 390 x 844                 | portrait                | iOS 15.5             |
| `iphone_13_pro`                 | 390 x 844                 | portrait                | iOS 15.5             |
| `iphone_13_pro_max`             | 428 x 926                 | portrait                | iOS 15.5             |
| `iphone_se`                     | 375 x 667                 | portrait                | iOS 15.5             |
| `iphone_14`                     | 390 x 844                 | portrait                | iOS 16.2             |
| `iphone_14_plus`                | 428 x 926                 | portrait                | iOS 16.2             |
| `iphone_14_pro`                 | 393 x 852                 | portrait                | iOS 16.2             |
| `iphone_14_pro_max`             | 430 x 932                 | portrait                | iOS 16.2             |
| `ipad`                          | 1080 x 810                | landscape               | iOS 15.5             |
| `ipad_mini`                     | 1133 x 744                | landscape               | iOS 15.5             |
| `ipad_air`                      | 1180 x 820                | landscape               | iOS 15.5             |
| `ipad_pro_11`                   | 1194 x 834                | landscape               | iOS 15.5             |
| `ipad_pro_12_9`                 | 1366 x 1024               | landscape               | iOS 15.5             |
| `pixel_5`                       | 393 x 851                 | portrait                | Android 12           |
| `pixel_6`                       | 412 x 915                 | portrait                | Android 12           |
| `pixel_xl`                      | 412 x 732                 | portrait                | Android 12           |
| `nexus_10`                      | 1280 x 800                | landscape               | Android 12           |
| `pixel_c`                       | 1280 x 900                | landscape               | Android 12           |
| `kindle_fire`                   | 1024 x 600                | landscape               |                      |
| `kindle_firehd7`                | 800 x 480                 | landscape               | Fire OS 3            |
| `kindle_firehd8`                | 1280 x 800                | landscape               | Fire OS 5            |
| `kindle_firehd10`               | 1920 x 1200               | landscape               | Fire OS 5            |
| `surface`                       | 1366 x 768                | landscape               |                      |
| `blackberry_playbook`           | 1024 x 600                | landscape               | BlackBerry Tablet OS |
| `windows_phone7`                | 320 x 480                 | portrait                | Windows Phone OS 7.5 |
| `windows_phone8`                | 320 x 480                 | portrait                | Windows Phone OS 8.0 |
| `lumia_950_xl`                  | 360 x 640                 | portrait                | Windows Phone OS 10  |
| `blackberry_z10`                | 384 x 640                 | portrait                | BlackBerry 10 OS     |
| `blackberry_z30`                | 360 x 640                 | portrait                | BlackBerry 10 OS     |
| `blackberry_leap`               | 360 x 640                 | portrait                | BlackBerry 10 OS     |
| `blackberry_passport`           | 504 x 504                 | square                  | BlackBerry 10 OS     |

#### Local Emulated Mobile Browser using Environment Variables

If the `options` hash is not provided when calling the `TestCentricity::WebDriverConnect.initialize_web_driver` method,
then the following Environment Variables must be set as described in the table below:

| **Environment Variable** | **Description**                                       |
|--------------------------|-------------------------------------------------------|
| `WEB_BROWSER`            | Must be set to one of the values from the table above |
| `DRIVER`                 | Must be set to `webdriver`                            |
| `ORIENTATION`            | [Optional] Set to `portrait` or `landscape`           |

Refer to [**section 8.9 (Using Browser Specific Profiles in `cucumber.yml`)**](#using-browser-specific-profiles-in-cucumber-yml) below.


#### Local Emulated Mobile Browser in the `options` Hash

When using the `options` hash, the following options and capabilities must be specified:
- `driver:` must be set to `:webdriver`
- `browserName:` in the `capabilities:` hash must be set to one of the values from the table above

```
    options = {
      capabilities: { browserName: value_from_table_above },
      driver: :webdriver
    }
    WebDriverConnect.initialize_web_driver(options)
```
To change the emulated device's screen orientation from the default setting, set the optional `orientation:` to either
`:portrait` or `:landscape` in the `capabilities:` hash as shown in the example below:

    options = {
      capabilities: {
        browserName: :ipad_pro_12_9,
        orientation: :portrait
      },
      driver: :webdriver
    }
    WebDriverConnect.initialize_web_driver(options)

ℹ️ If an optional user defined `driver_name:` is not specified in the `options` hash, the default driver name will be set to
`:local_<browserName>` - e.g. `:local_ipad_pro_12_9` or `:local_pixel_6`.

Below is an example of an `options` hash for specifying a connection to a locally hosted emulated mobile Safari web browser
running on an iPhone. The`options` hash includes options for specifying the driver name and setting the browser orientation
to landscape mode.

    options = {
      driver: :webdriver,
      driver_name: :user1,
      capabilities: {
        browserName: :iphone_13_pro_max,
        orientation: :landscape
      }
    }
    WebDriverConnect.initialize_web_driver(options)


#### User Defined Emulated Mobile Browser Profiles

User defined mobile browser profiles can be specified in a `device.yml` file for testing locally hosted emulated mobile
web browsers running in an instance of the Chrome desktop browser. The user specified browser profiles must be located
at `config/data/devices/devices.yml` as depicted below:

        📁 my_automation_project/
        ├── 📁 config/
        │   ├── 📁 data/
        │   │   └── 📁 devices/
        │   │       └── 📄devices.yml
        │   ├── 📁 locales/
        │   ├── 📁 test_data/
        │   └── 📄 cucumber.yml
        ├── 📁 downloads/
        ├── 📁 features/
        ├── 📄 Gemfile
        └── 📄 README.md

The format for a new mobile browser profile is:
```
    :my_device_profile:
      :name: "My New Device Name"
      :os: (ios, android, kindle, or blackberry)
      :type: (phone or tablet)
      :css_width: css width in pixels
      :css_height: css height in pixels
      :default_orientation: (portrait or landscape)
      :user_agent: "user agent string"
```

To specify a user defined emulated mobile browser, set `browserName:` or the `WEB_BROWSER` Environment Variable to the
device's profile name.


### Selenium Grid Hosted Desktop and Emulated Mobile Web Browsers

For remotely hosted desktop web browsers running on a Selenium 4 Grid, the browser type and driver type must be specified
when calling the `TestCentricity::WebDriverConnect.initialize_web_driver` method. The table below contains the values that
can be used to specify the grid hosted desktop web browser to be instantiated when calling the`initialize_web_driver` method:

| `browserName:` or `WEB_BROWSER` |
|---------------------------------|
| `chrome`                        |
| `chrome_headless`               |
| `firefox`                       |
| `firefox_headless`              |
| `edge`                          |
| `edge_headless`                 |

#### Grid Browsers using Environment Variables

If the `options` hash is not provided when calling the `TestCentricity::WebDriverConnect.initialize_web_driver` method,
then the following Environment Variables must be set as described in the table below:

| **Environment Variable** | **Description**                                                                                                                   |
|--------------------------|-----------------------------------------------------------------------------------------------------------------------------------|
| `WEB_BROWSER`            | Must be set to one of the values from the table above, or any of the emulated mobile web browsers described above in section 8.4. |
| `DRIVER`                 | Must be set to `grid`                                                                                                             |
| `REMOTE_ENDPOINT`        | [Optional] Set to the URL of the Grid hub. Set to `http://localhost:4444/wd/hub` if not specified                                 |
| `BROWSER_SIZE`           | [Optional] Set to _'width in pixels, heigh in pixels'_ or _'max'_                                                                 |

Refer to [**section 8.9 (Using Browser Specific Profiles in `cucumber.yml`)**](#using-browser-specific-profiles-in-cucumber-yml) below.


#### Grid Browser in the `options` Hash

When using the `options` hash, the following options and capabilities must be specified:
- `driver:` must be set to `:grid`
- `browserName:` in the `capabilities:` hash must be set to one of the values from the table above

```
    options = {
      capabilities: { browserName: value_from_table_above },
      driver: :grid,
      endpoint: 'http://localhost:4444/wd/hub'
    }
    WebDriverConnect.initialize_web_driver(options)
```
ℹ️ If an optional user defined `driver_name:` is not specified in the `options` hash, the default driver name will be set to
`:remote_<browserName>` - e.g. `:remote_chrome` or `:remote_edge_headless`.

ℹ️ If an `endpoint:` is not specified in the `options`hash, then the default remote endpoint URL of `http://localhost:4444/wd/hub`
will be used.

Below is an example of an `options` hash for specifying a connection to a grid hosted Chrome desktop web browser. The
`options` hash includes options for specifying the driver name and setting the browser window size.

    options = {
      driver: :grid,
      driver_name: :admin_user,
      browser_size: [1400, 1100],
      capabilities: { browserName: :chrome }
    }
    WebDriverConnect.initialize_web_driver(options)


### Locally Hosted Mobile Browsers on Simulators or Physical Devices

Refer to [this page](https://appium.io/docs/en/2.2/guides/caps/) for information regarding specifying Appium capabilities.

#### Mobile Safari Browser on iOS Simulators or iOS Physical Devices

You can run your mobile web tests against the mobile Safari browser on iOS device simulators or physically connected iOS
devices using Appium and XCode on macOS. You must install Appium, XCode, and the iOS version-specific device simulators
for XCode. Information about Appium setup and configuration requirements with the XCUITest driver for testing on physically
connected iOS devices can be found on [this page](https://github.com/appium/appium-xcuitest-driver/blob/master/docs/real-device-config.md). Refer to [this page](https://appium.github.io/appium-xcuitest-driver/5.12/capabilities/) for information regarding specifying
Appium capabilities that are specific to the XCUITest driver.

The Appium server must be running prior to invoking Cucumber to run your features/scenarios. Refer to [**section 8.6.3 (Starting and Stopping Appium Server)**](#starting-and-stopping-appium-server) below.


##### Local Mobile Safari Browser using Environment Variables

If the `options` hash is not provided when calling the `TestCentricity::WebDriverConnect.initialize_web_driver` method,
the following **Environment Variables** must be set as described in the table below.

| **Environment Variable**   | **Description**                                                                                                                                                       |
|----------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `DRIVER`                   | Must be set to `appium`                                                                                                                                               |
| `AUTOMATION_ENGINE`        | Must be set to `xcuitest`                                                                                                                                             |
| `APP_PLATFORM_NAME`        | Must be set to `iOS`                                                                                                                                                  |
| `APP_BROWSER`              | Must be set to `Safari`                                                                                                                                               |
| `APP_VERSION`              | Must be set to which ever iOS version you wish to run within the XCode Simulator                                                                                      |
| `APP_DEVICE`               | Set to iOS device name supported by the iOS Simulator (`iPhone 13 Pro Max`, `iPad Pro (12.9-inch) (5th generation)`, etc.) or name of physically connected iOS device |
| `DEVICE_TYPE`              | Must be set to `phone` or `tablet`                                                                                                                                    |
| `APP_UDID`                 | UDID of physically connected iOS device (not used for simulators)                                                                                                     |
| `TEAM_ID`                  | unique 10-character Apple developer team identifier string (not used for simulators)                                                                                  |
| `TEAM_NAME`                | String representing a signing certificate (not used for simulators)                                                                                                   |
| `APP_ALLOW_POPUPS`         | [Optional] Allow javascript to open new windows in Safari. Set to `true` or `false`                                                                                   |
| `APP_IGNORE_FRAUD_WARNING` | [Optional] Prevent Safari from showing a fraudulent website warning. Set to `true` or `false`                                                                         |
| `APP_NO_RESET`             | [Optional] Don't reset app state after each test. Set to `true` or `false`                                                                                            |
| `APP_FULL_RESET`           | [Optional] Perform a complete reset. Set to `true` or `false`                                                                                                         |
| `APP_INITIAL_URL`          | [Optional] Initial URL, default is a local welcome page.  e.g.  `http://www.apple.com`                                                                                |
| `WDA_LOCAL_PORT`           | [Optional] Used to forward traffic from Mac host to real iOS devices over USB. Default value is same as port number used by WDA on device.                            |
| `ORIENTATION`              | [Optional] Set to `portrait` or `landscape` (only for iOS simulators)                                                                                                 |
| `NEW_COMMAND_TIMEOUT`      | [Optional] Time (in Seconds) that Appium will wait for a new command from the client                                                                                  |
| `SHOW_SIM_KEYBOARD`        | [Optional] Show the simulator keyboard during text entry. Set to `true` or `false`                                                                                    |
| `SHUTDOWN_OTHER_SIMS`      | [Optional] Close any other running simulators. Set to `true` or `false`. See note below.                                                                              |

The `SHUTDOWN_OTHER_SIMS` environment variable can only be set if you are running Appium Server with the `--relaxed-security`
or `--allow-insecure=shutdown_other_sims` arguments passed when starting it from the command line, or when running the server
from the Appium Server GUI app. A security violation error will occur without relaxed security enabled. 

Refer to [**section 8.9 (Using Browser Specific Profiles in `cucumber.yml`)**](#using-browser-specific-profiles-in-cucumber-yml) below.


##### Local Mobile Safari Browser in the `options` Hash

When using the `options` hash, the following options and capabilities must be specified:
- `driver:` must be set to `:appium`
- `device_type:` must be set to `:tablet` or `:phone`
- `browserName:` must be set to 'Safari' in the `capabilities:` hash
- `platformName:` must be set to 'ios' in the `capabilities:` hash
- `'appium:automationName':` must be set to 'xcuitest' in the `capabilities:` hash
- `'appium:platformVersion':` must be set to the version of iOS on the simulator or physical device
- `'appium:deviceName':` must be set to the name of the iOS simulator or physical device

```
    options = {
      driver: :appium,
      device_type: phone_or_tablet,
      capabilities: {
        platformName: 'ios',
        browserName: 'Safari',
        'appium:automationName': 'xcuitest',
        'appium:platformVersion': ios_version,
        'appium:deviceName': device_or_simulator_name
      },
      endpoint: 'http://localhost:4723/wd/hub'
    }
    WebDriverConnect.initialize_web_driver(options)
```
ℹ️ If an optional user defined `driver_name:` is not specified in the `options` hash, the default driver name will be set to
`appium_safari`.

ℹ️ If an `endpoint:` is not specified in the `options` hash, then the default remote endpoint URL of `http://localhost:4723/wd/hub`
will be used.

Below is an example of an `options` hash for specifying a connection to a locally hosted mobile Safari web browser running
on an iPad simulator. The `options` hash includes options for specifying the driver name and setting the simulated device
orientation to portrait mode.

      options = {
        driver: :appium,
        device_type: :tablet,
        driver_name: :student_ipad,
        capabilities: {
          platformName: 'ios',
          browserName: 'Safari',
          'appium:platformVersion': '15.4',
          'appium:deviceName': 'iPad Pro (12.9-inch) (5th generation)',
          'appium:automationName': 'xcuitest',
          'appium:orientation': 'PORTRAIT'
        }
      }
      WebDriverConnect.initialize_web_driver(options)


#### Mobile Chrome or Android Browsers on Android Studio Virtual Device Emulators

You can run your mobile web tests against the mobile Chrome or Android browser on emulated Android devices using Appium and
Android Studio on macOS. You must install Android Studio, the desired Android version-specific virtual device emulators, and
Appium. Refer to [this page](https://appium.io/docs/en/2.2/quickstart/uiauto2-driver/) for information on configuring Appium to work with the Android SDK.

The Appium server must be running prior to invoking Cucumber to run your features/scenarios. Refer to [**section 8.6.3 (Starting and Stopping Appium Server)**](#starting-and-stopping-appium-server) below.


##### Local Mobile Android Browsers using Environment Variables

If the `options` hash is not provided when calling the `TestCentricity::WebDriverConnect.initialize_web_driver` method,
the following **Environment Variables** must be set as described in the table below.

| **Environment Variable**  | **Description**                                                                                                                |
|---------------------------|--------------------------------------------------------------------------------------------------------------------------------|
| `DRIVER`                  | Must be set to `appium`                                                                                                        |
| `AUTOMATION_ENGINE`       | Must be set to `UiAutomator2`                                                                                                  |
| `APP_PLATFORM_NAME`       | Must be set to `Android`                                                                                                       |
| `APP_BROWSER`             | Must be set to `Chrome` or `Browser`                                                                                           |
| `APP_VERSION`             | Must be set to which ever Android OS version you wish to run with the Android Virtual Device                                   |
| `APP_DEVICE`              | Set to Android Virtual Device ID (`Pixel_2_XL_API_26`, `Nexus_6_API_23`, etc.) found in Advanced Settings of AVD Configuration |
| `DEVICE_TYPE`             | Must be set to `phone` or `tablet`                                                                                             |
| `ORIENTATION`             | [Optional] Set to `portrait` or `landscape`                                                                                    |
| `APP_INITIAL_URL`         | [Optional] Initial URL, default is a local welcome page.  e.g.  `http://www.apple.com`                                         |
| `APP_NO_RESET`            | [Optional] Don't reset app state after each test. Set to `true` or `false`                                                     |
| `APP_FULL_RESET`          | [Optional] Perform a complete reset. Set to `true` or `false`                                                                  |
| `NEW_COMMAND_TIMEOUT`     | [Optional] Time (in Seconds) that Appium will wait for a new command from the client                                           |
| `CHROMEDRIVER_EXECUTABLE` | [Optional] Absolute local path to ChromeDriver executable                                                                      |

Refer to [**section 8.9 (Using Browser Specific Profiles in `cucumber.yml`)**](#using-browser-specific-profiles-in-cucumber-yml) below.


##### Local Mobile Android Browser in the `options` Hash

When using the `options` hash, the following options and capabilities must be specified:
- `driver:` must be set to `:appium`
- `device_type:` must be set to `:tablet` or `:phone`
- `browserName:` must be set to 'Chrome' in the `capabilities:` hash
- `platformName:` must be set to 'Android' in the `capabilities:` hash
- `'appium:automationName':` must be set to 'UiAutomator2' in the `capabilities:` hash
- `'appium:platformVersion':` must be set to the version of Android on the simulator or physical device
- `'appium:deviceName':` must be set to the Android Virtual Device ID

```
    options = {
      driver: :appium,
      device_type: phone_or_tablet,
      capabilities: {
        platformName: 'Android',
        browserName: 'Chrome',
        'appium:automationName': 'UiAutomator2',
        'appium:platformVersion': android_version,
        'appium:deviceName': simulator_name,
        'appium:avd': simulator_name
      },
      endpoint: 'http://localhost:4723/wd/hub'
    }
    WebDriverConnect.initialize_web_driver(options)
```
ℹ️ If an optional user defined `driver_name:` is not specified in the `options` hash, the default driver name will be set to
`appium_chrome`.

ℹ️ If an `endpoint:` is not specified in the `options` hash, then the default remote endpoint URL of `http://localhost:4723/wd/hub`
will be used.

Below is an example of an `options` hash for specifying a connection to a locally hosted mobile Chrome web browser running
on an Android phone simulator. The `options` hash includes options for specifying the driver name, setting the simulated
device orientation to landscape mode, and specifying the path to the ChromeDriver executable.

      options = {
        driver: :appium,
        device_type: :phone,
        driver_name: :student_phone,
        capabilities: {
          platformName: 'Android',
          browserName: 'Chrome',
          'appium:platformVersion': '12.0',
          'appium:deviceName': 'Pixel_5_API_31',
          'appium:avd': 'Pixel_5_API_31',
          'appium:automationName': 'UiAutomator2',
          'appium:orientation': 'LANDSCAPE',
          'appium:chromedriverExecutable': '/Users/Shared/config/webdrivers/chromedriver'
        }
      }
      WebDriverConnect.initialize_web_driver(options)


#### Starting and Stopping Appium Server

##### Using Appium Server with Cucumber

The Appium server must be running prior to invoking Cucumber to run your features/scenarios on locally hosted mobile simulators
or physical devices. To programmatically control the starting and stopping of Appium server with the execution of your automated
tests, place the code shown below in your `hooks.rb` file.

    BeforeAll do
      # start Appium Server if APPIUM_SERVER = 'run' and target browser is a mobile simulator or device
      if ENV['APPIUM_SERVER'] == 'run' && Environ.driver == :appium
        $server = TestCentricity::AppiumServer.new
        $server.start
      end
    end

    AfterAll do
      # terminate all driver instances
      WebDriverConnect.close_all_drivers
      # terminate Appium Server if APPIUM_SERVER = 'run' and target browser is a mobile simulator or device
      $server.stop if ENV['APPIUM_SERVER'] == 'run' && Environ.driver == :appium && $server.running?
    end

The `APPIUM_SERVER` environment variable must be set to `run` in order to programmatically start and stop the Appium server.
This can be set by adding the following to your `cucumber.yml` file and including `-p run_appium` in your command line when
starting your Cucumber test suite(s):

    run_appium: APPIUM_SERVER=run

Refer to [**section 8.9 (Using Browser Specific Profiles in `cucumber.yml`)**](#using-browser-specific-profiles-in-cucumber-yml) below.


##### Using Appium Server with RSpec

The Appium server must be running prior to executing test specs on locally hosted mobile simulators or physical device. To
control the starting and stopping of the Appium server with the execution of your specs, place the code shown below in the
body of an example group:

    before(:context) do
      # start Appium server before all of the examples in this group
      $server = TestCentricity::AppiumServer.new
      $server.start
    end

    after(:context) do
      # terminate Appium Server after all of the examples in this group
      $server.stop if Environ.driver == :appium && $server.running?
    end


### Remote Cloud Hosted Desktop and Mobile Web Browsers

You can run your automated tests against remote cloud hosted desktop and mobile web browsers using the BrowserStack, SauceLabs,
TestingBot, or LambdaTest services. If your tests are running against a web site hosted on your local computer (`localhost`),
or on a staging server inside your LAN, you must set the `TUNNELING` Environment Variable to `true`.

If the BrowserStack Local instance is running (`TUNNELING` Environment Variable is `true`), call the`TestCentricity::WebDriverConnect.close_tunnel`
method upon completion of your test suite to stop the Local instance. Place the code shown below in your `env.rb` or
`hooks.rb` file:

    # code to stop BrowserStack Local instance after end of test (if tunneling is enabled)
    at_exit do
      TestCentricity::WebDriverConnect.close_tunnel if Environ.tunneling
    end

#### Remote Desktop Browsers on the BrowserStack Service

For remotely hosted desktop web browsers on the BrowserStack service, refer to the [Browserstack-specific capabilities chart page](https://www.browserstack.com/automate/capabilities?tag=selenium-4)
for information regarding the options and capabilities available for the various supported desktop operating systems and
web browsers.

##### BrowserStack Desktop Browser using Environment Variables

If the `options` hash is not provided when calling the `TestCentricity::WebDriverConnect.initialize_web_driver` method,
the following **Environment Variables** must be set as described in the table below.

| **Environment Variable** | **Description**                                                                                                                                                            |
|--------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `DRIVER`                 | Must be set to `browserstack`                                                                                                                                              |
| `BS_USERNAME`            | Must be set to your BrowserStack account user name                                                                                                                         |
| `BS_AUTHKEY`             | Must be set to your BrowserStack account access key                                                                                                                        |
| `BS_OS`                  | Must be set to `OS X` or `Windows`                                                                                                                                         |
| `BS_OS_VERSION`          | Refer to `os_version` capability in chart                                                                                                                                  |
| `BS_BROWSER`             | Refer to `browserName` capability in chart                                                                                                                                 |
| `BS_VERSION`             | [Optional] Refer to `browser_version` capability in chart. If not specified, latest stable version of browser will be used.                                                |
| `TUNNELING`              | [Optional] Must be `true` if you are testing against internal/local servers (`true` or `false`). If `true`, the BrowserStack Local instance will be automatically started. |
| `RESOLUTION`             | [Optional] Refer to supported screen `resolution` capability in chart                                                                                                      |
| `RECORD_VIDEO`           | [Optional] Enable screen video recording during test execution (`true` or `false`)                                                                                         |
| `TIME_ZONE`              | [Optional] Specify custom time zone. Refer to `browserstack.timezone` capability in chart                                                                                  |
| `IP_GEOLOCATION`         | [Optional] Specify IP Geolocation. Refer to [IP Geolocation](https://www.browserstack.com/ip-geolocation) to select a country code.                                        |
| `ALLOW_POPUPS`           | [Optional] Allow popups (`true` or `false`) - for Safari, IE, and Edge browsers only                                                                                       |
| `ALLOW_COOKIES`          | [Optional] Allow all cookies (`true` or `false`) - for Safari browsers only                                                                                                |
| `SCREENSHOTS`            | [Optional] Generate screenshots for debugging (`true` or `false`)                                                                                                          |
| `NETWORK_LOGS`           | [Optional] Capture network logs (`true` or `false`)                                                                                                                        |


##### BrowserStack Desktop Browser in the `options` Hash

When using the `options` hash, the following options and capabilities must be specified:
- `driver:` must be set to `:browserstack`
- `browserName:` in the `capabilities:` hash must be set to name from capability in chart
- `browserVersion:` in the `capabilities:` hash must be set to browser version from capability in chart

```
    options = {
      driver: :browserstack,
      capabilities: {
        browserName: browser_name_from_chart,
        browserVersion: browser_version_from_chart,
        'bstack:options': {
          userName: bs_account_user_name,
          accessKey: bs_account_access_key,
          os: os_name_from_chart,
          osVersion: os_version_from_chart
        }
      }
    }
    WebDriverConnect.initialize_web_driver(options)
```
ℹ️ If an optional user defined `driver_name:` is not specified in the `options` hash, the default driver name will be set to
`:browserstack_<browserName>` - e.g. `:browserstack_chrome` or `:browserstack_safari`.

ℹ️ If an `endpoint:` is not specified in the `options` hash, then the default remote endpoint URL will be set to the following:

`https://#{ENV['BS_USERNAME']}:#{ENV['BS_AUTHKEY']}@hub-cloud.browserstack.com/wd/hub`

This default endpoint requires that the `BS_USERNAME` Environment Variable is set to your BrowserStack account user name and
the `BS_AUTHKEY` Environment Variable is set to your BrowserStack access key.

Below is an example of an `options` hash for specifying a connection to the latest version of an Edge desktop web browser
running on macOS Sonoma hosted on BrowserStack. The `options` hash includes options for specifying the driver name, setting
the browser window size, and capabilities for setting screen resolution, geoLocation, time zone, Selenium version, and various
test configuration options.

    options = {
      driver: :browserstack,
      driver_name: :admin_user,
      browser_size: [1400, 1100],
      capabilities: {
        browserName: 'Edge',
        browserVersion: 'latest',
        'bstack:options': {
          userName: ENV['BS_USERNAME'],
          accessKey: ENV['BS_AUTHKEY'],
          projectName: 'ALP AP',
          buildName: "Test Build {ENV['BUILD_NUM']}",
          sessionName: 'AU Regression Suite',
          os: 'OS X',
          osVersion: 'Sonoma',
          resolution: '3840x2160',
          local: 'false',
          seleniumVersion: '4.15.0',
          networkLogs: 'true',
          geoLocation: 'AU',
          timezone: 'Perth'
        }
      }
    }
    WebDriverConnect.initialize_web_driver(options)


#### Remote Mobile Browsers on the BrowserStack Service

For remotely hosted mobile web browsers on the BrowserStack service, refer to the [Browserstack-specific capabilities chart page](https://www.browserstack.com/automate/capabilities?tag=selenium-4)
for information regarding the options and capabilities available for the various supported mobile operating systems, devices,
and web browsers.

##### BrowserStack Mobile Browser using Environment Variables

If the `options` hash is not provided when calling the `TestCentricity::WebDriverConnect.initialize_web_driver` method,
the following **Environment Variables** must be set as described in the table below.

| **Environment Variable** | **Description**                                                                                                                                                            |
|--------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `DRIVER`                 | Must be set to `browserstack`                                                                                                                                              |
| `BS_USERNAME`            | Must be set to your BrowserStack account user name                                                                                                                         |
| `BS_AUTHKEY`             | Must be set to your BrowserStack account access key                                                                                                                        |
| `BS_OS`                  | Must be set to `ios` or `android`                                                                                                                                          |
| `BS_OS_VERSION`          | Refer to `osVersion` capability in chart                                                                                                                                   |
| `BS_BROWSER`             | Must be set to `Safari` (for iOS) or `Chrome` (for Android)                                                                                                                |
| `BS_DEVICE`              | Refer to `deviceName` capability in chart                                                                                                                                  |
| `BS_REAL_MOBILE`         | Set to `true` if running against a real device                                                                                                                             |
| `DEVICE_TYPE`            | Must be set to `phone` or `tablet`                                                                                                                                         |
| `TUNNELING`              | [Optional] Must be `true` if you are testing against internal/local servers (`true` or `false`). If `true`, the BrowserStack Local instance will be automatically started. |
| `ORIENTATION`            | [Optional] Set to `portrait` or `landscape`                                                                                                                                |
| `RECORD_VIDEO`           | [Optional] Enable screen video recording during test execution (`true` or `false`)                                                                                         |
| `TIME_ZONE`              | [Optional] Specify custom time zone. Refer to `browserstack.timezone` capability in chart                                                                                  |
| `IP_GEOLOCATION`         | [Optional] Specify IP Geolocation. Refer to [IP Geolocation](https://www.browserstack.com/ip-geolocation) to select a country code.                                        |
| `SCREENSHOTS`            | [Optional] Generate screenshots for debugging (`true` or `false`)                                                                                                          |
| `NETWORK_LOGS`           | [Optional] Capture network logs (`true` or `false`)                                                                                                                        |
| `APPIUM_LOGS`            | [Optional] Generate Appium logs (`true` or `false`)                                                                                                                        |


##### BrowserStack Mobile Browser in the `options` Hash

When using the `options` hash, the following options and capabilities must be specified:
- `driver:` must be set to `:browserstack`
- `device_type:` must be set to `:tablet` or `:phone`
- `browserName:` in the `capabilities:` hash must be set to name from capability in chart

```
    options = {
      driver: :browserstack,
      device_type: phone_or_tablet,
      capabilities: {
        browserName: browser_name_from_chart,
        'bstack:options': {
          userName: bs_account_user_name,
          accessKey: bs_account_access_key,
          osVersion: os_version_from_chart,
          deviceName: device_name_from_chart
        }
      }
    }
    WebDriverConnect.initialize_web_driver(options)
```
ℹ️ If an optional user defined `driver_name:` is not specified in the `options` hash, the default driver name will be set to
`:browserstack_<browserName>` - e.g. `:browserstack_chrome` or `:browserstack_safari`.

ℹ️ If an `endpoint:` is not specified in the `options` hash, then the default remote endpoint URL will be set to the following:

`https://#{ENV['BS_USERNAME']}:#{ENV['BS_AUTHKEY']}@hub-cloud.browserstack.com/wd/hub`

This default endpoint requires that the `BS_USERNAME` Environment Variable is set to your BrowserStack account user name and
the `BS_AUTHKEY` Environment Variable is set to your BrowserStack access key.

Below is an example of an `options` hash for specifying a connection to a mobile Samsung web browser running on an Android
tablet hosted on BrowserStack. The `options` hash includes options for specifying the driver name, and capabilities for setting
geoLocation, time zone, Appium version, and various test configuration options.

    options = {
      driver: :browserstack,
      driver_name: :admin_tablet,
      capabilities: {
        browserName: 'samsung',
        device_type: :tablet,
        'bstack:options': {
          userName: ENV['BS_USERNAME'],
          accessKey: ENV['BS_AUTHKEY'],
          projectName: 'ALP AP',
          buildName: "Test Build {ENV['BUILD_NUM']}",
          sessionName: 'AU Regression Suite',
          os: 'android',
          osVersion: '13.0',
          deviceName: 'Samsung Galaxy Tab S9',
          deviceOrientation: 'portrait',
          appiumVersion: '1.22.0',
          realMobile: 'true',
          local: 'false',
          networkLogs: 'true',
          geoLocation: 'AU',
          timezone: 'Perth'
        }
      }
    }
    WebDriverConnect.initialize_web_driver(options)


#### Remote Desktop Browsers on the Sauce Labs Service

For remotely hosted desktop web browsers on the Sauce Labs service, refer to the [Platform Configurator page](https://wiki.saucelabs.com/display/DOCS/Platform+Configurator#/)
for information regarding the options and capabilities available for the various supported desktop operating systems and
web browsers. Use the **Selenium 4** selection in the Config Script section of the Configurator page.

##### Sauce Labs Desktop Browser using Environment Variables

If the `options` hash is not provided when calling the `TestCentricity::WebDriverConnect.initialize_web_driver` method,
the following **Environment Variables** must be set as described in the table below.

| **Environment Variable** | **Description**                                                                                                            |
|--------------------------|----------------------------------------------------------------------------------------------------------------------------|
| `DRIVER`                 | Must be set to `saucelabs`                                                                                                 |
| `SL_USERNAME`            | Must be set to your Sauce Labs account user name or email address                                                          |
| `SL_AUTHKEY`             | Must be set to your Sauce Labs account access key                                                                          |
| `DATA_CENTER`            | Must be set to your Sauce Labs account Data Center assignment (`us-west-1`, `eu-central-1`, `apac-southeast-1`)            |
| `SL_OS`                  | Refer to `platformName` capability in the Config Script section of the Platform Configurator page                          |
| `SL_BROWSER`             | Must be set to `chrome`, `firefox`, `safari`, `internetExplorer`, or `MicrosoftEdge`                                       |
| `SL_VERSION`             | Refer to `browserVersion` capability in the Config Script section of the Platform Configurator page                        |
| `RESOLUTION`             | [Optional] Refer to supported `screenResolution` capability in the Config Script section of the Platform Configurator page |
| `BROWSER_SIZE`           | [Optional] Specify width, height of browser window                                                                         |
| `RECORD_VIDEO`           | [Optional] Enable screen video recording during test execution (`true` or `false`)                                         |


##### Sauce Labs Desktop Browser in the `options` Hash

When using the `options` hash, the following options and capabilities must be specified:
- `driver:` must be set to `:saucelabs`
- `browserName:` in the `capabilities:` hash must be set to name from capability in chart
- `browser_version:` in the `capabilities:` hash must be set to browser version from capability in chart

```
    options = {
      driver: :saucelabs,
      capabilities: {
        browserName: browser_name_from_chart,
        browser_version: browser_version_from_chart,
        platform_name: platform_name_from_chart,
        'sauce:options': {
          username: sl_account_user_name,
          access_key: bs_account_access_key
        }
      }
    }
    WebDriverConnect.initialize_web_driver(options)
```
ℹ️ If an optional user defined `driver_name:` is not specified in the `options` hash, the default driver name will be set to
`:saucelabs_<browserName>` - e.g. `:saucelabs_chrome` or `:saucelabs_safari`.

ℹ️ If an `endpoint:` is not specified in the `options` hash, then the default remote endpoint URL will be set to the following:

`https://#{ENV['SL_USERNAME']}:#{ENV['SL_AUTHKEY']}@ondemand.#{ENV['DATA_CENTER']}.saucelabs.com:443/wd/hub`

This default endpoint requires that the `SL_USERNAME` Environment Variable is set to your Sauce Labs account user name, the
`SL_AUTHKEY` Environment Variable is set to your Sauce Labs access key, and the `DATA_CENTER` Environment Variable is set to
your Sauce Labs account Data Center assignment (`us-west-1`, `eu-central-1`, `apac-southeast-1`).

Below is an example of an `options` hash for specifying a connection to the latest version of an Edge desktop web browser
running on macOS Ventura hosted on Sauce Labs. The `options` hash includes options for specifying the driver name, setting
the browser window size, and capabilities for setting screen resolution, time zone, and various test configuration options.

    options = {
      driver: :saucelabs,
      driver_name: :admin_user,
      browser_size: [1400, 1100],
      capabilities: {
        browserName: 'MicrosoftEdge',
        browser_version: 'latest',
        platform_name: 'macOS 13',
        'sauce:options': {
          username: ENV['SL_USERNAME'],
          access_key: ENV['SL_AUTHKEY'],
          name: 'ALP AP',
          build: "Test Build {ENV['BUILD_NUM']}",
          screenResolution: '2048x1536',
          timeZone: 'Perth',
          maxDuration: 2400,
          idleTimeout: 60
        }
      }
    }
    WebDriverConnect.initialize_web_driver(options)


#### Remote Mobile Browsers on the Sauce Labs Service

For remotely hosted mobile web browsers on the Sauce Labs service, refer to the [Platform Configurator page](https://wiki.saucelabs.com/display/DOCS/Platform+Configurator#/)
for information regarding the options and capabilities available for the various supported mobile operating systems, devices,
and web browsers.

##### Sauce Labs Mobile Browser using Environment Variables

If the `options` hash is not provided when calling the `TestCentricity::WebDriverConnect.initialize_web_driver` method,
the following **Environment Variables** must be set as described in the table below.

| **Environment Variable** | **Description**                                                                                                 |
|--------------------------|-----------------------------------------------------------------------------------------------------------------|
| `DRIVER`                 | Must be set to `saucelabs`                                                                                      |
| `AUTOMATION_ENGINE`      | Must be set to `XCUITest` or `UiAutomator2`                                                                     |
| `SL_PLATFORM`            | Must be set to `iOS` or `Android`                                                                               |
| `SL_BROWSER`             | Must be set to `Safari` or `Chrome`                                                                             |
| `SL_VERSION`             | Refer to `platformVersion` capability in the Config Script section of the Platform Configurator page            |
| `SL_DEVICE`              | Refer to `deviceName` capability in chart                                                                       |
| `DEVICE_TYPE`            | Must be set to `phone` or `tablet`                                                                              |
| `SL_USERNAME`            | Must be set to your Sauce Labs account user name or email address                                               |
| `SL_AUTHKEY`             | Must be set to your Sauce Labs account access key                                                               |
| `DATA_CENTER`            | Must be set to your Sauce Labs account Data Center assignment (`us-west-1`, `eu-central-1`, `apac-southeast-1`) |
| `ORIENTATION`            | [Optional] Set to `PORTRAIT` or `LANDSCAPE`                                                                     |


##### Sauce Labs Mobile Browser in the `options` Hash

When using the `options` hash, the following options and capabilities must be specified:
- `driver:` must be set to `:saucelabs`
- `device_type:` must be set to `:tablet` or `:phone`
- `browserName:` in the `capabilities:` hash must be set to `browserName` from capability in chart
- `platform_name:` in the `capabilities:` hash must be set to `platform_name` from capability in chart
- `'appium:automationName':` must be set to `automationName` from capability in chart
- `'appium:platformVersion':` must be set to `platformVersion` from capability in chart
- `'appium:deviceName':` must be set to `deviceName` from capability in chart

```
    options = {
      driver: :saucelabs,
      device_type: phone_or_tablet,
      capabilities: {
        browserName: browser_name_from_chart,
        platform_name: platform_name_from_chart,
        'appium:automationName': automationName_from_chart,
        'appium:platformVersion': os_version_from_chart,
        'appium:deviceName': device_name_from_chart,
        'sauce:options': {
          userName: bs_account_user_name,
          accessKey: bs_account_access_key
        }
      }
    }
    WebDriverConnect.initialize_web_driver(options)
```
ℹ️ If an optional user defined `driver_name:` is not specified in the `options` hash, the default driver name will be set to
`:saucelabs_<browserName>` - e.g. `:saucelabs_chrome` or `:saucelabs_safari`.

ℹ️ If an `endpoint:` is not specified in the `options` hash, then the default remote endpoint URL will be set to the following:

`https://#{ENV['SL_USERNAME']}:#{ENV['SL_AUTHKEY']}@ondemand.#{ENV['DATA_CENTER']}.saucelabs.com:443/wd/hub`

This default endpoint requires that the `SL_USERNAME` Environment Variable is set to your Sauce Labs account user name, the
`SL_AUTHKEY` Environment Variable is set to your Sauce Labs access key, and the `DATA_CENTER` Environment Variable is set to
your Sauce Labs account Data Center assignment (`us-west-1`, `eu-central-1`, `apac-southeast-1`).

Below is an example of an `options` hash for specifying a connection to a mobile Safari web browser running on an iPad
tablet hosted on Sauce Labs. The `options` hash includes options for specifying the driver name, and capabilities for setting
device orientation, Appium version, and various test configuration options.

    options = {
      driver: :saucelabs,
      device_type: :tablet,
      driver_name: :admin_tablet,
      capabilities: {
        browserName: 'Safari',
        platform_name: 'iOS',
        'appium:automationName': 'XCUITest',
        'appium:platformVersion': '15.4',
        'appium:deviceName': 'iPad Pro (12.9 inch) (5th generation) Simulator',
        'sauce:options': {
          username: ENV['SL_USERNAME'],
          access_key: ENV['SL_AUTHKEY'],
          name: 'ALP AP',
          build: "Test Build {ENV['BUILD_NUM']}",
          deviceOrientation: 'PORTRAIT',
          appiumVersion: '1.22.3'
        }
      }
    }
    WebDriverConnect.initialize_web_driver(options)


#### Remote Desktop Browsers on the TestingBot Service

For remotely hosted desktop web browsers on the TestingBot service, refer to the [TestingBot List of Available Browsers page](https://testingbot.com/support/getting-started/browsers.html)
and the [TestingBot Automated Test Options page](https://testingbot.com/support/other/test-options) for information regarding the options and capabilities available for
the various supported desktop operating systems and web browsers.

##### TestingBot Desktop Browser using Environment Variables

If the `options` hash is not provided when calling the `TestCentricity::WebDriverConnect.initialize_web_driver` method,
the following **Environment Variables** must be set as described in the table below.

| **Environment Variable** | **Description**                                                                                                    |
|--------------------------|--------------------------------------------------------------------------------------------------------------------|
| `DRIVER`                 | Must be set to `testingbot`                                                                                        |
| `TB_USERNAME`            | Must be set to your TestingBot account user name                                                                   |
| `TB_AUTHKEY`             | Must be set to your TestingBot account access key                                                                  |
| `TB_OS`                  | Refer to `platform` capability in chart                                                                            |
| `TB_BROWSER`             | Refer to `browserName` capability in chart                                                                         |
| `TB_VERSION`             | Refer to `version` capability in chart                                                                             |
| `TUNNELING`              | [Optional] Must be `true` if you are testing against internal/local servers (`true` or `false`)                    |
| `RESOLUTION`             | [Optional] Refer to [Change Screen Resolution](https://testingbot.com/support/other/test-options#screenresolution) |
| `BROWSER_SIZE`           | [Optional] Specify width, height of browser window                                                                 |


##### TestingBot Desktop Browser in the `options` Hash

When using the `options` hash, the following options and capabilities must be specified:
- `driver:` must be set to `:testingbot`
- `browserName:` in the `capabilities:` hash must be set to name from capability in chart
- `browser_version:` in the `capabilities:` hash must be set to browser version from capability in chart
- `platform_name:` in the `capabilities:` hash must be set to platform name from capability in chart

```
    options = {
      driver: :testingbot,
      capabilities: {
        browserName: browser_name_from_chart,
        browser_version: browser_version_from_chart,
        platform_name: platform_name_from_chart
      }
    }
    WebDriverConnect.initialize_web_driver(options)
```
ℹ️ If an optional user defined `driver_name:` is not specified in the `options` hash, the default driver name will be set to
`:testingbot_<browserName>` - e.g. `:testingbot_chrome` or `:testingbot_microsoftedge`.

ℹ️ If an `endpoint:` is not specified in the `options` hash, then the default remote endpoint URL will be set to the following:

`https://#{ENV['TB_USERNAME']}:#{ENV['TB_AUTHKEY']}@hub.testingbot.com/wd/hub`

This default endpoint requires that the `TB_USERNAME` Environment Variable is set to your TestingBot account user name and
the `TB_AUTHKEY` Environment Variable is set to your TestingBot access key.

Below is an example of an `options` hash for specifying a connection to the latest version of an Edge desktop web browser
running on macOS Sonoma hosted on TestingBot. The `options` hash includes options for specifying the driver name, setting
the browser window size, and capabilities for setting screen resolution, time zone, and various test configuration options.

    options = {
      driver: :testingbot,
      driver_name: :admin_user,
      browser_size: [1400, 1100],
      capabilities: {
        browserName: 'microsoftedge',
        browser_version: 'latest',
        platform_name: 'SONOMA',
        'tb:options': {
          name: 'ALP AP',
          build: "Test Build {ENV['BUILD_NUM']}",
          timeZone: 'Australia/Adelaide',
          'testingbot.geoCountryCode': 'AU',
          'screen-resolution': '2048x1536',
          'selenium-version': '4.14.1'
        }
      }
    }
    WebDriverConnect.initialize_web_driver(options)


#### Remote Mobile Browsers on the TestingBot Service

For remotely hosted mobile web browsers on the TestingBot service, refer to the [TestingBot List of Available Browsers page](https://testingbot.com/support/getting-started/browsers.html)
and the [TestingBot Automated Test Options page](https://testingbot.com/support/other/test-options) for information regarding the options and capabilities available for
the various supported mobile operating systems, devices, and web browsers.

##### TestingBot Mobile Browser using Environment Variables

If the `options` hash is not provided when calling the `TestCentricity::WebDriverConnect.initialize_web_driver` method,
the following **Environment Variables** must be set as described in the table below.

| **Environment Variable** | **Description**                                                                                 |
|--------------------------|-------------------------------------------------------------------------------------------------|
| `DRIVER`                 | Must be set to `testingbot`                                                                     |
| `TB_USERNAME`            | Must be set to your TestingBot account user name                                                |
| `TB_AUTHKEY`             | Must be set to your TestingBot account access key                                               |
| `TB_PLATFORM`            | Must be set to `iOS` or `ANDROID`                                                               |
| `TB_OS`                  | Must be set to `iOS` or `ANDROID`                                                               |
| `TB_BROWSER`             | Must be set to `safari` (for iOS) or `chrome` (for Android)                                     |
| `TB_VERSION`             | Refer to `version` capability in chart                                                          |
| `TB_DEVICE`              | Refer to `deviceName` capability in chart                                                       |
| `DEVICE_TYPE`            | Must be set to `phone` or `tablet`                                                              |
| `TUNNELING`              | [Optional] Must be `true` if you are testing against internal/local servers (`true` or `false`) |
| `ORIENTATION`            | [Optional] Set to `portrait` or `landscape`                                                     |


##### TestingBot Mobile Browser in the `options` Hash

When using the `options` hash, the following options and capabilities must be specified:
- `driver:` must be set to `:testingbot`
- `device_type:` must be set to `:tablet` or `:phone`
- `browserName:` in the `capabilities:` hash must be set to `browserName` from capability in chart
- `platform_name:` in the `capabilities:` hash must be set to `platform_name` from capability in chart

```
    options = {
      driver: :testingbot,
      device_type: phone_or_tablet,
      capabilities: {
        browserName: browser_name_from_chart,
        platform_name: platform_name_from_chart,
        browserVersion: os_version_from_chart,
        'tb:options': {
          deviceName: device_name_from_chart
        }
      }
    }
    WebDriverConnect.initialize_web_driver(options)
```
ℹ️ If an optional user defined `driver_name:` is not specified in the `options` hash, the default driver name will be set to
`:testingbot_<browserName>` - e.g. `:testingbot_chrome` or `:testingbot_safari`.

ℹ️ If an `endpoint:` is not specified in the `options` hash, then the default remote endpoint URL will be set to the following:

`https://#{ENV['TB_USERNAME']}:#{ENV['TB_AUTHKEY']}@hub.testingbot.com/wd/hub`

This default endpoint requires that the `TB_USERNAME` Environment Variable is set to your TestingBot account user name and
the `TB_AUTHKEY` Environment Variable is set to your TestingBot access key.

Below is an example of an `options` hash for specifying a connection to a mobile Safari web browser running on an iPad
tablet hosted on TestingBot. The `options` hash includes options for specifying the driver name, and capabilities for setting
device orientation, Appium version, and various test configuration options.

    options = {
      driver: :testingbot,
      device_type: :tablet,
      driver_name: :admin_tablet,
      capabilities: {
        browserName: 'safari',
        browserVersion: '15.4',
        platformName: 'iOS',
        'tb:options': {
          deviceName: 'iPad Pro (12.9-inch) (5th generation)',
          name: 'ALP AP',
          build: "Test Build {ENV['BUILD_NUM']}",
          orientation: 'LANDSCAPE'
        }
      }
    }
    WebDriverConnect.initialize_web_driver(options)


#### Remote Desktop Browsers on the LambdaTest Service

For remotely hosted desktop web browsers on the LambdaTest service, refer to the Selenium 4 Configuration Wizard on the
[Selenium Desired Capabilities Generator](https://www.lambdatest.com/capabilities-generator/) for information regarding the options and capabilities available for the
various supported desktop operating systems and web browsers.

##### LambdaTest Desktop Browser using Environment Variables

If the `options` hash is not provided when calling the `TestCentricity::WebDriverConnect.initialize_web_driver` method,
the following **Environment Variables** must be set as described in the table below.

| **Environment Variable** | **Description**                                                                          |
|--------------------------|------------------------------------------------------------------------------------------|
| `DRIVER`                 | Must be set to `lambdatest`                                                              |
| `LT_USERNAME`            | Must be set to your LambdaTest account user name or email address                        |
| `LT_AUTHKEY`             | Must be set to your LambdaTest account access key                                        |
| `LT_OS`                  | Refer to `platformName` capability in the sample script of the Wizard                    |
| `LT_BROWSER`             | Refer to `browserName` capability in the sample script of the Wizard                     |
| `LT_VERSION`             | Refer to `browserVersion` capability in chart                                            |
| `RESOLUTION`             | [Optional] Refer to supported `resolution` capability in the sample script of the Wizard |
| `BROWSER_SIZE`           | [Optional] Specify width, height of browser window                                       |
| `RECORD_VIDEO`           | [Optional] Enable screen video recording during test execution (`true` or `false`)       |
| `ALLOW_POPUPS`           | [Optional] Allow popups (`true` or `false`) - for Safari, IE, and Edge browsers only     |
| `ALLOW_COOKIES`          | [Optional] Allow all cookies (`true` or `false`) - for Safari browsers only              |
| `CONSOLE_LOGS`           | [Optional] Used to capture browser console logs.                                         |


##### LambdaTest Desktop Browser in the `options` Hash

When using the `options` hash, the following options and capabilities must be specified:
- `driver:` must be set to `:lambdatest`
- `browserName:` in the `capabilities:` hash must be set to name from capability in chart
- `browserVersion:` in the `capabilities:` hash must be set to browser version from capability in chart

```
    options = {
      driver: :lambdatest,
      capabilities: {
        browserName: browser_name_from_chart,
        browserVersion: browser_version_from_chart,
        'LT:Options': {
          userName: lt_account_user_name,
          accessKey: lt_account_access_key,
          platformName: platformName_from_chart
        }
      }
    }
    WebDriverConnect.initialize_web_driver(options)
```
ℹ️ If an optional user defined `driver_name:` is not specified in the `options` hash, the default driver name will be set to
`:lambdatest_<browserName>` - e.g. `:lambdatest_chrome` or `:lambdatest_safari`.

ℹ️ If an `endpoint:` is not specified in the `options` hash, then the default remote endpoint URL will be set to the following:

`https://#{ENV['LT_USERNAME']}:#{ENV['LT_AUTHKEY']}@hub.lambdatest.com/wd/hub`

This default endpoint requires that the `LT_USERNAME` Environment Variable is set to your LambdaTest account user name and
the `LT_AUTHKEY` Environment Variable is set to your LambdaTest access key.

Below is an example of an `options` hash for specifying a connection to the latest version of an Edge desktop web browser
running on macOS Sonoma hosted on LambdaTest. The `options` hash includes options for specifying the driver name, setting
the browser window size, and capabilities for setting screen resolution, geoLocation, time zone, Selenium version, and various
test configuration options.

    options = {
      driver: :lambdatest,
      driver_name: :admin_user,
      browser_size: [1400, 1100],
      capabilities: {
        browserName: 'MicrosoftEdge',
        browserVersion: '119.0',
        'LT:Options': {
          platformName: 'macOS Sonoma',
          userName: ENV['LT_USERNAME'],
          accessKey: ENV['LT_AUTHKEY'],
          project: 'ALP AP',
          build: "Test Build {ENV['BUILD_NUM']}",
          resolution: '2560x1440',
          selenium_version: '4.13.0',
          networkLogs: 'true',
          geoLocation: 'AU',
          timezone: 'Adelaide',
          console: 'info',
          network: true
        }
      }
    }
    WebDriverConnect.initialize_web_driver(options)


### Closing Browser and Driver Instances

#### Closing Instances Using Cucumber

To close all browser and driver instances upon completion of your automated Cucumber features, place the code shown below
in your `hooks.rb` file:

    AfterAll do
      # terminate all driver instances
      WebDriverConnect.close_all_drivers
    end


#### Closing Instances Using RSpec

To close all browser and driver instances upon completion of an automated spec, place the code shown below in the body
of an example group:

    after(:each) do
      # terminate all driver instances
      WebDriverConnect.close_all_drivers
    end


### Using Browser Specific Profiles in `cucumber.yml`

While you can set **Environment Variables** in the command line when invoking Cucumber, a preferred method of specifying and
managing target web browsers is to create browser specific **Profiles** that set the appropriate **Environment Variables**
for each target browser in your `cucumber.yml` file.

Below is a list of Cucumber **Profiles** for supported locally and remotely hosted desktop and mobile web browsers (put
these in in your`cucumber.yml` file). Before you can use the BrowserStack, SauceLabs, TestingBot or LambdaTest services,
you will need to replace the *INSERT USER NAME HERE* and *INSERT PASSWORD HERE* placeholder text with your user account
and authorization code for the cloud service(s) that you intend to connect with.

⚠️ Cloud service credentials should not be stored as text in your `cucumber.yml` file where it can be exposed by anyone
with access to your version control system.


    <% desktop = "--tags @desktop --require features BROWSER_TILE=true BROWSER_SIZE=1500,1000" %>
    <% tablet  = "--tags @desktop --require features BROWSER_TILE=true" %>
    <% mobile  = "--tags @mobile  --require features BROWSER_TILE=true" %>

    #==============
    # profiles for locally hosted desktop web browsers
    #==============

    firefox: WEB_BROWSER=firefox <%= desktop %>
    chrome:  WEB_BROWSER=chrome <%= desktop %>
    edge:    WEB_BROWSER=edge <%= desktop %>
    safari:  WEB_BROWSER=safari <%= desktop %>

    firefox_headless: WEB_BROWSER=firefox_headless <%= desktop %>
    chrome_headless:  WEB_BROWSER=chrome_headless <%= desktop %>
    edge_headless:    WEB_BROWSER=edge_headless <%= desktop %>


    #==============
    # profiles for locally hosted mobile web browsers (emulated locally in Chrome browser)
    #==============

    iphone_11:           WEB_BROWSER=iphone_11           <%= mobile %>
    iphone_11_pro:       WEB_BROWSER=iphone_11_pro       <%= mobile %>
    iphone_11_pro_max:   WEB_BROWSER=iphone_11_pro_max   <%= mobile %>
    iphone_12_mini:      WEB_BROWSER=iphone_12_mini      <%= mobile %>
    iphone_12:           WEB_BROWSER=iphone_12           <%= mobile %>
    iphone_12_pro:       WEB_BROWSER=iphone_12_pro       <%= mobile %>
    iphone_12_pro_max:   WEB_BROWSER=iphone_12_pro_max   <%= mobile %>
    iphone_13_mini:      WEB_BROWSER=iphone_13_mini      <%= mobile %>
    iphone_13:           WEB_BROWSER=iphone_13           <%= mobile %>
    iphone_13_pro:       WEB_BROWSER=iphone_13_pro       <%= mobile %>
    iphone_13_pro_max:   WEB_BROWSER=iphone_13_pro_max   <%= mobile %>
    iphone_se:           WEB_BROWSER=iphone_se           <%= mobile %>
    iphone_14:           WEB_BROWSER=iphone_14           <%= mobile %>
    iphone_14_plus:      WEB_BROWSER=iphone_14_plus      <%= mobile %>
    iphone_14_pro:       WEB_BROWSER=iphone_14_pro       <%= mobile %>
    iphone_14_pro_max:   WEB_BROWSER=iphone_14_pro_max   <%= mobile %>
    ipad:                WEB_BROWSER=ipad                <%= tablet %>
    ipad_mini:           WEB_BROWSER=ipad_mini           <%= tablet %>
    ipad_air:            WEB_BROWSER=ipad_air            <%= tablet %>
    ipad_pro_11:         WEB_BROWSER=ipad_pro_11         <%= tablet %>
    ipad_pro_12_9:       WEB_BROWSER=ipad_pro_12_9       <%= tablet %>
    pixel_5:             WEB_BROWSER=pixel_5             <%= mobile %>
    pixel_6:             WEB_BROWSER=pixel_6             <%= mobile %>
    pixel_xl:            WEB_BROWSER=pixel_xl            <%= mobile %>
    windows_phone7:      WEB_BROWSER=windows_phone7      <%= mobile %>
    windows_phone8:      WEB_BROWSER=windows_phone8      <%= mobile %>
    lumia_950_xl:        WEB_BROWSER=lumia_950_xl        <%= mobile %>
    blackberry_z10:      WEB_BROWSER=blackberry_z10      <%= mobile %>
    blackberry_z30:      WEB_BROWSER=blackberry_z30      <%= mobile %>
    blackberry_leap:     WEB_BROWSER=blackberry_leap     <%= mobile %>
    blackberry_passport: WEB_BROWSER=blackberry_passport <%= mobile %>
    pixel_c:             WEB_BROWSER=pixel_c             <%= tablet %>
    nexus_10:            WEB_BROWSER=nexus_10            <%= tablet %>
    kindle_fire:         WEB_BROWSER=kindle_fire         <%= tablet %>
    kindle_firehd7:      WEB_BROWSER=kindle_firehd7      <%= tablet %>
    kindle_firehd8:      WEB_BROWSER=kindle_firehd8      <%= tablet %>
    kindle_firehd10:     WEB_BROWSER=kindle_firehd10     <%= tablet %>
    surface:             WEB_BROWSER=surface             <%= tablet %>
    blackberry_playbook: WEB_BROWSER=blackberry_playbook <%= tablet %>


    #==============
    # profiles for mobile device screen orientation
    #==============

    portrait:  ORIENTATION=portrait
    landscape: ORIENTATION=landscape


    #==============
    # profile to start Appium Server prior to running mobile browser tests on iOS or Android simulators or physical devices
    #==============

    run_appium: APPIUM_SERVER=run


    #==============
    # profiles for mobile Safari web browsers hosted within XCode iOS simulator
    # NOTE: Requires installation of XCode, iOS version specific target simulators, and Appium
    #==============

    appium_ios: DRIVER=appium AUTOMATION_ENGINE=XCUITest APP_PLATFORM_NAME="ios" APP_BROWSER="Safari" NEW_COMMAND_TIMEOUT=30 SHOW_SIM_KEYBOARD=false
    app_ios_15: --profile appium_ios APP_VERSION="15.4"
    ipad_pro_12_15_sim: --profile app_ios_15 DEVICE_TYPE=tablet APP_DEVICE="iPad Pro (12.9-inch) (5th generation)"
    ipad_air_15_sim:    --profile app_ios_15 DEVICE_TYPE=tablet APP_DEVICE="iPad Air (5th generation)" <%= desktop %>
    ipad_15_sim:        --profile app_ios_15 DEVICE_TYPE=tablet APP_DEVICE="iPad (9th generation)"


    #==============
    # profiles for mobile Safari web browsers running on physically connected iOS devices
    # NOTE: Requires installation of XCode and Appium
    #==============

    my_ios_15_iphone: --profile app_ios_15 DEVICE_TYPE=phone APP_DEVICE="My Test iPhoneX" APP_UDID="INSERT YOUR DEVICE UDID"
    my_ios_15_ipad:   --profile app_ios_15 DEVICE_TYPE=tablet APP_DEVICE="My Test iPad Pro" APP_UDID="INSERT YOUR DEVICE UDID"


    #==============
    # profiles for Android mobile web browsers hosted within Android Studio Android Virtual Device emulators
    # NOTE: Requires installation of Android Studio, Android version specific virtual device simulators, and Appium
    #==============

    appium_android:    DRIVER=appium APP_PLATFORM_NAME="Android" <%= mobile %>
    app_android_12:    --profile appium_android APP_BROWSER="Chrome" APP_VERSION="12.0"
    pixel_c_api31_sim: --profile app_android_12 DEVICE_TYPE=tablet APP_DEVICE="Pixel_C_API_31"


    #==============
    # profiles for remotely hosted web browsers on the BrowserStack service
    # WARNING: Credentials should not be stored as text in your cucumber.yml file where it can be exposed by anyone with
    #          access to your version control system
    #==============

    browserstack: DRIVER=browserstack BS_USERNAME="<INSERT USER NAME HERE>" BS_AUTHKEY="<INSERT PASSWORD HERE>"
    bs_desktop: --profile browserstack <%= desktop %> RESOLUTION="1920x1080"
    bs_mobile:  --profile browserstack <%= mobile %>

    # BrowserStack macOS desktop browser profiles
    bs_macos_sonoma:  --profile bs_desktop BS_OS="OS X" BS_OS_VERSION="Sonoma"
    bs_chrome_sonoma: --profile bs_macos_sonoma BS_BROWSER="Chrome" BS_VERSION="latest"
    bs_edge_sonoma:   --profile bs_macos_sonoma BS_BROWSER="Edge" BS_VERSION="latest"
    bs_safari_sonoma: --profile bs_macos_sonoma BS_BROWSER="Safari" BS_VERSION="latest"

    # BrowserStack Windows desktop browser profiles
    bs_win11:        --profile bs_desktop BS_OS="Windows" BS_OS_VERSION="11"
    bs_chrome_win11: --profile bs_win11 BS_BROWSER="Chrome" BS_VERSION="latest"
    bs_edge_win11:   --profile bs_win11 BS_BROWSER="Edge" BS_VERSION="latest"
    bs_win10:        --profile bs_desktop BS_OS="Windows" BS_OS_VERSION="10"
    bs_ie_win10:     --profile bs_win10 BS_BROWSER="IE" BS_VERSION="11.0"

    # BrowserStack iOS mobile browser profiles
    bs_ipad:        --profile bs_mobile BS_OS=ios BS_BROWSER=Safari DEVICE_TYPE=tablet BS_REAL_MOBILE="true"
    bs_ipad_pro_12: --profile bs_ipad BS_DEVICE="iPad Pro 12.9 2018" BS_OS_VERSION="15"

    # BrowserStack Android mobile browser profiles
    bs_android:        --profile bs_mobile BS_OS=android BS_BROWSER=Chrome DEVICE_TYPE=tablet BS_REAL_MOBILE="true"
    bs_android_tablet: --profile bs_android BS_DEVICE="Samsung Galaxy Tab S7" BS_OS_VERSION="10.0"


    #==============
    # profiles for remotely hosted web browsers on the SauceLabs service
    # WARNING: Credentials should not be stored as text in your cucumber.yml file where it can be exposed by anyone with
    #          access to your version control system
    #==============

    saucelabs:  DRIVER=saucelabs SL_USERNAME="<INSERT USER NAME HERE>" SL_AUTHKEY="<INSERT PASSWORD HERE>" DATA_CENTER="<INSERT DATA CENTER HERE"
    sl_desktop: --profile saucelabs <%= desktop %>
    sl_mobile:  --profile saucelabs <%= mobile %>

    # SauceLabs macOS desktop browser profiles
    sl_macos_ventura:  --profile sl_desktop SL_OS="macOS 13" RESOLUTION="1920x1440"
    sl_chrome_ventura: --profile sl_macos_ventura SL_BROWSER="chrome" SL_VERSION="latest"
    sl_edge_ventura:   --profile sl_macos_ventura SL_BROWSER="MicrosoftEdge" SL_VERSION="latest"
    sl_firefox_ventura: --profile sl_macos_ventura SL_BROWSER="Firefox" SL_VERSION="latest"

    # SauceLabs Windows desktop browser profiles
    sl_windows:    --profile sl_desktop RESOLUTION="1920x1200"
    sl_edge_win11: --profile sl_windows SL_OS="Windows 11" SL_BROWSER="MicrosoftEdge" SL_VERSION="latest"
    sl_ie_win10:   --profile sl_windows SL_OS="Windows 10" SL_BROWSER="internet explorer" SL_VERSION="11"

    # SauceLabs iOS mobile browser profiles
    sl_ipad:        --profile sl_mobile DEVICE_TYPE=tablet SL_PLATFORM=iOS SL_BROWSER=Safari
    sl_ipad_pro_12: --profile sl_ipad SL_DEVICE="iPad Pro (12.9 inch) (5th generation) Simulator" SL_VERSION="15.0"


    #==============
    # profiles for remotely hosted web browsers on the TestingBot service
    # WARNING: Credentials should not be stored as text in your cucumber.yml file where it can be exposed by anyone with
    #          access to your version control system
    #==============

    testingbot: DRIVER=testingbot TB_USERNAME="<INSERT USER NAME HERE>" TB_AUTHKEY="<INSERT PASSWORD HERE>"
    tb_desktop: --profile testingbot <%= desktop %> RESOLUTION="1920x1200"

    # TestingBot macOS desktop browser profiles
    tb_macos_sonoma:  --profile tb_desktop TB_OS="SONOMA"
    tb_chrome_sonoma: --profile tb_macos_sonoma TB_BROWSER="chrome" TB_VERSION="latest"
    tb_edge_sonoma:   --profile tb_macos_sonoma TB_BROWSER="microsoftedge" TB_VERSION="latest"

    # TestingBot Windows desktop browser profiles
    tb_win11:      --profile tb_desktop TB_OS="WIN11"
    tb_edge_win11: --profile tb_win11 TB_BROWSER="microsoftedge" TB_VERSION="latest"
    tb_win10:      --profile tb_desktop TB_OS="WIN10"
    tb_ie_win10:   --profile tb_win10 TB_BROWSER="internet explorer" TB_VERSION="11"


    #==============
    # profiles for remotely hosted web browsers on the LambdaTest service
    # WARNING: Credentials should not be stored as text in your cucumber.yml file where it can be exposed by anyone with
    #          access to your version control system
    #==============

    lambdatest: DRIVER=lambdatest LT_USERNAME=<INSERT USER NAME HERE> LT_AUTHKEY=<INSERT PASSWORD HERE>
    lt_desktop: --profile lambdatest <%= desktop %> RESOLUTION="2560x1440"

    # LambdaTest macOS desktop browser profiles
    lt_macos_monterey:  --profile lt_desktop LT_OS="MacOS Monterey"
    lt_chrome_monterey: --profile lt_macos_monterey LT_BROWSER="Chrome" LT_VERSION="98.0"
    lt_edge_monterey:   --profile lt_macos_monterey LT_BROWSER="MicrosoftEdge" LT_VERSION="97.0"

    # LambdaTest Windows desktop browser profiles
    lt_win11:      --profile lt_desktop LT_OS="Windows 11"
    lt_edge_win11: --profile lt_win11 LT_BROWSER="MicrosoftEdge" LT_VERSION="98.0"
    lt_win10:      --profile lt_desktop LT_OS="Windows 10"
    lt_i0_win11:   --profile lt_win10 LT_BROWSER="Internet Explorer" LT_VERSION="11.0"


To specify a locally hosted target browser using a profile at runtime, you use the flag `--profile` or `-p` followed by the
profile name when invoking Cucumber in the command line. For instance, the following command invokes Cucumber and specifies
that a local instance of Firefox will be used as the target web browser:
    
    cucumber -p firefox


The following command specifies that Cucumber will run tests against an instance of Chrome hosted within a Dockerized Selenium
Grid 4 environment:
    
    cucumber -p chrome -p grid


The following command specifies that Cucumber will run tests against a local instance of Chrome, which will be used to emulate
an iPad Pro in landscape orientation:
    
    cucumber -p ipad_pro -p landscape


The following command specifies that Cucumber will run tests against an iPad Pro (12.9-inch) (5th generation) with iOS version
15.4 in an XCode Simulator in landscape orientation:
    
    cucumber -p ipad_pro_12_15_sim -p landscape
    
    ⚠️ Appium must be running prior to executing this command

You can ensure that Appium Server is running by including `-p run_appium` in your command line:

    cucumber -p ipad_pro_12_15_sim -p landscape -p run_appium


The following command specifies that Cucumber will run tests against a remotely hosted Safari web browser running on a macOS
Sonoma virtual machine on the BrowserStack service:

    cucumber -p bs_safari_sonoma


---
## Recommended Project Organization and Structure

Below is an example of the project structure of a typical Cucumber based test automation framework with a Page Object Model
architecture. `PageObject` class definitions should be stored in the `/features/support/pages` folder, organized in functional
area sub-folders as needed. Likewise, `PageSection` class definitions should be stored in the `/features/support/sections` folder.

        📁 my_automation_project/
        ├── 📁 config/
        │   ├── 📁 locales/
        │   ├── 📁 test_data/
        │   └── 📄 cucumber.yml
        ├── 📁 downloads/
        ├── 📁 features/
        │   ├── 📁 step_definitions/
        │   └── 📁 support/
        │       ├── 📁 pages/
        │       ├── 📁 sections/
        │       ├── 📄 env.rb
        │       ├── 📄 hooks.rb
        │       └── 📄 world_pages.rb
        ├── 📄 Gemfile
        └── 📄 README.md


---
## Web Test Automation Framework Implementation

![TestCentricity Web Framework Overview](https://raw.githubusercontent.com/TestCentricity/testcentricity_web/main/.github/images/tc_overview.jpg "TestCentricity Web Framework Overview")


---
## Copyright and License

TestCentricity™ Framework is Copyright (c) 2014-2023, Tony Mrozinski.
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following
conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer
in the documentation and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived
from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING,
BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT
SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
OR OTHERWISE)ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
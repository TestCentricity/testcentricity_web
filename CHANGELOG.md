# CHANGELOG
All notable changes to this project will be documented in this file.

## [3.2.18] - 12-AUG-2020

### Fixed
* Updated `PageObject.verify_ui_states` and `PageSection.verify_ui_states` methods to correctly handle `:row`, `:column`,
`:cell`, `:item`, and `:attribute` properties.

## [3.2.17] - 19-JUNE-2020

### Changed
* Updated `Table.define_table_elements` method to accept value for `:row_header` element.
* Updated `Table.get_row_count`, `Table.get_column_count`, and `Table.get_table_cell_locator` methods to support tables
with row headers in row #1.

## [3.2.16] - 13-MAY-2020

### Changed
* `WebDriverConnect.initialize_web_driver` method now sets local Chrome and Firefox browser Download directory to separate
folders for each parallel test thread when using `parallel_tests` gem to run tests in concurrent threads.

## [3.2.15] - 06-APR-2020

### Fixed
* `PageObject.populate_data_fields` and `PageSection.populate_data_fields` methods accept `String` or `Boolean` values
for checkboxes and radio buttons.

## [3.2.14] - 06-APR-2020

### Added
* Added `UIElement.scroll_to` method.

## [3.2.13] - 24-MAR-2020

### Added
* Added `PageObject.send_keys` method.

## [3.2.12] - 11-MAR-2020

### Added
* Added `UIElement.focused?` method.
* Updated `PageObject.verify_ui_states` and `PageSection.verify_ui_states` methods to support verification of the
`focused` property.

## [3.2.11] - 10-MAR-2020

### Added
* Added `PageSection.verify_focus_order` method.

## [3.2.10] - 09-MAR-2020

### Added
* Added `PageObject.verify_focus_order` method.

## [3.2.9] - 12-FEB-2020

### Fixed
* Fixed `UIElement.wait_until_value_is`, `List.wait_until_item_count_is`, and `Table.wait_until_row_count_is`' methods.

## [3.2.8] - 08-FEB-2020

### Fixed
* Fixed `UIElement.visible?` method that was broken in release 3.2.7.

## [3.2.7] - 05-FEB-2020

### Added
* Added `Audio.crossorigin` and `Video.crossorigin` methods.
* Added `Audio.preload` and `Video.preload` methods.
* Added `Video.poster` method.
* Updated `PageObject.verify_ui_states` and `PageSection.verify_ui_states` methods to support verification of the
`crossorigin`, `preload`, and `poster` properties.

## [3.2.6] - 31-JAN-2020

### Changed
* `Audio.volume` and `Video.volume` methods now return a `Float`.

## [3.2.5] - 25-JAN-2020

### Added
* Added `UIElement.content_editable?` method.
* Updated `PageObject.verify_ui_states` and `PageSection.verify_ui_states` methods to support verification of the
`content_editable` property.

### Fixed
* Fixed `UIElement.aria_multiselectable?` method.

## [3.2.4] - 16-JAN-2020

### Added
* Added `Range` type `UIElement` to support interaction with and verification of HTML5 Input Range Slider Objects.

## [3.2.3] - 29-DEC-2019

### Added
* Additional methods to support WCAG 2.x accessibility testing and verification:
  * `UIElement.aria_valuemax` method
  * `UIElement.aria_valuemin` method
  * `UIElement.aria_valuenow` method
  * `UIElement.aria_valuetext` method
  * `UIElement.aria_orientation` method
  * `UIElement.aria_keyshortcuts` method
  * `UIElement.aria_roledescription` method
  * `UIElement.aria_autocomplete` method
  * `UIElement.aria_modal?` method
  * `UIElement.aria_busy?` method
  * `UIElement.aria_multiline?` method
  * `UIElement.aria_multiselectable?` method
  * `UIElement.aria_controls` method
* Updated `PageObject.verify_ui_states` and `PageSection.verify_ui_states` methods to support verification of the following
properties:
  * `aria_valuemax`
  * `aria_valuemin`
  * `aria_valuenow`
  * `aria_valuetext`
  * `aria_orientation`
  * `aria_roledescription`
  * `aria_autocomplete`
  * `aria_modal`
  * `aria_keyshortcuts`
  * `aria_multiline`
  * `aria_multiselectable`
  * `aria_controls`

## [3.2.2] - 16-OCT-2019

### Added
* Added device profiles for iPhone 11, 11 Pro, and 11 Pro Max (iOS 13.1) with Mobile Safari browser.
* Added `Table.wait_until_row_count_is` and `Table.wait_until_row_count_changes` methods.
* Added `CheckBox.indeterminate?` method.
* Updated `PageObject.verify_ui_states` and `PageSection.verify_ui_states` methods to support verification of `indeterminate` property.
* Updated device profiles for iPad Pro 12.9" 3rd Generation (iOS 13.1) with Mobile Safari browser.

## [3.2.1] - 03-OCT-2019

### Changed
* `CheckBox.visible?`, `CheckBox.disabled?`, and `CheckBox.get_value` methods now work with React and Ember checkboxes with
proxy elements.
* `Radio.visible?`, `Radio.disabled?`, and `Radio.get_value` methods now work with React and Ember radio buttons with
proxy elements.

## [3.2.0] - 28-JULY-2019

### Added
* Added support for connecting to and running your tests on cloud hosted browsers on the LambdaTest cloud platform.
* Added `UIElement.obscured?` and `UIElement.inspect` methods.
* Added `Video.wait_until_ready_state_is` and `Audio.wait_until_ready_state_is` methods.

### Changed
* `Video.ready_state` and `Audio.ready_state` methods now return an Integer result.

## [3.1.11] - 20-JUNE-2019

### Added
* Added `SelectList.get_group_count` and `SelectList.get_group_headings` methods.
* Updated `PageObject.verify_ui_states` and `PageSection.verify_ui_states` methods to support verification of `groupcount`
and `group_headings` properties of `SelectList` objects.

## [3.1.10] - 21-MAY-2019

### Fixed
* Improved compatibility with React and Chosen select lists.


## [3.1.9] - 16-MAY-2019

### Added
* Added support for enabling popups when testing on BrowserStack cloud hosted Safari, IE, and Edge browsers.
* Added support for enabling all cookies when testing on BrowserStack cloud hosted Safari browsers.

### Changed
* `List.get_list_items` and `List.get_list_item` methods now strip leading and trailing whitespace from returned values.

## [3.1.8] - 08-MAY-2019

### Added
* Added `Link.href` method.
* Updated `PageObject.verify_ui_states` and `PageSection.verify_ui_states` methods to support verification of `href` property.

### Changed
* Updated device profiles for iPhone 7 (iOS 12.2) with Mobile Firefox browser and iPad (iOS 12.2) with Mobile Firefox browser.
* Updated device profiles for iPhone 7 (iOS 12.2) with Mobile Edge browser and iPad (iOS 12.2) with Mobile Edge browser.
* Updated device profiles for iPhone 7 (iOS 12.2) with Mobile Chrome browser and iPad (iOS 12.2) with Mobile Chrome browser.


## [3.1.7] - 01-FEB-2019

### Added
* Added `UIElement.title` and `PageObject.title` methods.
* Added `Video.video_height`, and `Video.video_width` methods.
* Updated `PageObject.verify_ui_states` and `PageSection.verify_ui_states` methods to support verification of `title` property.


## [3.1.6] - 20-JAN-2019

### Added
* Updated `PageObject.verify_ui_states` and `PageSection.verify_ui_states` methods to support verification of `name` property.


## [3.1.5] - 06-JAN-2019

### Added
* Additional methods to support WCAG 2.x accessibility testing and verification:
  * `UIElement.aria_rowcount` method.
  * `UIElement.aria_colcount` method.
  * `UIElement.aria_sort` method.
  * `UIElement.aria_haspopup?` method.
  * `UIElement.aria_pressed?` method.
* Updated `PageObject.verify_ui_states` and `PageSection.verify_ui_states` methods to support verification of `aria_rowcount`, `aria_colcount`,
`aria_sort`, `aria_pressed`, and `aria_haspopup` properties.


## [3.1.4] - 2018-12-12

### Fixed
* `PageObject.audio`, `PageObject.audios`, `PageObject.video`, and `PageObject.videos` methods now correctly instantiate HTML 5 Audio and
Video objects at the page level.


## [3.1.3] - 2018-12-08

### Added
* Additional methods to support WCAG 2.x accessibility testing and verification:
  * `UIElement.aria_invalid?` method.
  * `UIElement.aria_checked?` method.
  * `UIElement.aria_readonly?` method.
* Updated `PageObject.verify_ui_states` and `PageSection.verify_ui_states` methods to support verification of `aria_invalid`, `aria_checked`,
and `aria_readonly` properties.


## [3.1.2] - 2018-12-03

### Added
* Added `Audio.current_time` (setter), `Audio.play`, and `Audio.pause` methods.
* Added `Video.current_time` (setter), `Video.play`, and `Video.pause` methods.


## [3.1.1] - 2018-11-30

### Added
* Added device profiles for iPhone XR, XS, and XS Max (iOS 12.1) with Mobile Safari browser.
* Added device profiles for iPad Pro 11" and iPad Pro 12.9" 3rd Generation (iOS 12.1) with Mobile Safari browser.

### Changed
* Updated device profiles for iPhone 7 (iOS 12) with Mobile Firefox browser and iPad (iOS 12) with Mobile Firefox browser.
* Updated device profiles for iPhone 7 (iOS 12) with Mobile Edge browser and iPad (iOS 12) with Mobile Edge browser.
* Updated device profiles for iPhone 7 (iOS 12) with Mobile Chrome browser and iPad (iOS 12) with Mobile Chrome browser.


## [3.1.0] - 2018-11-10

### Added
* Adding greater support for WCAG 2.x accessibility testing and verification:
  * `UIElement.role` method.
  * `UIElement.tabindex` method.
  * `UIElement.aria_labelledby` method.
  * `UIElement.aria_describedby` method.
  * `UIElement.aria_live` method.
  * `UIElement.aria_selected?` method.
  * `UIElement.aria_hidden?` method.
  * `UIElement.aria_expanded?` method.
  * `UIElement.aria_required?` method.
* Updated `PageObject.verify_ui_states` and `PageSection.verify_ui_states` methods to support verification of the following
properties:
  * `role`
  * `tabindex`
  * `aria-labelledby`
  * `aria-describedby`
  * `aria-live`
  * `aria-selected`
  * `aria-hidden`
  * `aria-expanded`
  * `aria-required`


## [3.0.20] - 2018-11-08

### Changed
* `PageObject.verify_ui_states` and `PageSection.verify_ui_states` methods now ignore case and whitespace when verifying text
captions and values when running tests against Microsoft Edge browsers to accommodate known Edge WebDriver [Issue #11322543](https://developer.microsoft.com/en-us/microsoft-edge/platform/issues/11322543/).
* Updated `PageObject.populate_data_fields` and `PageSection.populate_data_fields` methods to accept optional `integrity_check` parameter.


## [3.0.19] - 2018-10-10

### Added
* Added support for testing file downloads with locally hosted instances of Chrome or Firefox desktop browsers.

### Changed
* `Audio.current_time`, `Audio.duration`, `Video.current_time`, and `Video.duration` methods now return a `Float`.

### Removed
* Removed support for legacy Firefox version 47.0.1.
* Removed deprecated `TestCentricity::WebDriverConnect.set_webdriver_path` method.


## [3.0.18] - 2018-10-02

### Added
* `UIElement.style` method.
* Updated `PageObject.verify_ui_states` and `PageSection.verify_ui_states` methods to support verification of `style` property.

### Changed
* Updated device profiles for iPhone 7 (iOS 12) with Mobile Firefox browser and iPad (iOS 12) with Mobile Firefox browser.
* Updated device profiles for iPhone 7 (iOS 12) with Mobile Edge browser and iPad (iOS 12) with Mobile Edge browser.
* Updated device profiles for iPhone 7 (iOS 12) with Mobile Chrome browser and iPad (iOS 12) with Mobile Chrome browser.

### Removed
* Removed `iPhone`, `iPhone4`, and `iPhone5` device profiles.


## [3.0.17] - 2018-10-01

### Added
* `UIElement.aria_disabled?` and `UIElement.aria_label` methods.
* Updated `PageObject.verify_ui_states` and `PageSection.verify_ui_states` methods to support verification of `aria-label` and `aria-disabled` properties.


## [3.0.16] - 2018-09-21

### Added
* `Image.src` and `Image.alt` method.
* Added `Video` and `Audio` type `UIElement` to support verification of HTML5 Video and Audio Objects.


## [3.0.15] - 2018-09-19

### Added
* `UIElement.hover_at` method.
* Added support for specifying IP Geolocation when testing on BrowserStack cloud hosted browsers.


## [3.0.14] - 2018-09-17

### Added
* Added support for testing file uploads in browsers running on remote cloud hosted services as well as in Selenium Grid and Dockerized Selenium
Grid environments.


## [3.0.13] - 2018-08-10

### Fixed
* Improved response times of `List.get_item_count` and `List.get_list_items` methods by shortening `wait` time.


## [3.0.12] - 2018-08-09
### Added
* `PageSection.hover` method.
* `List.hover_item` method.


## [3.0.11] - 2018-08-05
### Added
* `UIElement.count` method.


## [3.0.10] - 2018-07-20
### Added
* `Image.broken?` method.
* `UIElement.highlight` and `UIElement.unhighlight` methods.

### Changed
* `PageObject.verify_ui_states` and `PageSection.verify_ui_states` methods now takes screenshots that display a red dashed rectangular highlight around
any UI element with property states that do not match expected results.

### Removed
* Removed deprecated `DataObject.set_current` method.


## [3.0.9] - 2018-07-05

### Added
* Added `List.choose_item` and `List.get_selected_item` methods.
* Added `SelectList.set` method.


## [3.0.8] - 2018-06-28

### Added
* Added `PageObject.wait_for_ajax` method.

### Changed
* `PageObject.verify_ui_states` and `PageSection.verify_ui_states` methods now accept optional `fail_message` string parameter to add context to error
messages when UI verifications raise an exception.


## [3.0.7] - 2018-06-21

### Added
* Added support for connecting to and running your tests in desktop and emulated mobile web browsers hosted on Selenium Grid and Dockerized Selenium
Grid environments.
* Added `Environ.report_header` method that can be used to provide formatted test environment information in HTML test results.

### Deprecated
* Deprecated `TestCentricity::WebDriverConnect.set_webdriver_path` method because the correct WebDriver is now automatically set.


## [3.0.6] - 2018-06-14

### Added
* Added support for connecting to and running your tests on cloud hosted browsers on the Gridlastic cloud platform.
* Added support for specifying Selenium WebDriver version, browser-specific WebDriver version (for Firefox, IE, and Safari), and browser console
logs when running tests on BrowserStack hosted browsers. Refer to **section 8.5.1 (Remote desktop browsers on the BrowserStack service)** in the README.

### Changed
* Updated device profiles for iPhone 7 (iOS 11) with Mobile Firefox browser and iPad (iOS 11) with Mobile Firefox browser.
* Updated device profiles for iPhone 7 (iOS 11) with Mobile Edge browser and iPad (iOS 11) with Mobile Edge browser.
* Updated device profiles for iPhone 7 (iOS 11) with Mobile Chrome browser and iPad (iOS 11) with Mobile Chrome browser.


## [3.0.5] - 2018-05-17

### Added
* Added `Environ.headless` method. Will return `true` if testing against a *headless* instance of Chrome or Firefox.


## [3.0.4] - 2018-05-12

### Fixed
* Refactored `SelectList` methods to work with Capybara version 3.x.


## [3.0.3] - 2018-05-09

### Changed
* Pinning to Capybara version 2.18.0 because Capybara 3.x breaks several `SelectList` methods.


## [3.0.2] - 2018-05-09

### Changed
* `PageManager.find_page` method now raises an exception if the requested page object has not been defined and instantiated.


## [3.0.1] - 2018-04-28

### Changed
* Updated device profiles for iPhone 7 (iOS 11) with Mobile Firefox browser and iPad (iOS 10) with Mobile Firefox browser.
* Updated device profiles for iPhone 7 (iOS 11) with Mobile Edge browser and iPad (iOS 10) with Mobile Edge browser.
* Updated device profiles for iPhone 7 (iOS 11) with Mobile Chrome browser and iPad (iOS 10) with Mobile Chrome browser.


## [3.0.0] - 2018-04-25

### Added
* The TestCentricity™ Web gem now works with Selenium-WebDriver version 3.11 and **geckodriver** version 0.20.1 (or later) to support testing of the latest versions
of Firefox web browsers.
* Support for testing on locally hosted "headless" Chrome or Firefox browsers has been added.
* Support for headless browser testing using Poltergeist and PhantomJS has been removed.
* Support for Legacy FirefoxDriver (used in Firefox versions < 48) has been added.

### Fixed
* `TestCentricity::WebDriverConnect.set_webdriver_path` method now sets the path to the appropriate **geckodriver** file for OS X or Windows when testing on
locally hosted Firefox browsers.


## [2.4.3] - 2018-04-11

### Changed
* Updated device profiles for iPhone 7 (iOS 11) with Mobile Firefox browser and iPad (iOS 10) with Mobile Firefox browser.


## [2.4.1] - 2018-03-27

### Added
* Added device profiles for iPad (iOS 10) with MS Edge browser.


## [2.4.0] - 2018-03-25

### Changed
* Updated `TestCentricity::WebDriverConnect.initialize_web_driver` method to read the `APP_FULL_RESET`, `APP_NO_RESET`, and `NEW_COMMAND_TIMEOUT` Environment
Variables and set the corresponding `fullReset`, `noReset`, and `newCommandTimeout` Appium capabilities for iOS and Android physical devices and simulators.
Also reads the `WDA_LOCAL_PORT` Environment Variable and sets the `wdaLocalPort` Appium capability for iOS physical devices only.


## [2.3.19] - 2018-03-14

### Fixed
* Fixed device profile for `android_phone` - Generic Android Phone.


## [2.3.18] - 2018-03-11

### Changed
* Updated `SelectList.define_list_elements` method to accept value for `:list_trigger` element.
* Updated `SelectList.choose_option` to respect `:list_item` value and to click on `:list_trigger` element, if one is specified.
* Updated `PageSection` and `PageObject` UI element object declaration methods to no longer use `class_eval` pattern.
* Updated device profiles for iPhone 7 (iOS 10) with Chrome browser and iPad (iOS 10) with Chrome browser.

### Fixed
* Fixed `SelectList.choose_option` to also accept `:text`, `:value`, and `:index` option hashes across all types of select list objects.


## [2.3.17] - 2018-03-08

### Added
* Added `List.wait_until_item_count_is` and `List.wait_until_item_count_changes` methods.

### Changed
* `UIElement.wait_until_value_is` and `List.wait_until_item_count_is` methods now accept comparison hash.


## [2.3.16] - 2018-03-04

### Added
* Added `PageSection.double_click`, `PageObject.right_click`, and `PageObject.send_keys` methods.


## [2.3.15] - 2018-03-02

### Added
* Added `PageObject.wait_until_exists` and `PageObject.wait_until_gone` methods.

### Fixed
* Fixed bug in `UIElement.get_object_type` method that could result in a `NoMethodError obj not defined` error.
* Fixed bug in `PageObject.verify_ui_states` and `PageSection.verify_ui_states` methods that failed to enqueue errors when UI elements could not be found.


## [2.3.14] - 2018-02-28

### Changed
* Updated device profiles for iPhone 7 (iOS 10) with MS Edge browser.


## [2.3.13] - 2018-02-09

### Added
* Added `AppiumServer.start`, `AppiumServer.running?`, and `AppiumServer.stop` methods for starting and stopping the Appium Server prior to executing tests on
iOS physical devices or simulators, or Android virtual device emulators.


## [2.3.12] - 2018-02-07

### Added
* Added `Environ.is_simulator?` and `Environ.is_web?` methods.


## [2.3.11] - 2018-02-02

### Added
* Added support for running tests in Mobile Safari browser on physical iOS devices.

### Changed
* Updated device profiles for iPhone 7 (iOS 10) with Mobile Firefox browser and iPad (iOS 10) with Mobile Firefox browser.


## [2.3.10] - 2018-01-31

### Added
* Added support for running tests in mobile Chrome or Android browsers on Android Studio virtual device emulators.
* Added `displayed?`, `get_all_items_count`, and `get_all_list_items` methods to `PageSection` class.
* Added `get_all_items_count`, and `get_all_list_items` methods to `List` class.


## [2.3.9] - 2018-01-27

### Changed
* Updated `PageObject.populate_data_fields` and `PageSection.populate_data_fields` methods to accept optional `wait_time` parameter.
* Updated device profiles for iPhone 7 (iOS 10) with MS Edge browser, iPhone 7 (iOS 10) with Chrome browser, and iPhone 7 (iOS 10) with Firefox browser.
* Updated device profiles for iPad (iOS 10) with Chrome browser and iPad (iOS 10) with Firefox browser.


## [2.3.8] - 2018-01-23

### Fixed
* Fixed locator resolution for **Indexed PageSection Objects**.


## [2.3.7] - 2018-01-18

### Added
* Added `width`, `height`, `x`, `y`, and `displayed?` methods to `UIElement` class.


## [2.3.6] - 2017-12-21

### Added
* Added `TextField.clear` method for deleting the contents of text fields. This method should trigger the `onchange` event for the associated text field.

### Changed
* `TextField.clear` method now works with most `number` type fields.


## [2.3.5] - 2017-12-19

### Changed
* Updated `PageObject.populate_data_fields` and `PageSection.populate_data_fields` methods to be compatible with Redactor editor fields.
* Updated device profiles for iPhone 7 (iOS 10) with MS Edge browser, iPhone 7 (iOS 10) with Chrome browser, and iPhone 7 (iOS 10) with Firefox browser.


## [2.3.4] - 2017-12-12

### Fixed
* Fixed bug in `PageObject.populate_data_fields` and `PageSection.populate_data_fields` methods that prevented deletion of data in number type textfields
and textarea controls.


## [2.3.3] - 2017-12-09

### Added
* Added device profile for iPhone 7 (iOS 10) with MS Edge browser.

### Fixed
* Corrected device profiles for iPad (iOS 10) with Mobile Chrome browser and iPad (iOS 10) with Mobile Firefox browser.


## [2.3.1] - 2017-12-07

### Added
* When testing using remotely hosted browsers on the BrowserStack service, the BrowserStack Local instance is automatically started if the `TUNNELING`
Environment Variable is set to `true`. `Environ.tunneling` will be set to true if the BrowserStack Local instance is succesfully started.
* Added `TestCentricity::WebDriverConnect.close_tunnel` method to close BrowserStack Local instance when Local testing is enabled. Refer to the
**Remotely hosted desktop and mobile web browsers** section for information on usage.


## [2.2.1] - 2017-11-29

### Changed
* `SelectList.choose_option` method now accepts index values for Chosen list objects.


## [2.2.0] - 2017-11-29

### Changed
* CSS selectors or XPath expressions may be used as locators for all types of **UI Elements**, including tables.


## [2.1.10] - 2017-11-14

### Added
* Added device profiles for iPhone 7 (iOS 10) with Mobile Firefox browser and iPad (iOS 10) with Mobile Firefox browser.


## [2.1.9] - 2017-11-13

### Fixed
* Fixed bug in `SelectList.choose_option`, `SelectList.get_options`, `SelectList.get_option_count`, and `SelectList.get_selected_option` methods which
did not recognize grouped option in Chosen list objects.


## [2.1.8] - 2017-11-09

### Added
* Added `PageSection.verify_list_items` method for **Indexed PageSection Objects**.


## [2.1.7] - 2017-11-07

### Changed
* Updated `PageObject.populate_data_fields` and `PageSection.populate_data_fields` methods to use backspace characters to delete contents of a textfield
instead of using `clear`, which was preventing `onchange` JavaScript events from being triggered in some browsers.


## [2.1.6] - 2017-10-31

### Fixed
* Fixed bug in `TestCentricity::WebDriverConnect.set_webdriver_path` method that was failing to set the path to the appropriate **chromedriver** file for OS X
and Windows.


## [2.1.5] - 2017-10-28

### Added
* Added `get_min`, `get_max`, and `get_step` methods to `TextField` class.
* Updated `PageObject.verify_ui_states` and `PageSection.verify_ui_states` methods to support verification of `min`, `max`, and `step` attributes
for textfields.

### Fixed
* Fixed Chrome and Firefox support for setting browser language via the `LOCALE` Environment Variable. This capability now works for emulated mobile
browsers hosted in a local instance of Chrome or Firefox.


## [2.1.4] - 2017-10-24

### Added
* Added suppression of the Info Bar that displays "Chrome is being controlled by automated test software" on locally hosted instances of the Chrome browser.


## [2.1.3] - 2017-10-17

### Added
* Added support for "tiling" or cascading multiple browser windows when the `BROWSER_TILE` and `PARALLEL` Environment Variables are set to true. For each
concurrent parallel thread being executed, the position of each browser will be offset by 100 pixels right and 100 pixels down. For parallel test execution,
use the [parallel_tests gem](https://rubygems.org/gems/parallel_tests) to decrease overall test execution time.


## [2.1.2] - 2017-10-01

### Added
* Added device profiles for Microsoft Lumia 950, Blackberry Leap, Blackberry Passport, and Kindle Fire HD 10
* Added ability to set browser language support via the `LOCALE` Environment Variable for local instances of Chrome browsers


## [2.1.0] - 2017-09-23

### Added
* Added device profiles for iPhone 8, iPhone 8 Plus, iPhone X devices running iOS 11
* Added device profile for iPad Pro 10.5" with iOS 11

### Changed
* Updated iPhone 7 and iPhone 7 Plus profiles to iOS 10
* Updated Google Pixel and Google Pixel XL profiles to Android 8
* Added device profiles for iPhone 7 (iOS 10) with Mobile Chrome browser and iPad (iOS 10) with Mobile Chrome browser
* The `TestCentricity::WebDriverConnect.initialize_web_driver` method now sets the `Environ` object to the correct device connection states for local and
cloud hosted browsers.

### Fixed
* The `TestCentricity::WebDriverConnect.initialize_web_driver` method no longer calls `initialize_browser_size` when running tests against cloud hosted
mobile web browser, which was resulting in Appium throwing exceptions for unsupported method calls.
* The `TestCentricity::WebDriverConnect.set_webdriver_path` method now correctly sets the path for Chrome webDrivers when the `HOST_BROWSER` Environment
Variable is set to `chrome`. Tests against locally hosted emulated mobile web browser running on a local instance of Chrome will now work correctly.

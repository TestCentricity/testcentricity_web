# CHANGELOG
All notable changes to this project will be documented in this file.


## [4.6.4] - 22-MAY-2025

### Changed

* Updated `selenium-webdriver` gem to version 4.32.0.


## [4.6.3] - 23-APR-2025

### Changed

* Updated `selenium-webdriver` gem to version 4.31.0.


## [4.6.2] - 28-MAR-2025

### Changed

* Updated `appium_lib` gem to version 16.1.0.
* Updated `appium_lib_core` gem to version 11.0.1.
* Updated `selenium-webdriver` gem to version 4.30.1.


## [4.6.1] - 18-MAR-2025

### Changed

* Updated `appium_lib` gem to version 16.0.1.
* Updated `appium_lib_core` gem to version 10.0.0.
* Updated `selenium-webdriver` gem to version 4.29.1.


## [4.6.0] - 25-JAN-2025

### Changed

* Updated `selenium-webdriver` gem to version 4.28.0.
* Updated `appium_lib` gem to version 15.3.0.
* Updated `appium_lib_core` gem to version 9.5.0.
* Ruby version 3.1.0 or greater is now required.


## [4.5.15] - 01-NOV-2024

### Changed

* Updated `selenium-webdriver` gem to version 4.26.0.
* Updated `rexml` gem to latest version to address ReDoS vulnerability.


## [4.5.14] - 09-OCT-2024

### Fixed

* Disable Chrome search engine choice screen.


## [4.5.13] - 24-SEP-2024

### Changed

* Updated `selenium-webdriver` gem to version 4.25.0.


## [4.5.12] - 30-AUG-2024

### Changed

* Updated `selenium-webdriver` gem to version 4.24.0.


## [4.5.11] - 08-AUG-2024

### Changed

* Updated `appium_lib` gem to version 15.2.2.


## [4.5.10] - 05-AUG-2024

### Changed

* Updated `selenium-webdriver` gem to version 4.23.0.
* Updated `appium_lib` gem to version 15.2.1.
* Updated `appium_lib_core` gem to version 9.2.1.


## [4.5.9.1] - 26-JUNE-2024

### Fixed

* Added `cuke_modeler` gem as a development dependency so that Cucumber test results logging would not fail when running
tests in parallel with Ruby version 3.1.0 or greater.


## [4.5.9] - 23-JUNE-2024

### Changed

* Updated `selenium-webdriver` gem to version 4.22.0.


## [4.5.8] - 21-MAY-2024

### Changed

* Setting `DOWNLOADS` Environment Variable to `true` will create a `/downloads` folder which will be used as the destination
for files that are downloaded by your automated tests. You know longer need to manually create the `/downloads` folder.
* Updated `appium_lib` gem to version 15.1.0.
* Updated `appium_lib_core` gem to version 9.1.1.
* Updated `selenium-webdriver` gem to version 4.21.1.


## [4.5.7] - 25-APR-2024

### Changed

* Updated `selenium-webdriver` gem to version 4.20.0.
* Updated `appium_lib` gem to version 15.0.0.
* Updated `appium_lib_core` gem to version 8.0.1.


## [4.5.6] - 02-APR-2024

### Fixed

* `WebDriverConnect.initialize_web_driver`, `AppiumServer.start`, and `AppiumServer.running?` methods now support Appium
version 2.x. Backward compatibility with Appium version 1.x is provided if `APPIUM_SERVER_VERSION` Environment Variable
is set to `1`.


## [4.5.5] - 27-MAR-2024

### Changed

* Updated `selenium-webdriver` gem to version 4.19.0.


## [4.5.4] - 04-MAR-2024

### Changed

* Updated `selenium-webdriver` gem to version 4.18.1.
* Updated `rack` gem to version 3.0.9.1.
* Updated `nokogiri` gem to version 1.16.2.


## [4.5.3] - 27-JAN-2024

### Changed

* Updated `capybara` gem to version 3.40.0.


## [4.5.2] - 26-JAN-2024

### Changed

* Updated `appium_lib` gem to version 14.0.0.
* Updated `selenium-webdriver` gem to version 4.17.0.


## [4.5.1] - 18-JAN-2024

### Fixed
* `WebDriverConnect.driver_exists?` and `activate_driver` methods now convert string passed as a driver name to a symbol
with lower case letters and spaces replaced with underscores, which is how `WebDriverConnect.initialize_web_driver` saves
the driver name.


## [4.5.0] - 16-JAN-2024

### Removed
* Support for test data assets stored in Excel `.xls` has been removed because `.xls` files cannot be properly tracked
and diffed by source control tools like git.
* `ExcelData` and `ExcelDataSource` classes removed.
* Removed dependence on `spreadsheet` gem.


## [4.4.7] - 13-JAN-2024

### Fixed
* `WebDriverConnect.activate_driver` now correctly sets `Environ.driver_name` to name of activated WebDriver instance.
* `WebDriverConnect.close_all_drivers` no longer raises exception if called before any WebDrivers have been instantiated.

### Added
* Added `WebDriverConnect.driver_exists?` method.

## [4.4.6] - 12-JAN-2024

### Fixed
* `WebDriverConnect.num_drivers` no longer raises exception if called before any WebDrivers have been instantiated.


## [4.4.5] - 10-JAN-2024

### Fixed
* `UIElement.find_object` no longer raises `Selenium::WebDriver::Error::StaleElementReferenceError` when testing with
multiple WebDriver instances.
* `DataPresenter.initialize` no longer fails if `data` parameter is `nil`.


## [4.4.4] - 08-JAN-2024

### Fixed
* `List.get_list_item` no longer returns `nil`.


## [4.4.3] - 24-DEC-2023

### Changed
* Changed Sauce Labs `DATA_CENTER` Environment Variable to `SL_DATA_CENTER`.


## [4.4.2] - 23-DEC-2023

### Added
* Added support for specifying and connecting to web browsers on unsupported cloud hosting services using `custom` user-
defined driver and capabilities.


## [4.4.0] - 22-DEC-2023

### Added
* Added support for connecting to, and switching between multiple WebDriver or Appium connected desktop and/or mobile web
browsers by utilizing the following new methods:
  * `WebDriverConnect.activate_driver`
  * `WebDriverConnect.num_drivers`
  * `WebDriverConnect.close_all_drivers`
* Added support for web page scrolling by utilizing the following methods:
  * `Browsers.scroll_to_bottom`
  * `Browsers.scroll_to_top`
  * `Browsers.scroll_to`

### Changed
* `WebDriverConnect.initialize_web_driver` method now accepts an optional `options` hash for specifying desired capabilities
(using W3C protocol), driver, driver name, endpoint URL, device type, and desktop browser window size information.
* The `HOST_BROWSER` Environment Variable is no longer required to support emulated mobile web browsers.
* The `SELENIUM` Environment Variable is no longer used to instantiate a WebDriver connection to a Selenium 4 Grid instance.
 To establish a connection to browser instances on a Selenium 4 Grid, set the `DRIVER` Environment Variable to `grid`.
* TestCentricity now supports and integrates with Selenium-Webdriver version 4.14 and Capybara version 3.39.
* Updated profiles for emulated mobile device browsers.
* Removed dependency on `appium_capybara` and `webdrivers` gems.
* Ruby version 3.0.0 or greater is now required.
* Locally hosted Internet Explorer web browsers are no longer supported.


## [4.3.1] - 19-AUG-2022

### Added
* Added support for connecting to remote mobile browsers on iOS simulators and Android emulators on the TestingBot service.


## [4.3.0] - 01-AUG-2022

### Added
* The `DRIVER` Environment Variable is now used to specify the `appium`, `browserstack`, `saucelabs`, `testingbot`,
  or `lambdatest` driver.

* ### Changed
* The `WEB_BROWSER` Environment Variable is no longer used to specify the `appium`, `browserstack`, `saucelabs`, `testingbot`,
or `lambdatest` driver.
* TestCentricity now supports and integrates with Selenium-Webdriver version 4.3.


## [4.2.6] - 12-JUNE-2022

### Fixed
* Fix `gemspec` to no longer include specs and Cucumber tests as part of deployment package for gem.


## [4.2.5] - 10-JUNE-2022

### Fixed
*`WebDriverConnect.initialize_web_driver` method no longer raises `No such file or directory @ dir_s_mkdir` error due to
missing `Downloads` folder when running tests in parallel.


## [4.2.4] - 02-JUNE-2022

### Added
* Added `UIElement.wait_until_enabled` method


## [4.2.3] - 01-JUNE-2022

### Added
* Added `UIElement.wait_while_busy` method
* Updated `PageObject.verify_ui_states` and `PageSection.verify_ui_states` methods to support verification of `aria_busy`
attribute.


## [4.2.2] - 21-MAY-2022

### Changed
* Update default version of Appium used when running tests on Sauce Labs service.
* Refactored capabilities definition when running with locally hosted Appium instance.


## [4.2.1] - 23-APR-2022

### Added
* Added the following `Audio`, `Media`, and `Video` methods to support verification of media text tracks (subtitles, captions,
chapters, descriptions, or metadata):
  * `track_count`
  * `active_track`
  * `active_track_data`
  * `all_tracks_data`
  * `track_data`
  * `active_track_source`
  * `track_source`
* Updated `PageObject.verify_ui_states` and `PageSection.verify_ui_states` methods to support verification of the following
  `Media` properties:
  * `:track_count`
  * `:active_track`
  * `:active_track_data`
  * `:all_tracks_data`
  * `:track_data`
  * `:active_track_source`
  * `:track_source`


## [4.2.0] - 20-APR-2022

### Added
* `TextField.validation_message` and `TextField.validity?` methods added.
* Updated `PageObject.verify_ui_states` and `PageSection.verify_ui_states` methods to support verification of the following
`TextField.validity?` properties:
  * `:badInput`
  * `:customError`
  * `:patternMismatch`
  * `:rangeOverflow`
  * `:rangeUnderflow`
  * `:stepMismatch`
  * `:tooLong`
  * `:tooShort`
  * `:typeMismatch`
  * `:valid`
  * `:valueMissing`


## [4.1.10] - 19-APR-2022

### Fixed
* `PageObject.set_verify_focus` and `PageSection.set_verify_focus` methods now correctly return the `id` of the UI element
that unexpectedly has focus during an exception.
* Rolled back `require_all` gem version to 1.5.0 in gemspec development dependencies due to `RequireAll::LoadError` when
running gem test specs and features.


## [4.1.9] - 18-APR-2022

### Fixed
* `PageSection.radio` no longer returns `wrong number of arguments` error.
* `PageObject.populate_data_fields` and `PageSection.populate_data_fields` methods no longer skip setting checkboxes or
radio buttons to the unchecked state.

### Added
* `CheckBox.define_custom_elements` and `Radio.define_custom_elements` methods now support specifying a child `input`
component contained by a top level `label` element.


## [4.1.8] - 31-MAR-2022

### Fixed
* `Image.loaded?` now correctly returns a `Boolean` value instead of a `String`.
* `Video.video_height` and `Video.video_width` now correctly returns an `Integer` value instead of a `String`.
* `UIElement.scroll_to` now works for all supported browsers.

### Changed
* `UIElement.crossorigin` is no longer limited to `Audio` and `Video` objects.


## [4.1.7] - 28-MAR-2022

### Fixed
* `CheckBox.set_checkbox_state` and `Radio.set_selected_state` work on iOS simulators again.

### Changed
* `Audio.playback_rate` and `Video.playback_rate` now return value as a `Float` instead of a `String`.
* `Audio.default_playback_rate` and `Video.default_playback_rate` now return value as a `Float` instead of a `String`.
* `Audio.current_time` and `Video.current_time` now return value as a `Float` rounded to two decimal places.
* `Audio.duration` and `Video.duration` now return value as a `Float` rounded to two decimal places.

### Added
* `Audio.mute` and `Video.mute` methods added.
* `Audio.unmute` and `Video.unmute` methods added.
* `Audio.playback_rate` and `Video.playback_rate` now accept a `Float` value as an input for setting the playback rate
  of media.
* `Audio.volume` and `Video.volume` now accept a `Float` value between 0 and 1 as an input for setting the volume of media.


## [4.1.6] - 21-MAR-2022

### Fixed
* `PageObject.verify_page_exists` now works with `page_locator` traits expressed in Xpath format, and no longer fails with a
`invalid selector: An invalid or illegal selector was specified - Selenium::WebDriver::Error::InvalidSelectorError` error.

### Added
* `UIElement.required?` method added.
* `PageObject.populate_data_fields` and `PageSection.populate_data_fields` methods now work with the following:
  * `input(type='color')` color picker controls if they are specified as a `textfield` type element.
  * `input(type='range')` slider controls if they are specified as a `range` type element.
  * `input(type='file')` file upload controls if they are specified as a `filefield` type element.


## [4.1.5] - 15-MAR-2022

### Fixed
* `SelectList.selected?` now correctly returns selected value for custom `selectlist` controls.

### Updated
* Updated HTML documentation.


## [4.1.4] - 09-MAR-2022

### Fixed
* `Environ.driver` is now correctly set to `:appium` when target test browser is running on iOS or Android simulators or
physical devices.


## [4.1.3] - 08-MAR-2022

### Fixed
* Fixed `AppiumServer.start` so that it no longer times out after failing to start Appium.

### Updated
* Updated docs regarding the `SHUTDOWN_OTHER_SIMS` Environment Variable when testing on iOS Simulators.


## [4.1.2] - 07-MAR-2022

### Updated
* Updated HTML documentation.


## [4.1.1] - 03-MAR-2022

### Changed
* W3C WebDriver-compliant sessions using Selenium version 4.x are now supported when using the BrowserStack, LambdaTest,
TestingBot, and SauceLabs services.
* W3C WebDriver-compliant sessions are now supported when running against remote browsers hosted on Selenium Grid 4 and
Dockerized Selenium Grid 4 environments.


## [4.1.0] - 28-FEB-2022

### Removed
* Support for CrossBrowserTesting and Gridlastic cloud hosted Selenium grids have been removed due to their lack of support
for Selenium 4.x and the W3C browser capabilities protocol.

### Added
* TestCentricity now supports and integrates with Selenium-Webdriver version 4.1.
* Added support for locally hosted Microsoft Edge desktop web browsers, including in `headless` mode.
* Added `CheckBox.define_custom_elements` and `Radio.define_custom_elements` methods to support abstracted UI implementations
  where the `input type="checkbox"` or `input type="radio"` object is hidden or obscured by a proxy object, typically a `label`.
* Added support for `shutdownOtherSimulators` and `forceSimulatorSoftwareKeyboardPresence` capabilities for iOS simulators
  when testing with Mobile Safari browser on iOS Simulators.

### Changed
* `checkbox` and `radio` methods no longer accept an optional `proxy`. Calling the `checkbox` or `radio` methods with a `proxy`
  parameter will result in a `wrong number of arguments (given 3, expected 2) (ArgumentError)` exception. Use the `define_custom_elements`
  method to specify the locator for an associated `proxy` and/or `label` element. The `define_custom_elements` method can be
  called from an `initialize` method for the `PageObject` or `PageSection` where the `checkbox` or `radio` is instantiated.
* Ruby version 2.7 or greater required.
* Selenium-Webdriver version 4 or greater required.


## [4.0.3] - 30-DEC-2021

### Changed
* Primary test data path has been changed from `features/test_data/` to `config/test_data/`.

### Fixed
* No longer throws a `NoMethodError: undefined method 'World' for main:Object` error when using RSpec.


## [4.0.0] - 18-APR-2021

### Changed
* `WebDriverConnect.initialize_web_driver` method now accepts an `options` hash as an optional parameter, which can be used to
  specify an optional base host URL and/or the desired Selenium-Webdriver capabilities required to establish a connection with
  a cloud hosted target web browser.
* User defined mobile device profiles can be specified in a `device.yml` file for testing locally hosted emulated mobile
  web browsers running in an instance of the Chrome desktop browser. The user specified device profiles must be located at 
  `config/data/devices/devices.yml`. Refer to the **User defined mobile device profiles** section of the {file:README.md README} file.

### Removed
* Removed support for the following legacy UI elements:
  * `CellElement`
  * `CellButton`
  * `CellCheckBox`
  * `CellRadio`
  * `CellImage`
  * `ListElement`
  * `ListButton`
  * `ListCheckBox`
* Removed support for Siebel Open UI objects. This includes removal of the following legacy methods:
  * `CheckBox.set_siebel_checkbox_state`
  * `SelectList.choose_siebel_option`
  * `SelectList.get_siebel_options`
  * `SelectList.verify_siebel_options`
  * `SelectList.read_only?`
  * `UIElement.invoke_siebel_dialog`
  * `UIElement.invoke_siebel_popup`
  * `UIElement.get_siebel_object_type`


## [3.3.0] - 14-MAR-2021

### Fixed
* `WebDriverConnect.initialize_web_driver` method now correctly sets local Chrome browser Download directory when running
with headless Chrome.


## [3.2.25] - 11-MAR-2021

### Added
* Added `String.titlecase` method.


## [3.2.23] - 11-FEB-2021

### Changed
* Updated `PageObject.verify_ui_states` and `PageSection.verify_ui_states` methods to allow `:translate_upcase`,
  `:translate_downcase`, `:translate_capitalize`, and `:translate_titlecase` conversions to fall back to `:en` default
  locale if translated strings are missing from the current locale specified in `I18n.locale`.


## [3.2.22] - 09-FEB-2021

### Fixed
* Updated `PageObject.verify_ui_states` and `PageSection.verify_ui_states` methods to correctly handle `:translate_upcase`,
  `:translate_downcase`, `:translate_capitalize`, and `:translate_titlecase` conversions for Arrays of `String`.
  

## [3.2.21] - 04-FEB-2021

### Changed
* `UIElement.hover_at` method now accepts an optional `visible` parameter to allow hovering over UI elements that are not
  visible.


## [3.2.20] - 21-JAN-2021

### Changed
* `UIElement.hover` method now accepts an optional `visible` parameter to allow hovering over UI elements that are not
visible.


## [3.2.19] - 05-JAN-2021

### Fixed
* `SelectList.choose_option` and `SelectList.get_options` methods now wait up to 5 seconds for list drop menu to appear.


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

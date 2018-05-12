
###Version 3.0.4

* Refactored `SelectList` methods to work with Capybara version 3.x.

###Version 3.0.3

* Pinning to Capybara version 2.18.0 because Capybara 3.x breaks several `SelectList` methods.

###Version 3.0.2

* `PageManager.find_page` method now raises an exception if the requested page object has not been defined and instantiated.

###Version 3.0.1

* Updated device profiles for iPhone 7 (iOS 11) with Mobile Firefox browser and iPad (iOS 10) with Mobile Firefox browser.
* Updated device profiles for iPhone 7 (iOS 11) with Mobile Edge browser and iPad (iOS 10) with Mobile Edge browser.
* Updated device profiles for iPhone 7 (iOS 11) with Mobile Chrome browser and iPad (iOS 10) with Mobile Chrome browser.

###Version 3.0.0

* The TestCentricity™ Web gem now works with Selenium-WebDriver version 3.11 and **geckodriver** version 0.20.1 (or later) to support testing of the latest versions
of Firefox web browsers.
* Support for testing on locally hosted "headless" Chrome or Firefox browsers has been added.
* Support for headless browser testing using Poltergeist and PhantomJS has been removed.
* Support for Legacy FirefoxDriver (used in Firefox versions < 48) has been added.
* `TestCentricity::WebDriverConnect.set_webdriver_path` method now sets the path to the appropriate **geckodriver** file for OS X or Windows when testing on
locally hosted Firefox browsers.

###Version 2.4.3

* Updated device profiles for iPhone 7 (iOS 11) with Mobile Firefox browser and iPad (iOS 10) with Mobile Firefox browser.

###Version 2.4.1

* Added device profiles for iPad (iOS 10) with MS Edge browser.

###Version 2.4.0

* Updated `TestCentricity::WebDriverConnect.initialize_web_driver` method to read the `APP_FULL_RESET`, `APP_NO_RESET`, and `NEW_COMMAND_TIMEOUT` Environment
Variables and set the corresponding `fullReset`, `noReset`, and `newCommandTimeout` Appium capabilities for iOS and Android physical devices and simulators.
Also reads the `WDA_LOCAL_PORT` Environment Variable and sets the `wdaLocalPort` Appium capability for iOS physical devices only.

###Version 2.3.19

* Fixed device profile for `android_phone` - Generic Android Phone.

###Version 2.3.18

* Updated `SelectList.define_list_elements` method to accept value for `:list_trigger` element.
* Updated `SelectList.choose_option` to respect `:list_item` value and to click on `:list_trigger` element, if one is specified.
* Updated `PageSection` and `PageObject` UI element object declaration methods to no longer use `class_eval` pattern.
* Updated device profiles for iPhone 7 (iOS 10) with Chrome browser and iPad (iOS 10) with Chrome browser.
* Fixed `SelectList.choose_option` to also accept `:text`, `:value`, and `:index` option hashes across all types of select list objects.

###Version 2.3.17

* Added `List.wait_until_item_count_is` and `List.wait_until_item_count_changes` methods.
* `UIElement.wait_until_value_is` and `List.wait_until_item_count_is` methods now accept comparison hash.

###Version 2.3.16

* Added `PageSection.double_click`, `PageObject.right_click`, and `PageObject.send_keys` methods.

###Version 2.3.15

* Added `PageObject.wait_until_exists` and `PageObject.wait_until_gone` methods.
* Fixed bug in `UIElement.get_object_type` method that could result in a `NoMethodError obj not defined` error.
* Fixed bug in `PageObject.verify_ui_states` and `PageSection.verify_ui_states` methods that failed to enqueue errors when UI elements could not be found.

###Version 2.3.14

* Updated device profiles for iPhone 7 (iOS 10) with MS Edge browser.

###Version 2.3.13

* Added `AppiumServer.start`, `AppiumServer.running?`, and `AppiumServer.stop` methods for starting and stopping the Appium Server prior to executing tests on
iOS physical devices or simulators, or Android virtual device emulators.

###Version 2.3.12

* Added `Environ.is_simulator?` and `Environ.is_web?` methods.

###Version 2.3.11

* Added support for running tests in Mobile Safari browser on physical iOS devices.
* Updated device profiles for iPhone 7 (iOS 10) with Mobile Firefox browser and iPad (iOS 10) with Mobile Firefox browser.

###Version 2.3.10

* Added support for running tests in mobile Chrome or Android browsers on Android Studio virtual device emulators.
* Added `displayed?`, `get_all_items_count`, and `get_all_list_items` methods to `PageSection` class.
* Added `get_all_items_count`, and `get_all_list_items` methods to `List` class.

###Version 2.3.9

* Updated `PageObject.populate_data_fields` and `PageSection.populate_data_fields` methods to accept optional `wait_time` parameter.
* Updated device profiles for iPhone 7 (iOS 10) with MS Edge browser, iPhone 7 (iOS 10) with Chrome browser, and iPhone 7 (iOS 10) with Firefox browser.
* Updated device profiles for iPad (iOS 10) with Chrome browser and iPad (iOS 10) with Firefox browser.

###Version 2.3.8

* Fixed locator resolution for **Indexed PageSection Objects**.

###Version 2.3.7

* Added `width`, `height`, `x`, `y`, and `displayed?` methods to `UIElement` class.

###Version 2.3.6

* Added `TextField.clear` method for deleting the contents of text fields. This method should trigger the `onchange` event for the associated text field.
* `TextField.clear` method now works with most `number` type fields.

###Version 2.3.5

* Updated `PageObject.populate_data_fields` and `PageSection.populate_data_fields` methods to be compatible with Redactor editor fields.
* Updated device profiles for iPhone 7 (iOS 10) with MS Edge browser, iPhone 7 (iOS 10) with Chrome browser, and iPhone 7 (iOS 10) with Firefox browser.

###Version 2.3.4

* Fixed bug in `PageObject.populate_data_fields` and `PageSection.populate_data_fields` methods that prevented deletion of data in number type textfields
and textarea controls.

###Version 2.3.3

* Added device profile for iPhone 7 (iOS 10) with MS Edge browser.
* Corrected device profiles for iPad (iOS 10) with Mobile Chrome browser and iPad (iOS 10) with Mobile Firefox browser.

###Version 2.3.1

* When testing using remotely hosted browsers on the BrowserStack service, the BrowserStack Local instance is automatically started if the `TUNNELING`
Environment Variable is set to `true`. `Environ.tunneling` will be set to true if the BrowserStack Local instance is succesfully started.
* Added `TestCentricity::WebDriverConnect.close_tunnel` method to close BrowserStack Local instance when Local testing is enabled. Refer to the
**Remotely hosted desktop and mobile web browsers** section for information on usage.

###Version 2.2.1

* `SelectList.choose_option` method now accepts index values for Chosen list objects.

###Version 2.2.0

* CSS selectors or XPath expressions may be used as locators for all types of **UI Elements**, including tables.

###Version 2.1.10

* Added device profiles for iPhone 7 (iOS 10) with Mobile Firefox browser and iPad (iOS 10) with Mobile Firefox browser.

###Version 2.1.9

* Fixed bug in `SelectList.choose_option`, `SelectList.get_options`, `SelectList.get_option_count`, and `SelectList.get_selected_option` methods which
did not recognize grouped option in Chosen list objects.

###Version 2.1.8

* Added `PageSection.verify_list_items` method for **Indexed PageSection Objects**.

###Version 2.1.7

* Updated `PageObject.populate_data_fields` and `PageSection.populate_data_fields` methods to use backspace characters to delete contents of a textfield
instead of using `clear`, which was preventing `onchange` JavaScript events from being triggered in some browsers.

###Version 2.1.6

* Fixed bug in `TestCentricity::WebDriverConnect.set_webdriver_path` method that was failing to set the path to the appropriate **chromedriver** file for OS X
and Windows.

###Version 2.1.5

* Added `get_min`, `get_max`, and `get_step` methods to `TextField` class.
* Updated `PageObject.verify_ui_states` and `PageSection.verify_ui_states` methods to support verification of `min`, `max`, and `step` attributes
for textfields.
* Fixed Chrome and Firefox support for setting browser language via the `LOCALE` Environment Variable. This capability now works for emulated mobile
browsers hosted in a local instance of Chrome or Firefox.

###Version 2.1.4

* Added suppression of the Info Bar that displays "Chrome is being controlled by automated test software" on locally hosted instances of the Chrome browser.


###Version 2.1.3

* Added support for "tiling" or cascading multiple browser windows when the `BROWSER_TILE` and `PARALLEL` Environment Variables are set to true. For each
concurrent parallel thread being executed, the position of each browser will be offset by 100 pixels right and 100 pixels down. For parallel test execution,
use the [parallel_tests gem](https://rubygems.org/gems/parallel_tests) to decrease overall test execution time.

###Version 2.1.2

* Added device profiles for Microsoft Lumia 950, Blackberry Leap, Blackberry Passport, and Kindle Fire HD 10
* Added ability to set browser language support via the `LOCALE` Environment Variable for local instances of Chrome browsers

###Version 2.1.0

* Added device profiles for iPhone 8, iPhone 8 Plus, iPhone X devices running iOS 11
* Added device profile for iPad Pro 10.5" with iOS 11
* Updated iPhone 7 and iPhone 7 Plus profiles to iOS 10
* Updated Google Pixel and Google Pixel XL profiles to Android 8
* Added device profiles for iPhone 7 (iOS 10) with Mobile Chrome browser and iPad (iOS 10) with Mobile Chrome browser
* The `TestCentricity::WebDriverConnect.initialize_web_driver` method now sets the `Environ` object to the correct device connection states for local and
cloud hosted browsers.
* The `TestCentricity::WebDriverConnect.initialize_web_driver` method no longer calls `initialize_browser_size` when running tests against cloud hosted
mobile web browser, which was resulting in Appium throwing exceptions for unsupported method calls.
* The `TestCentricity::WebDriverConnect.set_webdriver_path` method now correctly sets the path for Chrome webDrivers when the `HOST_BROWSER` Environment
Variable is set to `chrome`. Tests against locally hosted emulated mobile web browser running on a local instance of Chrome will now work correctly.

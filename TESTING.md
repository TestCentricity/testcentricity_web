# How TestCentricity™ For Web Is Tested

The TestCentricity™ For Web core framework gem is tested prior to every release using a combination of test specs (RSpec)
and Cucumber feature tests. Test specs and Cucumber features are executed on a combination of Apple MacOS Ventura running
on Macs with Intel CPUs (x86 architecture) and MacOS Sequoia running on Macs with Apple Silicon CPUs (arm64 architecture).

The `Rakefile` in this repository defines the individual test spec and Cucumber feature tasks, as well as tasks for running
combinations of specs and cukes for required, mobile, grid, and release categories.

## Test Specs

Test specs are used to verify connectivity to the following target web browsers:
* locally hosted desktop browsers (Chrome, Edge, Firefox, and Safari)
* locally hosted "headless" Chrome, Firefox, and Edge browsers
* remote Chrome, Firefox, and Edge desktop browsers and emulated mobile web browsers hosted on a Dockerized Selenium 4 environments
* mobile Safari browsers on iOS device simulators (using Appium 2.x and XCode)
* mobile Chrome browsers on Android Studio virtual device emulators (using Appium 2.x and Android Studio)
* cloud hosted desktop browsers (Firefox, Chrome, Safari, IE, and Edge) and mobile browsers (iOS Mobile Safari or Android Chrome) using the following service:
    * Browserstack
    * Sauce Labs
    * TestingBot
    * LambdaTest

## Cucumber Features

Cucumber feature tests are used to verify the gem's Page Object Model implementation using a locally and grid hosted test
web site with most of the supported standard UI element types and custom UI based on multiple composite UI components. The
test web site source code is contained in the `test_site/` folder of this repository.

Cucumber feature tests are executed against the following target web browsers:
* locally hosted desktop browsers (Chrome, Edge, Firefox, and Safari)
* locally hosted "headless" Chrome, Firefox, and Edge browsers
* remote Chrome, Firefox, and Edge desktop browsers and emulated mobile web browsers hosted on a Dockerized Selenium 4 environments
* mobile Safari browsers on iOS device simulators (using Appium 2.x and XCode)
* mobile Chrome browsers on Android Studio virtual device emulators (using Appium 2.x and Android Studio)

Cucumber feature tests executed against locally hosted Chrome and Edge browsers are run in 6 concurrent test threads using
the `parallel_tests` gem, while tests run in the Docker Selenium environment are run in 4 concurrent test threads.
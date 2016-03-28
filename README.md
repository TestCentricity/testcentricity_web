# TestCentricityWeb

The TestCentricity™ core generic framework for desktop and mobile web site testing implements a Page Object and Data Object Model DSL for
use with Cucumber, Capybara, and selenium-webdriver.

The TestCentricity™ web gem supports running testing against the following web test targets:
  * locally hosted desktop browsers (Firefox, Chrome, Safari, IE, or Edge)
  * locally hosted emulated iOS and Android mobile browsers (using Firefox)
  * a "headless" browser (using Poltergeist and PhantomJS)
  * cloud hosted desktop or mobile web browsers using the BrowserStack, Sauce Labs, CrossBrowserTesting, or TestingBot services.


## Web Test Automation Framework Implementation

 <img src="http://i.imgur.com/K4XGTQi.jpg" width="1024" alt="Web Framework Overview" title="Web Framework Overview">


## Installation

Add this line to your automation project's Gemfile:

    gem 'testcentricity_web'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install testcentricity_web


## Setup
###Using Cucumber

If you are using Cucumber, you need to require the following in your *env.rb* file:

    require 'capybara'
    require 'capybara/cucumber'
    require 'selenium-webdriver'
    require 'testcentricity_web'
    
    
###Using RSpec

If you are using RSpec instead, you need to require the following in your *env.rb* file:

    require 'capybara'
    require 'capybara/rspec'
    require 'selenium-webdriver'
    require 'testcentricity_web'
    
    
### Using Poltergeist

If you will be running your tests on a "headless" web browser using Poltergeist and PhantomJS, you must add this line to your automation
project's Gemfile:

    gem 'poltergeist'



## Page Objects

The **Page Object Model** is a test automation pattern that aims to create an abstraction of your web app's User Interface that can be used
in tests. A **Page Object** is an object that represents a single page in your AUT (Application Under Test). **Page Objects** encapsulate the
implementation details of a web page and expose an API that supports interaction with, and validation of UI elements on the page.

**Page Objects** makes it easier to maintain automated tests, because changes to page UI elements are only changed in one location - in the
**Page Object** class definition. By adopting a **Page Object Model**, Cucumber Feature files and step definitions are no longer required to
hold specific information about a page's UI objects, thus minimizing maintenance requirements. If any element on a page changes (URL path,
text field attributes, button captions, etc.), maintenance is performed in the **Page Object** class definition only, typically with no need
to update the affected feature file, scenarios, or step definitions.


### Defining a Page Object

Your **Page Object** class definitions should be contained within individual *.rb* files in the ***features/support/pages*** folder of your
test automation project. You define new **Page Objects** as shown below:

    class LoginPage < TestCentricity::PageObject
      trait(:page_name)       { 'Login' }
      trait(:page_url)        { "/sign_in" }
      trait(:page_locator)    { "//body[@class='login-body']" }
    end


    class HomePage < TestCentricity::PageObject
      trait(:page_name)       { 'Home' }
      trait(:page_url)        { "/dashboard" }
      trait(:page_locator)    { "//body[@class='dashboard']" }
    end


### Adding UI Elements to your Page Object

**UI Elements** are added to your **Page Object** class definition as shown below:

    class LoginPage < TestCentricity::PageObject
      trait(:page_name)       { 'Login' }
      trait(:page_url)        { "/sign_in" }
      trait(:page_locator)    { "//body[@class='login-body']" }
    
      # Login page UI elements
      textfield :user_id_field,        "userName"
      textfield :password_field,       "password"
      button    :login_button,         "//input[@id='submit_button']"
      checkbox  :remember_checkbox,    "rememberUser']"
      label     :error_message_label,  'div#statusBar.login-error'
    end
    
Once your **Page Objects** have been instantiated, you can interact with the **UI Elements** in your **Page Objects**. An example is shown
below:

    login_page.user_id_field.set('snicklefritz')
    login_page.password_field.set('Pa55w0rd')
    login_page.login_button.click


### Adding Methods to your Page Object

It is good practice for your Cucumber step definitions to call high level methods in your your **Page Object** instead of directly accessing
and interacting with a page object's UI elements. You can add high level methods to your **Page Object** class definition for interacting with
the UI to hide implementation details, as shown below:

    class LoginPage < TestCentricity::PageObject
      trait(:page_name)       { 'Login' }
      trait(:page_url)        { "/sign_in" }
      trait(:page_locator)    { "//body[@class='login-body']" }
    
      # Login page UI elements
      textfield :user_id_field,        "userName"
      textfield :password_field,       "password"
      button    :login_button,         "//input[@id='submit_button']"
      checkbox  :remember_checkbox,    "rememberUser']"
      label     :error_message_label,  'div#statusBar.login-error'
    
      def login(user_id, password)
        user_id_field.set(user_id)
        password_field.set(password)
        login_button.click
      end

      def remember_me(state)
        remember_checkbox.set_checkbox_state(state)
      end
    end


Once your **Page Objects** have been instantiated, you can call your methods as shown below:

    login_page.remember_me(true)
    login_page.user_id_field.set('snicklefritz', 'Pa55w0rd')
    


## PageSection Objects

A **PageSection Object** is a collection of **UI Elements** that may appear in multiple locations on a page, or on multiple pages in a web
app. It is a collection of **UI Elements** that represent a conceptual area of functionality, like a navigation bar, a search capability,
or a menu. **UI Elements** and functional behavior are confined to the scope of a **PageSection Object**.

A **PageSection Object** may contain other **PageSection Objects**.


### Defining a PageSection Object

Your **PageSection** class definitions should be contained within individual *.rb* files in the ***features/support/sections*** folder of
your test automation project. You define new **PageSection Objects** as shown below:

    class SearchForm < TestCentricity::PageSection
      trait(:section_locator)    { "//form[@id='gnav-search']" }
    end


### Adding UI Elements to your PageSection Object

**UI Elements** are added to your **PageSection** class definition as shown below:

    class SearchForm < TestCentricity::PageSection
      trait(:section_locator)    { "//form[@id='gnav-search']" }
        
      # Search Form UI elements
      textfield :search_field,   "//input[@id='search-query']"
      button    :search_button,  "//button[@type='submit']"
    end


### Adding Methods to your PageSection Object

You can add high level methods to your **PageSection** class definition, as shown below:

    class SearchForm < TestCentricity::PageSection
      trait(:section_locator)    { "//form[@id='gnav-search']" }
        
      # Search Form UI elements
      textfield :search_field,   "//input[@id='search-query']"
      button    :search_button,  "//button[@type='submit']"

      def search_for(value)
        search_field.set(value)
        search_button.click
      end
    end


### Adding PageSection Objects to your Page Object

You add a **PageSection Object** to its associated **Page Object** as shown below:

    class HomePage < TestCentricity::PageObject
      trait(:page_name)       { 'Home' }
      trait(:page_url)        { "/dashboard" }
      trait(:page_locator)    { "//body[@class='dashboard']" }
      
      # Home page Section Objects
      section :search_form, SearchForm
    end

Once your **Page Object** has been instantiated, you can call its **PageSection** methods as shown below:

    home_page.search_form.search_for('ocarina')
    
    

## Instantiating your Page Objects

Before you can call the methods in your **Page Objects** and **PageSection Objects**, you must instantiate the **Page Objects** of your
web application, as well as create instance variables which can be used when calling a **Page Objects** methods from your step definitions.
There are several ways to instantiate your **Page Objects**.

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
    end
        
    World(WorldPages)

The **WorldPages** module above can be defined in your *env.rb* file, or you can define it in a separate *world_pages.rb* file in the
***features/support*** folder.

While this approach is effective for small web applications with only a few pages (and hence few **Page Objects**), it quickly becomes
cumbersome to manage if your web application has dozens of **Page Objects** that need to be instantiated and managed.

### Using the PageManager

The **PageManager** class provides methods for supporting the instantiation and management of **Page Objects**. In the code example below,
the **page_objects** method contains a hash table of your **Page Object** instances and their associated **Page Object** class names
to be instantiated by **PageManager**:
    
    module WorldPages
      def page_objects
        { :login_page                 => LoginPage,
          :home_page                  => HomePage,
          :registration_page          => RegistrationPage,
          :products_grid_page         => ProductsCollectionPage,
          :product_detail_page        => ProductDetailPage,
          :shopping_basket_page       => ShoppingBasketPage,
          :payment_method_page        => PaymentMethodPage,
          :confirm_purchase_page      => PurchaseConfirmationPage,
          :my_account_page            => MyAccountPage,
          :my_order_history_page      => MyOrderHistoryPage,
          :my_ship_to_addresses_page  => MyShipToAddressesPage
        }
      end
    end
    
    World(WorldPages)
    
The **WorldPages** module above should be defined in the *world_pages.rb* file in the ***features/support*** folder.

Include the code below in your *env.rb* file to ensure that your **Page Objects** are instantiated before your Cucumber scenarios are
executed:
    
    include WorldPages
    WorldPages.instantiate_page_objects
    


## Connecting to a Web Browser

The ***WebDriverConnect.initialize_web_driver*** method configures the appropriate selenium-webdriver capabilities required to establish a
connection with a target web browser, and sets the base host URL of the web site you are running your tests against

The ***WebDriverConnect.initialize_web_driver*** method accepts a single optional parameter - the base host URL. Cucumber **Environment
Variables**are used to specify the target local or remote web browser, and the various webdriver capability parameters required to configure
the connection.


### Locally hosted desktop web browser

For locally hosted desktop web browsers, the **WEB_BROWSER** Environment Variable must be set to one of the values from the table below: 

**WEB_BROWSER** | Desktop Platform
--------------- | ----------------
firefox | OS X or Windows
chrome | OS X or Windows
safari | OS X only
ie | Windows only
edge | Windows 10 only
poltergeist | OS X or Windows


### Locally hosted emulated mobile web browser

You can also run your tests against emulated mobile device browsers within a locally hosted instance of the Firefox desktop browser. You may
even specify the emulated device's screen orientation. For locally hosted emulated mobile web browsers, the **WEB_BROWSER** Environment Variable
must be set to one of the values from the table below: 

**WEB_BROWSER** |
--------------- |
ipad |
ipad_pro |
iphone |
iphone4 |
iphone5 |
iphone6 |
iphone6_plus |
android_phone |
android_tablet |

To specify the emulated device's screen orientation, you set the **ORIENTATION** Environment Variable to either ***portrait*** or ***landscape***.


### Remotely hosted desktop and mobile web browsers

You can run your automated tests against remotely hosted desktop and mobile web browsers using the BrowserStack, CrossBrowserTesting,
Sauce Labs, or TestingBot services.


#### Remote desktop browsers on the BrowserStack service

For remotely hosted desktop web browsers on the BrowserStack service, the following **Environment Variables** must be set as described in
the table below. Refer to the [Browserstack-specific capabilities chart page](https://www.browserstack.com/automate/capabilities#capabilities-browserstack) for information regarding the specific capabilities.

**Environment Variable** | Description
--------------- | ----------------
WEB_BROWSER | Must be set to ***browserstack***
BS_USERNAME | Must be set to your BrowserStack account user name
BS_AUTHKEY | Must be set to your BrowserStack account access key
BS_OS | Must be set to ***OS X*** or ***Windows***
BS_OS_VERSION | Refer to ***os_version*** capability in chart
BS_BROWSER | Refer to ***browser*** capability in chart
BS_VERSION | Refer to ***browser_version*** capability in chart
TUNNELING | Must be ***true*** if you are testing against internal/local servers
RESOLUTION | Refer to supported screen ***resolution*** capability in chart


#### Remote mobile browsers on the BrowserStack service

For remotely hosted mobile web browsers on the BrowserStack service, the following **Environment Variables** must be set as described in
the table below. Refer to the [Browserstack-specific capabilities chart page](https://www.browserstack.com/automate/capabilities#capabilities-browserstack) for information regarding the specific capabilities.

**Environment Variable** | Description
--------------- | ----------------
WEB_BROWSER | Must be set to ***browserstack***
BS_USERNAME | Must be set to your BrowserStack account user name
BS_AUTHKEY | Must be set to your BrowserStack account access key
BS_BROWSER | Must be set to ***iPhone***, ***iPad***, or ***android***
BS_PLATFORM | Must be set to ***MAC*** (for iOS) or ***ANDROID***
BS_DEVICE | Refer to ***device*** capability in chart
TUNNELING | Must be ***true*** if you are testing against internal/local servers
ORIENTATION | set to ***portrait*** or ***landscape***



#### Remote desktop browsers on the CrossBrowserTesting service

For remotely hosted desktop web browsers on the CrossBrowserTesting service, the following **Environment Variables** must be set as described in
the table below. Use the Configuration Wizard on the [Start a Selenium Test page](https://app.crossbrowsertesting.com/selenium/run) to obtain information regarding the specific capabilities.

**Environment Variable** | Description
--------------- | ----------------
WEB_BROWSER | Must be set to ***crossbrowser***
CB_USERNAME | Must be set to your CrossBrowserTesting account user name or email address
CB_AUTHKEY | Must be set to your CrossBrowserTesting account access key
CB_OS | Refer to ***os_api_name*** capability in the sample script of the Wizard
CB_BROWSER | Refer to ***browser_api_name*** capability in the sample script of the Wizard
RESOLUTION | Refer to supported ***screen_resolution*** capability in the sample script of the Wizard


#### Remote mobile browsers on the CrossBrowserTesting service

For remotely hosted mobile web browsers on the CrossBrowserTesting service, the following **Environment Variables** must be set as described in
the table below. Use the Configuration Wizard on the [Start a Selenium Test page](https://app.crossbrowsertesting.com/selenium/run) to obtain information regarding the specific capabilities.

**Environment Variable** | Description
--------------- | ----------------
WEB_BROWSER | Must be set to ***crossbrowser***
CB_USERNAME | Must be set to your CrossBrowserTesting account user name or email address
CB_AUTHKEY | Must be set to your CrossBrowserTesting account access key
CB_PLATFORM | Refer to ***os_api_name*** capability in the sample script of the Wizard
CB_BROWSER | Refer to ***browser_api_name*** capability in the sample script of the Wizard
RESOLUTION | Refer to supported ***screen_resolution*** capability in the sample script of the Wizard



#### Remote desktop browsers on the Sauce Labs service

For remotely hosted desktop web browsers on the Sauce Labs service, the following **Environment Variables** must be set as described in
the table below. Use the Selenium API on the [Platform Configurator page](https://wiki.saucelabs.com/display/DOCS/Platform+Configurator#/) to obtain information regarding the specific capabilities.

**Environment Variable** | Description
--------------- | ----------------
WEB_BROWSER | Must be set to ***saucelabs***
SL_USERNAME | Must be set to your Sauce Labs account user name or email address
SL_AUTHKEY | Must be set to your Sauce Labs account access key
SL_OS | Refer to ***platform*** capability in the Copy Code section of the Platform Configurator page
SL_BROWSER | Must be set to ***chrome***, ***firefox***, ***safari***, ***internet explorer***, or ***edge***
SL_VERSION | Refer to ***version*** capability in the Copy Code section of the Platform Configurator page
RESOLUTION | Refer to supported ***screenResolution*** capability in the Copy Code section of the Platform Configurator page


#### Remote mobile browsers on the Sauce Labs service

For remotely hosted mobile web browsers on the Sauce Labs service, the following **Environment Variables** must be set as described in
the table below. Use the Selenium API on the [Platform Configurator page](https://wiki.saucelabs.com/display/DOCS/Platform+Configurator#/) to obtain information regarding the specific capabilities.

**Environment Variable** | Description
--------------- | ----------------
WEB_BROWSER | Must be set to ***saucelabs***
SL_USERNAME | Must be set to your Sauce Labs account user name or email address
SL_AUTHKEY | Must be set to your Sauce Labs account access key
SL_PLATFORM | Refer to ***platform*** capability in the Copy Code section of the Platform Configurator page
SL_BROWSER | Must be set to ***iPhone*** or ***android***
SL_VERSION | Refer to ***version*** capability in the Copy Code section of the Platform Configurator page
SL_DEVICE | Refer to ***deviceName*** capability in the Copy Code section of the Platform Configurator page
SL_DEVICE_TYPE | If displayed, refer to ***deviceType*** capability in the Copy Code section of the Platform Configurator page
ORIENTATION | Refer to ***deviceOrientation*** capability in the Copy Code section of the Platform Configurator page


#### Remote desktop browsers on the TestingBot service

For remotely hosted desktop web browsers on the TestingBot service, the following **Environment Variables** must be set as described in
the table below. Refer to the [TestingBot List of Available Browsers page](https://testingbot.com/support/getting-started/browsers.html) for information regarding the specific capabilities.

**Environment Variable** | Description
--------------- | ----------------
WEB_BROWSER | Must be set to ***testingbot***
TB_USERNAME | Must be set to your TestingBot account user name
TB_AUTHKEY | Must be set to your TestingBot account access key
TB_OS | Refer to ***platform*** capability in chart
TB_BROWSER | Refer to ***browserName*** capability in chart
TB_VERSION | Refer to ***version*** capability in chart
TUNNELING | Must be ***true*** if you are testing against internal/local servers
RESOLUTION | Possible values: 800x600, 1024x768, 1280x960, 1280x1024, 1600x1200, 1920x1200, 2560x1440


### Using Browser specific Profiles in cucumber.yml

While you can set **Environment Variables** in the command line when invoking Cucumber, a preferred method of specifying and managing
target web browsers is to create browser specific **Profiles** that set the appropriate **Environment Variables** for each target browser
in your ***cucumber.yml*** file.

Below is a list of Cucumber **Profiles** for supported locally and remotely hosted desktop and mobile web browsers (put these in in your
***cucumber.yml*** file). Before you can use the BrowserStack, CrossBrowserTesting, Sauce Labs, or TestingBot services, you will need to
replace the placeholder text with your user account and authorization code for the cloud service(s) that you intend to connect with.

    <% desktop          = "--tags ~@wip --tags ~@failing --tags @desktop --require features" %>
    <% mobile           = "--tags ~@wip --tags ~@failing --tags @mobile  --require features" %>
    
    #==============
    # profiles for locally hosted desktop web browsers
    #==============
    
    firefox:            WEB_BROWSER=firefox     <%= desktop %>
    safari:             WEB_BROWSER=safari      <%= desktop %>
    chrome:             WEB_BROWSER=chrome      <%= desktop %>
    ie:                 WEB_BROWSER=ie          <%= desktop %>
    edge:               WEB_BROWSER=edge        <%= desktop %>
    headless:           WEB_BROWSER=poltergeist <%= desktop %>
    
    #==============
    # profiles for locally hosted mobile web browsers (emulated locally in Firefox browser)
    #==============
    
    ipad:               WEB_BROWSER=ipad            <%= mobile %>
    ipad_pro:           WEB_BROWSER=ipad_pro        <%= mobile %>
    iphone:             WEB_BROWSER=iphone          <%= mobile %>
    iphone4:            WEB_BROWSER=iphone4         <%= mobile %>
    iphone5:            WEB_BROWSER=iphone5         <%= mobile %>
    iphone6:            WEB_BROWSER=iphone6         <%= mobile %>
    iphone6_plus:       WEB_BROWSER=iphone6_plus    <%= mobile %>
    android_phone:      WEB_BROWSER=android_phone   <%= mobile %>
    android_tablet:     WEB_BROWSER=android_tablet  <%= mobile %>
    
    
    #==============
    # profiles for mobile device screen orientation
    #==============
    portrait:           ORIENTATION=portrait
    landscape:          ORIENTATION=landscape
    
    
    #==============
    # profiles for remotely hosted web browsers on the BrowserStack service
    #==============
    
    browserstack:       WEB_BROWSER=browserstack BS_USERNAME=<INSERT USER NAME HERE> BS_AUTHKEY=<INSERT PASSWORD HERE>
    bs_desktop:         --profile browserstack <%= desktop %> RESOLUTION="1920x1080"
    bs_mobile:          --profile browserstack <%= mobile %>
    
    # BrowserStack OS X desktop browser profiles
    bs_osx_el_capitan:  --profile bs_desktop BS_OS="OS X" BS_OS_VERSION="El Capitan"
    bs_ff_el_cap:       --profile bs_osx_el_capitan BS_BROWSER="Firefox"
    bs_chrome_el_cap:   --profile bs_osx_el_capitan BS_BROWSER="Chrome"
    bs_safari_el_cap:   --profile bs_osx_el_capitan BS_BROWSER="Safari" BS_VERSION="9.0"
    bs_safari9_el_cap:  --profile bs_osx_el_capitan BS_BROWSER="Safari" BS_VERSION="9.0"
    
    bs_osx_yosemite:    --profile bs_desktop BS_OS="OS X" BS_OS_VERSION="Yosemite"
    bs_ff_yos:          --profile bs_osx_yosemite BS_BROWSER="Firefox"
    bs_chrome_yos:      --profile bs_osx_yosemite BS_BROWSER="Chrome"
    bs_safari_yos:      --profile bs_osx_yosemite BS_BROWSER="Safari" BS_VERSION="8.0"
    bs_safari8_osx:     --profile bs_osx_yosemite BS_BROWSER="Safari" BS_VERSION="8.0"
    
    bs_osx_mavericks:   --profile bs_desktop BS_OS="OS X" BS_OS_VERSION="Mavericks"
    bs_ff_mav:          --profile bs_osx_mavericks BS_BROWSER="Firefox"
    bs_chrome_mav:      --profile bs_osx_mavericks BS_BROWSER="Chrome"
    bs_safari_mav:      --profile bs_osx_mavericks BS_BROWSER="Safari" BS_VERSION="7.0"
    bs_safari7_osx:     --profile bs_osx_mavericks BS_BROWSER="Safari" BS_VERSION="7.0"
    
    # BrowserStack Windows desktop browser profiles
    bs_win7:            --profile bs_desktop BS_OS="Windows" BS_OS_VERSION="7"
    bs_win8:            --profile bs_desktop BS_OS="Windows" BS_OS_VERSION="8.1"
    bs_win10:           --profile bs_desktop BS_OS="Windows" BS_OS_VERSION="10"
    bs_ff_win7:         --profile bs_win7 BS_BROWSER="Firefox"
    bs_ff_win8:         --profile bs_win8 BS_BROWSER="Firefox"
    bs_ff_win10:        --profile bs_win10 BS_BROWSER="Firefox"
    bs_chrome_win7:     --profile bs_win7 BS_BROWSER="Chrome"
    bs_chrome_win8:     --profile bs_win8 BS_BROWSER="Chrome"
    bs_chrome_win10:    --profile bs_win10 BS_BROWSER="Chrome"
    
    bs_ie_win7:         --profile bs_win7 BS_BROWSER="IE"
    bs_ie11_win7:       --profile bs_ie_win7 BS_VERSION="11.0"
    bs_ie10_win7:       --profile bs_ie_win7 BS_VERSION="10.0"
    bs_ie9_win7:        --profile bs_ie_win7 BS_VERSION="9.0"
    bs_ie11_win8:       --profile bs_win8 BS_BROWSER="IE" BS_VERSION="11.0"
    bs_ie10_win8:       --profile bs_desktop BS_OS="Windows" BS_OS_VERSION="8.0" BS_BROWSER="IE" BS_VERSION="10.0"
    bs_ie11_win10:      --profile bs_win10 BS_BROWSER="IE" BS_VERSION="11.0"
    bs_edge_win10:      --profile bs_win10 BS_BROWSER="Edge" BS_VERSION="13.0"
    
    # BrowserStack iOS mobile browser profiles
    bs_iphone:          --profile bs_mobile BS_PLATFORM=MAC BS_BROWSER=iPhone
    bs_ipad:            --profile bs_mobile BS_PLATFORM=MAC BS_BROWSER=iPad
    bs_iphone6_plus:    --profile bs_iphone BS_DEVICE="iPhone 6S Plus"
    bs_iphone6:         --profile bs_iphone BS_DEVICE="iPhone 6S"
    bs_iphone5s:        --profile bs_iphone BS_DEVICE="iPhone 5S"
    bs_iphone4s:        --profile bs_iphone BS_DEVICE="iPhone 4S (6.0)"
    bs_ipad_pro:        --profile bs_ipad BS_DEVICE="iPad Pro"
    bs_ipad_air:        --profile bs_ipad BS_DEVICE="iPad Air 2"
    bs_ipad_mini:       --profile bs_ipad BS_DEVICE="iPad Mini 4"
    
    # BrowserStack Android mobile browser profiles
    bs_android:         --profile bs_mobile BS_PLATFORM=ANDROID BS_BROWSER=android
    bs_galaxy_s5:       --profile bs_android BS_DEVICE="Samsung Galaxy S5"
    bs_kindle_fire:     --profile bs_android BS_DEVICE="Amazon Kindle Fire HDX 7"
    bs_nexus5:          --profile bs_android BS_DEVICE="Google Nexus 5"
    bs_moto_razr:       --profile bs_android BS_DEVICE="Motorola Razr"
    bs_sony_xperia:     --profile bs_android BS_DEVICE="Sony Xperia Tipo"
    
    
    #==============
    # profiles for remotely hosted web browsers on the CrossBrowserTesting service
    #==============
    
    crossbrowser:       WEB_BROWSER=crossbrowser CB_USERNAME=<INSERT USER NAME HERE> CB_AUTHKEY=<INSERT PASSWORD HERE>
    cb_desktop:         --profile crossbrowser <%= desktop %>
    cb_mobile:          --profile crossbrowser <%= mobile %>
    
    # CrossBrowserTesting OS X desktop browser profiles
    cb_osx:             --profile cb_desktop RESOLUTION="1920x1200"
    cb_osx_el_capitan:  --profile cb_osx CB_OS="Mac10.11"
    cb_ff_el_cap:       --profile cb_osx_el_capitan CB_BROWSER="FF44"
    cb_chrome_el_cap:   --profile cb_osx_el_capitan CB_BROWSER="Chrome48x64"
    cb_safari_el_cap:   --profile cb_osx_el_capitan CB_BROWSER="Safari9"
    cb_safari9_el_cap:  --profile cb_osx_el_capitan CB_BROWSER="Safari9"
    
    cb_osx_yosemite:    --profile cb_osx CB_OS="Mac10.10"
    cb_ff_yos:          --profile cb_osx_yosemite CB_BROWSER="FF44"
    cb_chrome_yos:      --profile cb_osx_yosemite CB_BROWSER="Chrome48x64"
    cb_safari_yos:      --profile cb_osx_yosemite CB_BROWSER="Safari8"
    cb_safari8_osx:     --profile cb_osx_yosemite CB_BROWSER="Safari8"
    
    cb_osx_mavericks:   --profile cb_osx CB_OS="Mac10.9"
    cb_ff_mav:          --profile cb_osx_mavericks CB_BROWSER="FF43"
    cb_chrome_mav:      --profile cb_osx_mavericks CB_BROWSER="Chrome48x64"
    cb_safari_mav:      --profile cb_osx_mavericks CB_BROWSER="Safari7"
    cb_safari7_osx:     --profile cb_osx_mavericks CB_BROWSER="Safari7"
    
    # CrossBrowserTesting Windows desktop browser profiles
    cb_win:             --profile cb_desktop RESOLUTION="1920x1080"
    cb_win7:            --profile cb_win CB_OS="Win7x64-C1"
    cb_win8:            --profile cb_win CB_OS="Win8"
    cb_win10:           --profile cb_win CB_OS="Win10"
    cb_ff_win7:         --profile cb_win7 CB_BROWSER="FF44"
    cb_ff_win8:         --profile cb_win8 CB_BROWSER="FF44"
    cb_ff_win10:        --profile cb_win10 CB_BROWSER="FF44"
    cb_chrome_win7:     --profile cb_win7 CB_BROWSER="Chrome48x64"
    cb_chrome_win8:     --profile cb_win8 CB_BROWSER="Chrome48x64"
    cb_chrome_win10:    --profile cb_win10 CB_BROWSER="Chrome48x64"
    
    cb_ie11_win7:       --profile cb_win7 CB_BROWSER="IE11"
    cb_ie10_win7:       --profile cb_win7 CB_BROWSER="IE10"
    cb_ie9_win7:        --profile cb_win7 CB_BROWSER="IE9"
    cb_ie11_win8:       --profile cb_win8 CB_BROWSER="IE11"
    cb_ie10_win8:       --profile cb_win8 CB_BROWSER="IE10"
    cb_ie11_win10:      --profile cb_win10 CB_BROWSER="IE11"
    
    # CrossBrowserTesting iOS mobile browser profiles
    cb_iphone6_plus:    --profile cb_mobile CB_PLATFORM="iPhone6Plus-iOS8sim" CB_BROWSER="MblSafari8.0" RESOLUTION="1080x1920"
    cb_iphone6:         --profile cb_mobile CB_PLATFORM="iPhone6-iOS8sim" CB_BROWSER="MblSafari8.0" RESOLUTION="750x1334"
    cb_iphone5s:        --profile cb_mobile CB_PLATFORM="iPhone5s-iOS7sim" CB_BROWSER="MblSafari7.0" RESOLUTION="640x1136"
    cb_ipad_air:        --profile cb_mobile CB_PLATFORM="iPadAir-iOS8Sim" CB_BROWSER="MblSafari8.0" RESOLUTION="1024x768"
    cb_ipad_mini:       --profile cb_mobile CB_PLATFORM="iPadMiniRetina-iOS7Sim" CB_BROWSER="MblSafari7.0" RESOLUTION="1024x768"
    
    # CrossBrowserTesting Android mobile browser profiles
    cb_nexus7:          --profile cb_mobile CB_PLATFORM="Nexus7-And42" CB_BROWSER="MblChrome37" RESOLUTION="800x1280"
    cb_galaxy_tab2:     --profile cb_mobile CB_PLATFORM="GalaxyTab2-And41" CB_BROWSER="MblChrome38" RESOLUTION="1280x800"
    cb_galaxy_s5:       --profile cb_mobile CB_PLATFORM="GalaxyS5-And44" CB_BROWSER="MblChrome35" RESOLUTION="1080x1920"
    cb_galaxy_s4:       --profile cb_mobile CB_PLATFORM="GalaxyS4-And42" CB_BROWSER="MblChrome33" RESOLUTION="1080x1920"
    cb_galaxy_s3:       --profile cb_mobile CB_PLATFORM="GalaxyS3-And41" CB_BROWSER="MblChrome34" RESOLUTION="720x1280"
    
    
    #==============
    # profiles for remotely hosted web browsers on the SauceLabs service
    #==============
    
    saucelabs:          WEB_BROWSER=saucelabs SL_USERNAME=<INSERT USER NAME HERE> SL_AUTHKEY=<INSERT PASSWORD HERE>
    sl_desktop:         --profile saucelabs <%= desktop %>
    sl_mobile:          --profile saucelabs <%= mobile %>
    
    # SauceLabs OS X desktop browser profiles
    sl_osx_el_capitan:  --profile sl_desktop SL_OS="OS X 10.11"
    sl_ff_el_cap:       --profile sl_osx_el_capitan SL_BROWSER="firefox"
    sl_chrome_el_cap:   --profile sl_osx_el_capitan SL_BROWSER="chrome"
    sl_safari_el_cap:   --profile sl_osx_el_capitan SL_BROWSER="safari"
    sl_safari9_el_cap:  --profile sl_osx_el_capitan SL_BROWSER="safari"
    
    sl_osx_yosemite:    --profile sl_desktop SL_OS="OS X 10.10" RESOLUTION="1920x1200"
    sl_ff_yos:          --profile sl_osx_yosemite SL_BROWSER="firefox"
    sl_chrome_yos:      --profile sl_osx_yosemite SL_BROWSER="chrome"
    sl_safari_yos:      --profile sl_osx_yosemite SL_BROWSER="safari"
    sl_safari8_osx:     --profile sl_osx_yosemite SL_BROWSER="safari"
    
    sl_osx_mavericks:   --profile sl_desktop SL_OS="OS X 10.9" RESOLUTION="1920x1200"
    sl_ff_mav:          --profile sl_osx_mavericks SL_BROWSER="firefox"
    sl_chrome_mav:      --profile sl_osx_mavericks SL_BROWSER="chrome"
    sl_safari_mav:      --profile sl_osx_mavericks SL_BROWSER="safari"
    sl_safari7_osx:     --profile sl_osx_mavericks SL_BROWSER="safari"
    
    # SauceLabs Windows desktop browser profiles
    sl_win7:            --profile sl_desktop SL_OS="Windows 7" RESOLUTION="1920x1200"
    sl_win8:            --profile sl_desktop SL_OS="Windows 8.1" RESOLUTION="1280x1024"
    sl_win10:           --profile sl_desktop SL_OS="Windows 10" RESOLUTION="1280x1024"
    sl_ff_win7:         --profile sl_win7 SL_BROWSER="firefox"
    sl_ff_win8:         --profile sl_win8 SL_BROWSER="firefox"
    sl_ff_win10:        --profile sl_win10 SL_BROWSER="firefox"
    sl_chrome_win7:     --profile sl_win7 SL_BROWSER="chrome"
    sl_chrome_win8:     --profile sl_win8 SL_BROWSER="chrome"
    sl_chrome_win10:    --profile sl_win10 SL_BROWSER="chrome"
    
    sl_ie11_win7:       --profile sl_win7 SL_BROWSER="internet explorer" SL_VERSION="11.0"
    sl_ie10_win7:       --profile sl_win7 SL_BROWSER="internet explorer" SL_VERSION="10.0"
    sl_ie9_win7:        --profile sl_win7 SL_BROWSER="internet explorer" SL_VERSION="9.0"
    sl_ie11_win8:       --profile sl_win8 SL_BROWSER="internet explorer" SL_VERSION="11.0"
    sl_ie11_win10:      --profile sl_win10 SL_BROWSER="internet explorer"
    
    # SauceLabs iOS mobile browser profiles
    sl_ios:             --profile sl_mobile SL_PLATFORM=OS X 10.10 SL_BROWSER="iphone" SL_VERSION="9.2"
    sl_iphone6_plus:    --profile sl_ios SL_DEVICE="iPhone 6 Plus"
    sl_iphone6:         --profile sl_ios SL_DEVICE="iPhone 6"
    sl_iphone5s:        --profile sl_ios SL_DEVICE="iPhone 5s"
    sl_iphone4s:        --profile sl_ios SL_DEVICE="iPhone 4s"
    sl_ipad_air:        --profile sl_ios SL_DEVICE="iPad Air"
    
    # SauceLabs Android mobile browser profiles
    sl_android:         --profile sl_mobile SL_PLATFORM=Linux SL_BROWSER="android" SL_VERSION="4.4"
    sl_android_phone:   --profile sl_android SL_DEVICE="Android Emulator" SL_DEVICE_TYPE="phone"
    sl_android_tablet:  --profile sl_android SL_DEVICE="Android Emulator" SL_DEVICE_TYPE="tablet"
    
    
    #==============
    # profiles for remotely hosted web browsers on the TestingBot service
    #==============
    
    testingbot:         WEB_BROWSER=testingbot TB_USERNAME=<INSERT USER NAME HERE> TB_AUTHKEY=<INSERT PASSWORD HERE>
    tb_desktop:         --profile testingbot <%= desktop %> RESOLUTION="1920x1200"
    
    # TestingBot OS X desktop browser profiles
    tb_osx_el_capitan:  --profile tb_desktop TB_OS="CAPITAN"
    tb_ff_el_cap:       --profile tb_osx_el_capitan TB_BROWSER="firefox"
    tb_chrome_el_cap:   --profile tb_osx_el_capitan TB_BROWSER="chrome"
    tb_safari_el_cap:   --profile tb_osx_el_capitan TB_BROWSER="safari" TB_VERSION="9"
    tb_safari9_el_cap:  --profile tb_osx_el_capitan TB_BROWSER="safari" TB_VERSION="9"
    
    tb_osx_yosemite:    --profile tb_desktop TB_OS="YOSEMITE"
    tb_ff_yos:          --profile tb_osx_yosemite TB_BROWSER="firefox"
    tb_chrome_yos:      --profile tb_osx_yosemite TB_BROWSER="chrome"
    tb_safari_yos:      --profile tb_osx_yosemite TB_BROWSER="safari" TB_VERSION="8"
    tb_safari8_osx:     --profile tb_osx_yosemite TB_BROWSER="safari" TB_VERSION="8"
    
    tb_osx_mavericks:   --profile tb_desktop TB_OS="MAVERICKS"
    tb_ff_mav:          --profile tb_osx_mavericks TB_BROWSER="firefox"
    tb_chrome_mav:      --profile tb_osx_mavericks TB_BROWSER="chrome"
    tb_safari_mav:      --profile tb_osx_mavericks TB_BROWSER="safari" TB_VERSION="7"
    tb_safari7_osx:     --profile tb_osx_mavericks TB_BROWSER="safari" TB_VERSION="7"
    
    # TestingBot Windows desktop browser profiles
    tb_win7:            --profile tb_desktop TB_OS="WIN7"
    tb_win8:            --profile tb_desktop TB_OS="WIN8"
    tb_win10:           --profile tb_desktop TB_OS="WIN10"
    tb_ff_win7:         --profile tb_win7 TB_BROWSER="firefox"
    tb_ff_win8:         --profile tb_win8 TB_BROWSER="firefox"
    tb_ff_win10:        --profile tb_win10 TB_BROWSER="firefox"
    tb_chrome_win7:     --profile tb_win7 TB_BROWSER="chrome"
    tb_chrome_win8:     --profile tb_win8 TB_BROWSER="chrome"
    tb_chrome_win10:    --profile tb_win10 TB_BROWSER="chrome"
    
    tb_ie9_win7:        --profile tb_win7 TB_BROWSER="internet explorer" TB_VERSION="9"
    tb_ie11_win8:       --profile tb_win8 TB_BROWSER="internet explorer" TB_VERSION="11"
    tb_ie10_win8:       --profile tb_win8 TB_BROWSER="internet explorer" TB_VERSION="10"
    tb_ie11_win10:      --profile tb_win10 TB_BROWSER="internet explorer" TB_VERSION="11"
    tb_edge_win10:      --profile tb_win10 TB_BROWSER="microsoftedge" TB_VERSION="13"


To specify a locally hosted target browser using a profile at runtime, you use the flag --profile or -p followed by the profile name when
invoking Cucumber in the command line. For instance, the following command invokes Cucumber and specifies that a local instance of Chrome
will be used as the target web browser:
    
    cucumber -p chrome
    
The following command specifies that Cucumber will run tests against a local instance of Firefox, which will be used to emulate an iPad Pro
in landscape orientation:
    
    cucumber -p ipad_pro -p landscape
 
The following command specifies that Cucumber will run tests against a remotely hosted Safari web browser running on an OS X Yosemite
virtual machine on the BrowserStack service:

    cucumber -p bs_safari_yos
 
The following command specifies that Cucumber will run tests against a remotely hosted Mobile Safari web browser on an iPhone 6s Plus in
landscape orientation running on the BrowserStack service:

    cucumber -p bs_iphone6_plus -p landscape



## Copyright and License

TestCentricity™ Framework is Copyright (c) 2014-2016, Tony Mrozinski.
All rights reserved.


Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions
are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions, and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions, and the following disclaimer in
the documentation and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from
this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

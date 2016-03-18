# TestCentricityWeb

The TestCentricity™ core generic framework for desktop and mobile web site testing implements a Page Object and Data Object Model DSL for
use with Cucumber, Capybara, and selenium-webdriver. It supports testing against locally hosted desktop browsers (Firefox, Chrome, Safari,
IE, or Edge), locally hosted emulated iOS and Android mobile browsers (using Firefox), a "headless" browser (using Poltergeist and PhantomJS),
or on cloud hosted desktop or mobile web browsers using the BrowserStack, Sauce Labs, or CrossBrowserTesting services.


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
    require 'testcentricity_web'
    
    
###Using RSpec

If you are using RSpec instead, you need to require the following in your *env.rb* file:

    require 'capybara'
    require 'capybara/rspec'
    require 'testcentricity_web'
    
    
###Selenium WebDriver

If you choose to not connect to selenium-webdriver using the ***WebDriverConnect.initialize_web_driver*** method, or if you need to directly
call methods in selenium-webdriver, you will also need to require the following in your *env.rb* file:

    require 'selenium-webdriver'



##Usage

### Page Objects

The **Page Object Model** is a test automation pattern that aims to create an abstraction of your web app's User Interface that can be used
in tests. A **Page Object** is an object that represents a single page in your AUT (Application Under Test). **Page Objects** encapsulate the
implementation details of a web page and expose an API that supports interaction with, and validation of UI elements on the page.

**Page Objects** makes it easier to maintain automated tests, because changes to page UI elements are only changed in one location - in the
**Page Object** class definition. By adopting a **Page Object Model**, Cucumber Feature files and step definitions are no longer required to
hold specific information about a page's UI objects, thus minimizing maintenance requirements. If any element on a page changes (URL path,
text field attributes, button captions, etc.), maintenance is performed in the **Page Object** class definition only, typically with no need
to update the affected feature file, scenarios, or step definitions.


####Defining a Page Object

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


####Adding UI Elements to your Page Object

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


####Adding Methods to your Page Object

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
    


### PageSection Objects

A **PageSection Object** is a collection of **UI Elements** that may appear in multiple locations on a page, or on multiple pages in a web
app. It is a collection of **UI Elements** that represent a conceptual area of functionality, like a navigation bar, a search capability,
or a menu. **UI Elements** and functional behavior are confined to the scope of a **PageSection Object**.

A **PageSection Object** may contain other **PageSection Objects**.


####Defining a PageSection Object

Your **PageSection** class definitions should be contained within individual *.rb* files in the ***features/support/sections*** folder of
your test automation project. You define new **PageSection Objects** as shown below:

    class SearchForm < TestCentricity::PageSection
      trait(:section_locator)    { "//form[@id='gnav-search']" }
    end


####Adding UI Elements to your PageSection Object

**UI Elements** are added to your **PageSection** class definition as shown below:

    class SearchForm < TestCentricity::PageSection
      trait(:section_locator)    { "//form[@id='gnav-search']" }
        
      # Search Form UI elements
      textfield :search_field,   "//input[@id='search-query']"
      button    :search_button,  "//button[@type='submit']"
    end


####Adding Methods to your PageSection Object

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


####Adding PageSection Objects to your Page Object

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
    
    

###Instantiating your Page Objects

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

####Using the PageManager

The **PageManager** class provides methods for supporting the instantiation and management of **Page Objects**. In the code example below,
the **page_objects** method contains a hash table of your **Page Object** instance variables and their associated **Page Object** classes
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
    




## Copyright and License

TestCentricity™ Framework is Copyright (c) 2014-2016, Tony Mrozinski.
All rights reserved.


Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice,
this list of conditions, and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright
notice, this list of conditions, and the following disclaimer in the
documentation and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its contributors
may be used to endorse or promote products derived from this software without
specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.

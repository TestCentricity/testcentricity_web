# TestcentricityWeb

The TestCentricity™ core generic framework for desktop and responsive mobile web site testing implements a Page Object
and Data Object Model DSL, for use with Cucumber, Capybara, and selenium-webdriver. It supports testing against locally
hosted desktop browsers (Firefox, Chrome, Safari, IE, or Edge), locally hosted emulated mobile browsers (using Firefox),
"headless" (using Poltergeist), or on cloud hosted desktop or mobile web browsers using the BrowserStack, Sauce Labs,
or CrossBrowserTesting services.


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

If you choose to not connect to selenium-webdriver using the ***WebDriverConnect.initialize_web_driver*** method, or if you need to 
directly call methods in selenium-webdriver, you will also need to require the following in your *env.rb* file:

    require 'selenium-webdriver'



##Usage

###Page Objects
####Defining a Page Object

You define new **Page Objects** as shown below:

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

Your Page Object's **UI Elements** are added as shown below:

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
    
Once your **Page Objects** have been instantiated, you can interact with the **UI Elements** in your **Page Objects**. An example is shown below:

    login_page.user_id_field.set('snicklefritz')
    login_page.password_field.set('Pa55w0rd')
    login_page.login_button.click


####Adding Methods to your Page Object

You can add high level methods for interacting with the UI to hide implementation details, as shown below:

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
    


###PageSection Objects
####Defining a PageSection Object

You define new **PageSection Objects** as shown below:

    class SearchForm < TestCentricity::PageSection
      trait(:section_locator)    { "//form[@id='gnav-search']" }
    end


####Adding UI Elements to your PageSection Object

Your PageSection Object's **UI Elements** are added as shown below:

    class SearchForm < TestCentricity::PageSection
      trait(:section_locator)    { "//form[@id='gnav-search']" }
        
      # Search Form UI elements
      textfield :search_field,   "//input[@id='search-query']"
      button    :search_button,  "//button[@type='submit']"
    end


####Adding Methods to your PageSection Object

You can add high level methods to your PageSection Objects, as shown below:

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

Your Page Object's **PageSection Objects** are added as shown below:

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

There are several ways to instantiate your **Page Objects**. One common implementation is shown below:

    module WorldPages
      def login_page
        @login_page ||= LoginPage.new
      end
    
      def home_page
        @home_page ||= HomePage.new
      end
    end


####Using the PageManager

Your world_pages.rb file:

    module WorldPages
      #
      # page_objects method returns a hash table of your web app's page objects and associated page classes to be instantiated
      # by the TestCentricity™ PageManager. Page Object class definitions are contained in the features/support/pages folder.
      #
      def page_objects
        { :login_page            => LoginPage,
          :home_page             => HomePage,
          :registration_page     => RegistrationPage,
          :shopping_basket_page  => ShoppingBasketPage,
          :payment_method_page   => PaymentMethodPage,
          :confirm_purchase_page => PurchaseConfirmationPage
        }
      end
    end
    
    World(WorldPages)


Your *env.rb* file:

    include WorldPages
    WorldPages.instantiate_page_objects




## Copyright and License

TestCentricity(tm) Framework is Copyright (c) 2014-2016, Tony Mrozinski.
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

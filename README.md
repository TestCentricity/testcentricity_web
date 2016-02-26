# TestcentricityWeb

The TestCentricity™ core generic framework for desktop and responsive mobile web site testing implements a Page Object 
and Data Object Model DSL, for use with Capybara and selenium-webdriver. It supports testing against locally hosted
desktop browsers (Firefox, Chrome, Safari, IE, or Edge), locally hosted emulated mobile browsers (using Firefox), or 
on cloud hosted browsers using the BrowserStack, Sauce Labs, or CrossBrowserTesting services.


## Installation

Add this line to your application's Gemfile:

    gem 'testcentricity_web'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install testcentricity_web


## Setup

If you are using Cucumber, you must require the following in your env.rb file:

    require 'capybara/cucumber'
    require 'testcentricity_web'
    
If you choose to not connect to WebDriver using the ***WebDriverConnect.initialize_web_driver*** method, or if you need to 
directly call methods in selenium-webdriver, you will also need to require the following in your env.rb file:

    require 'selenium-webdriver'



## Usage

TODO: Write usage instructions here


## Copyright and License

TestCentricity (tm) Framework is Copyright (c) 2014-2016, Tony Mrozinski.
All rights reserved.


Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice,
this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright
notice, this list of conditions and the following disclaimer in the
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

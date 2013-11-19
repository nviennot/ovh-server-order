#!/usr/bin/env ruby

require 'bundler'
Bundler.require 

require 'capybara'
require 'capybara/dsl'

Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(app, :browser => :chrome)
end

Capybara.javascript_driver = :selenium
Capybara.current_driver = :selenium
Capybara.app_host = 'http://www.ovh.com'
Capybara.default_selector = :css
Capybara.default_wait_time = 10

class Order
  include Capybara::DSL

  def do_order
    visit '/us/dedicated-servers/ks3.xml'
    page.find("button").click
    page.evaluate_script("SelectValidForm('root')")
    page.evaluate_script("validChoice('ubuntu1204','','')")
    page.evaluate_script("checkForm()")

    page.find("input#isNewOrExisting_existing").click
    page.evaluate_script("switchDivNewOrExisting('existing')")
    page.find("#textNic").set(ENV['OVH_LOGIN'])
    page.find("#textPassword").set(ENV['OVH_PASSWORD'])
    page.evaluate_script("checkForm()")

    page.evaluate_script("checkForm()")

    page.evaluate_script("check_unckeck_box()")
    page.evaluate_script("checkForm()")

    page.find('form input[type="image"]').click

    page.find('input#login_email').set(ENV['PAYPAL_LOGIN'])
    page.find('input#login_password').set(ENV['PAYPAL_PASSWORD'])
    page.find('input#submitLogin').click
    page.find('input#continue_abovefold').click
  end
end

Order.new.do_order

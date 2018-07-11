require 'rspec'
require 'watir/rspec'

module Grid
  class TestRunner
    BROWSERS = ['firefox', 'chrome'].freeze

    def run
      BROWSERS.each do |browser|
        setup(browser)
        yield
      end
    end

    def setup(browser)
      puts "\n\n############################"
      puts "Starting #{browser.capitalize} test run..."
      puts "############################\n\n"

      RSpec.configure do |config|
        config.before :all do
          @browser = Watir::Browser.new(
            browser.to_sym,
            { url: "http://#{ENV.fetch('HUB_HOST')}/wd/hub" }
          )
        end

        config.after :all do
          @browser&.close
        end
      end
    end
  end
end

testrunner = Grid::TestRunner.new
testrunner.run do
  RSpec::Core::Runner.run ['spec']
  RSpec.clear_examples
end

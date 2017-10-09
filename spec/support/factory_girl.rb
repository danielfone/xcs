include RSpec::Core::Formatters
RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
    DatabaseCleaner.cleaning { FactoryGirl.lint }

    puts ConsoleCodes.wrap("✔︎ Linted factories", :success)
  end
end

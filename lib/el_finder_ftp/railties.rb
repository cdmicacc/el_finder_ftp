module ElFinderFtp
  class Railties < ::Rails::Railtie
    initializer 'Rails logger' do
      puts "In Railtie"
      ElFinderFtp::Connector.logger = Rails.logger
    end
  end
end
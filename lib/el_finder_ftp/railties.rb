module ElFinderFtp
  class Railties < ::Rails::Railtie
    initializer 'Rails logger' do
      ElFinderFtp::Connector.logger = Rails.logger
    end
  end
end
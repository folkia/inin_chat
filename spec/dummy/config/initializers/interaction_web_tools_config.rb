InteractionWebTools.configure do |config|
  config.inin_server = 'http://ininchatprovider.com/CustomerId/Server2/websvcs'
  config.chat_additional_information = -> {
    'Default payload'
  }
  congig.chat_target = 'Frogtail Labb'
end

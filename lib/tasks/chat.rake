namespace :chat do
  desc "Ping the chat app"
  task review_app_deployed: :environment do
    `curl --data-urlencode "message=Review app #{ENV['HEROKU_APP_NAME']} deployed" #{ENV['GITTER_WEBHOOK_URL']}`
  end
end

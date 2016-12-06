namespace :chat do
  desc "Ping the chat app"
  task review_app_deployed: :environment do
    `curl --data-urlencode "message=Heroku \[[#{ENV['HEROKU_APP_NAME']}](https://#{ENV['HEROKU_APP_NAME']}.herokuapp.com)\] deployed" #{ENV['GITTER_WEBHOOK_URL']}`
  end
end

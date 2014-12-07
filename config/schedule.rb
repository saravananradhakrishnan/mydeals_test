#set :output, "/home/mydeals/public_html/mydeals_india/log/cron_log.log"
#env :PATH, "$PATH:/home/mydeals/public_html/mydeals_india/simple_captcha/ruby/1.9.1/bin"

#every 20.minutes do
#  runner "Scheduler.send_sms_message"
#end

set :output, "/home/mydeals/public_html/mydeals_india/log/cron_log.log"
env :PATH, "$PATH:/usr/local/lib/ruby/gems/1.9.1/bin"


#every 20.minutes do
#    command "cd /home/mydeals/public_html/mydeals && RAILS_ENV=production /usr/local/bin/ruby ./script/rails runner Scheduler.send_sms_message"
#end

#every 20.minutes do
#    command "cd /home/mydeals/public_html/mydeals_india && RAILS_ENV=production /usr/local/bin/ruby ./script/rails runner Scheduler.send_sms_message"
#end



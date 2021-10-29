require 'pony'
require 'telegram/bot'


class Mailer
  #
  # Send report by email
  #
  # @param [String] from
  # @param [String] to
  # @param [String] subject
  # @param [String] report
  #
  # @return [Boolean]

  TOKEN = '2085721284:AAFUBqaC_uOtwPmGipjMGOoY5HJDg_5yIqc' # TOP SECRET =)

  def self.format_report(report)
    body = ''

    sorted_report = report[:body].sort_by { |h| h[report[:sort].to_sym] }

    sorted_report.each do |hh|
      body += "#{hh[:code]}. Guest: #{hh[:guest]}. #{hh[:type].capitalize} #{hh[:entity]} at #{hh[:updated_at]}\n"
    end
    body
  end

  def self.deliver_by_telegram(params)
    #To send a telegram report you need to start chat with @Testrepotiobot !!!

    bot = Telegram::Bot::Client.new(TOKEN)
    bot.api.send_message(chat_id: params[:to], text: format_report(params[:report]))
    true
  end

  def self.deliver_by_mail(params)
    # TODO make check params
    Pony.mail({
                subject: params[:subject],
                body: format_report(params[:report]),
                to: params[:to],
                from: 'testreport@bk.ru',
                via: :smtp,
                via_options: {
                  address: 'smtp.mail.ru',
                  port: '465',
                  tls: true,
                  user_name: 'testreport@bk.ru',
                  password: 'S0mfW7HQDeFvHKY5DdjR', # Top secret =)
                  authentication: :plain
                }
              })
    true
  end
end

# Example
# report =  [
#  { code: 'A-001', guest: 'guest@email.com', entity: 'reservation', type: 'confirmed', created_at: '2019-06-08 23:06:45', updated_at: '2019-06-08 23:06:45' },
# { code: 'A-001', guest: 'guest@email.com', entity: 'reservation', type: 'modified', created_at: '2019-06-08 23:06:45', updated_at: '2019-06-08 23:40:02' }
#]

#Mailer.deliver_by_mail(
#  to: 'testreport@bk.ru',
#  subject: 'Report',
#  report: {
#    body: report,
#    sort: 'type'
#  }
#)

#To send a telegram report you need to start chat with @Testrepotiobot !!!
#Mailer.deliver_by_telegram(
#  to: '733017529', # Chat_id sting or integer
#  report: {
#    body: report,
#    sort: 'type' # type of sort (string) code,guest,entity,type,created_at,updated_at
#  }
#)



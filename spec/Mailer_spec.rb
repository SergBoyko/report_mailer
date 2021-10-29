require './Mailer'
require 'rspec'

describe Mailer do

  report_for_sending =  [
     { code: 'A-001', guest: 'guest@email.com', entity: 'reservation', type: 'confirmed', created_at: '2019-06-08 23:06:45', updated_at: '2019-06-08 23:06:45' },
     { code: 'A-001', guest: 'guest@email.com', entity: 'reservation', type: 'modified', created_at: '2019-06-08 23:06:45', updated_at: '2019-06-08 23:40:02' }
   ]

  it 'should format report' do
    report = {
      body: [
      { code: 'A-001', guest: 'guest@email.com', entity: 'reservation', type: 'confirmed',
created_at: '2019-06-08 23:06:45', updated_at: '2019-06-08 23:06:45' },
      { code: 'A-001', guest: 'guest@email.com', entity: 'reservation', type: 'modified',
created_at: '2019-06-08 23:06:45', updated_at: '2019-06-08 23:40:02' }
    ],
      sort: 'type'
    }
    body = Mailer.format_report(report)
    expected_body = "A-001. Guest: guest@email.com. Confirmed reservation at 2019-06-08 23:06:45\nA-001. Guest: guest@email.com. Modified reservation at 2019-06-08 23:40:02\n"

    expect(body).to eq expected_body
  end

  it 'should sort report by type' do
    report = {
      body: [
        { code: 'A-001', guest: 'guest@email.com', entity: 'reservation', type: 'confirmed',
created_at: '2019-06-08 23:06:45', updated_at: '2019-06-08 23:06:45' },
        { code: 'A-001', guest: 'guest@email.com', entity: 'reservation', type: 'modified',
created_at: '2019-06-08 23:06:45', updated_at: '2019-06-08 23:40:02' },
        { code: 'A-001', guest: 'guest@email.com', entity: 'reservation', type: 'confirmed',
created_at: '2019-06-08 23:26:45', updated_at: '2019-06-08 23:40:02' },
      ],
      sort: 'type'
    }
    body = Mailer.format_report(report)
    expect_body = "A-001. Guest: guest@email.com. Confirmed reservation at 2019-06-08 23:06:45\nA-001. Guest: guest@email.com. Confirmed reservation at 2019-06-08 23:40:02\nA-001. Guest: guest@email.com. Modified reservation at 2019-06-08 23:40:02\n"
    expect(body).to eq expect_body
  end

  it 'should send email message' do
    email = Mailer.deliver_by_mail(
      to: 'badwolf6661@gmail.com',
      subject: 'Report',
      body: report_for_sending,
      sort: 'type'
      )
    expect(email).to be true
  end

  it 'should send telegram message' do
    message = Mailer.deliver_by_telegram(
      to: '733017529', # Chat_id sting or integer
      body: report_for_sending,
      sort: 'type' # type of sort (string) code,guest,entity,type,created_at,updated_at
    )
    expect(message).to be true
  end

end
from twilio.rest import Client
from credentialsTwilio import account_sid, auth_token, my_cell, my_twilio

client = Client(account_sid, auth_token)

customer_name = input()
customer_company = input()
my_msg = "Hello %s! Thank you and %s for applying for more Working Capital with Business Capital!" \
         % (customer_name, customer_company)

message = client.messages.create(
    from_=my_twilio,
    to=my_cell,
    body=my_msg
)

print(message.sid)

# Pricing Information - https://www.twilio.com/sms/pricing/us

# Whatsapp Twilio API - https://www.twilio.com/docs/sms/whatsapp/quickstart/python


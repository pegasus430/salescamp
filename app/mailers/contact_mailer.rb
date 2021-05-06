class ContactMailer < ApplicationMailer
	default from: 'no-reply@salescamp.io'

  	layout 'mailer'

  	def send_contact_mail(request)
  		@name = request[:name]
	    @email  = request[:email]
	    @message_body  = request[:message_body]
	    mail(to: "support@salescamp.io", subject: 'Contact Message from salescamp.io')
	    # mail(to: "nptechsols@gmail.com", subject: 'Contact Message from salescamp.io')
  	end
end

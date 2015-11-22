class ContactMailer < ActionMailer::Base
	default from: "robertimtoc@gmail.com"

    def alert_sale_store(store, subject)
        @store = store
        mail(to: @store.email, content_type: "text/html", subject: subject)
    end
end
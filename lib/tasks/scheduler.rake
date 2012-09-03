desc "This task is called by the Heroku scheduler add-on"
task :send_reminders => :environment do
	puts "Sending reminders..."
	User.all.each do |user|
		if user.profile.send_reminder_mail
			item_names = []
			links = user.profile.links.each do |link|
				if link.item.project.input_date == Date.tomorrow
					item_names << link.item.name	
				end
			end
			if !item_names.empty?
				email = ReminderMailer.new(:item_names => item_names.to_sentence, :email => user.email)
				email.deliver
				puts "delivered to " + user.email + "..."
			end
		end
	end
	puts "done."
end

desc "This task is called by the Heroku scheduler add-on"
task :send_reminders => :environment do
	puts "Sending reminders..."
	User.all.each do |user|
		if user.profile.send_reminder_mail
			item_names = []
			items = user.profile.items.all.entries
			items.each do |item|
				if item.project.input_date == Date.tomorrow
					item_names << item.name	
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

task :update_project_status => :environment do
	puts "Updating project status..."
	projects = Project.where(:success => false).all
	projects.each do |project|
		if project.end_at && project.end_at < Time.now
			project.update_attributes(:success => true)
		end
	end
	puts "done."
end

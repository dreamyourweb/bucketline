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
			p project.query
			project.update_attributes(:success => true)
		end
	end
	puts "done."
end

task :send_item_placement_mail => :environment do
	#Build item list
	items = Item.where(:created_at.gt => Time.now.utc - 1.hour, :project_id => nil).all #Get all items that were created less than an hour ago

	unless items.empty?
		puts "Building item placement mail..."

		#Build mailinglist
		mailing_list = []
		User.all.each do |user|
			if user.profile.always_send_project_placement_mail #Get all the to-be-reminded-users
				mailing_list << user.email
			end
		end
		joined_mailing_list = "<" + mailing_list.join(">,<") + ">"

		#Build sentence
		item_sentence = ""
		items.each do |item|
			item_sentence << item.amount.to_s + " " + item.name + ": " + item.description + "<br>"
		end	

		email = ItemPlacementMailer.new(:recipients => joined_mailing_list, :item_sentence => item_sentence)
		puts "sending emails..."
		puts email.recipients
		puts email.item_sentence
		email.deliver
	end

	puts "done."
end
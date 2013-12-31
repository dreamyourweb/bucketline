#desc "This task is called by the Heroku scheduler add-on"
task :send_reminders => :environment do
	puts "Sending reminders..."
	User.all.each do |user|
		if user.profile.send_reminder_mail
			item_names = []
			project_names = []
			initiative_names = []
			links = user.profile.links.each do |link|
				if !link.item.project_id.nil? && link.item.project.input_date == Date.tomorrow
					item_names << link.item.name
					project_names << link.item.project.query
					initiative_names << link.item.project.initiative.name	
				end
			end
			project_names.uniq!
			initiative_names.uniq!
			if !item_names.empty?
				email = ReminderMailer.new(:item_names => item_names.to_sentence, :project_names => project_names.to_sentence, :initiative_names => initiative_names.to_sentence, :email => user.email)
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
	Initiative.all.each do |initiative|
		#Build item list
		items = initiative.items.where(:created_at.gt => Time.now.utc - 1.hour, :project_id => nil).all #Get all items that were created less than an hour ago

		unless items.empty?
			puts "Building item placement mail for #{initiative.name}..."

			#Build mailinglist
			mailing_list = []
			initiative.users.each do |user|
				if user.profile.always_send_project_placement_mail #Get all the to-be-reminded-users
					mailing_list << user.email
				end
			end

			#Build sentence
			item_sentence = ""
			items.each do |item|
				item_sentence << item.amount.to_s + " " + item.name + ": " + item.description + " / "
			end	

			email = ItemPlacementMailer.new(:recipients => mailing_list, :item_sentence => item_sentence, :initiative => initiative.name)
			puts "sending emails..."
			#puts email.recipients
			#puts email.item_sentence
			email.deliver
		end
	end
	puts "done."
end

task :send_project_placement_mail => :environment do
	Initiative.all.each do |initiative|
		#Build item list
		projects = initiative.projects.where(:created_at.gt => Time.now.utc - 1.hour).all #Get all projects that were created less than an hour ago

		unless projects.empty?
			puts "Building project placement mail for #{initiative.name}..."

			#Build mailing list
			mailing_list = []
			initiative.users.each do |user|
				if user.profile.always_send_project_placement_mail #Get all the to-be-notified-users that are not the owner of this project
					mailing_list << user.email
				end
			end

	        email = NotificationMailer.project_placement_mail(initiative, projects, mailing_list)
			puts "sending emails..."
			email.deliver
		end
	end
end
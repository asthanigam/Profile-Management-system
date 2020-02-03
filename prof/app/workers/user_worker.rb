class UserWorker
  include Sidekiq::Worker

  def perform()
  	#if User.find_by(create: User.created_at).to_date==Date.current
  	#current_user.created_at.to_date == Date.current
 	#created_at = Rails.cache.read(User.created_at)
  	##	i=Rails.cache.read(Date.today)
  	#	Rails.cache.write(Date.today,i+1)
  	#else
  	#	Rails.cache.write(Date.today,1)
  	#end
  	# => end
  	puts "hi"
  	#@usertodays = User.group(Date.yesterday).count
  	#usertodays = UserWorker.where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day)
	#@usertodays = User.count(Date.today.advance(:days => -1))
	@usertodays = User.where("Date(created_at) = ?", Date.yesterday).count
	puts "   #@usertodays"
 	file = File.open("output.txt","a")
 	file.puts "#{Date.yesterday}   : #@usertodays"
 	file.close
	
  end
end


#Sidekiq::Cron::Job.create(name: 'UserWorker-every 24hours', cron: '45 12 * * *', class: 'UserWorker' )

namespace :authorized_users do
  desc "Authorize a Slack user ID"
  task :add, [:slack_user_id] => :environment do |t, args|
    unless args.slack_user_id.present?
      puts "Usage: rails authorized_users:add[SLACK_USER_ID]"
      exit
    end

    AuthorizedUser.find_or_create_by!(slack_user_id: args.slack_user_id)
    puts "✅ Authorized Slack user ID: #{args.slack_user_id}"
  end

  desc "Remove a Slack user ID from authorized users"
  task :remove, [:slack_user_id] => :environment do |t, args|
    unless args.slack_user_id.present?
      puts "Usage: rails authorized_users:remove[SLACK_USER_ID]"
      exit
    end

    if user = AuthorizedUser.find_by(slack_user_id: args.slack_user_id)
      user.destroy
      puts "✅ Removed authorization for Slack user ID: #{args.slack_user_id}"
    else
      puts "❌ Slack user ID not found: #{args.slack_user_id}"
    end
  end

  desc "List all authorized Slack user IDs"
  task list: :environment do
    users = AuthorizedUser.all
    if users.any?
      puts "\nAuthorized Slack User IDs:"
      puts "------------------------"
      users.each do |user|
        puts user.slack_user_id
      end
    else
      puts "No authorized users found."
    end
  end
end 
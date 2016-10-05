namespace :attention_job do
  desc 'test'
  task execute_attention_job: :environment do
    # main = ApplicationController.new
    # main.set_newest_session_rate
    # # main.attention_job
    puts 'Test Success'
    CheckService.new.refresh_rate!
    # console 可直接測
  end
end

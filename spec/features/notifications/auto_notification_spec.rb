require 'rails_helper'
require 'rake'

describe "Auto Notification job:", type: :feature do
  let(:user) { FactoryBot.create(:user, password: 'password') }
  let(:item) { FactoryBot.create(:item) }

  before do
    sign_in user
    Rails.application.load_tasks
    puts "Loading tasks"
    puts Notification.all.inspect
  end

  after do
    puts "After"
    puts Notification.all.inspect
  end

  it 'return reminder should send a message to every user whose borrowed item is overdue by one day' do
    FactoryBot.create(:lending, user: user, item: item, due_at: Date.tomorrow, completed_at: nil)
    expect { Rake::Task['return_reminder'].invoke }.to change { Notification.count }.by(1)
  end

  it 'overdue reminder should send a message to every user whose borrowed item is overdue by one day' do
    FactoryBot.create(:lending, user: user, item: item, due_at: Date.yesterday, completed_at: nil)
    expect { Rake::Task['overdue_reminder'].invoke }.to change { Notification.count }.by(1)
  end

  it 'weekly overdue reminder should send a message to every user whose borrowed item is overdue by some weeks' do
    FactoryBot.create(:lending, user: user, item: item, due_at: 2.weeks.ago, completed_at: nil)
    expect { Rake::Task['weekly_overdue_reminder'].invoke }.to change { Notification.count }.by(1)
  end
end
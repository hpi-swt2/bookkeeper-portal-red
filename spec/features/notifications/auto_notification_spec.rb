require 'rails_helper'
require 'rake'

describe "Auto Notification job:", type: :feature do
  let(:user) { FactoryBot.create(:user, password: 'password') }
  let(:item) { FactoryBot.create(:item) }

  Rails.application.load_tasks

  before do
    sign_in user
  end

  it 'return reminder should send a message to every user whose borrowed item is overdue by one day' do
    FactoryBot.create(:lending, user: user, item: item, due_at: Date.tomorrow, completed_at: nil)
    expect { Rake::Task['return_reminder'].invoke }.to change(Notification, :count).by(1)
  end

  it 'overdue reminder should send a message to every user whose borrowed item is overdue by one day' do
    FactoryBot.create(:lending, user: user, item: item, due_at: Date.yesterday, completed_at: nil)
    expect { Rake::Task['overdue_reminder'].invoke }.to change(Notification, :count).by(1)
  end

  it 'weekly overdue reminder should send a message to every user whose borrowed item is overdue by some weeks' do
    FactoryBot.create(:lending, user: user, item: item, due_at: 2.weeks.ago, completed_at: nil)
    expect { Rake::Task['weekly_overdue_reminder'].invoke }.to change(Notification, :count).by(1)
  end

  it 'return reminder should not send a message if item was already returned' do
    FactoryBot.create(:lending, user: user, item: item, due_at: Date.tomorrow, completed_at: Time.zone.now)
    expect { Rake::Task['return_reminder'].invoke }.not_to change(Notification, :count)
  end

  it 'overdue reminder should not send a message if item was already returned' do
    FactoryBot.create(:lending, user: user, item: item, due_at: Date.yesterday, completed_at: Time.zone.now)
    expect { Rake::Task['overdue_reminder'].invoke }.not_to change(Notification, :count)
  end

  it 'weekly overdue reminder should not send a message if item was already returned' do
    FactoryBot.create(:lending, user: user, item: item, due_at: 2.weeks.ago, completed_at: Time.zone.now)
    expect { Rake::Task['weekly_overdue_reminder'].invoke }.not_to change(Notification, :count)
  end

  it 'return reminder should not send a message if item is due in two days' do
    FactoryBot.create(:lending, user: user, item: item, due_at: 2.days.from_now, completed_at: nil)
    expect { Rake::Task['return_reminder'].invoke }.not_to change(Notification, :count)
  end

  it 'overdue reminder should not send a message if item was due two days ago' do
    FactoryBot.create(:lending, user: user, item: item, due_at: 2.days.ago, completed_at: nil)
    expect { Rake::Task['overdue_reminder'].invoke }.not_to change(Notification, :count)
  end

  it 'weekly overdue reminder should not send a message if item was due 18 days ago' do
    FactoryBot.create(:lending, user: user, item: item, due_at: 18.days.ago, completed_at: nil)
    expect { Rake::Task['weekly_overdue_reminder'].invoke }.not_to change(Notification, :count)
  end
end

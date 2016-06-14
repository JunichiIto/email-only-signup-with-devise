require 'rails_helper'

feature 'Sign up' do
  background do
    ActionMailer::Base.deliveries.clear
  end

  scenario 'メールアドレスのみでユーザー登録を行い、パスワードを後から設定する' do
    visit root_path
    expect(page).to have_http_status :ok

    click_link 'Sign up'
    fill_in 'Email', with: 'foo@example.com'
    expect { click_button 'Sign up' }.to change { ActionMailer::Base.deliveries.size }.by(1)
    expect(page).to have_content 'A message with a confirmation link has been sent to your email address'

    mail = ActionMailer::Base.deliveries.last
    body = mail.body.encoded
    url = body[/http[^"]+/]
    visit url
    expect(page).to have_content 'Enter new password'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_button 'Submit'
    expect(page).to have_content 'Your email address has been successfully confirmed.'
  end
end
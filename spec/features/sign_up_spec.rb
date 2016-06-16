require 'rails_helper'

feature 'Sign up' do
  scenario 'メールアドレスのみでユーザー登録を行い、パスワードを後から設定する' do
    visit root_path
    expect(page).to have_http_status :ok

    click_link 'Sign up'
    fill_in 'Email', with: 'foo@example.com'
    expect { click_button 'Sign up' }.to change { ActionMailer::Base.deliveries.size }.by(1)
    expect(page).to have_content 'A message with a confirmation link has been sent to your email address'

    user = User.last
    token = user.confirmation_token
    visit users_confirmation_path(confirmation_token: token)
    expect(page).to have_content 'Enter new password'

    # 登録に失敗する場合
    click_button 'Submit'
    expect(page).to have_content "Password can't be blank"
    expect(page).to have_content "Password confirmation can't be blank"

    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '123456789'
    click_button 'Submit'
    expect(page).to have_content 'Password confirmation does not match password'

    # 登録に成功する場合
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_button 'Submit'
    expect(page).to have_content 'Your email address has been successfully confirmed.'

    click_link 'Log out'
    expect(page).to have_content 'Signed out successfully.'

    click_link 'Log in'
    fill_in 'Email', with: 'foo@example.com'
    fill_in 'Password', with: '12345678'
    click_button 'Log in'
    expect(page).to have_content 'Signed in successfully.'
  end
end
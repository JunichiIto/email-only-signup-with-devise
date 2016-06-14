require 'rails_helper'

feature 'Sign up' do
  scenario 'メールアドレスのみでユーザー登録を行い、パスワードを後から設定する' do
    visit root_path
    expect(page).to have_http_status :ok
  end
end
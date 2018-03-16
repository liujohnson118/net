require 'rails_helper'

feature "Add users" do
  scenario "Create 2 users with same email for the same organization" do

    #Expect success to create organization OrgC with subdomain c
    Capybara.default_host = "http://localhost"
    Capybara.server_port = 3000
    Capybara.app_host = "http://localhost:3000"
    visit root_path
    click_link "New Organization"
    fill_in "organization_name", with: "OrgC"
    fill_in "organization_subdomain", with: "c"
    click_button "Sign up"
    expect(page).to have_content("Organization was successfully created.")

    #Go to organization OrgC and create the very first user
    expect(page).to have_content("OrgC")
    expect(page).to have_content("c")
    Capybara.default_host = "http://lvh.me"
    Capybara.server_port = 3000
    Capybara.app_host = "http://c.lvh.me:3000"
    visit root_path
    click_link "Register"
    expect(page).to have_content("There are currently")
    expect(page).to have_content("You are the first one to register to this organization and will be an admin automatically")
    fill_in "user_email", with: "admin1@c.ca"
    fill_in "user_phone", with: 111
    fill_in "user_age", with: 1
    fill_in "user_password", with: "cccc"
    click_button "Sign up"

    #Expect to be redirected to login
    expect(page).to have_content("Login")
    expect(page).to have_content("Email:")
    expect(page).to have_content("Password:")
    fill_in "email", with: "admin1@c.ca"
    fill_in "password", with: "cccc"
    click_button "Submit"

    #Expect to see user info just for OrgC
    expect(page).to have_content("admin1@c.ca")
    expect(page).to have_content("111")

    #Expect to do stuff that only admins can do
    expect(page).to have_content("You are an admin user")
    expect(page).to have_content("You can add other users")
    click_on "here"
    expect(page).to have_content("You're admin so you can add other people as admin or regular user")

    fill_in "user_email", with: "admin1@c.ca"
    fill_in "user_phone", with: 113
    fill_in "user_age", with: 2
    fill_in "user_password", with: "cccc1"
    click_button "Sign up"
    expect(page).to have_content("User creation failed")
  end
end
require 'rails_helper'

feature "Registered user" do
  scenario "Update phone number" do

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
    expect(page).to have_content("Subdomain: c")

    #Expect to do stuff that only admins can do
    expect(page).to have_content("You are an admin user")
    expect(page).to have_content("You can add other users")
    fill_in "user_phone", with: 1122335
    click_button "Update phone"
    expect(page).to have_content("Phone: 1122335")

    #Test logging out
    click_link "Logout"
    expect(page).to have_content("Login")
    expect(page).to have_content("Email:")
    expect(page).to have_content("Password:")

    #log back in and check
    fill_in "email", with: "admin1@c.ca"
    fill_in "password", with: "cccc"
    click_button "Submit"
    expect(page).to have_content("Phone: 1122335")
  end

  scenario "Update phone only affects data in current organization" do
    Capybara.default_host = "http://localhost"
    Capybara.server_port = 3000
    Capybara.app_host = "http://localhost:3000"
    visit root_path
    click_link "New Organization"
    fill_in "organization_name", with: "OrgA"
    fill_in "organization_subdomain", with: "a"
    click_button "Sign up"
    expect(page).to have_content("Organization was successfully created.")

    Capybara.default_host = "http://localhost"
    Capybara.server_port = 3000
    Capybara.app_host = "http://localhost:3000"
    visit root_path
    click_link "New Organization"
    fill_in "organization_name", with: "OrgB"
    fill_in "organization_subdomain", with: "b"
    click_button "Sign up"
    expect(page).to have_content("Organization was successfully created.")

    Capybara.default_host = "http://lvh.me"
    Capybara.server_port = 3000
    Capybara.app_host = "http://a.lvh.me:3000"
    visit root_path
    click_link "Register"
    expect(page).to have_content("There are currently")
    fill_in "user_email", with: "admin1@a.ca"
    fill_in "user_phone", with: 111
    fill_in "user_age", with: 1
    fill_in "user_password", with: "aaaa"
    click_button "Sign up"
    expect(page).to have_content("User was successfully created.")

    Capybara.default_host = "http://lvh.me"
    Capybara.server_port = 3000
    Capybara.app_host = "http://b.lvh.me:3000"
    visit root_path
    click_link "Register"
    expect(page).to have_content("There are currently")
    fill_in "user_email", with: "admin1@a.ca"
    fill_in "user_phone", with: 1112
    fill_in "user_age", with: 1
    fill_in "user_password", with: "aaaa"
    click_button "Sign up"
    expect(page).to have_content("User was successfully created.")

    fill_in "email", with: "admin1@a.ca"
    fill_in "password", with: "aaaa"
    click_button "Submit"
    expect(page).to have_content("Phone: 1112")
    fill_in "user_phone", with: 8889
    click_button "Update phone"
    expect(page).to have_content("Phone: 8889")
    #click_link "Logout"

    Capybara.default_host = "http://lvh.me"
    Capybara.server_port = 3000
    Capybara.app_host = "http://a.lvh.me:3000"
    visit root_path
    click_link "Login"
    fill_in "email", with: "admin1@a.ca"
    fill_in "password", with: "aaaa"
    click_button "Submit"
    expect(page).to have_content("Phone: 111")

  end

end
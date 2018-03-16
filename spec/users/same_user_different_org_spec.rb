require 'rails_helper'

feature "Add users" do
  scenario "add user with same email as admin to OrgA and OrgB" do

    #Expect success to create organization OrgC with subdomain c
    Capybara.default_host = "http://localhost"
    Capybara.server_port = 3000
    Capybara.app_host = "http://localhost:3000"
    visit root_path
    click_link "New Organization"
    fill_in "organization_name", with: "OrgA"
    fill_in "organization_subdomain", with: "a"
    click_button "Sign up"
    expect(page).to have_content("Organization was successfully created.")

    expect(page).to have_content("OrgA")
    expect(page).to have_content("a")
    expect(page).to have_content("Sign up for this organization (Please right click choose to open in new tap)")

    visit root_path
    click_link "New Organization"
    fill_in "organization_name", with: "OrgB"
    fill_in "organization_subdomain", with: "b"
    click_button "Sign up"
    expect(page).to have_content("Organization was successfully created.")

    expect(page).to have_content("OrgB")
    expect(page).to have_content("b")
    expect(page).to have_content("Sign up for this organization (Please right click choose to open in new tap)")

    Capybara.default_host = "http://lvh.me"
    Capybara.server_port = 3000
    Capybara.app_host = "http://a.lvh.me:3000"
    visit '/users/new'
    expect(page).to have_content("There are currently")
    expect(page).to have_content("You are the first one to register to this organization and will be an admin automatically")
    fill_in "user_email", with: "admin1@a.ca"
    fill_in "user_phone", with: 111
    fill_in "user_age", with: 1
    fill_in "user_password", with: "aaaa"
    click_button "Sign up"

    #Expect to be redirected to login
    expect(page).to have_content("Login")
    expect(page).to have_content("Email:")
    expect(page).to have_content("Password:")
    fill_in "email", with: "admin1@a.ca"
    fill_in "password", with: "aaaa"
    click_button "Submit"

    #Expect to see user info just for OrgC
    expect(page).to have_content("admin1@a.ca")
    expect(page).to have_content("111")

    #Expect to do stuff that only admins can do
    expect(page).to have_content("You are an admin user")
    expect(page).to have_content("You can add other users")
    click_on "here"
    expect(page).to have_content("You're admin so you can add other people as admin or regular user")

    #Create the first admin user in OrgB with admin1@a.ca
    Capybara.default_host = "http://lvh.me"
    Capybara.server_port = 3000
    Capybara.app_host = "http://b.lvh.me:3000"
    visit '/users/new'
    expect(page).to have_content("There are currently")
    expect(page).to have_content("You are the first one to register to this organization and will be an admin automatically")
    fill_in "user_email", with: "admin1@a.ca"
    fill_in "user_phone", with: 112
    fill_in "user_age", with: 12
    fill_in "user_password", with: "aaaa"
    click_button "Sign up"

    #Expect to be redirected to login
    expect(page).to have_content("Login")
    expect(page).to have_content("Email:")
    expect(page).to have_content("Password:")
    fill_in "email", with: "admin1@a.ca"
    fill_in "password", with: "aaaa"
    click_button "Submit"

    #Expect to see user info just for OrgC
    expect(page).to have_content("admin1@a.ca")
    expect(page).to have_content("112")
    expect(page).to have_content("12")

    #Go back to OrgA and check info
    Capybara.default_host = "http://lvh.me"
    Capybara.server_port = 3000
    Capybara.app_host = "http://a.lvh.me:3000"
    visit '/login'
    fill_in "email", with: "admin1@a.ca"
    fill_in "password", with: "aaaa"
    click_button "Submit"

    expect(page).to have_content("111")
    expect(page).to have_content("11")
    #Expect to do stuff that only admins can do
    expect(page).to have_content("You are an admin user")
    expect(page).to have_content("You can add other users")
    click_on "here"
    expect(page).to have_content("You're admin so you can add other people as admin or regular user")

  end
end
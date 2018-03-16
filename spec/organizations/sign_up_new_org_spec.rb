require 'rails_helper'

feature "Organizations" do
  scenario "Create new organization" do

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

    #Expect failure trying to recreate OrgC with subdomain c
    visit root_path
    click_link "New Organization"
    fill_in "organization_name", with: "OrgC"
    fill_in "organization_subdomain", with: "c"
    click_button "Sign up"
    expect(page).to have_content("Organization creation fail")
  end

  scenario "Create new organization with empty name" do
    visit root_path
    click_link "New Organization"
    fill_in "organization_name", with: ""
    fill_in "organization_subdomain", with: "d"
    click_button "Sign up"
    expect(page).to have_content("Organization creation fail")
  end

  scenario "Create new organization with empty subdomain" do
    visit root_path
    click_link "New Organization"
    fill_in "organization_name", with: "OrgE"
    fill_in "organization_subdomain", with: ""
    click_button "Sign up"
    expect(page).to have_content("Organization creation fail")
  end

  scenario "Create new organization with long name" do
    visit root_path
    click_link "New Organization"
    fill_in "organization_name", with: "FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF"
    fill_in "organization_subdomain", with: "f"
    click_button "Sign up"
    expect(page).to have_content("Organization creation fail")
  end

  scenario "Create new organization with long subdomain" do
    visit root_path
    click_link "New Organization"
    fill_in "organization_name", with: "OrgF"
    fill_in "organization_subdomain", with: "ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff"
    click_button "Sign up"
    expect(page).to have_content("Organization creation fail")
  end
end
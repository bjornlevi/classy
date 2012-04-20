require 'spec_helper'

describe "Dashboard" do
  describe "Root" do
    it "should have content 'Welcome" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      visit root_path
      page.should have_content('Welcome')
    end
  end

  describe "Help page" do

    it "should have the content 'Help'" do
      visit help_path
      page.should have_content('Help')
    end
  end

  describe "About page" do

    it "should have the content 'About'" do
      visit about_path
      page.should have_content('About')
    end
  end
end

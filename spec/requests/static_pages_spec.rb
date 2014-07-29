require 'spec_helper'

describe "Static pages" do

  subject { page }

  shared_examples_for "all static pages" do
    it { should have_selector('h1', text: heading) }
    it { should have_title(full_title(page_title))}
  end

  describe "Home page" do
    before { visit root_path }
    let(:heading)    { 'Sample App' }
    let(:page_title) { '' }

    it_should_behave_like "all static pages"
    it { should_not have_title("| Home") }

    describe "for signed-in users" do
      let(:user) {FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user: user, content: "Lorem_ip_sum")
        FactoryGirl.create(:micropost, user: user, content: "Dolor_sit_amet")
        sign_in user
        visit root_path
      end

      it "should render the user's feed" do
        user.feed.each do |item| 
          expect(page).to have_selector("li##{item.id}", text: item.content)
        end
      end

      it { should have_selector("aside", text: "#{user.microposts.count} #{"micropost".pluralize(user.microposts.count)}") } 
                                              #pluralize(user.microposts.count, "micropost")

      describe "pagination" do
        before(:all) do
          Micropost.delete_all
          30.times {FactoryGirl.create(:micropost, user: user, content: "Simply_text")}
        end
        after(:all) do
          User.delete_all
          Micropost.delete_all
        end

        it "should list each micropost" do
          Micropost.paginate(page:1).each do |micropost|
            expect(page).to have_selector('li', text: "Simply_text")
          end
        end
      end
    end
  end

  describe "Help page" do
    before { visit help_path }
    let(:heading)    { 'Help' }
    let(:page_title) { 'Help' }

    it_should_behave_like "all static pages"
  end

  describe "About page" do
    before { visit about_path }
    let(:heading)    { 'About Us' }
    let(:page_title) { 'About Us' }

    it_should_behave_like "all static pages"
  end

  describe "Contact page" do
    before { visit contact_path }
    let(:heading)    { 'Contact' }
    let(:page_title) { 'Contact' }

    it_should_behave_like "all static pages"
  end

  it "should have the right links on the layout" do
    visit root_path
    click_link "About"
    expect(page).to have_title(full_title('About Us'))
    click_link "Help"
    expect(page).to have_title(full_title('Help'))
    click_link "Contact"
    expect(page).to have_title(full_title('Contact'))
    click_link "Home"
    click_link "Sign up now!"
    expect(page).to have_title(full_title('Sign up'))
#    click_link "sample app"
#    expect(page).to have_title(full_title('Sign up'))
  end
end

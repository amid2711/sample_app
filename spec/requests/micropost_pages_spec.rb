require 'spec_helper'

describe "MicropostPages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "micropost creation" do
    before { visit root_path }

    describe "with invalid information" do

      it "should not create a micropost" do
        expect { click_button "Post" }.not_to change(Micropost, :count)
      end

      describe "error messages" do
        before { click_button "Post" }
        it { should have_content('error') }
      end
    end

    describe "with valid information" do  

      before { fill_in 'micropost_content', with: "Lorem ipsum" }
      it "should create a micropost" do
        expect { click_button "Post" }.to change(Micropost, :count).by(1)
      end
    end
  end

  describe "micropost destruction" do
    before { FactoryGirl.create(:micropost, user: user) }

    describe "as correct user" do
      before { visit root_path }  

      it "should delete a micropost" do
        expect { click_link "delete" }.to change(Micropost, :count).by(-1)
      end
    end
  end

  describe "microposts list" do
    let(:admin) { FactoryGirl.create(:admin) }    

    describe "should not have link \"delete\" for another user" do   
      let!(:m1) { FactoryGirl.create(:micropost, user: admin, content: "Foo") }   
      before { visit user_path(admin) }
      it { should_not have_link('delete', href: micropost_path(m1)) }
    end

    describe "should have link \"delete\" for itself " do
      let!(:m1) { FactoryGirl.create(:micropost, user: user, content: "Foo") }
      before do
        visit user_path(user)
      end
      it { should have_link('delete', href: micropost_path(m1)) }
    end
  end
end

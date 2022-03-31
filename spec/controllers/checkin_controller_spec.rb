require 'rails_helper'
include FactoryBot::Syntax::Methods

describe CheckinController do
  before do
    # set precondition: sessions, datetime, checkin records
    @stu = create :student
    @expected_time = DateTime.parse("2022-03-08T12:00:00-08:00")
    Timecop.freeze(@expected_time)
    controller.session[:current_user_id] = @stu.id
  end

  describe "POST create" do
    describe ": happy path: " do
      before do
        controller.session[:current_user_id] = @stu.id
        post :create, params: {checkin: { reason: "Studying" }}
        @new_checkin = Checkin.order(id: :desc).first
      end
  
      it "should add 1 new checkin record to the table" do
        expect(Checkin.all.size).to eq(@n_checkin_before + 1)
      end
  
      it "should create a checkin record with correct time" do
        expect(@new_checkin.time).to eq(@expected_time)
      end
  
      it "the new checkin record should belongs to the student in session" do
        expect(@new_checkin.student).to eq(@stu)
      end
    end
    
    describe ": sad path: " do

      it "should redirect user to login if the user haven't log in" do
        controller.session[:current_user_id] = nil
        post :create, params: {checkin: { reason: "Studying" }}
        expect(response).to redirect_to login_path
      end
    end
    
  end
end
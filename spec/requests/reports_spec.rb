require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe "/reports", type: :request do
  # This should return the minimal set of attributes required to create a valid
  # Report. As you add validations to Report, be sure to
  # adjust the attributes here as well.

  let(:spam_attributes) {
    {
      "RecordType": "Bounce",
      "Type": "SpamNotification",
      "TypeCode": 512,
      "Name": "Spam notification",
      "Tag": "",
      "MessageStream": "outbound",
      "Description": "The message was delivered, but was either blocked by the user, or classified as spam, bulk mail, or had rejected content.",
      "Email": "zaphod@example.com",
      "From": "notifications@honeybadger.io",
      "BouncedAt": "2023-02-27T21:41:30Z"
  }
}

let(:other_attributes) {
    {
      "RecordType": "Bounce",
      "MessageStream": "outbound",
      "Type": "HardBounce",
      "TypeCode": 1,
      "Name": "Hard bounce",
      "Tag": "Test",
      "Description": "The server was unable to deliver your message (ex: unknown user, mailbox not found).",
      "Email": "arthur@example.com",
      "From": "notifications@honeybadger.io",
      "BouncedAt": "2019-11-05T16:33:54.9070259Z"
  }
}

  describe "POST /create" do
    context "with spam parameters" do
      it "respond with status 200" do
        post reports_url, params: spam_attributes 
        expect(response).to have_http_status(:ok)
      end
      
      it "sends slack notification" do
        post reports_url, params: spam_attributes 
        expect(response.body).to eq ({ message: "Spam notification sent" }.to_json)
      end
    end

    context "with other parameters" do
      it "respond with status 200" do
        post reports_url, params: other_attributes
        expect(response).to have_http_status(:ok)
      end

      it "doesn't send slack notification" do
        post reports_url, params: other_attributes
        expect(response.body).to eq ({ message: "All good" }.to_json)
      end
    end
  end
  
end

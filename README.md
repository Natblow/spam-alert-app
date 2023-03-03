# Slack Spams Alerts

#### This accepts a JSON payload as a POST request and sends an alert to a Slack channel if the payload matches desired criteria.

On line 17 from the reports controller we have that endpoint that behave that way.

```ruby
#app/controllers/reports_controller.rb

  # POST /reports
  def create
    if params[:Type] == "SpamNotification"
      @slack_notifier.ping("Spam notification for #{params[:Email]}")
      render json: { message: "Spam notification sent" }, status: :ok
    else
      render json: { message: "All good" }, status: :ok 
    end
  end
```

We have our Slack setup this way on the base controller: 

```ruby
require 'slack-notifier'

class ApplicationController < ActionController::API
    before_action :set_slack_notifier

    private 

    def set_slack_notifier
        @slack_notifier = Slack::Notifier.new(
            Rails.application.credentials.dig(:slack, :webhook_url),
            channel: '#application',
            username: 'alert_bot'
        )
    end
end
```
If you want to set up your own you have to get your webhook_url on https://api.slack.com/apps .


To do a **POST request** to that endpoint, you can use any front-end frameworks such as Vue, React etc. 
Or here you can run the rake task that will do the post request from our CLI : 

```bash
rake send:payload
```

And you should get a Slack alert if it got a spam notification.

Here is our code for the Rake task, it will send either a spam parameters or an other parameters :

```rake
namespace :send do
    desc 'send post request to report controller'
    task :payload => :environment do
        url = Rails.env.development? ? 'http://localhost:3000/reports' : 'https://alert-api-app.onrender.com/reports'
        uri = URI(url)
        payload = JSON.parse(Rails.root.join('lib/payloads.json').read)
        params = payload['payloads'][rand(0..1)]
        response = Net::HTTP.post_form(uri, params)

        puts response.body if response.is_a?(Net::HTTPSuccess)
    end
end
```

## Usage 

### Prequisite to run locally :

Ruby version: 3.1.2

Database: postgresql

#### Clone the Application

```bash
git clone git@github.com:Natblow/spam-alert-app.git
```

#### Setup

```
bin/setup
```

#### Start the Rails server

```
bin/rails s
```

### Deploy 

Login or SignUp on https://render.com/

Click on the "New" button on the top right from your dashboard.

![image](https://user-images.githubusercontent.com/85266997/222637516-1553e777-4461-4c26-a12c-b0fa1c29b25f.png)

**Select Web Services** . Then you can put this repo url or your own.

Make sure to have the environment variables on render as such :

```bash
RACK_ENV = production
```

```bash
RAILS_ENV = production
```

```bash
SECRET_KEY_BASE = 'somethingsomething' 
``` 
(You can see your secret key base with the command `Rails credentials:edit`)

On the build command, we only need `bundle install` ![image](https://user-images.githubusercontent.com/85266997/222730894-ba2cc17b-d518-400a-8f98-2ffd8f03fe30.png)



## Tests

Run 

```bash
rspec spec/requests
```

You should get 4 tests pass successfully.

![image](https://user-images.githubusercontent.com/85266997/222638992-fa7d135d-10a5-487b-986b-3b8845cdc99d.png)

This is our code for testing :

```ruby
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
```

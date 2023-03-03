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

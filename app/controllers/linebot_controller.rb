class LinebotController < ApplicationController
  require 'line/bot'  # gem 'line-bot-api'

  # callbackアクションのCSRFトークン認証を無効
  protect_from_forgery :except => [:callback]

  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
  end

  def callback
    body = request.body.read
    signature = request.env['HTTP_X_LINE_SIGNATURE']

    # unless client.validate_signature(body, signature)
    #   error 400 do 'Bad Request' end
    # end

    events = client.parse_events_from(body)

    events.each do |event|
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          message = {
            type: 'text',
            text: event.message['text']
          }
          carousel = {
            "type": "carousel",
            "contents": [
              {
                "type": "bubble",
                "body": {
                  "type": "box",
                  "layout": "vertical",
                  "contents": [
                    {
                      "type": "text",
                      "text": "First bubble"
                    }
                  ]
                }
              },
              {
                "type": "bubble",
                "body": {
                  "type": "box",
                  "layout": "vertical",
                  "contents": [
                    {
                      "type": "text",
                      "text": "Second bubble"
                    }
                  ]
                }
              }
            ]
          }
          client.push_message(event['source']['groupId'], message)
        end
      end
    end

    head :ok
  end

  def call
    pp '@@@@@@@@@@@@@@@@@@@@@@@@@'
    body = request.body.read
    values = body.split(',')
    keys = ['temp', 'desc', 'min', 'max', 'humidity']
    params = Hash[*[keys, values].transpose.flatten]
    pp params
    pp '@@@@@@@@@@@@@@@@@@@@@@@@@'


    carousel = {
      "type": "carousel",
      "contents": [
        {
          "type": "bubble",
          "body": {
            "type": "box",
            "layout": "vertical",
            "contents": [
              {
                "type": "text",
                "text": "First bubble"
              }
            ]
          }
        },
        {
          "type": "bubble",
          "body": {
            "type": "box",
            "layout": "vertical",
            "contents": [
              {
                "type": "text",
                "text": "Second bubble"
              }
            ]
          }
        }
      ]
    }
    
    client.push_message('C5b56a06f5b1bd3c971785bf6e3f970cd', carousel)
    
    head :ok
  end
end

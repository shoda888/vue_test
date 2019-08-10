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
            "type": "bubble",
            "body": {
              "type": "box",
              "layout": "vertical",
              "contents": [
                {
                  "type": "text",
                  "text": "今日の東京の天気",
                  "weight": "bold",
                  "gravity": "center",
                  "size": "xl"
                }
              ]
            }
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

    message = {
      type: 'text',
      text: "現在の気温#{params['temp']}℃"
    }

    card = {
      "type": "bubble",
      "body": {
        "type": "box",
        "layout": "vertical",
        "contents": [
          {
            "type": "text",
            "text": "今日の東京の天気",
            "weight": "bold",
            "gravity": "center",
            "size": "xl"
          },
          {
            "type": "text",
            "text": "#{params['desc']}"
          },
          {
            "type": "text",
            "text": "#{params['temp']}"
          },
          {
            "type": "text",
            "text": "#{params['max']}"
          },
          {
            "type": "text",
            "text": "#{params['min']}"
          },
          {
            "type": "text",
            "text": "#{params['humidity']}"
          }
        ]
      }
    }
    card2 = {  
      "type": "flex",
      "altText": "this is a flex message",
      "contents": {
        "type": "bubble",
        "body": {
          "type": "box",
          "layout": "vertical",
          "contents": [
            {
              "type": "text",
              "text": "今日の東京の天気",
              "weight": "bold",
              "gravity": "center",
              "size": "xl"
            },
            {
              "type": "text",
              "text": "#{params['desc']}"
            },
            {
              "type": "text",
              "text": "#{params['temp']}"
            },
            {
              "type": "text",
              "text": "#{params['max']}"
            },
            {
              "type": "text",
              "text": "#{params['min']}"
            },
            {
              "type": "text",
              "text": "#{params['humidity']}"
            }
          ]
        }
      }
    }
    
    client.push_message('C5b56a06f5b1bd3c971785bf6e3f970cd', message)
    client.push_message('C5b56a06f5b1bd3c971785bf6e3f970cd', card2)
    
    head :ok
  end
end

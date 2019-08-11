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
      "type": "flex",
      "altText": "this is a flex message",
      "contents": {
        "type": "bubble",
        "styles": {
          "footer": {
            "separator": true
          }
        },
        "body": {
          "type": "box",
          "layout": "vertical",
          "contents": [
            {
              "type": "text",
              "text": "RECEIPT",
              "weight": "bold",
              "color": "#1DB446",
              "size": "sm"
            },
            {
              "type": "text",
              "text": "Brown Store",
              "weight": "bold",
              "size": "xxl",
              "margin": "md"
            },
            {
              "type": "text",
              "text": "Miraina Tower, 4-1-6 Shinjuku, Tokyo",
              "size": "xs",
              "color": "#aaaaaa",
              "wrap": true
            },
            {
              "type": "separator",
              "margin": "xxl"
            },
            {
              "type": "box",
              "layout": "vertical",
              "margin": "xxl",
              "spacing": "sm",
              "contents": [
                {
                  "type": "box",
                  "layout": "horizontal",
                  "contents": [
                    {
                      "type": "text",
                      "text": "Energy Drink",
                      "size": "sm",
                      "color": "#555555",
                      "flex": 0
                    },
                    {
                      "type": "text",
                      "text": "$2.99",
                      "size": "sm",
                      "color": "#111111",
                      "align": "end"
                    }
                  ]
                },
                {
                  "type": "box",
                  "layout": "horizontal",
                  "contents": [
                    {
                      "type": "text",
                      "text": "Chewing Gum",
                      "size": "sm",
                      "color": "#555555",
                      "flex": 0
                    },
                    {
                      "type": "text",
                      "text": "$0.99",
                      "size": "sm",
                      "color": "#111111",
                      "align": "end"
                    }
                  ]
                },
                {
                  "type": "box",
                  "layout": "horizontal",
                  "contents": [
                    {
                      "type": "text",
                      "text": "Bottled Water",
                      "size": "sm",
                      "color": "#555555",
                      "flex": 0
                    },
                    {
                      "type": "text",
                      "text": "$3.33",
                      "size": "sm",
                      "color": "#111111",
                      "align": "end"
                    }
                  ]
                },
                {
                  "type": "separator",
                  "margin": "xxl"
                },
                {
                  "type": "box",
                  "layout": "horizontal",
                  "margin": "xxl",
                  "contents": [
                    {
                      "type": "text",
                      "text": "ITEMS",
                      "size": "sm",
                      "color": "#555555"
                    },
                    {
                      "type": "text",
                      "text": "3",
                      "size": "sm",
                      "color": "#111111",
                      "align": "end"
                    }
                  ]
                },
                {
                  "type": "box",
                  "layout": "horizontal",
                  "contents": [
                    {
                      "type": "text",
                      "text": "TOTAL",
                      "size": "sm",
                      "color": "#555555"
                    },
                    {
                      "type": "text",
                      "text": "$7.31",
                      "size": "sm",
                      "color": "#111111",
                      "align": "end"
                    }
                  ]
                },
                {
                  "type": "box",
                  "layout": "horizontal",
                  "contents": [
                    {
                      "type": "text",
                      "text": "CASH",
                      "size": "sm",
                      "color": "#555555"
                    },
                    {
                      "type": "text",
                      "text": "$8.0",
                      "size": "sm",
                      "color": "#111111",
                      "align": "end"
                    }
                  ]
                },
                {
                  "type": "box",
                  "layout": "horizontal",
                  "contents": [
                    {
                      "type": "text",
                      "text": "CHANGE",
                      "size": "sm",
                      "color": "#555555"
                    },
                    {
                      "type": "text",
                      "text": "$0.69",
                      "size": "sm",
                      "color": "#111111",
                      "align": "end"
                    }
                  ]
                }
              ]
            },
            {
              "type": "separator",
              "margin": "xxl"
            },
            {
              "type": "box",
              "layout": "horizontal",
              "margin": "md",
              "contents": [
                {
                  "type": "text",
                  "text": "PAYMENT ID",
                  "size": "xs",
                  "color": "#aaaaaa",
                  "flex": 0
                },
                {
                  "type": "text",
                  "text": "#743289384279",
                  "color": "#aaaaaa",
                  "size": "xs",
                  "align": "end"
                }
              ]
            }
          ]
        }
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
    
    client.push_message('C5b56a06f5b1bd3c971785bf6e3f970cd', card)
    client.push_message('C5b56a06f5b1bd3c971785bf6e3f970cd', card2)
    
    head :ok
  end
end

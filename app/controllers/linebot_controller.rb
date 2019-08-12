class LinebotController < ApplicationController
  require 'line/bot'  # gem 'line-bot-api'

  # callbackアクションのCSRFトークン認証を無効
  protect_from_forgery :except => [:callback]

  def client
    @client ||= Line::Bot::Client.new { |config|
      # config.channel_secret = '5b92adcfaa71cbc059b1b9fc623e106e'
      # config.channel_token = 'JuS18Th43UGvMlf3L+6Yff7jjVCm2BmZxvLcl3IvxcydA1tzESvWfK86xUe21uErJawmEV02tHOC8K5hNauFMZ0GvWQRGU+/4SScG+htauT2Q2p7rjSGnOo7trX/WWu4nLzil2VA6KHZwJzb/37LkQdB04t89/1O/w1cDnyilFU='
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
    # pp '@@@@@@@@@@@@@@@@@@@@@@@@@'
    # # body = request.body.read
    # # pp params['temp']
    # # values = body.split(',')
    # # keys = ['temp', 'desc', 'min', 'max', 'humidity', 'area']
    # # params = Hash[*[keys, values].transpose.flatten]
    # # pp params
    # pp '@@@@@@@@@@@@@@@@@@@@@@@@@'
    # @weather = Weather.new(area: params['area'], temp: params['temp'], description: params['desc'], max_temp: params['max'], min_temp: params['min'], humidity: params['humidity'])
    # @weather.save
    # head :ok
    head :ok
  end

  def push
    3.times.each do |n|
      params["time#{n}"] = (Time.parse(params["time#{n}"]) + 9.hours).to_s(:db)
    end
    client.push_message('C5b56a06f5b1bd3c971785bf6e3f970cd', carousel(params['area'], params['time0'], params['temp0'], params['humidity0'], params['description0'], params['time1'], params['temp1'], params['humidity1'], params['description1'], params['time2'], params['temp2'], params['humidity2'], params['description2']))
    head :ok
  end

  private

  def carousel(area, time0, temp0, humidity0, desc0, time1, temp1, humidity1, desc1, time2, temp2, humidity2, desc2)
    {
      "type": "flex",
      "altText": "this is a flex message",
      "contents": {
        "type": "carousel",
        "contents": [
          {
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
                  "text": "#{area}の天気",
                  "weight": "bold",
                  "color": "#1DB446",
                  "size": "xl"
                },
                {
                  "type": "text",
                  "text": "#{desc0}",
                  "weight": "bold",
                  "size": "xl",
                  "margin": "md"
                },
                {
                  "type": "text",
                  "text": "#{time0}",
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
                          "text": "気温",
                          "size": "sm",
                          "color": "#555555",
                          "flex": 0
                        },
                        {
                          "type": "text",
                          "text": "#{temp0}℃",
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
                          "text": "湿度",
                          "size": "sm",
                          "color": "#555555"
                        },
                        {
                          "type": "text",
                          "text": "#{humidity0}",
                          "size": "sm",
                          "color": "#111111",
                          "align": "end"
                        }
                      ]
                    }
                  ]
                }
              ]
            }
          },
          {
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
                  "text": "#{area}の天気",
                  "weight": "bold",
                  "color": "#1DB446",
                  "size": "xl"
                },
                {
                  "type": "text",
                  "text": "#{desc1}",
                  "weight": "bold",
                  "size": "xl",
                  "margin": "md"
                },
                {
                  "type": "text",
                  "text": "#{time1}",
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
                          "text": "気温",
                          "size": "sm",
                          "color": "#555555",
                          "flex": 0
                        },
                        {
                          "type": "text",
                          "text": "#{temp1}℃",
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
                          "text": "湿度",
                          "size": "sm",
                          "color": "#555555"
                        },
                        {
                          "type": "text",
                          "text": "#{humidity1}",
                          "size": "sm",
                          "color": "#111111",
                          "align": "end"
                        }
                      ]
                    }
                  ]
                }
              ]
            }
          },
          {
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
                  "text": "#{area}の天気",
                  "weight": "bold",
                  "color": "#1DB446",
                  "size": "xl"
                },
                {
                  "type": "text",
                  "text": "#{desc2}",
                  "weight": "bold",
                  "size": "xl",
                  "margin": "md"
                },
                {
                  "type": "text",
                  "text": "#{time2}",
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
                          "text": "気温",
                          "size": "sm",
                          "color": "#555555",
                          "flex": 0
                        },
                        {
                          "type": "text",
                          "text": "#{temp2}℃",
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
                          "text": "湿度",
                          "size": "sm",
                          "color": "#555555"
                        },
                        {
                          "type": "text",
                          "text": "#{humidity2}",
                          "size": "sm",
                          "color": "#111111",
                          "align": "end"
                        }
                      ]
                    }
                  ]
                }
              ]
            }
          }
        ]
      }
    }
  end

end

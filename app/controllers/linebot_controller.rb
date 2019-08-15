class LinebotController < ApplicationController
  require 'line/bot'  # gem 'line-bot-api'
  require 'rake'

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
          
          if event.message['text'] == '東京の天気'
            ENV['token'] = event['replyToken']
            Rails.application.load_tasks
            Rake::Task['tokyo_weather'].execute
            Rake::Task['tokyo_weather'].clear
          elsif event.message['text'] == '上海の天気'
            ENV['token'] = event['replyToken']
            Rails.application.load_tasks
            Rake::Task['shanghai_weather'].execute
            Rake::Task['shanghai_weather'].clear
          end
        end
      end
    end

    head :ok
  end

  def push
    if params[:area] == 'Tokyo'
      params[:area] = '東京'
      params[:cnt].to_i.times.each do |n|
        params["time#{n}"] = (Time.parse(params["time#{n}"]) + 9.hours).to_s(:db)
      end
    elsif params[:area] == 'Shanghai'
      params[:area] = '上海'
      params[:cnt].to_i.times.each do |n|
        params["time#{n}"] = (Time.parse(params["time#{n}"]) + 8.hours).to_s(:db)
      end
    end
    client.reply_message(params['token'], carousel(params['area'], params['time0'], params['temp0'], params['humidity0'], params['icon0'], params['time1'], params['temp1'], params['humidity1'], params['icon1'], params['time2'], params['temp2'], params['humidity2'], params['icon2'], params['time3'], params['temp3'], params['humidity3'], params['icon3'], params['time4'], params['temp4'], params['humidity4'], params['icon4']))
    head :ok
  end

  def push_family
    params[:area] = '東京'
    params[:cnt].to_i.times.each do |n|
      params["time#{n}"] = (Time.parse(params["time#{n}"]) + 9.hours).to_s(:db)
    end
    if params[:temp0].to_i >= 30
      message = {
        type: 'text',
        text: '暑いよー'
      }
      client.push_message('C5b56a06f5b1bd3c971785bf6e3f970cd', message)
      # client.push_message('C0f109e7936999f32d0f7fbc696b8ca55', message)
    end
    client.push_message('C5b56a06f5b1bd3c971785bf6e3f970cd', carousel(params['area'], params['time0'], params['temp0'], params['humidity0'], params['icon0'], params['time1'], params['temp1'], params['humidity1'], params['icon1'], params['time2'], params['temp2'], params['humidity2'], params['icon2'], params['time3'], params['temp3'], params['humidity3'], params['icon3'], params['time4'], params['temp4'], params['humidity4'], params['icon4']))
    # client.push_message('C0f109e7936999f32d0f7fbc696b8ca55', carousel(params['area'], params['time0'], params['temp0'], params['humidity0'], params['icon0'], params['time1'], params['temp1'], params['humidity1'], params['icon1'], params['time2'], params['temp2'], params['humidity2'], params['icon2'], params['time3'], params['temp3'], params['humidity3'], params['icon3'], params['time4'], params['temp4'], params['humidity4'], params['icon4']))
    head :ok
  end

  private

  def carousel(area, time0, temp0, humidity0, icon0, time1, temp1, humidity1, icon1, time2, temp2, humidity2, icon2, time3, temp3, humidity3, icon3, time4, temp4, humidity4, icon4)
    {
      "type": "flex",
      "altText": "お天気情報",
      "contents": {
        "type": "carousel",
        "contents": [
          {
            "type": "bubble",
            "header": {
              "type": "box",
              "layout": "vertical",
              "contents": [
                {
                  "type": "text",
                  "text": "#{area}の天気",
                  "weight": "bold",
                  "color": "#1DB446",
                  "size": "xl"
                }
              ]
            },
            "hero": {
              "type": "image",
              "url": "https://openweathermap.org/img/w/#{icon0}.png"
            },
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
                          "text": "#{humidity0}%",
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
            "header": {
              "type": "box",
              "layout": "vertical",
              "contents": [
                {
                  "type": "text",
                  "text": "#{area}の天気",
                  "weight": "bold",
                  "color": "#1DB446",
                  "size": "xl"
                }
              ]
            },
            "hero": {
              "type": "image",
              "url": "https://openweathermap.org/img/w/#{icon1}.png"
            },
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
                          "text": "#{humidity1}%",
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
            "header": {
              "type": "box",
              "layout": "vertical",
              "contents": [
                {
                  "type": "text",
                  "text": "#{area}の天気",
                  "weight": "bold",
                  "color": "#1DB446",
                  "size": "xl"
                }
              ]
            },
            "hero": {
              "type": "image",
              "url": "https://openweathermap.org/img/w/#{icon2}.png"
            },
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
                          "text": "#{humidity2}%",
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
            "header": {
              "type": "box",
              "layout": "vertical",
              "contents": [
                {
                  "type": "text",
                  "text": "#{area}の天気",
                  "weight": "bold",
                  "color": "#1DB446",
                  "size": "xl"
                }
              ]
            },
            "hero": {
              "type": "image",
              "url": "https://openweathermap.org/img/w/#{icon3}.png"
            },
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
                  "text": "#{time3}",
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
                          "text": "#{temp3}℃",
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
                          "text": "#{humidity3}%",
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
            "header": {
              "type": "box",
              "layout": "vertical",
              "contents": [
                {
                  "type": "text",
                  "text": "#{area}の天気",
                  "weight": "bold",
                  "color": "#1DB446",
                  "size": "xl"
                }
              ]
            },
            "hero": {
              "type": "image",
              "url": "https://openweathermap.org/img/w/#{icon4}.png"
            },
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
                  "text": "#{time4}",
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
                          "text": "#{temp4}℃",
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
                          "text": "#{humidity4}%",
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

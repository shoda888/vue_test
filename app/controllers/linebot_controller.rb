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
          # message = {
          #   type: 'text',
          #   text: event.message['text']
          # }
          # client.reply_message(event['replyToken'], message)
          message = {
            type: 'text',
            text: '散歩開始'
          }
          pp event['source']['groupId']
          client.push_message('C5b56a06f5b1bd3c971785bf6e3f970cd', message)
        end
      end
    end

    head :ok
  end

  def call
    body = request.body.read
    signature = request.env['HTTP_X_LINE_SIGNATURE']

    # unless client.validate_signature(body, signature)
    #   error 400 do 'Bad Request' end
    # end
    events = client.parse_events_from(body)
    events.each { |event|
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          message = {
            type: 'text',
            text: event.message['text']
          }
          client.reply_message(event['replyToken'], message)
          # message = {
          #   type: 'text',
          #   text: '散歩開始'
          # }
          # pp event['source']['groupId']
          # client.push_message('C5b56a06f5b1bd3c971785bf6e3f970cd'), message)
          # client.push_message(event['source']['groupId'], message)
        end
      end
    }
    

    head :ok
  end
end

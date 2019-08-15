
task :tokyo_weather => :environment do
    require 'net/http'
    require 'uri'
    require 'json'
    require 'logger'

    # [ロガー]
    # カレントディレクトリのwebapi.logというファイルに出力
    logger = Logger.new('./webapi.log')

    # [クエリパラメータ]
    # URI.encode_www_formを使って「application/x-www-form-urlencoded」形式の文字列に変換
    # 文字列はURLエンコードされた形式に変換（半角スペースの"+"への変換等）
    #
    # （変換例）
    # 'bar baz' => 'bar+baz'
    # 'あ' => '%E3%81%82'
    params = URI.encode_www_form({ appid: 'ec1fbefcc87ce0258cb250ff7777eb84', q: 'Tokyo' , units: 'metric', cnt: '5' })

    # [URI]
    # URI.parseは与えられたURIからURI::Genericのサブクラスのインスタンスを返す
    # -> 今回はHTTPプロトコルなのでURI::HTTPクラスのインスタンスが返される
    #
    # オブジェクトからは以下のようにして構成要素を取得できる
    # uri.scheme => 'http'
    # uri.host   => 'mogulla3.com'
    # uri.port   => 4567
    # uri.path   => ''
    # uri.query  => 'param1=foo&param2=bar+baz&param3=%E3%81%82'
    uri = URI.parse("http://api.openweathermap.org/data/2.5/forecast?#{params}")

    begin
    # [GETリクエスト]
    # Net::HTTP.startでHTTPセッションを開始する
    # 既にセッションが開始している場合はIOErrorが発生
    response = Net::HTTP.start(uri.host, uri.port) do |http|
        # Net::HTTP.open_timeout=で接続時に待つ最大秒数の設定をする
        # タイムアウト時はTimeoutError例外が発生
        http.open_timeout = 5

        # Net::HTTP.read_timeout=で読み込み1回でブロックして良い最大秒数の設定をする
        # デフォルトは60秒
        # タイムアウト時はTimeoutError例外が発生
        http.read_timeout = 10

        # Net::HTTP#getでレスポンスの取得
        # 返り値はNet::HTTPResponseのインスタンス
        http.get(uri.request_uri)
    end

    # [レスポンス処理]
    # 2xx系以外は失敗として終了することにする
    # ※ リダイレクト対応できると良いな..
    #
    # ステータスコードに応じてレスポンスのクラスが異なる
    # 1xx系 => Net::HTTPInformation
    # 2xx系 => Net::HTTPSuccess
    # 3xx系 => Net::HTTPRedirection
    # 4xx系 => Net::HTTPClientError
    # 5xx系 => Net::HTTPServerError
    
    case response
    # 2xx系
    when Net::HTTPSuccess
        # [JSONパース処理]
        # JSONオブジェクトをHashへパースする
        # JSON::ParserErrorが発生する可能性がある
        body = JSON.parse(response.body)
        params2 = URI.encode_www_form(
            { 
                area: body['city']['name'],
                cnt: body['cnt'],
                token: ENV['token'],
                time0: body['list'][0]['dt_txt'],
                temp0: body['list'][0]['main']['temp'],
                humidity0: body['list'][0]['main']['humidity'],
                icon0: body['list'][0]['weather'][0]['icon'],
                time1: body['list'][1]['dt_txt'],
                temp1: body['list'][1]['main']['temp'],
                humidity1: body['list'][1]['main']['humidity'],
                icon1: body['list'][1]['weather'][0]['icon'],
                time2: body['list'][2]['dt_txt'],
                temp2: body['list'][2]['main']['temp'],
                humidity2: body['list'][2]['main']['humidity'],
                icon2: body['list'][2]['weather'][0]['icon'],
                time3: body['list'][3]['dt_txt'],
                temp3: body['list'][3]['main']['temp'],
                humidity3: body['list'][3]['main']['humidity'],
                icon3: body['list'][4]['weather'][0]['icon'],
                time4: body['list'][4]['dt_txt'],
                temp4: body['list'][4]['main']['temp'],
                humidity4: body['list'][4]['main']['humidity'],
                icon4: body['list'][4]['weather'][0]['icon']
            })

        uri2 = URI.parse("http://kina-bot.herokuapp.com/push?#{params2}")
        # uri2 = URI.parse("http://00a42747.ngrok.io/push?#{params2}")

        response = Net::HTTP.start(uri2.host, uri2.port) do |http|
            # Net::HTTP.open_timeout=で接続時に待つ最大秒数の設定をする
            # タイムアウト時はTimeoutError例外が発生
            http.open_timeout = 5
            logger.warn('redirect')
            # Net::HTTP.read_timeout=で読み込み1回でブロックして良い最大秒数の設定をする
            # デフォルトは60秒
            # タイムアウト時はTimeoutError例外が発生
            http.read_timeout = 10
    
            # Net::HTTP#getでレスポンスの取得
            # 返り値はNet::HTTPResponseのインスタンス
            http.get(uri2.request_uri)
        end
    # 3xx系
    when Net::HTTPRedirection
        # リダイレクト先のレスポンスを取得する際は
        # response['Location']でリダイレクト先のURLを取得してリトライする必要がある
        logger.warn("Redirection: code=#{response.code} message=#{response.message}")
    else
        logger.error("HTTP ERROR: code=#{response.code} message=#{response.message}")
    end

    # [エラーハンドリング]
    # 各種処理で発生しうるエラーのハンドリング処理
    # 各エラーごとにハンドリング処理が書けるようにrescue節は小さい単位で書く
    # (ここでは全て同じ処理しか書いていない)
    rescue IOError => e
    logger.error(e.message)
    rescue TimeoutError => e
    logger.error(e.message)
    rescue JSON::ParserError => e
    logger.error(e.message)
    rescue => e
    logger.error(e.message)
    end
end
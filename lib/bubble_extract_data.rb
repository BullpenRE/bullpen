class Bubble_extract_data
    def initialize(type)
        @type = type
    end

    # def request_users
    #     users = request(1)
    #     body = JSON.parse(users.body)
        
    #     if users.success?
    #         upload_users(body)
    #     else 
    #         "#{body["statusCode"]}: #{body["body"]["status"]} -- #{body["body"]["message"]}"
    #     end
    # end

    def retrieve(cursor=0)

    end

    def retrieve_all

    end

    def process

    end

    def find_by(field, value)
        
    end

    private
    def client
        connection ||= Faraday.new(
            url: ENV['BUBBLE_API_URL']
        )
    end

    def request(cursor=0)
        response = client.get(@type) do |req|
          req.params['cursor'] = cursor
        end
    end
end
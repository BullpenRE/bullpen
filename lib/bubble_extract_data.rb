class Bubble_extract_data
    @data = []

    def initialize(type)
        @type = type
    end

    def retrieve(cursor=0)
        call = request(cursor)
        body = JSON.parse(call.body)
        raw_data = body['response']['results']

        if call.success? && raw_data.length
            @data = raw_data
            return true
        else
            return false
        end
    end

    def retrieve_all
        @data = []
        return repeat_request(0)
    end

    def process
        
    end

    def find_by(field, value)

    end

    def view_data 
        @data
    end

    private
    def client
        connection = Faraday.new(
            url: ENV['BUBBLE_API_URL']
        )
    end

    def request(cursor=0)
        response = client.get(@type) do |req|
          req.params['cursor'] = cursor
        end
    end

    # recursively call the API until all results for desired obj are retrieved
    def repeat_request(cursor)
        call = request(cursor)
        body = JSON.parse(call.body)
        raw_data = body['response']['results']
        
        if call.success? && raw_data.length != 0 # check if the call was successfull and there are results
            @data = @data.concat(raw_data)
            remaining = body['response']['remaining']
            return repeat_request(cursor + 100) if remaining
        elsif call.success? && raw_data.length == 0 # catch for when the call is successfull and there are no further results
            return true
        else
            return false
        end
    end
end
class Bubble_extract_data
    # request a list of users from the API
    # if successful, upload the contents into the app
    # if not, display the error message
    def request_users
        users = request('user')
        body = JSON.parse(users.body)
        
        if users.success? # .success is a Faraday method
            upload_users(body)
        else 
            "#{body["statusCode"]}: #{body["body"]["status"]} -- #{body["body"]["message"]}"
        end
    end

    #TODO
    # once a successful API response is received, go through the object to upload it's contents
    def upload_users(users_body)
        users_body
    end
        
    private  
    def request(type)
        # using the Faraday gem, make a get request to a specified type through the Bubble API 
        response = Faraday.get ENV['BUBBLE_API_URL'] + type
    end
end
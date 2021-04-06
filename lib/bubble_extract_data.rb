# frozen_string_literal: true

class BubbleExtractData
  @api_results = []
  @data = {}

  def initialize(type)
    @type = type
  end

  def retrieve(cursor=0)
    call = request(cursor)
    body = JSON.parse(call.body)
    raw_data = body['response']['results']

    if call.success? && raw_data.length
      @api_results = raw_data
      return true
    else
      return false
    end
  end

  def retrieve_all
    @api_results = []
    return repeat_request(0)
  end

  def process
    return false if !@api_results

    hash = {}
    @api_results.map do |entry|
      id = entry["_id"]
      hash[id] = clean_hash(entry)
    end

    @data = hash
    return true
  end

  def find_by(field, value)
    return false if !@data

    @data.each do |k,v|
      result = v.find{|h_k,h_v| h_k == field and h_v == value}
      if result != nil
        return @data[k] if result.size > 0
      end
    end
    return false
  end

  def data 
    @data
  end

  def results
    @api_results
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
      @api_results = @api_results.concat(raw_data)
      remaining = body['response']['remaining']
      return repeat_request(cursor + 100) if remaining
    elsif call.success? && raw_data.length == 0 # catch for when the call is successfull and there are no further results
      return true
    else
      return false
    end
  end

    # flattens nested hashes and removes keys that include "discontinued"
  def clean_hash(hash)
    hash.each_with_object({}) do |(k, v), h|
      next if k =~ /discontinued/
      if v.is_a? Hash
        clean_hash(v).map do |h_k, h_v|
          h[h_k] = h_v
        end
      else
        h[k] = v
      end
    end
  end
end
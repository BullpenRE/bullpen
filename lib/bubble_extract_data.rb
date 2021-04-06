# frozen_string_literal: true

class BubbleExtractData
  attr_reader :data, :results

  def initialize(type)
    @data = {}
    @results = []
    @type = type
  end

  def retrieve(cursor = 0)
    call = request(cursor)
    return false unless call.success?

    body = JSON.parse(call.body)
    @results = body['response']['results']

    @results.length > 0
  end

  def retrieve_all
    @results = []
    return repeat_request(0)
  end

  def process
    return false unless @results

    hash = {}
    @results.map do |entry|
      id = entry["_id"]
      hash[id] = clean_hash(entry)
    end

    @data = hash
    return true
  end

  def find_by(field, value)
    return false unless @data

    @data.each do |k,v|
      result = v.find{|h_k,h_v| h_k == field and h_v == value}
      if result != nil
        return @data[k] if result.size > 0
      end
    end
    return false
  end

  private

  def client
    connection = Faraday.new(
      url: ENV['BUBBLE_API_URL']
    )
  end

  def request(cursor = 0)
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
      @results = @results.concat(raw_data)
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
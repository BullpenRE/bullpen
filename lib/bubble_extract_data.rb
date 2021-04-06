# frozen_string_literal: true

# Sample Use Instructions
# > service = BubbleExtractData.new('User')
# > service.retrieve # (or service.retrieve_all)
# > service.process
# > bubble_user = service.results.sample
# > user = User.find_by(email: bubble_user['authentication']['email']['email'])
# > user.update(id_bubble: bubble_user['_id'])
#
# > abe_user = User.find_by(email: 'abe@something.com')
# > abe_bubble_user_data = service.lookup(abe_user.id_bubble)
# > abe_user.update(first_name: abe_bubble_user_data['First Name'], last_name: abe_bubble_user_data['Last Name'])

class BubbleExtractData
  attr_reader :lookup, :results, :total_calls

  def initialize(type)
    @lookup = {}
    @results = []
    @type = type
    @total_calls = 0
  end

  def retrieve(cursor = 0)
    @total_calls += 1
    call = request(cursor)
    return false unless call.success?

    body = JSON.parse(call.body)
    @results = body['response']['results']

    @results.length.positive?
  end

  def retrieve_all
    repeat_request(0)
  end

  def process
    return false unless @results

    hash = {}
    @results.each do |entry|
      id = entry['_id']
      hash[id] = clean_hash(entry)
    end

    @lookup = hash
    true
  end

  def find_by(field, value)
    return false unless @lookup

    @lookup.each do |k, v|
      result = v.find { |h_k, h_v| h_k == field and h_v == value }
      unless result.nil?
        return @lookup[k] if result.size.positive?
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
    @total_calls += 1
    call = request(cursor)
    body = JSON.parse(call.body)
    raw_data = body['response']['results']
    return false unless call.success?
    return true if raw_data.length.zero?

    @results = @results.concat(raw_data)
    remaining = body['response']['remaining']

    return repeat_request(cursor + 100) if remaining
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

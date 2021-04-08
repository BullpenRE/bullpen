# frozen_string_literal: true

# Sample Use Instructions
# > user_service = BubbleExtractData.new('User')
# > user_service.retrieve_all
# > user_service.process
# > bubble_user = service.results.sample
# > user = User.find_by(email: bubble_user['authentication']['email']['email'])
# > user.update(id_bubble: bubble_user['_id'])
#
# > freelancer_service = BubbleExtractData.new('Freelancer')
# > freelancer_service.retrieve_all
# > freelancer_service.process(lookup_key: 'User')
# >

class BubbleExtractData
  attr_reader :lookup, :results, :total_calls, :keys, :lookup_key

  def initialize(type)
    return false unless type

    @lookup = {}
    @results = []
    @bubble_table = type
    @total_calls = 0
    @keys = []
  end

  def retrieve(cursor = 0)
    return false unless @bubble_table

    @total_calls += 1
    call = request(cursor)
    puts "#{@bubble_table} not found on Bubble" if call.status == 404
    return false unless call.success?

    body = JSON.parse(call.body)
    @results = body['response']['results']

    puts 'No results found' unless @results.length.positive?
    @results.length.positive?
  end

  def retrieve_all
    repeat_request(0)
  end

  def process(lookup_key: '_id')
    @lookup_key = lookup_key
    @lookup = {}
    return false unless @results

    hash = {}
    ids = []
    @results.each do |entry|
      clean_entry = clean_hash(entry)
      id = clean_entry[lookup_key]
      hash[id] = clean_entry
      ids << id
    end

    @lookup = hash
    @keys = ids.uniq
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

    false
  end

  def sample
    lookup[keys.sample]
  end

  private

  def client
    connection = Faraday.new(
      url: ENV['BUBBLE_API_URL']
    )
  end

  def request(cursor = 0)
    response = client.get(@bubble_table) do |req|
      req.params['cursor'] = cursor
    end
  end

  # recursively call the API until all results for desired obj are retrieved
  def repeat_request(cursor)
    return false unless @bubble_table

    @total_calls += 1
    call = request(cursor)
    return false unless call.success?

    body = JSON.parse(call.body)
    raw_data = body['response']['results']
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

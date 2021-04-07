module FreelancersHelper
  def freelancer_ba_link
    stripe_url = 'https://connect.stripe.com/express/oauth/authorize'
    redirect_uri = freelancer_stripe_connect_url
    client_id = ENV['STRIPE_CLIENT_ID']

    base_part = "#{stripe_url}?redirect_uri=#{redirect_uri}&client_id=#{client_id}"

    base_part.concat(
      [stripe_email, stripe_first_name, stripe_last_name, stripe_phone, stripe_user_country].join
    )
  end

  private

  def stripe_email
    "&stripe_user%5Bemail%5D=#{current_user.email}"
  end

  def stripe_first_name
    "&stripe_user%5Bfirst_name%5D=#{current_user.first_name}"
  end

  def stripe_last_name
    "&stripe_user%5Blast_name%5D=#{current_user.last_name}"
  end

  def stripe_phone
    "&stripe_user%5Bphone_number%5D=#{current_user.phone_number}"
  end

  def stripe_user_country
    '&stripe_user%5Bcountry%5D=US'
  end
end

class StripeCardProcess {
  constructor() {
    this.stripePublishableKey = document.getElementsByName('stripe-public-key')[0].getAttribute('content');
    this.$form = $('#payment-form');
    this.displayError = document.getElementById('card-errors');
    this.submitStripeButton = document.getElementById('submit-stripe');

    this.setupStripe();
  }

  setupStripe() {
    //Initialize stripe with publishable key
    const stripe = Stripe(this.stripePublishableKey);

    //Create Stripe credit card elements.
    const elements = stripe.elements();
    const card = elements.create('card');

    //Add a listener in order to check if
    card.addEventListener('change', function(event) {

      this.submitStripeButton.disabled = false;
      if (event.error) {
        // Display error
        this.displayError.textContent = event.error.message;
      } else {
        // Clear error
        this.displayError.textContent = '';
      }
    });

    // Mount Stripe card element in the #card-element div.
    card.mount('#card-element');
    const form = document.getElementById('payment-form');
    // This will be called when the #submit-stripe button is clicked by the user.
    this.$form.on('submit', function(event) {
      $(this.submitStripeButton).prop('disabled', true);
      event.preventDefault();
      stripe.createToken(card).then(function(result) {
        if (result.error) {
          // Inform that there was an error.
          this.displayError.textContent = result.error.message;
        } else {
          // Now we submit the form. We also add a hidden input storing
          // the token. So our back-end can consume it.
          // Add a hidden input stripe[token]
          this.$form.append($('<input type="hidden" name="orders[token]"/>').val(result.token.id));
          this.$form.submit();
        }
      });
      return false;
    });
  }
}

export default StripeCardProcess;


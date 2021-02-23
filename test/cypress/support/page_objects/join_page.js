class JoinPage {

  get route() {
    return '/join';
  }

  get loginButton() {
    return cy.xpath("//a[contains(text(), 'Log In')]");
  }

  get emailInput() {
    return cy.get('#user_email');
  }

  get signUpWithEmail() {
    return cy.get('.actions > .btn');
  }

  submitEmail(email) {
    this.emailInput.type(email);
    return this.signUpWithEmail.click().wait(2000);
  }
}
export default JoinPage
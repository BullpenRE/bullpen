class SignUpPage {

  get route() {
    return '/users/sign_up';
  }

  get userFirstName() {
    return cy.get('#user_first_name');
  }

  get userLastName() {
    return cy.get('#user_last_name');
  }

  get userPassword() {
    return cy.get('#user_password');
  }

  get freelancerRadioButton() {
    return cy.get('#hide_phone_number > .custom-control-label');
  }

  get employerRadioButton() {
    return cy.get('#show_phone_number > .custom-control-label');
  }

  get userPhoneNumber() {
    return cy.get('#user_phone_number');
  }

  get createAccountButton() {
    return cy.get('#submit_button');
  }

  submitEmployerSigUpForm(firstName, lastName, password, phoneNumber) {
    this.userFirstName.type(firstName);
    this.userLastName.type(lastName);
    this.userPassword.type(password);
    this.employerRadioButton.click();
    this.userPhoneNumber.type(phoneNumber);
    return this.createAccountButton.click().wait(2000);
  }

  submitFreelancerSigUpForm(firstName, lastName, password, phoneNumber) {
    this.userFirstName.type(firstName);
    this.userLastName.type(lastName);
    this.userPassword.type(password);
    this.freelancerRadioButton.click();
    return this.createAccountButton.click().wait(2000);
  }
}

export default SignUpPage;

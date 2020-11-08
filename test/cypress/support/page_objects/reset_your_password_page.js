class ResetYourPasswordPage {

  getResetYourPasswordText(){
    return cy.get('.display-4');
  }

  getEnterYourEmailAddressText(){
    return cy.get('#new_user > .text-muted');
  }

  getEmailLabel(){
    return cy.get('.field > .text-primary');
  }

  getEmail(){
    return cy.get('#user_email');
  }

  getSendPasswordResetButton(){
    return cy.get('.form-control-lg');
  }

  getRememberYourPasswordText(){
    return cy.get('h5');
  }

  getLoginLink(){
    return cy.get('h5 > a');
  }

}
export default ResetYourPasswordPage
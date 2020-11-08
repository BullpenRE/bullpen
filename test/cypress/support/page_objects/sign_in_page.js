class SignInPage {

  getLogInText(){
    return cy.get('.display-4');
  }

  getEmailLabel(){
    return cy.get('#new_user > :nth-child(1) > .text-primary');
  }

  getEmail(){
    return cy.get('#user_email');
  }

  getPasswordLabel(){
    return cy.get(':nth-child(2) > .text-primary');
  }

  getPassword(){
    return cy.get('#user_password');
  }

  getForgotPasswordLink(){
    return cy.get('.field.text-center > .text-center');
  }
  getLoginButton() {
    return cy.get('.btn');
  }

  getNeedAnAccountText(){
    return cy.get('h5');
  }
  getSignUpLink(){
    return cy.get('h5 > a');
  }

}
export default SignInPage
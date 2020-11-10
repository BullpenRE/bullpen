class FreelancerSignUpPage {

  getBullpenNavImg(){
    return cy.get('img');
  }

  getCreateAccountText1st(){
    return cy.get('#step-1 > .mt-4');
  }

  getFirstNameLabel(){
    return cy.get('.mb-4 > .text-primary');
  }

  getFirstNameInput(){
    return cy.get('#firstName');
  }

  getLastNameLabel(){
    return cy.get('.mb-3 > .text-primary');
  }

  getLastNameInput(){
    return cy.get('#lastName');
  }

  getEmailLabel(){
    return cy.get('.mb-5.col-md-12 > .text-primary');
  }

  getEmailInput(){
    return cy.get('#email');
  }

  getSignUpAsFreelancerButton(){
    return cy.get('#step-1 > .form-control-lg');
  }

  getAlreadyHaveAccountText(){
    return cy.get('h5');
  }

  getLoginLink(){
    return cy.get('.p-2');
  }

  // 2nd step

  getCreateAccountText2nd(){
    return cy.get('#step-2 > .mb-5');
  }

  getCurrentEmail(){
    return cy.get('.current_email');
  }

  getChangeEmailLink(){
    return cy.get('.prevBtn-2');
  }

  getPasswordLabel(){
    return cy.get('#step-2 > :nth-child(4)');
  }

  getPasswordInput(){
    return cy.get('#psw');
  }

  getShowFieldIconPassword(){
    return cy.get(':nth-child(5) > .field-icon > .svg-inline--fa');
  }

  getConfirmPasswordLabel(){
    return cy.get('#step-2 > :nth-child(7)');
  }

  getConfirmPasswordInput(){
    return cy.get('#cPwdId');
  }

  getShowFieldIconConfirmPassword(){
    return cy.get('.input-group.mb-4 > .field-icon > .svg-inline--fa > path');
  }

  getShowIconConfirmPassword(){
    return cy.get('svg.svg-inline--fa.fa-eye.fa-w-18.fa-fw');
  }
  getDivider(){
    return cy.get('#step-2');
  }

  getCreateMyAccountInput(){
    return cy.get('#submitBtn');
  }

  getDivider2nd(){
    return cy.get('#step-2 > :nth-child(11)');
  }

  getAgreeText(){
    return cy.get('#cy-agree');
  }

  getTermOfServiceLink(){
    return cy.get('#cy-terms-of-service > a');
  }

  getPrivacyAgreementLink(){
    return cy.get('#cy-privacy-agreement > a');
  }

  getStripesConnectedAccountAuthLink(){
    return cy.get('#cy-stripe-connected-accounts > a');
  }

}
export default FreelancerSignUpPage


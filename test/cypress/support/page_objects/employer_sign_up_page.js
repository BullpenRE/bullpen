class EmployerSignUpPage {

  getBullpenNavImg() {
    return cy.get('img');
  }

  getCreateAccountText1st() {
    return cy.get('#step-1 > .mt-4');
  }

  getFirstNameLabel() {
    return cy.get('.mb-4 > .text-primary');
  }

  getFirstNameInput() {
    return cy.get('#firstName');
  }

  getLastNameLabel() {
    return cy.get('.mb-3 > .text-primary');
  }

  getLastNameInput() {
    return cy.get('#lastName');
  }

  getEmailLabel() {
    return cy.get(':nth-child(4) > .text-primary');
  }

  getEmailInput() {
    return cy.get('#email');
  }

  getPhoneNumberLabel() {
    return cy.get(':nth-child(5) > .text-primary');
  }

  getPhoneNumberInput() {
    return cy.get('#phone');
  }

  getDivider() {
    return cy.get('#step-1 > hr.mb-4');
  }

  getSignUpAsCompanyButton() {
    return cy.get('#step-1 > .form-control-lg');
  }

  getAlreadyHasAnAccountText() {
    return cy.get('h5');
  }

  getLoginLink() {
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
  getDivider1st(){
    return cy.get('#step-2 > :nth-child(9)');
  }

  getCreateMyAccountInput(){
    return cy.get('#submitBtn');
  }

  getDivider2nd(){
    return cy.get('#step-2 > :nth-child(11)');
  }

  getAgreeText(){
    return cy.get('#agree');
  }

  getTermOfServiceLink(){
    return cy.get('#first > a');
  }

  getPrivacyAgreementLink(){
    return cy.get('#second > a');
  }

  getStripesConnectedAccountAuthLink(){
    return cy.get('#third > a');
  }
}
export default EmployerSignUpPage

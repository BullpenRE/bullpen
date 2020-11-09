/// <reference types="Cypress" />

import EmployerSignUpPage from "../support/page_objects/employer_sign_up_page";

describe('EmployerSignUpPage', () => {

//   it('freelancer sign up page', () => {
//     cy.visit('http://localhost:5017/employer_sign_up', {failOnStatusCode: false})
//   })

  //usage of fixture data
  beforeEach(function(){
    cy.fixture('login').then(function (dataJson)
    {
      this.dataJson=dataJson ;
    })
  })

  it('register a new user', function () {

    //Object Creation for PageObject Page Class and assigning it to a constant variable
    const employerSignUpPage = new EmployerSignUpPage();

    cy.visit('http://localhost:5017/employer_sign_up', {failOnStatusCode: false})

    // page elements check 1st step

    employerSignUpPage.getBullpenNavImg()
      .should("be.visible")
      .should('have.attr', 'src', '/packs-test/media/images/bullpen-email-logo-64fc4a58c54693e46d0e2e963bd3c9ac.png')
      .should(($img) => {
        expect($img).css('width', '175px')
        expect($img).css('height', '55px')
      });

    employerSignUpPage.getCreateAccountText1st()
      .should("be.visible")
      .should('have.text', 'Create an Account');

    employerSignUpPage.getFirstNameLabel()
      .should("be.visible")
      .should('have.text', 'First name');

    employerSignUpPage.getFirstNameInput()
      .should("be.visible")
      .should('have.attr', 'name', 'user[first_name]');

    employerSignUpPage.getLastNameLabel()
      .should("be.visible")
      .should('have.text', 'Last name');

    employerSignUpPage.getLastNameInput()
      .should("be.visible")
      .should('have.attr', 'name', 'user[last_name]');

    employerSignUpPage.getEmailLabel()
      .should("be.visible")
      .should('have.text', 'Email');

    employerSignUpPage.getEmailInput()
      .should("be.visible")
      .should('have.attr', 'name', 'user[email]');

    employerSignUpPage.getPhoneNumberLabel()
      .should("be.visible")
      .should('have.text', 'Phone number');

    employerSignUpPage.getPhoneNumberInput()
      .should("be.visible")
      .should('have.attr', 'name', 'user[phone_number]');

    employerSignUpPage.getDivider()
      .should("be.visible");

    employerSignUpPage.getSignUpAsCompanyButton()
      .should("be.visible")
      .should('have.attr', 'type', 'button')
      .should('have.text', 'Sign up as a Company')

    employerSignUpPage.getAlreadyHasAnAccountText()
      .should("be.visible")
      .should('have.text', 'Already have an account? Login');

    employerSignUpPage.getLoginLink()
      .should("be.visible")
      .should('have.attr', 'href', '/users/sign_in')
      .should('have.text', 'Login')
      .click().go('back');

    // sign in with dataJson 1st step
    employerSignUpPage.getFirstNameInput().type(this.dataJson.first_name);
    employerSignUpPage.getLastNameInput().type(this.dataJson.last_name);
    employerSignUpPage.getEmailInput().type(this.dataJson.email);
    employerSignUpPage.getPhoneNumberInput().type(this.dataJson.phone_number);
    employerSignUpPage.getSignUpAsCompanyButton().click();

// page elements check 2nd step
    employerSignUpPage.getCreateAccountText2nd()
      .should("be.visible")
      .should('have.text', 'Create an Account');

    employerSignUpPage.getCurrentEmail()
      .should("be.visible")
      .should('have.text', 'tgoncharenko2013@gmail.com');

    employerSignUpPage.getChangeEmailLink()
      .should("be.visible")
      .should('have.attr', 'href', '#')
      .should('have.text', 'Change Email')
      .click().wait(2000).go('back')
    employerSignUpPage.getSignUpAsCompanyButton().click();

    // password group
    employerSignUpPage.getPasswordLabel()
      .should("be.visible")
      .should('have.text', 'Password');

    employerSignUpPage.getPasswordInput()
      .should("be.visible")
      .should('have.attr', 'name', 'user[password]');

    employerSignUpPage.getShowFieldIconPassword()
      .should("be.visible")
      .should(($svg) => {
        expect($svg).to.have.length(1)
        expect($svg).have.attr('data-prefix', 'fas')
        expect($svg).have.attr('data-icon', 'eye')
        expect($svg).have.attr('role', 'img')
      })
      .click()
    employerSignUpPage.getShowFieldIconPassword()
      .should("be.visible")
      .should(($svg) => {
        expect($svg).to.have.length(1)
        expect($svg).have.attr('data-prefix', 'fas')
        expect($svg).have.attr('data-icon', 'eye-slash')
        expect($svg).have.attr('role', 'img')
      })
      .click()
    //end of password group

    // confirm password group
    employerSignUpPage.getConfirmPasswordLabel()
      .should("be.visible")
      .should('have.text', 'Confirm Password');

    employerSignUpPage.getConfirmPasswordInput()
      .should("be.visible")
      .should('have.attr', 'name', 'user[password_confirmation]');

    employerSignUpPage.getShowFieldIconConfirmPassword()
      .should("be.visible")
    employerSignUpPage.getShowIconConfirmPassword()
      .should(($svg) => {
        expect($svg).to.have.length(2)
        expect($svg.eq(0)).have.attr('data-prefix', 'fas')
        expect($svg.eq(0)).have.attr('data-icon', 'eye')
        expect($svg.eq(0)).have.attr('role', 'img')
      })
      .first()
      .click();

    employerSignUpPage.getShowIconConfirmPassword()
      .should("be.visible")
      .get('svg.svg-inline--fa.fa-eye-slash.fa-w-20.fa-fw')
      .should(($svg) => {
        expect($svg).to.have.length(1)
        expect($svg).have.attr('data-prefix', 'fas')
        expect($svg).have.attr('data-icon', 'eye-slash')
        expect($svg).have.attr('role', 'img')
      })
      .click();
    // end of confirm password group

    employerSignUpPage.getDivider1st()
      .should("be.visible");

    employerSignUpPage.getCreateMyAccountInput()
      .should("be.visible")
      .should('have.attr', 'name', 'commit')
      .should('have.attr', 'type', 'submit')
      .should('have.attr', 'data-disable-with', 'Create my account');

    employerSignUpPage.getDivider2nd()
      .should("be.visible");

    employerSignUpPage.getAgreeText()
      .should("be.visible")
      .should('have.text', '\n            By creating your account, you agree to Bullpen\'s\n            \n              Terms of Service\n            ,\n            \n              Privacy Agreement\n            , and Stripe\'s Connected Accounts Authorization\n          ');

    employerSignUpPage.getTermOfServiceLink()
      .should("be.visible")
      .should('have.attr', 'href', 'https://bullpenre.com/terms-of-service/?_ga=2.176404525.943759142.1600229912-339552047.1597271456')
      .should('have.text', '\n              Terms of Service\n            ');

    employerSignUpPage.getPrivacyAgreementLink()
      .should("be.visible")
      .should('have.attr', 'href', 'https://bullpenre.com/privacy-policy/?_ga=2.79419548.943759142.1600229912-339552047.1597271456')
      .should('have.text', '\n              Privacy Agreement\n            ');

    employerSignUpPage.getStripesConnectedAccountAuthLink()
      .should("be.visible")
      .should('have.attr', 'href', 'https://stripe.com/connect-account/legal')
      .should('have.text', 'Stripe\'s Connected Accounts Authorization');

    employerSignUpPage.getPasswordInput().type(this.dataJson.password)
    employerSignUpPage.getConfirmPasswordInput().type(this.dataJson.confirm_password)
    employerSignUpPage.getCreateMyAccountInput().click()
  })

})
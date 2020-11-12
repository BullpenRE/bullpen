/// <reference types="Cypress" />

import FreelancerSignUpPage from "../support/page_objects/freelancer_sign_up_page";

describe('FreelancerSignUpPage', () => {

  //usage of fixture data
  beforeEach(function(){
    cy.fixture('login').then(function (dataJson)
    {
      this.dataJson=dataJson ;
    })
  })

  it('register a new user', function () {

    //Object Creation for PageObject Page Class and assigning it to a constant variable
    const freelancerSignUpPage = new FreelancerSignUpPage();

    freelancerSignUpPage.visitFreelancerSignUpPage()

    // page elements check 1st step

    freelancerSignUpPage.getBullpenNavImg()
      .should("be.visible")
      .should('have.attr', 'src', '/packs-test/media/images/bullpen-email-logo-64fc4a58c54693e46d0e2e963bd3c9ac.png')
      .should(($img) => {
        expect($img).css('width', '175px')
        expect($img).css('height', '55px')
      });

    freelancerSignUpPage.getCreateAccountText1st()
      .should("be.visible")
      .should('have.text', 'Create an Account');

    freelancerSignUpPage.getFirstNameLabel()
      .should("be.visible")
      .should('have.text', 'First name');

    freelancerSignUpPage.getFirstNameInput()
      .should("be.visible")
      .should('have.attr', 'name', 'user[first_name]');

    freelancerSignUpPage.getLastNameLabel()
      .should("be.visible")
      .should('have.text', 'Last name');

    freelancerSignUpPage.getLastNameInput()
      .should("be.visible")
      .should('have.attr', 'name', 'user[last_name]');

    freelancerSignUpPage.getEmailLabel()
      .should("be.visible")
      .should('have.text', 'Email');

    freelancerSignUpPage.getEmailInput()
      .should("be.visible")
      .should('have.attr', 'name', 'user[email]');

    freelancerSignUpPage.getSignUpAsFreelancerButton()
      .should("be.visible")
      .should('have.attr', 'type', 'button')
      .should('have.text', 'Sign up as a freelancer')

    freelancerSignUpPage.getAlreadyHaveAccountText()
      .should("be.visible")
      .should('have.text', 'Already have an account? Login');

    freelancerSignUpPage.getLoginLink()
      .should("be.visible")
      .should('have.attr', 'href', '/users/sign_in')
      .should('have.text', 'Login')
      .click().go('back');

    // sign in with dataJson 1st step
    freelancerSignUpPage.getFirstNameInput().type(this.dataJson.first_name);
    freelancerSignUpPage.getLastNameInput().type(this.dataJson.last_name);
    freelancerSignUpPage.getEmailInput().type(this.dataJson.email);
    freelancerSignUpPage.getSignUpAsFreelancerButton().click();

    // page elements check 2nd step
    freelancerSignUpPage.getCreateAccountText2nd()
      .should("be.visible")
      .should('have.text', 'Create an Account');

    freelancerSignUpPage.getCurrentEmail()
      .should("be.visible")
      .should('have.text', 'tgoncharenko2013@gmail.com');

    freelancerSignUpPage.getChangeEmailLink()
      .should("be.visible")
      .should('have.attr', 'href', '#')
      .should('have.text', 'Change Email')
      .click().wait(2000).go('back')
    freelancerSignUpPage.getSignUpAsFreelancerButton().click();

    // password group
    freelancerSignUpPage.getPasswordLabel()
      .should("be.visible")
      .should('have.text', 'Password');

    freelancerSignUpPage.getPasswordInput()
      .should("be.visible")
      .should('have.attr', 'name', 'user[password]');

    freelancerSignUpPage.getShowFieldIconPassword()
      .should("be.visible")
      .should(($svg) => {
        expect($svg).to.have.length(1)
        expect($svg).have.attr('data-prefix', 'fas')
        expect($svg).have.attr('data-icon', 'eye')
        expect($svg).have.attr('role', 'img')
      })
      .click()
    freelancerSignUpPage.getShowFieldIconPassword()
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
    freelancerSignUpPage.getConfirmPasswordLabel()
      .should("be.visible")
      .should('have.text', 'Confirm Password');

    freelancerSignUpPage.getConfirmPasswordInput()
      .should("be.visible")
      .should('have.attr', 'name', 'user[password_confirmation]');

    freelancerSignUpPage.getShowFieldIconConfirmPassword()
      .should("be.visible")
    freelancerSignUpPage.getShowIconConfirmPassword()
      .should(($svg) => {
        expect($svg).to.have.length(2)
        expect($svg.eq(0)).have.attr('data-prefix', 'fas')
        expect($svg.eq(0)).have.attr('data-icon', 'eye')
        expect($svg.eq(0)).have.attr('role', 'img')
      })
      .first()
      .click();

    freelancerSignUpPage.getShowIconConfirmPassword()
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

    freelancerSignUpPage.getDivider()
      .should("be.visible");

    freelancerSignUpPage.getCreateMyAccountInput()
      .should("be.visible")
      .should('have.attr', 'name', 'commit')
      .should('have.attr', 'type', 'submit')
      .should('have.attr', 'data-disable-with', 'Create my account');

    freelancerSignUpPage.getDivider2nd()
      .should("be.visible");

    freelancerSignUpPage.getAgreeText()
      .should("be.visible")
      .should('have.text', '\n          By creating your account, you agree to Bullpen\'s\n          \n            Terms of Service\n          ,\n          \n            Privacy Agreement\n          , and Stripe\'s Connected Accounts Authorization\n        ');

    freelancerSignUpPage.getTermOfServiceLink()
      .should("be.visible")
      .should('have.attr', 'href', 'https://bullpenre.com/terms-of-service/?_ga=2.176404525.943759142.1600229912-339552047.1597271456')
      .should('have.text', '\n            Terms of Service\n          ');

    freelancerSignUpPage.getPrivacyAgreementLink()
      .should("be.visible")
      .should('have.attr', 'href', 'https://bullpenre.com/privacy-policy/?_ga=2.79419548.943759142.1600229912-339552047.1597271456')
      .should('have.text', '\n            Privacy Agreement\n          ');

    freelancerSignUpPage.getStripesConnectedAccountAuthLink()
      .should("be.visible")
      .should('have.attr', 'href', 'https://stripe.com/connect-account/legal')
      .should('have.text', 'Stripe\'s Connected Accounts Authorization');

    freelancerSignUpPage.getPasswordInput().type(this.dataJson.password)
    freelancerSignUpPage.getConfirmPasswordInput().type(this.dataJson.confirm_password)
    freelancerSignUpPage.getCreateMyAccountInput().click()
  })
})

/// <reference types="Cypress" />

import ResetYourPasswordPage from '../support/page_objects/reset_your_password_page';

describe('reset your password page', () => {

  //usage of fixture data
  beforeEach(function(){
    cy.fixture('login').then(function (dataJson)
    {
      this.dataJson=dataJson ;
    })
  })

  it('register a new user', function () {

    //Object Creation for PageObject Page Class and assigning it to a constant variable
    const resetYourPasswordPage = new ResetYourPasswordPage();

    cy.visit('http://localhost:5017/users/password/new', {failOnStatusCode: false})

    // page elements check

    resetYourPasswordPage.getResetYourPasswordText()
      .should("be.visible")
      .should('have.text', 'Reset your password');

    resetYourPasswordPage.getEnterYourEmailAddressText()
      .should("be.visible")
      .should('have.text', '\n' +
        '          Enter the email address associated with your Bullpen acccount,\n' +
        '          and we\'ll email you a link to reset your password.\n' +
        '        ');

    resetYourPasswordPage.getEmailLabel()
      .should("be.visible")
      .should('have.text', 'Email');

    resetYourPasswordPage.getEmailInput()
      .should("be.visible")
      .should('have.attr', 'placeholder', 'Email address');

    resetYourPasswordPage. getSendPasswordResetButton()
      .should("be.visible")
      .should('have.attr', 'type', 'submit')
      .should('have.attr', 'value', 'Send Password Reset')
      .should('have.attr', 'data-disable-with', 'Send Password Reset');

    resetYourPasswordPage.getRememberYourPasswordText()
      .should("be.visible")
      .should('have.text', 'Remember your password? Login');

    resetYourPasswordPage.getLoginLink()
      .should("be.visible")
      .should('have.attr', 'href', '/users/sign_in')
      .should('have.text', 'Login')
      .click().go('back');

    resetYourPasswordPage.getEmailInput().type(this.dataJson.email);
    resetYourPasswordPage.getSendPasswordResetButton().click();

  })
})

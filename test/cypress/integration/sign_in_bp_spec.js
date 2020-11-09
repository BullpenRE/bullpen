/// <reference types="Cypress" />

import SignInPage from '../support/page_objects/sign_in_page.js';

describe('sign_in page', () => {

  //usage of fixture data
  beforeEach(function(){
    cy.fixture('login').then(function (dataJson)
    {
      this.dataJson=dataJson ;
    })
  })

  it('register a new user', function () {

    //Object Creation for PageObject Page Class and assigning it to a constant variable
    const signInPage = new SignInPage();

    cy.visit('http://localhost:5017/users/sign_in', {failOnStatusCode: false})

    // page elements check
    signInPage.getLogInText()
      .should("be.visible")
      .should('have.text', 'Log In');

    signInPage.getEmailLabel()
      .should("be.visible")
      .should('have.text', 'Email');

    signInPage.getEmailInput()
      .should("be.visible")
      .should('have.attr', 'placeholder', 'Email address');

    signInPage.getPasswordLabel()
      .should("be.visible")
      .should('have.text', 'Password');

    signInPage.getPasswordInput()
      .should("be.visible")
      .should('have.attr', 'placeholder', 'Password');

    signInPage.getForgotPasswordLink()
      .should("be.visible")
      .should('have.attr', 'href', '/users/password/new')
      .click().go('back');

    signInPage. getLoginButton()
      .should("be.visible")
      .should('have.attr', 'type', 'submit')
      .should('have.attr', 'value', 'Login')
      .should('have.attr', 'data-disable-with', 'Login');

    signInPage.getNeedAnAccountText()
      .should("be.visible")
      .should('have.text', 'Need an account? Sign up');

    signInPage.getSignUpLink()
      .should("be.visible")
      .should('have.attr', 'href', '/join')
      .should('have.text', 'Sign up')
      .click().wait(2000).go('back');

    // sign in with dataJson
    signInPage.getEmailInput().type(this.dataJson.email);
    signInPage.getPasswordInput().type(this.dataJson.password);
    signInPage.getLoginButton().click();
  })
})

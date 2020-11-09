/// <reference types="Cypress" />

import JoinPage from '../support/page_objects/join_page';

describe('join page', () => {

  it('register a new user', function () {

    //Object Creation for PageObject Page Class and assigning it to a constant variable
    const joinPage = new JoinPage();

    cy.visit('http://localhost:5017/join', {failOnStatusCode: false})

    // page elements check

    joinPage.getBullpenNavText()
      .should("be.visible")
      .should('have.text', 'Bullpen');

    joinPage.getJoinBullpenText()
      .should("be.visible")
      .should('have.text', 'Join Bullpen');

    joinPage.getFreelancerText()
      .should("be.visible")
      .should('have.text', 'Freelancer');

    joinPage.getIamIndividualText()
      .should("be.visible")
      .should('have.text', 'I\'m individual and I\'m looking for work. ');

    joinPage.getApplyLink()
      .should("be.visible")
      .should('have.text', 'Apply')
      .should('have.attr', 'href', '/freelancer_sign_up')
      .click().wait(2000).go('back')

    joinPage.getCompanyText()
      .should("be.visible")
      .should('have.text', 'Company');

    joinPage.getIamCompanyText()
      .should("be.visible")
      .should('have.text', 'I\'m a company interested in hiring. ');

    joinPage.getSignUpButton()
      .should("be.visible")
      .should('have.text', 'Sign-Up')
      .should('have.attr', 'href', '/employer_sign_up')
      .click().wait(2000).go('back')

    joinPage.getAlreadyHaveAccountText()
      .should("be.visible")
      .should('have.text', 'Already have an account? Login');

    joinPage.getLoginLink()
      .should("be.visible")
      .should('have.text', 'Login')
      .should('have.attr', 'href', '/users/sign_in')
      .click().wait(2000).go('back');

  })
})
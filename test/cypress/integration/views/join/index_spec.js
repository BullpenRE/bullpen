/// <reference types="Cypress" />

import JoinPage from '../../../support/page_objects/join_page';

describe('join page', () => {

  const domain = 'http://localhost:5017';
  const joinPage = new JoinPage();
  const testEmail = `test-${Math.random().toString(36).substring(7)}@bullpenre.com`;

  it("Check functionality of 'Log in' button in navbar", () => {
    cy.visit(`${domain}${joinPage.route}`, {failOnStatusCode: false});
    joinPage.loginButton.click().wait(2000).url().should('eq', `${domain}/users/sign_in`);
    cy.go('back').wait(2000).url().should('eq', `${domain}${joinPage.route}`);
  });

  it("Check due functionality of input-field 'Email address' & button 'Sign Up with email' in /join", () => {
    joinPage.submitEmail(testEmail).url().should('eq', `${domain}/users/sign_up`);
  });
});

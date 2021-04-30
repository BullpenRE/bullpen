/// <reference types="Cypress" />

import JoinPage from "../../../../support/page_objects/join_page";
import SignUpPage from "../../../../support/page_objects/sign_up_page";
import LetterOpener from "../../../../support/page_objects/letter_opener";

describe('Employer Sign Up', () => {

  const domain = 'http://localhost:5017';
  const signUpPage = new SignUpPage();
  const joinPage = new JoinPage();
  const letterOpener = new LetterOpener();
  const firstName = 'Betty';
  const lastName = 'Buyerzz';
  const password = 'Test123!';
  const phoneNumber = '9252225555';
  const testEmail = `test-${Math.random().toString(36).substring(7)}@bullpenre.com`;


  it("Employer can create account", () => {
    cy.visit(`${domain}${joinPage.route}`, {failOnStatusCode: false});
    joinPage.submitEmail(testEmail);
    signUpPage.submitEmployerSigUpForm(firstName, lastName, password, phoneNumber).url().should('eq', `${domain}/employer_profile_steps/about_company`);
    // cy.visit(`${domain}${letterOpener.route}`, {failOnStatusCode: false}).wait(2000);
    // letterOpener.clickConfirmEmailLink();
  });
});



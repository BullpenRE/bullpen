/// <reference types="Cypress" />

import JoinPage from "../../../../support/page_objects/join_page";
import SignUpPage from "../../../../support/page_objects/sign_up_page";
import LetterOpener from "../../../../support/page_objects/letter_opener";

describe('Freelancer Sign Up', () => {

  const domain = 'http://localhost:5017';
  const signUpPage = new SignUpPage();
  const joinPage = new JoinPage();
  const letterOpener = new LetterOpener();
  const firstName = 'Fred';
  const lastName = 'Buyerzz';
  const password = 'Test123!';
  const testEmail = `test-${Math.random().toString(36).substring(7)}@bullpenre.com`;


  it("Freelancer can create account", () => {
    cy.visit(`${domain}${joinPage.route}`, {failOnStatusCode: false});
    joinPage.submitEmail(testEmail);
    signUpPage.userFirstName.type(firstName);
    signUpPage.userLastName.type(lastName);
    signUpPage.userPassword.type(password);
    signUpPage.freelancerRadioButton.click();
    signUpPage.createAccountButton.click().wait(2000).url().should('eq', `${domain}/freelancer_profile_steps/skills_page`);
    // cy.visit(`${domain}${letterOpener.route}`, {failOnStatusCode: false}).wait(2000);
    // letterOpener.clickConfirmEmailLink();
  });
});


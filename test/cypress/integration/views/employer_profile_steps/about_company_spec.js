/// <reference types="Cypress" />

import JoinPage from "../../../support/page_objects/join_page";
import SignUpPage from "../../../support/page_objects/sign_up_page";
import AboutCompanyPage from "../../../support/page_objects/about_company_page";

describe('About company', () => {

  const domain = 'http://localhost:5017';
  const joinPage = new JoinPage();
  const signUpPage = new SignUpPage();
  const aboutCompanyPage = new AboutCompanyPage();
  const firstName = 'Betty';
  const lastName = 'Buyerzz';
  const password = 'Test123!';
  const phoneNumber = '9252225555';
  const testEmail = `test-${Math.random().toString(36).substring(7)}@bullpenre.com`;
  const companyName = 'ABC LLC';
  const companyWebsite = 'https://abc.com';
  const companyRole = 'Engineer';

  it('Employer can fill company information ', () => {
    cy.visit(`${domain}${joinPage.route}`, {failOnStatusCode: false});
    joinPage.submitEmail(testEmail);
    signUpPage.submitEmployerSigUpForm(firstName, lastName, password, phoneNumber);
    aboutCompanyPage.submitAboutCompanyForm(companyName, companyWebsite, companyRole)
      .url().should('eq', `${domain}/employer_profile_steps/employee_count`);
  });
});

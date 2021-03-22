/// <reference types="Cypress" />

import JoinPage from "../../../support/page_objects/join_page";
import SignUpPage from "../../../support/page_objects/sign_up_page";
import AboutCompanyPage from "../../../support/page_objects/about_company_page";
import EmployeeCountPage from "../../../support/page_objects/employee_count_page";
import TypeOfWorkPage from "../../../support/page_objects/type_of_work_page";

describe('Employee Count', () => {

  const domain = 'http://localhost:5017';
  const joinPage = new JoinPage();
  const signUpPage = new SignUpPage();
  const aboutCompanyPage = new AboutCompanyPage();
  const employeeCountPage = new EmployeeCountPage();
  const typeOfWorkPage = new TypeOfWorkPage();
  const firstName = 'Betty';
  const lastName = 'Buyerzz';
  const password = 'Test123!';
  const phoneNumber = '9252225555';
  const testEmail = `test-${Math.random().toString(36).substring(7)}@bullpenre.com`;
  const companyName = 'ABC LLC';
  const companyWebsite = 'https://abc.com';
  const companyRole = 'Engineer';

  it('Employer can choose number of employees', () => {
    cy.visit(`${domain}${joinPage.route}`, {failOnStatusCode: false});
    joinPage.submitEmail(testEmail);
    signUpPage.submitEmployerSigUpForm(firstName, lastName, password, phoneNumber);
    aboutCompanyPage.submitAboutCompanyForm(companyName, companyWebsite, companyRole);
    ['1-10', '11-50', '51-100', '101+'].forEach((range) => {
      employeeCountPage.submitEmployeeCountForm(range).wait(2000)
        .url().should('eq', `${domain}${typeOfWorkPage.route}`);
      cy.go('back').wait(2000).url().should('eq', `${domain}${employeeCountPage.route}`);
    });
    employeeCountPage.nextButton.click().wait(2000)
      .url().should('eq', `${domain}${typeOfWorkPage.route}`);
  });
});
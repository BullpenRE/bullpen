/// <reference types="Cypress" />

import JoinPage from "../../../support/page_objects/join_page";
import SignUpPage from "../../../support/page_objects/sign_up_page";
import AboutCompanyPage from "../../../support/page_objects/employer/about_company_page";
import EmployeeCountPage from "../../../support/page_objects/employer/employee_count_page";
import TypeOfWorkPage from "../../../support/page_objects/employer/type_of_work_page";
import SectorsPage from "../../../support/page_objects/employer/sectors_page";
import LastQuestionPage from "../../../support/page_objects/employer/last_question_page";

describe('LastQuestion', () => {

  const domain = 'http://localhost:5017';
  const joinPage = new JoinPage();
  const signUpPage = new SignUpPage();
  const aboutCompanyPage = new AboutCompanyPage();
  const employeeCountPage = new EmployeeCountPage();
  const typeOfWorkPage = new TypeOfWorkPage();
  const sectorsPage = new SectorsPage();
  const lastQuestionPage = new LastQuestionPage();
  const firstName = 'Betty';
  const lastName = 'Buyerzz';
  const password = 'Test123!';
  const phoneNumber = '9252225555';
  const testEmail = `test-${Math.random().toString(36).substring(7)}@bullpenre.com`;
  const companyName = 'ABC LLC';
  const companyWebsite = 'https://abc.com';
  const companyRole = 'Engineer';

  it('Employer can choose last question', () => {
    cy.visit(`${domain}${joinPage.route}`, {failOnStatusCode: false});
    joinPage.submitEmail(testEmail);
    signUpPage.submitEmployerSigUpForm(firstName, lastName, password, phoneNumber);
    aboutCompanyPage.submitAboutCompanyForm(companyName, companyWebsite, companyRole);
    employeeCountPage.submitEmployeeCountForm('1-10').wait(2000);
    typeOfWorkPage.submitWorkTypeForm('Brokerage').wait(2000);
    sectorsPage.submitSectorsForm(['Condo', 'Multifamily', 'Single Family']).wait(2000);
    lastQuestionPage.submitLastQuestionForm(['I have a one-time project', 'Other']).wait(2000)
      .url().should('eq', `${domain}/employer/talent`);
  });
});

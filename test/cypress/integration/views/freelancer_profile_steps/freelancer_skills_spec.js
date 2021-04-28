/// <reference types="Cypress" />

import JoinPage from "../../../support/page_objects/join_page";
import SignUpPage from "../../../support/page_objects/sign_up_page";
import FreelancerSkillsPage from "../../../support/page_objects/freelancer/freelancer_skills_page";
import FreelancerAvatarLocationPage from "../../../support/page_objects/freelancer/freelancer_avatar_location_page";

describe ('Freelancer skills', () => {

  const domain = 'http://localhost:5017';
  const joinPage = new JoinPage();
  const signUpPage = new SignUpPage();
  const freelancerSkillsPage = new FreelancerSkillsPage();
  const freelancerAvatarLocationPage = new FreelancerAvatarLocationPage();
  const firstName = 'Fred';
  const lastName = 'Buyerzz';
  const password = 'Test123!';
  const testEmail = `test-${Math.random().toString(36).substring(7)}@bullpenre.com`;
  const freelancerSkill = 'Marketing';
  const experienceSectors = 'Affordable Housing';
  const softwareLicenses = 'Buildout';

  it('Freelancer can fill skills', () => {
    cy.visit(`${domain}${joinPage.route}`, {failOnStatusCode: false});
    joinPage.submitEmail(testEmail);
    signUpPage.submitFreelancerSigUpForm(firstName, lastName, password);
    freelancerSkillsPage.submitFreelancerSkillsForm(freelancerSkill, experienceSectors, softwareLicenses)
      .url().should('eq', `${domain}${freelancerAvatarLocationPage.route}`);
    cy.go('back').wait(2000).url().should('eq', `${domain}${freelancerSkillsPage.route}`);
    freelancerSkillsPage.nextButton.click().wait(2000)
      .url().should('eq', `${domain}${freelancerAvatarLocationPage.route}`);
  });
});


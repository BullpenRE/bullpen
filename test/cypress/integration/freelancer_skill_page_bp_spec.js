/// <reference types="Cypress" />

import FreelancerSkillPage from "../support/page_objects/freelancer_skill_page";
import FreelancerSignUpPage from "../support/page_objects/freelancer_sign_up_page";

describe('FreelancerSkillPage', () => {
  beforeEach(() => {
    // seed the database prior to every test
    // cy.exec('RAILS_ENV=test rails db:seed');
    cy.fixture('login').then(function (dataJson)
    {
      this.dataJson=dataJson ;
    })
  })
  it('visit skill page & check page elements presence', function () {

    const freelancerSignUpPage = new FreelancerSignUpPage();
    freelancerSignUpPage.visitFreelancerSignUpPage()
    freelancerSignUpPage.getFirstNameInput().type(this.dataJson.first_name);
    freelancerSignUpPage.getLastNameInput().type(this.dataJson.last_name);
    freelancerSignUpPage.getEmailInput().type(this.dataJson.email);
    freelancerSignUpPage.getSignUpAsFreelancerButton().click();
    freelancerSignUpPage.getPasswordInput().type(this.dataJson.password)
    freelancerSignUpPage.getConfirmPasswordInput().type(this.dataJson.confirm_password)
    freelancerSignUpPage.getCreateMyAccountInput().click()

    const freelancerSkillPage = new FreelancerSkillPage();
    // cy.visit('http://localhost:5017/freelancer_profile_steps/skills_page');
    freelancerSkillPage.visitFreelancerSkillPage()

    // page elements check
    freelancerSkillPage.getBullpenNavImg()
      .should("be.visible")
      .should('have.attr', 'src', '/packs-test/media/images/bullpen-email-logo-64fc4a58c54693e46d0e2e963bd3c9ac.png')
      .should(($img) => {
        expect($img).css('width', '130px')
        expect($img).css('height', '40px')
      });

    freelancerSkillPage.getNavbarAvatarIcon()
      .should("be.visible")
      .should('have.attr', 'data-prefix', 'fas')
      .should('have.attr', 'data-icon', 'user-circle')
      .should('have.attr', 'role', 'img');

    const f_name = this.dataJson.first_name
    const l_name = this.dataJson.last_name
    freelancerSkillPage.getNavbarFirstLastNamesText()
      .should("be.visible")
      .should('have.text', f_name + ' ' + l_name)
      .click()

    freelancerSkillPage.getNavbarLogoutItem()
      .should("exist")
      .should('have.attr', 'href', '/users/sign_out')
      .should('have.text', 'Logout');

    freelancerSkillPage.getProgressBar()
      .should("exist")
      .should('have.attr', 'role', 'progressbar')
      .should('have.attr', 'style', 'width: 0%')
      .should('have.attr', 'aria-valuenow', '0');

    freelancerSkillPage.getProgressBarPercentage()
      .should("be.visible")
      .should('have.text', '0%');

    freelancerSkillPage.getTellUsAboutText()
      .should("be.visible")
      .should('have.text', 'Tell us about your skills.');

    freelancerSkillPage.getAddTagsText()
      .should("be.visible")
      .should('have.text', '\n          Add tags to your application that represent your sectors, operating knowledge and software licenses.\n        ');

    freelancerSkillPage.getDescribeYourRealEstatesSkillsLabel()
      .should("be.visible")
      .should('have.text', 'Describe your real estate skills\n          In what sectors do you have experience?\n        ');

    freelancerSkillPage.setSelectRealEstateSkillsInput()
      .should(($select) => {
        expect($select).to.have.length(1)
      });

    freelancerSkillPage.getSectorsYouHaveExperienceLabel()
      .should("be.visible")
      .should('have.text', '\n          In what sectors do you have experience?\n        ');

    freelancerSkillPage.setSectorsExperienceInput()
      .should(($select) => {
        expect($select).to.have.length(1)
      });

    freelancerSkillPage.getSoftwareLicensesLabel()
      .should("be.visible")
      .should('have.text', '\n          Software Licenses\n        ');

    freelancerSkillPage.setSoftwareLicensesInput()
      .should(($select) => {
        expect($select).to.have.length(1)
      });

    freelancerSkillPage.getNextInput()
      .should("be.visible")
      .should('have.attr', 'name', 'commit')
      .should('have.attr', 'type', 'submit')
      .should('have.attr', 'data-disable-with', 'Next')
      .click();
  })
})
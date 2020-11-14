/// <reference types="Cypress" />

import FreelancerSkillPage from "../support/page_objects/freelancer_skill_page";
import FreelancerSignUpPage from "../support/page_objects/freelancer_sign_up_page";
import FreelancerAvatarLocationPage from "../support/page_objects/freelancer_avatar_location_page";
import FreelancerProfessionalHistoryPage from "../support/page_objects/freelancer_professional_history_page";

describe('FreelancerProfessionalHistoryPage', () => {
  beforeEach(() => {
    // seed the database prior to every test
    // cy.exec('RAILS_ENV=test rails db:seed');
    cy.fixture('login').then(function (dataJson) {
      this.dataJson = dataJson;
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
    freelancerSkillPage.setSelectRealEstateSkillsInput()
    freelancerSkillPage.setSectorsExperienceInput()
    freelancerSkillPage.setSoftwareLicensesInput()
    freelancerSkillPage.getNextInput().click()

    const freelancerAvatarLocationPage = new FreelancerAvatarLocationPage();
    const bestFixtureFile = 'icons8_trash_can_48.png'
    freelancerAvatarLocationPage.getProfilePictureUploadInput()
      .attachFile(bestFixtureFile, { force: true })
    freelancerAvatarLocationPage.setFreelancerLocationInput()
    freelancerAvatarLocationPage.getNextInput().click()

    const freelancerProfessionalHistoryPage = new FreelancerProfessionalHistoryPage();
    // cy.visit('http://localhost:5017/freelancer_profile_steps/professional_history');
    freelancerProfessionalHistoryPage.visitFreelancerSkillPage()

    // page elements check
    freelancerProfessionalHistoryPage.getBullpenNavImg()
      .should("be.visible")
      .should('have.attr', 'src', '/packs-test/media/images/bullpen-email-logo-64fc4a58c54693e46d0e2e963bd3c9ac.png')
      .should(($img) => {
        expect($img).css('width', '130px')
        expect($img).css('height', '40px')
      });

    freelancerProfessionalHistoryPage.getNavbarAvatarImg().first()
      .invoke('attr', 'src').should('contain', 'http://localhost:5017/rails/active_storage/representations/');

    const f_name = this.dataJson.first_name
    const l_name = this.dataJson.last_name
    freelancerProfessionalHistoryPage.getNavbarFirstLastNamesText()
      .should("be.visible")
      .should('have.text', f_name + ' ' + l_name)
      .click()

    freelancerProfessionalHistoryPage.getNavbarLogoutItem()
      .should("exist")
      .should('have.attr', 'href', '/users/sign_out')
      .should('have.text', 'Logout');

    freelancerProfessionalHistoryPage.getProgressBar()
      .should("exist")
      .should('have.attr', 'role', 'progressbar')
      .should('have.attr', 'style', 'width: 50%')
      .should('have.attr', 'aria-valuenow', '50');

    freelancerProfessionalHistoryPage.getProgressBarPercentage()
      .should("be.visible")
      .should('have.text', '50%');

    freelancerProfessionalHistoryPage.getProfessionalHistoryText()
      .should("be.visible")
      .should('have.text', 'Professional History');

    freelancerProfessionalHistoryPage.getTellUsAboutYourProfessionalHistoryText()
      .should("be.visible")
      .should('have.text', 'Tell us about your professional history.');

    freelancerProfessionalHistoryPage.getProfessionalTitleLabel()
      .should("be.visible")
      .should('have.text', 'Professional Title')
      .should('have.attr', 'for', 'professionalTitleInput');

    freelancerProfessionalHistoryPage.getProfessionalTitleInput()
      .should("be.visible")
      .should('have.attr', 'placeholder', 'e.g. Senior Analyst')
      .should('have.attr', 'required', 'required')
      .should('have.attr', 'type', 'text')
      .should('have.attr', 'name', 'freelancer_profile[professional_title]');

    freelancerProfessionalHistoryPage.setProfessionalTitleInput()

    freelancerProfessionalHistoryPage.getProfessionalYearsExperienceLabel()
      .should("be.visible")
      .should('have.text', 'Years of professional experience')
      .should('have.attr', 'for', 'yearsExperienceSelect');

    freelancerProfessionalHistoryPage.getProfessionalYearsExperienceInput()
      .should("be.visible")
      .should('have.text', 'Please make a selection');

    freelancerProfessionalHistoryPage.setProfessionalYearsExperienceInputDrop();

    freelancerProfessionalHistoryPage.getProfessionalSummaryLabel()
      .should("be.visible")
      .should('have.text', 'Professional Summary')
      .should('have.attr', 'for', 'professionalSummaryTextarea');

    freelancerProfessionalHistoryPage.getProfessionalSummaryInputArea()
      .should("be.visible")
      .should('have.attr', 'placeholder', 'Describe your experience in a short elevator pitch')
      .should('have.attr', 'required', 'required')
      .should('have.attr', 'rows', '3')
      .should('have.attr', 'maxlength', '1000')
      .should('have.attr', 'name', 'freelancer_profile[professional_summary]');

    freelancerProfessionalHistoryPage.setProfessionalSummaryInputArea();

    freelancerProfessionalHistoryPage.getBackLink()
      .should("exist")
      .should('have.attr', 'href', '/freelancer_profile_steps/avatar_location')
      .should('have.text', 'Back')
      .click().wait(2000).go('back');

    freelancerProfessionalHistoryPage.setProfessionalYearsExperienceInputDrop();

    freelancerProfessionalHistoryPage.getNextInput()
      .should("be.visible")
      .should('have.attr', 'name', 'commit')
      .should('have.attr', 'type', 'submit')
      .should('have.attr', 'data-disable-with', 'Next')
      .click();

  })
})
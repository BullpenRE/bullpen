/// <reference types="Cypress" />

import FreelancerSignUpPage from "../support/page_objects/freelancer_sign_up_page";
import FreelancerSkillPage from "../support/page_objects/freelancer_skill_page";
import FreelancerAvatarLocationPage from "../support/page_objects/freelancer_avatar_location_page";


describe('FreelancerAvatarLocationPage', () => {
  beforeEach(() => {
    // seed the database prior to every test
    // cy.exec('RAILS_ENV=test rails db:seed');
    cy.fixture('login').then(function (dataJson)
    {
      this.dataJson=dataJson ;
    })
  })
  it('visit skill page & check page elements presence', function () {
    const freelancerAvatarLocationPage = new FreelancerAvatarLocationPage();

    freelancerAvatarLocationPage.visitFreelancerAvatarLocationPage()

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

    freelancerSkillPage.setSelectRealEstateSkillsInput();
    freelancerSkillPage.setSectorsExperienceInput();
    freelancerSkillPage.getNextInput().click()

    // page elements check
    freelancerAvatarLocationPage.getBullpenNavImg()
      .should("be.visible")
      .should('have.attr', 'src', '/packs-test/media/images/bullpen-email-logo-64fc4a58c54693e46d0e2e963bd3c9ac.png')
      .should(($img) => {
        expect($img).css('width', '130px')
        expect($img).css('height', '40px')
      });

    freelancerAvatarLocationPage.getNavbarAvatarIcon()
      .should("be.visible")
      .should('have.attr', 'data-prefix', 'fas')
      .should('have.attr', 'data-icon', 'user-circle')
      .should('have.attr', 'role', 'img');

    const f_name = this.dataJson.first_name
    const l_name = this.dataJson.last_name
    freelancerAvatarLocationPage.getNavbarFirstLastNamesText()
      .should("be.visible")
      .should('have.text', f_name + ' ' + l_name)
      .click()

    freelancerAvatarLocationPage.getNavbarLogoutItem()
      .should("exist")
      .should('have.attr', 'href', '/users/sign_out')
      .should('have.text', 'Logout');

    freelancerAvatarLocationPage.getProgressBar()
      .should("exist")
      .should('have.attr', 'role', 'progressbar')
      .should('have.attr', 'style', 'width: 25%')
      .should('have.attr', 'aria-valuenow', '25');

    freelancerAvatarLocationPage.getProgressBarPercentage()
      .should("be.visible")
      .should('have.text', '25%');

    freelancerAvatarLocationPage.getProfilePictureText()
      .should("be.visible")
      .should('have.text', 'Profile Picture');

    freelancerAvatarLocationPage.getUserWithClearText()
      .should("be.visible")
      .should('have.text', 'Users with a clear and recognizable photo are hired more often. (Optional)');

    freelancerAvatarLocationPage.getStrongOptionalText()
      .should("be.visible")
      .should('have.text', '(Optional)');

    freelancerAvatarLocationPage.getProfileBeforeAvatarIconSize()
      .should(($div) => {
        expect($div).css('font-size', '170px')
        expect($div).css('line-height', '0px')
      });

    freelancerAvatarLocationPage.getProfileBeforeAvatarIcon()
      .should(($svg) => {
        expect($svg).to.have.length(1)
        expect($svg).have.attr('data-prefix', 'fas')
        expect($svg).have.attr('data-icon', 'user-circle')
        expect($svg).have.attr('role', 'img')
      });

    freelancerAvatarLocationPage.getProfilePictureUploadInput()
      .should("exist")
      .should('have.attr', 'name', 'avatar')
      .should('have.attr', 'type', 'file');

    freelancerAvatarLocationPage.getProfilePictureUploadInputLabel()
      .should("be.visible")
      .should('have.text', '\n                Upload your photo\n              ')
      .should('have.attr', 'for', 'uploadProfilePic');

    const bestFixtureFile = 'icons8_trash_can_48.png'
    freelancerAvatarLocationPage.getProfilePictureUploadInput()
      .attachFile(bestFixtureFile, { force: true })

    freelancerAvatarLocationPage.getProfilePictureUploadedAvatar().first()
      .invoke('attr', 'src').should('contain', 'http://localhost:5017/rails/active_storage/blobs/');

    freelancerAvatarLocationPage.getProfilePictureEditInput()
      .should("exist")
      .should('have.attr', 'name', 'avatar')
      .should('have.attr', 'type', 'file');

    freelancerAvatarLocationPage.getProfilePictureEditInputLabel()
      .should("be.visible")
      .should('have.text', '\n                Edit your photo\n              ')
      .should('have.attr', 'for', 'uploadProfilePic');

    freelancerAvatarLocationPage.getProfilePictureLocationText()
      .should("be.visible")
      .should('have.text', 'Location');

    freelancerAvatarLocationPage.getWhereDoYouLiveText()
      .should("be.visible")
      .should('have.text', 'Where do you live? Some companies prefer to work with local talent.');

    freelancerAvatarLocationPage.getLocationInputFieldLabel()
      .should("be.visible")
      .should('have.text', 'Location')
      .should('have.attr', 'for', 'freelancerLocationInput');

    freelancerAvatarLocationPage.getFreelancerLocationInput()
      .should("be.visible")
      .should('have.attr', 'name', 'user[location]')
      .should('have.attr', 'type', 'text')
      .should('have.attr', 'placeholder', 'City, State abbreviation');

    freelancerAvatarLocationPage.setFreelancerLocationInput()

    freelancerAvatarLocationPage.getBackLink()
      .should("exist")
      .should('have.attr', 'href', '/freelancer_profile_steps/skills_page')
      .should('have.text', 'Back')
      .click().wait(2000).go('back');

    freelancerAvatarLocationPage.getNextInput()
      .should("be.visible")
      .should('have.attr', 'name', 'commit')
      .should('have.attr', 'type', 'submit')
      .should('have.attr', 'data-disable-with', 'Next')
      .click();

  })
})
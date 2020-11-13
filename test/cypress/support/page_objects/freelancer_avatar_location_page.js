class FreelancerAvatarLocationPage {

  visitFreelancerAvatarLocationPage() {
    cy.visit('http://localhost:5017/freelancer_profile_steps/avatar_location', {failOnStatusCode: false});
  }

  getBullpenNavImg() {
    return cy.get('img');
  }

  getNavbarAvatarIcon() {
    return cy.get('.svg-inline--fa');
  }

  getNavbarFirstLastNamesText() {
    return cy.get('.pr-1');
  }

  getNavbarLogoutItem() {
    return cy.get('.dropdown-item');
  }
  getProgressBar() {
    return cy.get('.progress-bar');
  }

  getProgressBarPercentage() {
    return cy.get('.text-secondary');
  }

  getProfilePictureText() {
    return cy.get('.avatar > h2');
  }

  getUserWithClearText() {
    return cy.get('.avatar > .mb-4');
  }

  getStrongOptionalText() {
    return cy.get('strong');
  }

  getProfileBeforeAvatarIconSize() {
    return cy.get('.avatar > .text-light > .svg-inline--fa > path');
  }

  getProfileBeforeAvatarIcon() {
    return cy.get('.avatar > .text-light > .svg-inline--fa');
  }

  getProfilePictureUploadInput() {
    return cy.get('#uploadProfilePic.d-none');
  }

  getProfilePictureUploadInputLabel() {
    return cy.get('.custom-file > .btn');
  }

  getProfilePictureUploadedAvatar() {
    return cy.get('.rounded-circle');
  }

  getProfilePictureEditInput() {
    return cy.get('.custom-file > #uploadProfilePic.d-none');
  }

  getProfilePictureEditInputLabel() {
    return cy.get('.btn-outline-primary');
  }

  getProfilePictureLocationText() {
    return cy.get('.cy-location');
  }

  getWhereDoYouLiveText() {
    return cy.get('.row > :nth-child(2) > .mb-4');
  }

  getLocationInputFieldLabel() {
    return cy.get('.bp-input-label');
  }

  getFreelancerLocationInput() {
    return cy.get('#freelancerLocationInput');
  }

  setFreelancerLocationInput() {
    return cy.get('#freelancerLocationInput')
      .type('Walnut Creek, CA');
  }

  getBackLink() {
    return cy.get('.btn-link');
  }

  getNextInput() {
    return cy.get('.btn-primary');
  }

}
export default FreelancerAvatarLocationPage
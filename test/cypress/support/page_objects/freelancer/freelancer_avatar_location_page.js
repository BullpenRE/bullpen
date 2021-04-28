class FreelancerAvatarLocationPage {

  get route() {
    return '/freelancer_profile_steps/avatar_location';
  }

  get freelancerAvatarButton() {
    return cy.get('.custom-file > .btn');
  }

  get freelancerLocationInput() {
    return cy.get('#freelancerLocationInput');
  }

  get nextButton() {
    return cy.get('.btn-primary');
  }
}
export default FreelancerAvatarLocationPage;
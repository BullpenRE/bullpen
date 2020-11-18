class FreelancerSummaryPage {

  visitFreelancerSummaryPage() {
    cy.visit('http://localhost:5017/freelancer_profile_steps/summary');
  }

  getPleaseVerifyYourInfo() {
    return cy.get('h1');
  }

  getProfessionalPhoto() {
    return cy.get('.rounded-circle');
  }

  getFirstLastNameText() {
    return cy.get('h2');
  }

  getTitleAndLocationText() {
    return cy.get('.flex-sm-row > :nth-child(2) > .mb-2');
  }

  getProfessionalSummaryText() {
    return cy.get('.mb-4');
  }

  getSector1Info() {
    return cy.get('.flex-sm-row > :nth-child(2) > :nth-child(4) > :nth-child(1)');
  }

  getSector2Info() {
    return cy.get('.flex-sm-row > :nth-child(2) > :nth-child(4) > :nth-child(2)');
  }

}
export default FreelancerSummaryPage

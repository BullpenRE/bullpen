class FreelancerProfessionalHistoryPage {

  visitFreelancerSkillPage() {
    cy.visit('http://localhost:5017/freelancer_profile_steps/professional_history');
  }

  getBullpenNavImg() {
    return cy.get('.navbar-brand > img');
  }

  getNavbarAvatarImg() {
    return cy.get('.rounded-circle');
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

  getProfessionalHistoryText() {
    return cy.get('h2');
  }

  getTellUsAboutYourProfessionalHistoryText() {
    return cy.get('.text-center > .mb-4');
  }

  getProfessionalTitleLabel() {
    return cy.get('.cy-title > .form-group > .bp-input-label');
  }

  getProfessionalTitleInput() {
    return cy.get('#professionalTitleInput');
  }

  setProfessionalTitleInput() {
    return cy.get('#professionalTitleInput')
      .type('Software Engineer')
  }

  getProfessionalYearsExperienceLabel() {
    return cy.get('.cy-experience > .form-group > .bp-input-label');
  }

  getProfessionalYearsExperienceInput() {
    return cy.get('.filter-option-inner-inner');
  }
  setProfessionalYearsExperienceInputDrop() {
    return cy.get('select#freelancer_profile_professional_years_experience.form-control.selectpicker', { includeShadowDom: true})
      .select('>10', {force: true})
  }

  getProfessionalSummaryLabel() {
    return cy.get('.mb-5 > .bp-input-label');
  }

  getProfessionalSummaryInputArea() {
    return cy.get('#professionalSummaryTextarea');
  }

  setProfessionalSummaryInputArea() {
    return cy.get('#professionalSummaryTextarea')
      .type('Some professional summary')
  }

  getBackLink() {
    return cy.get('.btn-link');
  }

  getNextInput() {
    return cy.get('.btn-primary');
  }

}
export default FreelancerProfessionalHistoryPage

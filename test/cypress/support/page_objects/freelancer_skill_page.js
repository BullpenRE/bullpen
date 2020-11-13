class FreelancerSkillPage {

  visitFreelancerSkillPage() {
    cy.visit('http://localhost:5017/freelancer_profile_steps/skills_page');
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

  getTellUsAboutText() {
    return cy.get('h2');
  }

  getAddTagsText() {
    return cy.get('.text-center > .mb-4');
  }

  getDescribeYourRealEstatesSkillsLabel() {
    return cy.get('.form-group.mb-4 > .bp-input-label');
  }

  setSelectRealEstateSkillsInput() {
    return cy.get('select.select2.select2-hidden-accessible', { includeShadowDom: true}).first()
      .select(['Underwriting', 'Investment Memo'], {force: true})
  }

  getSectorsYouHaveExperienceLabel() {
    return cy.get('.mb-5 > .bp-input-label');
  }

  setSectorsExperienceInput() {
    return cy.get('select.select2.select2-hidden-accessible', { includeShadowDom: true}).last()
      .select(['HTC','Affordable Housing'], {force: true})
  }

  getNextInput() {
    return cy.get('.btn-primary');
  }

}
export default FreelancerSkillPage

class FreelancerSkillsPage {

  get route() {
    return '/freelancer_profile_steps/skills_page';
  }

  get realEstateSkillsInput() {
    return cy.get('.w-100 > .select2-container > .selection > .select2-selection');
  }

  selectOption(option) {
    return cy.get('.select2-results__option').contains(option);
  }

  get experienceSectorsInput() {
    return cy.get(':nth-child(4) > .select2-container > .selection > .select2-selection');
  }

  get softwareLicensesInput() {
    return cy.get('.mb-5 > .select2-container > .selection > .select2-selection');
  }

  get nextButton() {
    return cy.get('.btn-primary');
  }

  submitFreelancerSkillsForm(freelancerSkill, experienceSectors, softwareLicenses) {
    this.realEstateSkillsInput.click();
    this.selectOption(freelancerSkill).click();
    this.experienceSectorsInput.click();
    this.selectOption(experienceSectors).click();
    this.softwareLicensesInput.click();
    this.selectOption(softwareLicenses).click();
    return this.nextButton.click().wait(2000);
  }
}
export default FreelancerSkillsPage;
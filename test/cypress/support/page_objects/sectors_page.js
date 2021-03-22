class SectorsPage {

  get route() {
    return '/employer_profile_steps/sectors';
  }

  get nextButton() {
    return cy.get('.btn-primary');
  }

  sectorsCheckbox() {
    return cy.get('.custom-control-label');
  }

  submitSectorsForm(sectors = []) {
    this.sectorsCheckbox().each((checkboxLabel) => {
      if(sectors.length === 0 || sectors.includes(checkboxLabel.text())) {
        cy.wrap(checkboxLabel).click();
      }
    });
    return this.nextButton.click();
  }
}
export default SectorsPage;
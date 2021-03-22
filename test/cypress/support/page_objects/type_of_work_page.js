class TypeOfWorkPage {

  get route() {
    return '/employer_profile_steps/type_of_work';
  }

  get nextButton() {
    return cy.get('.btn-primary');
  }

  workTypeRadio(workType) {
    return cy.get('label').contains(workType);
  }

  submitWorkTypeForm(workType) {
    this.workTypeRadio(workType).click();
    return this.nextButton.click();
  }
}
export default TypeOfWorkPage;
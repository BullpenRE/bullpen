class LastQuestionPage {

  get route() {
    return '/employer_profile_steps/last_question';
  }

  get nextButton() {
    return cy.get('.btn-primary');
  }

  lastQuestionCheckbox() {
    return cy.get('.custom-control-label');
  }

  submitLastQuestionForm(lastQuestion = []) {
    this.lastQuestionCheckbox().each((checkboxLabel) => {
      if(lastQuestion.length === 0 || lastQuestion.includes(checkboxLabel.text())) {
        cy.wrap(checkboxLabel).click();
      }
    });
    return this.nextButton.click();
  }
}
export default LastQuestionPage;

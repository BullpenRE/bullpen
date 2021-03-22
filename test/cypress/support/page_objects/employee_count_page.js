class EmployeeCountPage {

  get route() {
    return '/employer_profile_steps/employee_count';
  }

  get nextButton() {
    return cy.get('.btn-primary');
  }

  employeeCount(range) {
    return cy.get('label').contains(range);
  }

  submitEmployeeCountForm(range) {
    this.employeeCount(range).click();
    return this.nextButton.click();
  }
}
export default EmployeeCountPage;
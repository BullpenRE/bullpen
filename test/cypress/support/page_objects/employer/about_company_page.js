class AboutCompanyPage {

  get route() {
    return '/employer_profile_steps/about_company';
  }

  get companyNameInput() {
    return cy.get('#companyNameInput');
  }

  get companyWebsiteInput() {
    return cy.get('#companyWebsiteInput');
  }

  get companyRoleInput() {
    return cy.get('#companyRoleInput');
  }

  get nextButton() {
    return cy.get('.btn-primary');
  }

  submitAboutCompanyForm(companyName, companyWebsite, companyRole) {
    this.companyNameInput.type(companyName);
    this.companyWebsiteInput.type(companyWebsite);
    this.companyRoleInput.type(companyRole);
    return this.nextButton.click().wait(2000);
  }
}
export default AboutCompanyPage;

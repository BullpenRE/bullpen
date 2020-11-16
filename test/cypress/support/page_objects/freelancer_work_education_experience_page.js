class FreelancerWorkEducationExperiencePage {

  visitFreelancerSkillPage() {
    cy.visit('http://localhost:5017/freelancer_profile_steps/work_education_experience');
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

  getWorkExperienceAndEducationText() {
    return cy.get('h2');
  }

  getTellUsAboutWorkExperienceAndEducationText() {
    return cy.get('.text-center > .mb-4');
  }

  getAddWorkExperienceLabel() {
    return cy.get('div.mb-4 > .bp-input-label');
  }

  getAddWorkExperienceIcon() {
    return cy.get('div.mb-4 > .btn > .svg-inline--fa.fa-plus.fa-w-14.mr-2');
  }

  getAddWorkExperienceButton() {
    return cy.get('div.mb-4 > .btn');
  }

  setAddWorkExperienceButton() {
    return cy.get('div.mb-4 > .btn')
      .click({force: true});
  }

  // beginning of WorkExperienceModule
  getWorkExperienceModuleCloseButton() {
    return cy.get('.close');
  }

  setWorkExperienceModuleCloseButton() {
    return cy.get('.close.mt-2')
      .click();
  }

  getWorkExperienceModuleCloseX() {
    return cy.get('.close > .cy-close');
  }

  setWorkExperienceModuleCloseX() {
    return cy.get('.close > .cy-close')
      .click({force: true});
  }

  getAddEducationModuleText() {
    return cy.get('form.cy-work-experience > .modal-body > #modalLabel');
  }

  getJobTitleWorkExperienceModuleText() {
    return cy.get('.form-group.cy-job-title > .bp-input-label');
  }

  getJobTitleWorkExperienceModuleInput() {
    return cy.get('#jobTitleInput');
  }

  setJobTitleWorkExperienceModuleInput() {
    return cy.get('#jobTitleInput')
      .type('Software Engineer');
  }

  getCompanyWorkExperienceModuleText() {
    return cy.get('.form-group.cy-company > .bp-input-label');
  }

  getCompanyWorkExperienceModuleInput() {
    return cy.get('#companyInput');
  }

  setCompanyWorkExperienceModuleInput() {
    return cy.get('#companyInput')
      .type('Awesome company');
  }

  getLocationWorkExperienceModuleText() {
    return cy.get('.form-group.cy-location > .bp-input-label');
  }

  getLocationWorkExperienceModuleInput() {
    return cy.get('#locationInput');
  }

  setLocationWorkExperienceModuleInput() {
    return cy.get('#locationInput')
      .type('Walnut Creek, CA');
  }

  getStartDateWorkExperienceModulelabel() {
    return cy.get('.form-group.cy-start-date > .bp-input-label');
  }

  getStartMonthWorkExperienceModuleInput() {
    return cy.get('.cy-start-month > .dropdown > .btn > .filter-option > .filter-option-inner > .filter-option-inner-inner');
  }

  setStartMonthWorkExperienceModuleInput() {
    return cy.get('#startMonth.form-control.selectpicker')
      .select('July', {force: true});
  }

  getStartYearWorkExperienceModuleInput() {
    return cy.get('.cy-start-year > .dropdown > .btn > .filter-option > .filter-option-inner > .filter-option-inner-inner');
  }

  setStartYearWorkExperienceModuleInput() {
    return cy.get('#startYear.form-control.selectpicker')
      .select('2007', {force: true});
  }

  getCurrentJobYearWorkExperienceModuleInput() {
    return cy.get('.form-group.cy-start-date > .custom-control.custom-checkbox.cy-current-job > #currentJob.custom-control-input');
  }

  getCurrentJobYearWorkExperienceModuleLabel() {
    return cy.get('.form-group.cy-start-date > .custom-control > .custom-control-label');
  }

  getEndDateWorkExperienceModuleLabel() {
    return cy.get('#endDateToggle > .bp-input-label');
  }

  getEndMonthWorkExperienceModuleInput() {
    return cy.get('.cy-end-date > .dropdown > .btn > .filter-option > .filter-option-inner > .filter-option-inner-inner');
  }

  setEndMonthWorkExperienceModuleInput() {
    return cy.get('#endMonth.form-control.selectpicker')
      .select('July', {force: true});
  }

  getEndYearWorkExperienceModuleInput() {
    return cy.get('.cy-end-year > .dropdown > .btn > .filter-option > .filter-option-inner > .filter-option-inner-inner');
  }

  setEndYearWorkExperienceModuleInput() {
    return cy.get('#endYear.form-control.selectpicker')
      .select('2020', {force: true});
  }

  getDescriptionWorkExperienceModuleLabel() {
    return cy.get('form.cy-work-experience > .modal-body > .mb-0 > .bp-input-label');
  }

  getDescriptionWorkExperienceModuleTextArea() {
    return cy.get('#jobDescriptionTextarea');
  }

  setDescriptionWorkExperienceModuleTextArea() {
    return cy.get('#jobDescriptionTextarea')
      .type('Some description');
  }

  getWorkExperienceModuleCancelButton() {
    return cy.get('form.cy-work-experience > .modal-footer > .btn-link');
  }

  getWorkExperienceModuleSaveInput() {
    return cy.get('form.cy-work-experience > .modal-footer > .btn-primary');
  }
  // end of WorkExperienceModule


  getAddEducationLabel() {
    return cy.get('.mb-5 > .bp-input-label');
  }

  getAddEducationIcon() {
    return cy.get('.mb-5 > .btn > .svg-inline--fa.fa-plus.fa-w-14.mr-2');
  }

  getAddEducationButton() {
    return cy.get('.mb-5 > .btn');
  }

  // Beginning of Education Module
  getEducationModuleCloseButton() {
    return cy.get('#addEducationModal > .modal-dialog > .modal-content > .modal-header > .mt-2');
  }

  getEducationModuleCloseX() {
    return cy.get('.mt-2 > .cy-education');
  }

  getInstitutionEducationModuleLabel() {
    return cy.get('.form-group.cy-institution > .bp-input-label');
  }

  getInstitutionEducationModuleInput() {
    return cy.get('#institutionInput');
  }

  setInstitutionEducationModuleInput() {
    return cy.get('#institutionInput')
      .type('Some University');
  }

  getDegreeEducationModuleLabel() {
    return cy.get('.form-group.cy-degree > .bp-input-label');
  }

  getDegreeEducationModuleInputDrop() {
    return cy.get('.form-group.cy-degree > .dropdown > .btn > .filter-option > .filter-option-inner > .filter-option-inner-inner');
  }

  setDegreeEducationModuleInputDrop() {
    return cy.get('.form-group.cy-degree > .dropdown > .btn > .filter-option > .filter-option-inner > .filter-option-inner-inner')
      .select('Masters', {force: true});
  }

  getCourseOfStudyEducationModuleLabel() {
    return cy.get('.form-group.cy-course-of-study > .bp-input-label');
  }

  setCourseOfStudyEducationModuleInputDrop() {
    return cy.get('#courseInput')
      .type('Some Course');
  }

  getGraduationYearEducationModuleLabel() {
    return cy.get('.form-group.cy-graduation-year > .bp-input-label');
  }

  getGraduationYearEducationModuleInputDrop() {
    return cy.get('#graduationDateToggle > :nth-child(1) > .dropdown > .btn > .filter-option > .filter-option-inner > .filter-option-inner-inner');
  }

  setGraduationYearEducationModuleInputDrop() {
    return cy.get('#graduationDateToggle > :nth-child(1) > .dropdown > .btn > .filter-option > .filter-option-inner > .filter-option-inner-inner')
      .select('1982', {force: true});
  }

  getCurrentlyStudyingYearEducationModuleInput() {
    return cy.get('.form-group.cy-graduation-year > .custom-control.custom-checkbox.cy-current-studying > #currentlyStudying.custom-control-input');
  }

  getCurrentlyStudyingYearEducationModuleLabel() {
    return cy.get('.form-group.cy-graduation-year > .custom-control > .custom-control-label');
  }

  getDescriptionOptionalEducationModuleLabel() {
    return cy.get('form.cy-education > .modal-body > .mb-0 > .bp-input-label');
  }

  getDescriptionOptionalEducationModuleTextArea() {
    return cy.get('#educationDescriptionTextarea');
  }

  setDescriptionOptionalEducationModuleTextArea() {
    return cy.get('#educationDescriptionTextarea')
      .type('Some description');
  }

  getEducationModuleCancelButton() {
    return cy.get('form.cy-education > .modal-footer > .btn-link');
  }

  getEducationModuleSaveInput() {
    return cy.get('form.cy-education > .modal-footer > .btn-primary');
  }


  // End of Education Module

  getBackLink() {
    return cy.get('.btn-link');
  }

  getNextInput() {
    return cy.get('.btn-primary');
  }
}
export default FreelancerWorkEducationExperiencePage


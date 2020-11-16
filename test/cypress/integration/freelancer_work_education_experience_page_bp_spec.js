/// <reference types="Cypress" />

import FreelancerSkillPage from "../support/page_objects/freelancer_skill_page";
import FreelancerSignUpPage from "../support/page_objects/freelancer_sign_up_page";
import FreelancerAvatarLocationPage from "../support/page_objects/freelancer_avatar_location_page";
import FreelancerProfessionalHistoryPage from "../support/page_objects/freelancer_professional_history_page";
import FreelancerWorkEducationExperiencePage from "../support/page_objects/freelancer_work_education_experience_page";

describe('FreelancerWorkEducationExperiencePage', () => {
  beforeEach(() => {
    // seed the database prior to every test
    // cy.exec('RAILS_ENV=test rails db:seed');
    cy.fixture('login').then(function (dataJson) {
      this.dataJson = dataJson;
    })
  })
  it('visit skill page & check page elements presence', function () {

    const freelancerSignUpPage = new FreelancerSignUpPage();
    freelancerSignUpPage.visitFreelancerSignUpPage()
    freelancerSignUpPage.getFirstNameInput().type(this.dataJson.first_name);
    freelancerSignUpPage.getLastNameInput().type(this.dataJson.last_name);
    freelancerSignUpPage.getEmailInput().type(this.dataJson.email);
    freelancerSignUpPage.getSignUpAsFreelancerButton().click();
    freelancerSignUpPage.getPasswordInput().type(this.dataJson.password)
    freelancerSignUpPage.getConfirmPasswordInput().type(this.dataJson.confirm_password)
    freelancerSignUpPage.getCreateMyAccountInput().click()

    const freelancerSkillPage = new FreelancerSkillPage();
    freelancerSkillPage.setSelectRealEstateSkillsInput()
    freelancerSkillPage.setSectorsExperienceInput()
    freelancerSkillPage.setSoftwareLicensesInput()
    freelancerSkillPage.getNextInput().click()

    const freelancerAvatarLocationPage = new FreelancerAvatarLocationPage();
    const bestFixtureFile = 'icons8_trash_can_48.png'
    freelancerAvatarLocationPage.getProfilePictureUploadInput()
      .attachFile(bestFixtureFile, {force: true})
    freelancerAvatarLocationPage.setFreelancerLocationInput()
    freelancerAvatarLocationPage.getNextInput().click()

    const freelancerProfessionalHistoryPage = new FreelancerProfessionalHistoryPage();
    freelancerProfessionalHistoryPage.setProfessionalTitleInput()
    freelancerProfessionalHistoryPage.setProfessionalYearsExperienceInputDrop()
    freelancerProfessionalHistoryPage.setProfessionalSummaryInputArea()
    freelancerProfessionalHistoryPage.getNextInput().click()

    const freelancerWorkEducationExperiencePage = new FreelancerWorkEducationExperiencePage();
    // cy.visit('http://localhost:5017/freelancer_profile_steps/work_education_experience');
    freelancerWorkEducationExperiencePage.visitFreelancerSkillPage()

    // page elements check
    freelancerWorkEducationExperiencePage.getBullpenNavImg()
      .should("be.visible")
      .should('have.attr', 'src', '/packs-test/media/images/bullpen-email-logo-64fc4a58c54693e46d0e2e963bd3c9ac.png')
      .should(($img) => {
        expect($img).css('width', '130px')
        expect($img).css('height', '40px')
      });

    freelancerWorkEducationExperiencePage.getNavbarAvatarImg().first()
      .invoke('attr', 'src').should('contain', 'http://localhost:5017/rails/active_storage/representations/');

    const f_name = this.dataJson.first_name
    const l_name = this.dataJson.last_name
    freelancerWorkEducationExperiencePage.getNavbarFirstLastNamesText()
      .should("be.visible")
      .should('have.text', f_name + ' ' + l_name)
      .click()

    freelancerWorkEducationExperiencePage.getNavbarLogoutItem()
      .should("exist")
      .should('have.attr', 'href', '/users/sign_out')
      .should('have.text', 'Logout');

    freelancerWorkEducationExperiencePage.getProgressBar()
      .should("exist")
      .should('have.attr', 'role', 'progressbar')
      .should('have.attr', 'style', 'width: 75%')
      .should('have.attr', 'aria-valuenow', '75');

    freelancerWorkEducationExperiencePage.getProgressBarPercentage()
      .should("be.visible")
      .should('have.text', '75%');

    freelancerWorkEducationExperiencePage.getWorkExperienceAndEducationText()
      .should("be.visible")
      .should('have.text', 'Work experience and education');

    freelancerWorkEducationExperiencePage.getTellUsAboutWorkExperienceAndEducationText()
      .should("be.visible")
      .should('have.text', 'Tell us about your work experience and educational background.');

    freelancerWorkEducationExperiencePage.getAddWorkExperienceLabel()
      .should("be.visible")
      .should('have.text', '\n        Work Experience\n      ');

    freelancerWorkEducationExperiencePage.getAddWorkExperienceIcon()
      .should("be.visible")
      .should('have.attr', 'data-prefix', 'fas')
      .should('have.attr', 'data-icon', 'plus')
      .should('have.attr', 'role', 'img');

    freelancerWorkEducationExperiencePage.getAddWorkExperienceButton()
      .should("be.visible")
      .should('have.attr', 'data-toggle', 'modal')
      .should('have.attr', 'data-target', '#addWorkExperienceModal')
      .should('have.text', 'Add Experience');

    freelancerWorkEducationExperiencePage.setAddWorkExperienceButton();

    // beginning of WorkExperienceModule
    freelancerWorkEducationExperiencePage.getWorkExperienceModuleCloseButton()
      .should("exist")
      .should('have.attr', 'data-dismiss', 'modal')
      .should('have.attr', 'aria-label', 'Close')

    freelancerWorkEducationExperiencePage.getWorkExperienceModuleCloseX()
      .should("exist")
      .should('have.attr', 'aria-hidden', 'true')
      .should('have.text', '×');

    // freelancerWorkEducationExperiencePage.setWorkExperienceModuleCloseButton();
    // freelancerWorkEducationExperiencePage.setAddWorkExperienceButton();

    freelancerWorkEducationExperiencePage.getAddWorkExperienceModuleText()
      .should("be.visible")
      .should('have.text', 'Add Experience');

    freelancerWorkEducationExperiencePage.getJobTitleWorkExperienceModuleText()
      .should("be.visible")
      .should('have.text', 'Job Title');

    freelancerWorkEducationExperiencePage.getJobTitleWorkExperienceModuleInput()
      .should("be.visible")
      .should('have.attr', 'placeholder', 'Enter your job title')
      .should('have.attr', 'required', 'required')
      .should('have.attr', 'type', 'text')
      .should('have.attr', 'name', 'freelancer_profile_experience[job_title]');

    freelancerWorkEducationExperiencePage.setJobTitleWorkExperienceModuleInput();

    freelancerWorkEducationExperiencePage.getCompanyWorkExperienceModuleText()
      .should("be.visible")
      .should('have.text', 'Company');

    freelancerWorkEducationExperiencePage.getCompanyWorkExperienceModuleInput()
      .should("be.visible")
      .should('have.attr', 'placeholder', 'Enter the company name')
      .should('have.attr', 'required', 'required')
      .should('have.attr', 'type', 'text')
      .should('have.attr', 'name', 'freelancer_profile_experience[company]');

    freelancerWorkEducationExperiencePage.setCompanyWorkExperienceModuleInput();

    freelancerWorkEducationExperiencePage.getLocationWorkExperienceModuleText()
      .should("be.visible")
      .should('have.text', 'Location');

    freelancerWorkEducationExperiencePage.getLocationWorkExperienceModuleInput()
      .should("be.visible")
      .should('have.attr', 'placeholder', 'e.g. San Francisco, CA')
      .should('have.attr', 'required', 'required')
      .should('have.attr', 'type', 'text')
      .should('have.attr', 'name', 'freelancer_profile_experience[location]');

    freelancerWorkEducationExperiencePage.setLocationWorkExperienceModuleInput();

    freelancerWorkEducationExperiencePage.getStartDateWorkExperienceModulelabel()
      .should("be.visible")
      .should('have.text', 'Start Date');

    freelancerWorkEducationExperiencePage.getStartMonthWorkExperienceModuleInput()
      .should("be.visible")
      .should('have.text', 'Month');

    freelancerWorkEducationExperiencePage.setStartMonthWorkExperienceModuleInput();

    freelancerWorkEducationExperiencePage.getStartYearWorkExperienceModuleInput()
      .should("be.visible")
      .should('have.text', 'Year');

    freelancerWorkEducationExperiencePage.setStartYearWorkExperienceModuleInput();

    freelancerWorkEducationExperiencePage.getCurrentJobYearWorkExperienceModuleInput()
      .should("exist")
      .should('have.attr', 'type', 'checkbox')
      .should('have.attr', 'data-toggle', 'collapse')
      .should('have.attr', 'data-target', '#endDateToggle')
      .should('have.attr', 'aria-expanded', 'false')
      .should('have.attr', 'aria-controls', 'endDateToggle')
      .should('have.attr', 'value', '1')
      .should('have.attr', 'name', 'freelancer_profile_experience[current_job]');

    freelancerWorkEducationExperiencePage.getCurrentJobYearWorkExperienceModuleLabel()
      .should("be.visible")
      .should('have.text', 'Current Job')
      .should('have.attr', 'for', 'currentJob');

    freelancerWorkEducationExperiencePage.getEndDateWorkExperienceModuleLabel()
      .should("be.visible")
      .should('have.text', 'End Date');

    freelancerWorkEducationExperiencePage.getEndMonthWorkExperienceModuleInput()
      .should("be.visible")
      .should('have.text', 'Month');

    freelancerWorkEducationExperiencePage.setEndMonthWorkExperienceModuleInput();

    freelancerWorkEducationExperiencePage.getEndYearWorkExperienceModuleInput()
      .should("be.visible")
      .should('have.text', 'Year');

    freelancerWorkEducationExperiencePage.setEndYearWorkExperienceModuleInput();

    freelancerWorkEducationExperiencePage.getDescriptionWorkExperienceModuleLabel()
      .should("be.visible")
      .should('have.text', 'Description');

    freelancerWorkEducationExperiencePage.getDescriptionWorkExperienceModuleTextArea()
      .should("exist")
      .should('have.attr', 'placeholder', 'Enter your job description')
      .should('have.attr', 'rows', '3')
      .should('have.attr', 'required', 'required')
      .should('have.attr', 'name', 'freelancer_profile_experience[description]');

    freelancerWorkEducationExperiencePage.setDescriptionWorkExperienceModuleTextArea();

    freelancerWorkEducationExperiencePage.getWorkExperienceModuleCancelButton()
      .should("exist")
      .should('have.attr', 'data-dismiss', 'modal')
      .should('have.text', 'Cancel')

    freelancerWorkEducationExperiencePage.getWorkExperienceModuleSaveInput()
      .should("exist")
      .should('have.attr', 'name', 'commit')
      .should('have.attr', 'type', 'submit')
      .should('have.attr', 'data-disable-with', 'Save')
      .click();
    // end of WorkExperienceModule

    freelancerWorkEducationExperiencePage.getAddEducationLabel()
      .should("be.visible")
      .should('have.text', '\n        Education\n      ');

    freelancerWorkEducationExperiencePage.getAddEducationIcon()
      .should("be.visible")
      .should('have.attr', 'data-prefix', 'fas')
      .should('have.attr', 'data-icon', 'plus')
      .should('have.attr', 'role', 'img');

    freelancerWorkEducationExperiencePage.getAddEducationButton()
      .should("be.visible")
      .should('have.attr', 'data-toggle', 'modal')
      .should('have.attr', 'data-target', '#addEducationModal')
      .should('have.text', 'Add Education');

    freelancerWorkEducationExperiencePage.setAddEducationButton();

    // Beginning of Education Module
    freelancerWorkEducationExperiencePage.getEducationModuleCloseButton()
      .should("exist")
      .should('have.attr', 'data-dismiss', 'modal')
      .should('have.attr', 'aria-label', 'Close');

    freelancerWorkEducationExperiencePage.getEducationModuleCloseX()
      .should("exist")

      .should('have.text', '×');

    freelancerWorkEducationExperiencePage.getAddEducationModuleText()
      .should("be.visible")
      .should('have.text', 'Add Education');

    freelancerWorkEducationExperiencePage.getInstitutionEducationModuleLabel()
      .should("be.visible")
      .should('have.text', 'Institution')
      .should('have.attr', 'for', 'institutionInput');

    freelancerWorkEducationExperiencePage.getInstitutionEducationModuleInput()
      .should("be.visible")
      .should('have.attr', 'placeholder', 'Enter the school you attended')
      .should('have.attr', 'type', 'text')
      .should('have.attr', 'name', 'freelancer_profile_education[institution]');

    freelancerWorkEducationExperiencePage.setInstitutionEducationModuleInput();

    freelancerWorkEducationExperiencePage.getDegreeEducationModuleLabel()
      .should("be.visible")
      .should('have.text', 'Degree');

    freelancerWorkEducationExperiencePage.getDegreeEducationModuleInputDrop()
      .should("be.visible")
      .should('have.text', 'Please make a selection');

    freelancerWorkEducationExperiencePage.setDegreeEducationModuleInputDrop();

    freelancerWorkEducationExperiencePage.getCourseOfStudyEducationModuleLabel()
      .should("be.visible")
      .should('have.text', 'Course of Study');

    freelancerWorkEducationExperiencePage.getCourseOfStudyEducationModuleInput()
      .should("be.visible")
      .should('have.attr', 'placeholder', 'Enter your degree program')
      .should('have.attr', 'type', 'text')
      .should('have.attr', 'name', 'freelancer_profile_education[course_of_study]');

    freelancerWorkEducationExperiencePage.setCourseOfStudyEducationModuleInput();

    freelancerWorkEducationExperiencePage.getGraduationYearEducationModuleLabel()
      .should("be.visible")
      .should('have.text', 'Graduation Year');

    freelancerWorkEducationExperiencePage.getGraduationYearEducationModuleInputDrop()
      .should("be.visible")
      .should('have.text', 'Year');

    freelancerWorkEducationExperiencePage.setGraduationYearEducationModuleInputDrop();

    freelancerWorkEducationExperiencePage.getCurrentlyStudyingEducationModuleInput()
      .should("exist")
      .should('have.attr', 'type', 'checkbox')
      .should('have.attr', 'data-toggle', 'collapse')
      .should('have.attr', 'data-target', '#graduationDateToggle')
      .should('have.attr', 'aria-expanded', 'false')
      .should('have.attr', 'aria-controls', 'graduationDateToggle')
      .should('have.attr', 'value', '1')
      .should('have.attr', 'name', 'freelancer_profile_education[currently_studying]');

    freelancerWorkEducationExperiencePage.getCurrentlyStudyingYearEducationModuleLabel()
      .should("be.visible")
      .should('have.text', 'Currently Studying')
      .should('have.attr', 'for', 'currentlyStudying');

    freelancerWorkEducationExperiencePage.getDescriptionOptionalEducationModuleLabel()
      .should("be.visible")
      .should('have.text', 'Description (optional)');

    freelancerWorkEducationExperiencePage.getDescriptionOptionalEducationModuleTextArea()
      .should("exist")
      .should('have.attr', 'placeholder', 'Enter a brief description')
      .should('have.attr', 'rows', '3')
      .should('have.attr', 'name', 'freelancer_profile_education[description]');

    freelancerWorkEducationExperiencePage.setDescriptionOptionalEducationModuleTextArea();

    freelancerWorkEducationExperiencePage.getEducationModuleCancelButton()
      .should("exist")
      .should('have.attr', 'data-dismiss', 'modal')
      .should('have.text', 'Cancel')

    freelancerWorkEducationExperiencePage.getEducationModuleSaveInput()
      .should("exist")
      .should('have.attr', 'name', 'commit')
      .should('have.attr', 'type', 'submit')
      .should('have.attr', 'data-disable-with', 'Save')
      .click();
    // End of Education Module

    freelancerWorkEducationExperiencePage.getBackLink()
      .should("exist")
      .should('have.attr', 'href', '/freelancer_profile_steps/professional_history')
      .should('have.text', 'Back')
      .click().wait(2000).go('back');

    // freelancerProfessionalHistoryPage.setProfessionalYearsExperienceInputDrop();

    freelancerWorkEducationExperiencePage.getNextLink()
      .should("be.visible")
      .should('have.attr', 'href', '/freelancer_profile_steps/summary')
      .should('have.text', 'Next')
      .click();
  })
})

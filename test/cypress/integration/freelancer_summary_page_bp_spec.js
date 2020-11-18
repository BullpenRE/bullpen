/// <reference types="Cypress" />

import FreelancerSkillPage from "../support/page_objects/freelancer_skill_page";
import FreelancerSignUpPage from "../support/page_objects/freelancer_sign_up_page";
import FreelancerAvatarLocationPage from "../support/page_objects/freelancer_avatar_location_page";
import FreelancerProfessionalHistoryPage from "../support/page_objects/freelancer_professional_history_page";
import FreelancerWorkEducationExperiencePage from "../support/page_objects/freelancer_work_education_experience_page";
import FreelancerSummaryPage from "../support/page_objects/freelancer_summary_page";

describe('FreelancerSummaryPage', () => {
  beforeEach(() => {
    // seed the database prior to every test
    // cy.exec('RAILS_ENV=test rails db:seed');
    cy.fixture('login').then(function (dataJson) {
      this.dataJson = dataJson;
    })
  })
  it('visit summary page & check page elements presence', function () {

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
    freelancerWorkEducationExperiencePage.setAddWorkExperienceButton();
    freelancerWorkEducationExperiencePage.setJobTitleWorkExperienceModuleInput();
    freelancerWorkEducationExperiencePage.setCompanyWorkExperienceModuleInput();
    freelancerWorkEducationExperiencePage.setLocationWorkExperienceModuleInput();
    freelancerWorkEducationExperiencePage.setStartMonthWorkExperienceModuleInput();
    freelancerWorkEducationExperiencePage.setStartYearWorkExperienceModuleInput();
    freelancerWorkEducationExperiencePage.setEndMonthWorkExperienceModuleInput();
    freelancerWorkEducationExperiencePage.setEndYearWorkExperienceModuleInput();
    freelancerWorkEducationExperiencePage.setDescriptionWorkExperienceModuleTextArea();
    freelancerWorkEducationExperiencePage.setWorkExperienceModuleSaveInput();
    freelancerWorkEducationExperiencePage.setAddEducationButton();
    freelancerWorkEducationExperiencePage.setInstitutionEducationModuleInput();
    freelancerWorkEducationExperiencePage.setDegreeEducationModuleInputDrop();
    freelancerWorkEducationExperiencePage.setCourseOfStudyEducationModuleInput();
    freelancerWorkEducationExperiencePage.setGraduationYearEducationModuleInputDrop();
    freelancerWorkEducationExperiencePage.setDescriptionOptionalEducationModuleTextArea();
    freelancerWorkEducationExperiencePage.setEducationModuleSaveInput();
    freelancerWorkEducationExperiencePage.setNextFinalLink();


    const freelancerSummaryPage = new FreelancerSummaryPage();
    // cy.visit('http://localhost:5017/freelancer_profile_steps/summary');
    freelancerSummaryPage.visitFreelancerSummaryPage()

  })
})
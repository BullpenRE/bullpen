/// <reference types="Cypress" />

describe('Create freelancer_profiles.rb via factory and test freelancer your_profile flow', () => {

  it('create freelancer_profiles.rb via factory and test freelancer your_profile flow', function () {
    // via freelancer_profiles.rb create freelancer_profile
    cy.appFactories([
      ['create', 'freelancer_profile']

    ])
    // login as just created freelancer
    cy.visit('http://localhost:5017/users/sign_in', {failOnStatusCode: false})
    cy.get('#user_email')
      .should('exist')
      .type('tetyanaFree@gmail.com')
    cy.get('#user_password')
      .should('exist')
      .type('q1234567!Q')
    cy.get('.actions > .btn')
      .should('exist')
      .click()

    // try to click button 'Your Profile' on navbar
    cy.get(':nth-child(2) > .nav-link')
      .should('exist')
      .click()

    // try to click edit button in opened module 'Your Profile' re personal information
    cy.get('[data-target^="#editProfileModal"]')
      .should('exist')
      .click()

    // try to upload avatar
    const bestFixtureFile = 'icons8_trash_can_48.png'

    cy.get('input#uploadProfilePic')
      .should('exist')
      .attachFile(bestFixtureFile, { force: true })

    // try to amend last name in opened module 'Personal Information'
    cy.get('#lastName')
      .should('exist')
      .clear()
      .type('Newlastname')

    // try to amend location in opened module 'Personal Information'
    cy.get('#freelancerLocationInput')
      .should('exist')
      .clear()
      .type('San Francisco, CA')

    // try to amend 'Desired Hourly Rate' in opened module 'Personal Information'
    cy.get('#perHourBid')
      .should('exist')
      .clear()
      .type('195')

    // try to click button 'Save Changes' in opened module 'Personal Information'
    cy.get('#submitWithLocationCheck')
      .should('exist')
      .click()

    // try to edit data in chapter 'Skills'
    cy.get('[data-target^="#editSkills"]')
      .should('exist')
      // .wait(2000)
      .get('[data-target^="#editSkills"]')
      .click({force: true})

    // try to change skills via select menu in opened chapter 'Skills'
    cy.get('.select2-search__field', { includeShadowDom: true})
    cy.get('#freelancer_profile_freelancer_real_estate_skills.select2.select2-hidden-accessible', { includeShadowDom: true}).first()
      .select(['Acquisition Underwriting', 'Market Research', 'Zoning Requirements'], {force: true})

    // try to click button 'Save Changes'
    cy.get('.modal-body > .d-flex > .btn-primary')
      .should('exist')
      .click({force: true})

    // try to edit data in chapter 'Software Licenses'
    cy.get('[data-target^="#editSoftwareModal"]')
      .should('exist')
      .wait(2000)
      // .get('[data-target^="#editSoftwareModal"]')
      .click()

    // try to change software licenses via select menu in opened chapter 'Software Licenses'
    cy.get('.select2-search__field', { includeShadowDom: true})
    cy.get('#freelancer_softwares_freelancer_softwares.select2.select2-hidden-accessible', { includeShadowDom: true}).first()
      .select(['Microsoft Excel', 'Microsoft Powerpoint', 'Microsoft Suite'], {force: true})

    // try to click button 'Save Changes' in opened chapter 'Software Licenses'
    cy.get('#editSoftwareModal > .modal-dialog > .modal-content > .modal-body > form > .d-flex > .btn-primary')
      .should('exist')
      .click()

   // try to edit data in chapter 'Experience'
    cy.get('[data-target^="#editWorkExperienceModal"]')
      .first()
      .should('exist')
      // .wait(2000)
      // .get('[data-target^="#editWorkExperienceModal"]')
      .click()

    // try to amend company name
    cy.get('input[name="freelancer_profile_experience[company]"]')
      .eq(0)
      .should('exist')
      .clear({force: true})
      .type('Cy Newcompanyname')

    // try to amend job title
    cy.get('input[name="freelancer_profile_experience[job_title]"]')
      .eq(0)
      .should('exist')
      .clear({force: true})
      .type('Cy Newjobtitle')

    // try to amend location
    cy.get('input[name="freelancer_profile_experience[location]"]')
      .eq(0)
      .should('exist')
      .clear({force: true})
      .type('San Francisco, CA')

    // try to amend end date => try to check check-box 'This is my current work'
    cy.get('[id^="currentJob-"].custom-control-input')
      .check({force: true})

    // try to amend experience description
    cy.get('textarea[name="freelancer_profile_experience[description]"]')
      .eq(0)
      .clear({force: true})
      .type('Cy New work experience description')

    // try to click button 'Save Changes'
    cy.get('[id^="submitExperienceWithLocationCheck"')
      .eq(0)
      .should('exist')
      .click()

    // try to to edit data in chapter 'Education'
    cy.get('[data-target^="#editEducationModal"]')
      .first()
      .should('exist')
      .wait(2000)
      .get('[data-target^="#editEducationModal"]')
      .click({force: true})

    // try to amend institution
    cy.get('[id^="institutionInput"]')
      .first()
      .clear({force: true})
      .type('Cy New University', {force: true})

    // try to amend degree
    cy.get('[name="freelancer_profile_education[degree]"]')
      .eq(0)
      .should('exist')
      .select('PHD', {force: true})

    // try to amend course of study
    cy.get('[name="freelancer_profile_education[course_of_study]"]')
      .eq(0)
      .clear()
      .type('CS')

    // try to amend year of graduation
    cy.get('[name="freelancer_profile_education[graduation_year]"]')
      .eq(0)
      .should('exist')
      .select('1990', {force: true})

    // try to click button 'Save Changes'
    cy.get('[id^="submitEducationInput"')
      .eq(0)
      .should('exist')
      .click()

    // try to to edit data in chapter 'Licenses & Certifications'
    cy.get('[data-target^="#editLicenseCertificationModal"]')
      .first()
      .should('exist')
      // .wait(2000)
      // .get('[data-target^="#editLicenseCertificationModal"]')
      .click()

    // try to amend license or certification
    cy.get('[name="freelancer_certification[certification_id]"]')
      .eq(0)
      .should('exist')
      .select('Chartered Financial Analyst', {force: true})

    // try to click button 'Save Changes'
    cy.get('[id^="editLicenseCertificationModal"] > .modal-dialog > .modal-content > form > .modal-footer > .btn-primary')
    // cy.get('[data-disable-with="Save Changes"]')
      .eq(0)
      .should('exist')
      .click({force: true})

  })
})

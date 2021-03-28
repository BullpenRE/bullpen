/// <reference types="Cypress" />

describe('Create job via factory job_questions.rb, freelancer via factory freelancer_profiles.rb and test freelancer find_job flow', () => {

  it('create job via factory job_questions.rb, freelancer via factory freelancer_profiles.rb and test freelancer find_job flow', function () {
    // via factories job_questions.rb, freelancer_profiles.rb create job with questions, employer, employer_profile, freelancer, freelancer_profile
    cy.appFactories([
      ['create', 'job_question'],
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

   // try to click button 'Show Details'
    cy.get(':nth-child(2) > .btn')
      .should('exist')
      .click()

    // try to close opened module 'Show Details' of job via cliking to '×'
    cy.get('.close > span')
      .should('exist')
      .click()

    // try to click button 'Apply'
    cy.get('.mb-2 > .btn')
      .should('exist')
      .click()

    // try to complete module 'Apply...'
    cy.get('#bidAmount')
      .should('exist')
      .type('180')

    // try to check radio-button 'Yes' under 'Are you available from 9AM-5PM PST?'
    cy.get('input[name="job_application[available_during_work_hours]"]')
      .first()
      .check({force: true})

    // try to answer employer's question
    cy.get('#jobQuestion')
      .should('exist')
      .type('Cy Response_1')

    // try to click button 'Next'
    cy.get('form > .modal-footer > .btn-primary')
      .should('exist')
      .click()

    // try to complete text-area re cover letter
    cy.get('#coverLetter')
      .should('exist')
      .type('Cy My Cover Letter')

    // try to click button 'Preview Application'
    cy.get('.d-none > .btn-primary')
      .should('exist')
      .click()

    // try to click button 'Submit application'
    cy.get('.modal-footer > div > .btn-primary')
      .should('exist')
      .wait(2000)
      .get('.modal-footer > div > .btn-primary')
      .click()

    // try to click dropdown menu item 'Show Application'
    cy.get('[data-target^="#previewApplicationDropdown"]')
      .should('exist')
      .click({force: true})

    // try to click button 'Edit application'
    cy.get('.ml-auto')
      .should('exist')
      .click()

    // try to amend bid amount
    cy.get('#bidAmount')
      .clear()
      .should('exist')
      .type('195')

    // try to click button 'Next'
    cy.get('#jobAppStep1 > .modal-dialog > .modal-content > form > .modal-footer > .btn-primary')
      .should('exist')
      .click()

    // try to click button 'Preview application
    cy.get('.d-none > .btn')
      .should('exist')
      .click()

    // try to click button 'Submit application'
    cy.get('[action="/freelancer/application_flows/application_step_1"] > .modal-footer > div > .btn')
      .should('exist')
      .wait(2000)
      .get('[action="/freelancer/application_flows/application_step_1"] > .modal-footer > div > .btn')
      .click()

    // try to click dropdown menu item 'Edit application'
    cy.get('.flex-sm-row > .dropdown > .dropdown-menu > a.dropdown-item')
      .should('exist')
      .wait(2000)
      .get('.flex-sm-row > .dropdown > .dropdown-menu > a.dropdown-item')
      .click({force: true})

    // try to close opened for editin module 'Edit application' via clicking on '×'
    cy.get('#jobAppStep1 > .modal-dialog > .modal-content > .modal-header > .close > span')
      .should('exist')
      .click()

    // try to click dropdown menu item 'Show Job Details'
    cy.get('[data-target^="#showJobPost"]')
      .should('exist')
      .click({force: true})


    // try to close opened module 'Show Job Details' via '×'
    cy.get('[id^=showJobPost] > .modal-dialog > .modal-content > .modal-header > .close > span')
      .should('exist')
      .click()

    // try to click dropdown menu item 'Withdraw Application'
    cy.get('.dropdown-menu > .text-danger')
      .should('exist')
      .click({force: true})

    // try to cancel application withdrawal via 'Cancel' button click
    cy.get('[id^=withdrawApplication] > .modal-dialog > .modal-content > .modal-footer > .btn-link')
      .should('exist')
      .click({force: true})

  })
})

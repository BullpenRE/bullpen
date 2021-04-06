/// <reference types="Cypress" />

describe('Create billing via factory billings.rb and test billing flow', () => {

  it('create billing via factory billings.rb and test billing flow', function () {
    // via factory contract.rb create contract, employer, employer_profile, freelancer, freelancer_profile
    cy.appFactories([
      ['create', 'billing']

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

    // try to click button 'Contracts' on navbar
    cy.get(':nth-child(2) > .nav-link')
      .should('exist')
      .click({force: true})

    // try click button 'Accept Offer
    cy.get('.d-block > .btn')
      .should('exist')
      .click({force: true})

    // try to click link 'Show Billing'
    cy.get('[data-target^="#collapseBillings"]')
      .eq(0)
      .should('exist')
      .click({force: true})

    // try to click button 'Add Hours'
    cy.get('[data-target^="#addHours"]')
      .should('exist')
      .click({force: true})

    // try to add data in opened module 'Add Billing Hours'
    // try to add date
    cy.get('.today')
      .should('exist')
      .click({force: true})

    // try to add hours spent for job
    cy.get('[id^="hours"]')
      .type('2')

    // try to add minutes spent for job
    cy.get('[id^="minutes"]')
      .type('15')

    // try to add brief description of the task performed
    cy.get('#billing_description')
      .type('Cy - brief description of the task1 performed')

    // try to click button 'Add Hours'
    cy.get('[id^="addHours"] > .modal-dialog > .modal-content > .modal-body > form > .form-group > .d-flex > .btn')
      .eq(0)
      .should('exist')
      .click({force: true})

    // try to click link 'Show Billing' - again
    cy.get('[data-target^="#collapseBillings"]')
      .eq(0)
      .should('exist')
      .click({force: true})

    // try to add hours ones more
    cy.get('.d-block > .btn')
      .should('exist')
      .click()

    //try to add date in opened module 'Add Billing Hours'
    cy.get('.flatpickr.form-control.input')
      .eq('1')
      .should('exist')
      .click({force: true})
      .get('.open > .flatpickr-innerContainer > .flatpickr-rContainer > .flatpickr-days > .dayContainer > .selected')
      .should('exist')
      .click({force: true})

    // try to add hours
    cy.get('[name="billing[hours]"]')
      .eq(0)
      .should('exist')
      .type('3', {force: true})

    //try to add minutes
    cy.get('[name="billing[minutes]"]')
      .eq(0)
      .should('exist')
      .type('15', {force: true})

    // try to add brief description of the task performed
    cy.get('[name="billing[description]"]')
      .eq(0)
      .should('exist')
      .type('Cy - brief description of the task2 performed', {force: true})

    // try to click button 'Add Hours' in opened module 'Add Billing Hours'
    cy.get('[id^="addHours"] > .modal-dialog > .modal-content > .modal-body > form > .form-group > .d-flex > .btn')
      .eq(0)
      .should('exist')
      .click({force: true})

    // try to click link 'Show Billing' - after 2nd data 'Add Hours' adding
    cy.get('[data-target^="#collapseBillings"]')
      .eq(0)
      .should('exist')
      .click({force: true})

    // try to edit info about just inserted hours
    // try to click edit button icon
    cy.get('button.align-self-start.btn.btn-link.shadow-none.p-0.ml-1')
      .eq(0)
      .should('exist')
      .click({force: true})

    // try to amend description
    cy.get('[id^="addHours"] > .modal-dialog > .modal-content > .modal-body > form > .form-group > .w-100 > #billing_description')
      .eq(1)
      .should('exist')
      .clear({force: true})
      .type('Cy - Amended text', {force: true})

    // try to click button 'Save Changes'
    cy.get('[id^="addHours"] > .modal-dialog > .modal-content > .modal-body > form > .form-group > .d-flex > .btn-primary')
      .eq(1)
      .should('exist')
      .click({force: true})

    // try to click link 'Show Billing' - after amendment data 'Add Hours'
    cy.get('[data-target^="#collapseBillings"]')
      .eq(1)
      .should('exist')
      .click({force: true})

    // try to log out as freelancer
    cy.get('.dropdown-menu > [rel="nofollow"]')
      .should('exist')
      // .wait(2000)
      // .get('[rel="nofollow"]')
      .click({force: true})

    // login as just created employer
    cy.visit('http://localhost:5017/users/sign_in', {failOnStatusCode: false})
    cy.get('#user_email')
      .should('exist')
      .type('tetyanaEmpl@gmail.com')
    cy.get('#user_password')
      .should('exist')
      .type('q1234567!Q')
    cy.get('.actions > .btn')
      .should('exist')
      .click()

    // try to click button 'Contracts' on navbar
    cy.wait(2000)
      .get(':nth-child(5) > .nav-link')
      .should('exist')
      // .get(':nth-child(6) > .nav-link')
      .click()

    // try to click link 'Show Billing' as employer
    cy.get('[data-target^="#collapseBillings"]')
      .eq(0)
      .should('exist')
      .click()

    // try to click link 'Dispute Hours'
    cy.get('.align-self-start')
      .should('exist')
      .click()

    // try to close opened module via 'x'
    cy.get('[id^="disputeHours"] > .modal-dialog > .modal-content > .modal-header > .close > span')
      .should('exist')
      .click()

    // try to click link 'Dispute Hours' again
    cy.get('.align-self-start')
      .should('exist')
      .click()

    // try to check upper check-box among 'Select the time entries you would like to do dispute.'
    cy.get('[aria-controls="collapseDisputedComments"]')
      .eq(0)
      .should('exist')
      .check({force: true})

    // try to add text of dispute in text-area with placeholder 'Enter detailed comments'
    cy.get('[placeholder="Enter detailed comments"]')
      .eq(0)
      .should('exist')
      .type('Cy - Dispute text for upper item of disputing list', {force: true})

    // try to check upper check-box among 'Select the time entries you would like to do dispute.'
    cy.get('[aria-controls="collapseDisputedComments"]')
      .eq(1)
      .should('exist')
      .check({force: true})
    // try to add text of dispute in text-area with placeholder 'Enter detailed comments'
    cy.get('[placeholder="Enter detailed comments"]')
      .eq(1)
      .should('exist')
      .type('Cy - Dispute text for lower item of disputing list', {force: true})

    // try to click button 'submit dispute'
    cy.get('[data-disable-with="Submit Dispute"]')
      .should('exist')
      .click()

    // try to click link 'Show Billing' as employer again
    cy.get('[data-target^="#collapseBillings"]')
      .eq(0)
      .should('exist')
      .click()

    // try to check if word 'Disputed' has red color - class 'text-danger'
    cy.get(':nth-child(3) > .w-100 > .row > .col-2')
      .should('exist')
      .should( 'have.class', 'text-danger')

  })
})

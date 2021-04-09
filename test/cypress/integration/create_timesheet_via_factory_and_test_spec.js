/// <reference types="Cypress" />

describe('Create timesheet via factory timesheet.rb and test timesheet flow', () => {

  it('create timesheet via factory timesheet.rb and test timesheet flow', function () {
    // via factory timesheet.rb create contract, employer, employer_profile, freelancer, freelancer_profile
    cy.appFactories([
      ['create', 'timesheet']

    ])
    // try to login as just created freelancer
    cy.gui_login('tetyanaFree@gmail.com')

    // try to click button 'Contracts' on navbar
    cy.get(':nth-child(2) > .nav-link')
      .should('exist')
      .click()
    // try to click button 'Accept Offer'
    cy.get('.d-block > .btn')
      .should('exist')
      .click()

    // try to click button 'Add Hours'
    cy.get('.d-block > .btn')
      .should('exist')
      .wait(2000)
      .get('.d-block > .btn')
      .click()

    // try to complete opened module 'Add Billing Hours'
    // try to set date
    cy.get('.today')
      .should('exist')
      .click({force: true})

    // try to add hours
    cy.get('[id^="hours"]')
      .should('exist')
      .type('2', {force: true})

    // try to add minutes
    cy.get('[id^="minutes"]')
      .should('exist')
      .type('30', {force: true})

    // try to add 'Enter a brief description of the task performed'
    cy.get('#billing_description')
      .should('exist')
      .type('Cy - brief description of the task performed')

    // try to click button 'Add Hours'
    cy.get('[id^="addHours"] > .modal-dialog > .modal-content > .modal-body > form > .form-group > .d-flex > .btn')
      .should('exist')
      .click()

    // try to click link 'Show Billing'
    cy.get('[data-target^="#collapseBillings"]')
      .eq(0)
      .should('exist')
      .click({force: true})

  })
})

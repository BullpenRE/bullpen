/// <reference types="Cypress" />

describe('Create job_application via factory and test freelancer-employer job_application flow', () => {

  it('create job_application via factory and test freelancer-employer job_application flow', function () {
    // via freelancer_profiles.rb create freelancer_profile
    cy.appFactories([
      ['create', 'job_application']

    ])
    // try to login as just created freelancer
    cy.gui_login('tetyanaFree@gmail.com')

    // try to click button 'applications' on navbar
    cy.get(':nth-child(2) > .nav-link')
      .should('exist')
      .click()

    // try to test button 'More'
    // try to click dropdown menu item 'show job Details'
    cy.get('[data-target^="#showJobPost"]')
      .should('exist')
      .click({force: true})

    // try to close opened module via button '×'
    cy.get('[id^="showJobPost"] > .modal-dialog > .modal-content > .modal-header > .close > span')
      .should('exist')
      .click({force: true})

    // try to click dropdown menu item 'delete Draft'
    // cy.get('.dropdown-menu > .text-danger')
    cy.get('[data-target^="#deleteApplicationDraft"]')
      .should('exist')
      .click({force: true})

    // try to cancel job application deleting via button "Cancel' clicking
    cy.get('[id^="deleteApplicationDraft"] > .modal-dialog > .modal-content > .modal-footer > .btn-link')
      .should('exist')
      .click({force: true})

    // try to click button 'Apply'
    cy.get('[data-target^="#jobAppStep"]')
      .should('exist')
      .click({force: true})

    // try to click button 'Next' in opened module 'Apply..' step 1 of 2
    cy.get('[id^="jobAppStep"] > .modal-dialog > .modal-content > form > .modal-footer > .btn-primary')
      .should('exist')
      .click({force: true})

    // try to click button 'Preview application'
    cy.get('.d-none > .btn-primary')
      .should('exist')
      .click({force: true})

    // try to click button 'Submit application'
    cy.get('button.btn.btn-primary.cy-submit-application')
      .should('exist')
      .click({force: true})

    // try to log out as freelancer
    cy.gui_logout()

    // try to login as employer
    cy.gui_login('tetyanaEmpl@gmail.com')

    // try to click button 'Your Jobs' on navbar
    cy.get(':nth-child(4) > .nav-link')
      .should('exist')
      .click({force: true})

    // try to click button 'Application'
    cy.get('[id^="application-tab"]')
      .eq(0)
      .should('exist')
      .click({force: true})

    // try to like freelancer
    cy.get('[id^="like"] > .svg-inline--fa')
      .should('exist')
      .click({force: true})

    // try to get menu 'More
    // try to click dropdown menu item 'Show Application'
    cy.get('[data-target^="#previewApplicationDropdown"]')
      .should('exist')
      .click({force: true})

    // try to close opened showing application module via 'x'
    cy.get('div.modal-dialog.modal-lg')
      .get('div.modal-content')
      .get('div.modal-body')
      .should('be.visible')
      .then(($modal_body)=>{
        cy.wrap($modal_body).find('button').find('span').contains("×").click()
      })

    // try to click button 'Make an Offer'
    cy.get('[data-target^="#makeAnOffer"]')
      .should('exist')
      .click()

    // try to change Payment Method
    cy.get('select#make_an_offer_payment_account_id')
      .should('exist')
      // .select('value').eq(1)
      .find('option')
      .then($elm => $elm.get(1).setAttribute('selected', "selected"))
      .parent()
      .trigger('change')

    // try to click button 'Send Offer' in opened module
    cy.get('[id^="makeAnOffer"] > .modal-dialog > .modal-content > .modal-body > form > .form-group > .d-flex > .btn')
      .should('exist')
      .click()

    // try to log out as employer
    cy.gui_logout()

    // try to login as freelancer
    cy.gui_login('tetyanaFree@gmail.com')

    // try to click button 'Contracts' on navbar
    cy.get(':nth-child(3) > .nav-link')
      .should('exist')
      .click()

    // try to get menu 'More'
    // try to click dropdown menu item 'Show Offer Details'
    cy.get('[data-target^="#showOfferContractDetails"]')
      .should('exist')
      .click({force: true})

    // try to close opened module 'Offer Details' via 'x'
    cy.get('[id^="showOfferContractDetails"] > .modal-dialog > .modal-content > .modal-header > .close > span')
      .should('exist')
      .click({force: true})

    // try to click button 'Accept Offer'
    cy.get('.d-block > .btn')
      .should('exist')
      .click({force: true})

  })
})

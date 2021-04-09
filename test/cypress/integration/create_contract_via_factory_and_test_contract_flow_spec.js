/// <reference types="Cypress" />

describe('Create contract via factory contracts.rb and test contract flow', () => {

  it('create contract via factory contracts.rb and test contract flow', function () {
    // via factory contract.rb create contract, employer, employer_profile, freelancer, freelancer_profile
    cy.appFactories([
      ['create', 'contract']

    ])
    // try to login as just created employer
    cy.gui_login('tetyanaEmpl@gmail.com');

    // try click tab 'Your Jobs' on navbar to get /employer/jobs
    cy.get(':nth-child(4) > .nav-link')
      .should('exist')
      .click()

    // try to click button 'Contracts' on navbar
    cy.get(':nth-child(5) > .nav-link')
      .should('exist')
      .wait(2000)
      .get(':nth-child(5) > .nav-link')
      .click()

    // try to click menu button 'Options'  - top button
    // try to click dropdown menu item 'Show Offer Details'
    cy.get('button#dropdownMenu.btn.btn-outline-primary.dropdown-toggle.container-fluid')
      .first()
      .should('exist').click({force: true})
      .get('div.dropdown-menu.dropdown-menu-right')
      .eq(1)
      .should('exist')
      .find('button.dropdown-item')
      .eq(0)
      .should('exist')
      .click({force: true})

    // try to close opened module 'Offer Details' via '×'
    cy.get('[id^=showOfferContractDetails] > .modal-dialog > .modal-content > .modal-header > .close > span')
      .should('exist')
      .click({force: true})

    // try to click dropdown menu item 'Modify Offer'
    cy.get('button#dropdownMenu.btn.btn-outline-primary.dropdown-toggle.container-fluid')
      .first()
      .should('exist').click({force: true})
      .get('div.dropdown-menu.dropdown-menu-right')
      .eq(1)
      .should('exist')
      .find('button.dropdown-item')
      .eq(1)
      .should('exist').click()

    //try to modify 'Hourly Rate'
    cy.get('#make_an_offer_pay_rate')
      .should('exist')
      .clear()
      .type('280')

    // try to click button 'Save Changes'
    cy.get('[id^=makeAnOffer] > .modal-dialog > .modal-content > .modal-body > form > .form-group > .d-flex > .btn')
      .should('exist').click()

    // try to click dropdown item 'Withdraw Offer'
    cy.get('button#dropdownMenu.btn.btn-outline-primary.dropdown-toggle.container-fluid')
      .first()
      .should('exist').click({force: true})
      .get('div.dropdown-menu.dropdown-menu-right')
      .eq(1)
      .should('exist')
      .find('button.dropdown-item')
      .eq(2)
      .should('exist').click()

    // try to cancel offer withdrawal
    cy.get('.modal-content > .modal-footer > .btn-link')
      .should('exist')
      .click()

    // try to click button 'Option' - bottom one
    // try to click dropdown menu item 'Send a Message'
    cy.get('[data-target^="#sendMessage"]', { includeShadowDom: true})
      .should('exist')
      .click({force: true})

    // try to type text in opened text-area
    cy.get('#addPersonalMessageTextArea')
      .should('exist')
      .type('Cy TetyanaEmpl message to TetyanaFree!!!')

    // try to click button 'Send Message'
    cy.get('[id^=sendMessage] > .modal-dialog > .modal-content > .modal-body > form > .form-group > .d-flex > .btn')
      .should('exist')
      .click({force: true})

    // try to click dropdown menu item 'Show Profile'
    cy.get('[data-target^="#showProfile"]', { includeShadowDom: true})
      .should('exist')
      .click({force: true})

    cy.get('[id^=showProfile] > :nth-child(1) > :nth-child(1) > :nth-child(1) > .close-job > span')
      .should('exist')
      .click({force: true})

    // try to log out as employer
    cy.gui_logout()

    // try login as above created freelancer
    cy.gui_login('tetyanaFree@gmail.com')

    // try to click button 'Contracts' on navbar
    cy.get(':nth-child(2) > .nav-link')
      .should('exist')
      .click()

    // as freelancer try to click button 'More'
    // try to click dropdown menu item 'Show Offer Details'
    cy.get('[data-target^="#showOfferContractDetails"]', { includeShadowDom: true})
      .should('exist')
      .click({force: true})

    // try to close opened module 'Offer Details' via '×'
    cy.get('[id^=showOfferContractDetails] > .modal-dialog > .modal-content > .modal-header > .close > span')
      .should('exist')
      .click({force: true})

    // try to click dropdown menu item 'Decline Offer'
    cy.get('[data-target^="#declineOffer"]')
      .should('exist')
      .click({force: true})

    // try to cancel offer declining
    cy.get('.modal-content > .modal-footer > .btn-link')
      .should('exist')
      .click()

    // as freelancer try to click button 'Accept Offer'
    cy.get('.d-block > .btn')
      .should('exist')
      .click()

  })
})
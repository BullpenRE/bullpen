/// <reference types="Cypress" />

describe('To get /employer/talent page via factory employer_profile.rb and as employer create a job', () => {

  it('get /employer/talent via factory employer_profile.rb and create a job', function () {
    // create employer_profile
    cy.appFactories([
      ['create', 'interview_request']

    ])
    // try to login as just created employer
    cy.gui_login('tetyanaEmpl@gmail.com')

    // try to click button 'Interview' on navbar
    cy.get(':nth-child(4) > .nav-link')
      .should('exist')
      .click()

    // try to click button 'Show Profile'
    cy.get('.d-block.d-sm-inline-block.mr-sm-2.mb-2.mb-sm-0 > .btn.btn-primary.w-100')
      .should('exist')
      .click({force: true} )

    // try to close opened module 'Show Profile' via 'x'
    cy.get('div.modal-dialog.modal-lg')
      .get('div.modal-content')
      .get('div.modal-body')
      .should('be.visible')
      .then(($modal_body)=>{
        cy.wrap($modal_body).find('button').find('span').contains("×").click()
      })

    // try to click button 'More'
    // try to click dropdown-item 'Edit Request' in dropdown menu 'More'
    cy.get('button#dropdownMenu.btn.btn-outline-primary.dropdown-toggle.pr-1.w-100')
      .should('exist').click({force: true})
      .get('div.dropdown-menu.dropdown-menu-right')
      .eq(1)
      .should('exist')
      .find('button.dropdown-item')
      .eq(0)
      .should('exist')
      .click()

    // try to clean opened text-area and type new text
    cy.get('#addPersonalMessageTextArea').clear()
      .type('Cy TetyanaEmpl had edited this response')

    // try to click button 'Modify Invitation'
    cy.get('[id^=interviewRequest] > .modal-dialog > .modal-content > .modal-body > form > .form-group > .d-flex > .btn')
      .should('exist')
      .click({force: true} )

    // try to click dropdown-item 'Withdraw Request' in dropdown menu 'More'
    cy.get('button#dropdownMenu.btn.btn-outline-primary.dropdown-toggle.pr-1.w-100')
      .should('exist').click({force: true})
      .get('div.dropdown-menu.dropdown-menu-right')
      .eq(1)
      .should('exist')
      .find('button.dropdown-item')
      .eq(1)
      .should('exist')
      .click()

    // try to cancel request withdrawal
    cy.get('[id^=withdrawRequest] > .modal-dialog > .modal-content > .modal-footer > .btn-link')
      .should('exist')
      .click({force: true} )

    // try to log out as employer
    cy.gui_logout()

    // try to login as above created freelancer
    cy.gui_login('tetyanaFree@gmail.com')

    // try to click button 'Interview' on navbar
    cy.get(':nth-child(2) > .nav-link')
      .should('exist')
      .click()

    // try to decline interview request as freelancer
    cy.get('.d-sm-flex > :nth-child(3) > .btn')
      .should('exist')
      .click()

    // try cancel interview request decline
    cy.get('[id^=declineInterviewReques] > .modal-dialog > .modal-content > .modal-footer > .btn-link')
      .should('exist')
      .click()

    // try to click button 'Accept Request'
    cy.get('.mr-sm-2 > .btn')
      .should('exist')
      .click()

    // try to click button 'Remove'
    cy.get('.d-sm-flex > :nth-child(3) > .btn')
      .should('exist')
      .wait(2000)
      .get('.d-sm-flex > :nth-child(3) > .btn')
      .click()

    // try cancel removal of accepted request
    cy.get('[id^=removeInterviewRequest] > .modal-dialog > .modal-content > .modal-footer > .btn-link')
      .should('exist')
      .get('[id^=removeInterviewRequest] > .modal-dialog > .modal-content > .modal-footer > .btn-link')
      .click()


    // try to click button 'Send Message'
    cy.get('.mr-sm-2 > .btn')
      .should('exist')
      .click()

    // try type a message in text-area
    cy.get('#addPersonalMessageTextArea')
      .should('exist')
      .type('Cy this is TetyanaFree respond message to TetyanaEmpl\'s interview request!')

    // try to click button 'Send Message'
    cy.get('.d-flex > .btn')
      .should('exist')
      .click()

    // try to log out as freelancer
    cy.gui_logout()

    // try to login as employer
    cy.gui_login('tetyanaEmpl@gmail.com')

    // try to click button 'Interviews' on navbar
    cy.get(':nth-child(4) > .nav-link')
      .should('exist')
      .click()

    // try to click button 'More'
    // try get dropdown-item 'Show Profile'
    cy.get('button#dropdownMenu.btn.btn-outline-primary.dropdown-toggle.pr-1.w-100')
      .should('exist').click({force: true})
      .get('div.dropdown-menu.dropdown-menu-right')
      .eq(1)
      .should('exist')
      .find('button.dropdown-item')
      .eq(0)
      .should('exist').click()

    // try to close opened module 'Show Profile' via 'x'
    cy.get('div.modal-dialog.modal-lg')
      .get('div.modal-content')
      .get('div.modal-body')
      .should('be.visible')
      .then(($modal_body)=>{
        cy.wrap($modal_body).find('button').find('span').contains("×").click()
      })

    // try to click button 'Make an Offer'
    cy.get('button#dropdownMenu.btn.btn-outline-primary.dropdown-toggle.pr-1.w-100')
      .should('exist').click({force: true})
      .get('div.dropdown-menu.dropdown-menu-right')
      .eq(1)
      .should('exist')
      .find('button.dropdown-item')
      .eq(1)
      .should('exist')
      .click()

    // try to complete form 'Make an Offer' - job Title
    cy.get('[id^=JobTitleInput]')
      .should('exist')
      .type('Cy Special offer to TetyanaFree directly from Interview - Job Title')

    // try to add text in text-area 'Job Description'
    cy.get('[id^=JobDescriptionInput]')
      .should('exist')
      .type('Cy Special offer to TetyanaFree directly from Interview - Job Description')

    // try to complete 'Hourly Rate'
    cy.get('#make_an_offer_pay_rate')
      .should('exist')
      .type('250')

    // try to click button 'Send Offer'
    cy.get('[id^=makeAnOfferWithoutJob] > .modal-dialog > .modal-content > .modal-body > form > .form-group > .d-flex > .btn')
      .should('exist')
      .click()

    // try to click tab 'Contracts' on navbar
    cy.get(':nth-child(5) > .nav-link')
      .should('exist')
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
    cy.get('[id^=showOfferContractDetails]')
      .find('div.modal-dialog.modal-lg')
      .find('div.modal-content')
      .find('div.modal-header')
      .should('be.visible')
      .then(($modal_body)=>{
        cy.wrap($modal_body).find('button').find('span').contains("×")
          .click({force: true})
      })

    // try to click dropdown menu item 'Modify Offer'
    cy.get('button#dropdownMenu.btn.btn-outline-primary.dropdown-toggle.container-fluid')
      .first()
      .should('exist').click({force: true})
      .get('div.dropdown-menu.dropdown-menu-right')
      .eq(1)
      .should('exist')
      .find('button.dropdown-item')
      .eq(1)
      .should('exist')
      .click({force: true})

    //try to modify 'Hourly Rate'
    cy.get('#make_an_offer_pay_rate')
      .should('exist')
      .clear()
      .type('280')

    // try to change Payment Method
    cy.get('select#make_an_offer_payment_account_id')
      .should('exist')
      // .select('value').eq(1)
      .find('option')
      .then($elm => $elm.get(1).setAttribute('selected', "selected"))
      .parent()
      .trigger('change')

    // try to click button 'Save Changes'
    cy.get('[id^=makeAnOffer] > .modal-dialog > .modal-content > .modal-body > form > .form-group > .d-flex > .btn')
      .should('exist')
      .click()

    // try to click dropdown item 'Withdraw Offer'
    cy.get('button#dropdownMenu.btn.btn-outline-primary.dropdown-toggle.container-fluid')
      .first()
      .should('exist').click({force: true})
      .get('div.dropdown-menu.dropdown-menu-right')
      .eq(1)
      .should('exist')
      .find('button.dropdown-item')
      .eq(2)
      .should('exist')
      .click({force: true})

    // try to cancel offer withdrawal
    cy.get('.modal-content > .modal-footer > .btn-link')
      .should('exist').click()

  })
})

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
      .eq(0)
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
      .eq(0)
      .should('exist')
      .type('2', {force: true})

    // try to add minutes
    cy.get('[id^="minutes"]')
      .eq(0)
      .should('exist')
      .type('30', {force: true})

    // try to add 'Enter a brief description of the task performed'
    cy.get('#billing_description')
      .eq(0)
      .should('exist')
      .type('Cy - brief description of the task performed')

    // try to click button 'Add Hours'
    cy.get('[id^="addHours"] > .modal-dialog > .modal-content > .modal-body > form > .form-group > .d-flex > .btn')
      .eq(0)
      .should('exist')
      .click()

    // try to click button 'Add Hours' - 2nd time
    cy.get('.d-block > .btn')
      .eq(0)
      .should('exist')
      .wait(2000)
      .get('.d-block > .btn')
      .click()

    // try to add hours - 2nd time
    // cy.get('[id^="hours"]')
    cy.get('[name="billing[hours]"]')
      .eq(0)
      .should('exist')
      .type('5', {force: true})

    // try to add minutes - 2nd time
    cy.get('[name="billing[minutes]"]')
      .eq(0)
      .should('exist')
      .type('45', {force: true})

    // try to add 'Enter a brief description of the task performed' - 2nd time
    cy.get('#billing_description')
      .should('exist')
      .type('Cy - brief description of the 2nd task performed')

    // try to click button 'Add Hours' - 2nd time
    cy.get('[data-disable-with="Add Hours"]')
      .eq(0)
      .should('exist')
      .click({force: true})

    // try to click link 'Show Billing'
    cy.get('[data-target^="#collapseBillings"]')
      .eq(0)
      .should('exist')
      .click({force: true})

    // try to log out as freelancer
    cy.wait(2000)
      .gui_logout()

    // try to login as employer
    cy.gui_login('tetyanaEmpl@gmail.com')

    // try to click button 'Contracts' on the navbar
    cy.get(':nth-child(5) > .nav-link')
      .should('exist')
      .click()

    // try to get menu items within link 'Options'
    // try to click on dropdown menu item 'Show contract Details'
    cy.get('[data-target^="#showOfferContractDetails"]')
      .should('exist')
      .click( {force: true})

    // try to close opend module 'Contract Details' via button 'x'
    cy.get('[id^="showOfferContractDetails"] > .modal-dialog > .modal-content > .modal-header > .close > span')
      .should('exist')
      .click({force: true})

    // try to click on dropdown menu item 'Edit Contract'
    cy.get('[data-target^="#makeAnOffer"]')
      .eq(0)
      .should('exist')
      .click({force: true})

    // try to change 'Hourly Rate' in opened module 'Edit Contract'
    cy.get('[name="make_an_offer[pay_rate]"]')
      .eq(0)
      .should('exist')
      .clear({force: true})
      .type('180', {force: true})

    // try to click button 'Save changes' in opened module 'Edit Contract'
    cy.get('[id^="make-an-offer-"]')
      .should('exist')
      .click({force: true})

    // try to click on dropdown menu item 'Close Contract'
    cy.get('[data-target^="#closeContract"]')
      .should('exist')
      .click({force: true})

    // try to click link 'Cancel' in opened module 'Close Contract'
    cy.get('[id^="closeContract"] > .modal-dialog > .modal-content > .modal-footer > .btn-link')
      .should('exist')
      .click({force: true})

    // try to get menu items within link 'Menu'
    // try to click on dropdown menu item 'Write a Review'
    cy.get('[data-target^="#reviewModal"]')
      .should('exist')
      .click({force: true})

    // try to click 'star_1' in opened module 'Write a Review for...'
    cy.get('[name="review[rating]"]')
      .eq(4)
      .should('exist')
      .click({force: true})

    // try to click 'star_2' in opened module 'Write a Review for...'
    cy.get('[name="review[rating]"]')
      .eq(3)
      .should('exist')
      .click({force: true})

    // try to click 'star_3' in opened module 'Write a Review for...'
    cy.get('[name="review[rating]"]')
      .eq(2)
      .should('exist')
      .click({force: true})

    // try to click 'star_4' in opened module 'Write a Review for...'
    cy.get('[name="review[rating]"]')
      .eq(1)
      .should('exist')
      .click({force: true})

    // try to click 'star_5' in opened module 'Write a Review for...'
    cy.get('[name="review[rating]"]')
      .eq(0)
      .should('exist')
      .click({force: true})

    // try to add comments in text-area 'Comments' in opened module 'Write a Review for...'
    cy.get('#addCommentsTextArea')
      .should('exist')
      .type('Cy - Good Job! Thanks!', {force: true})

    // try to click button 'Submit Review'
    cy.get('[data-disable-with="Submit Review"]')
      .should('exist')
      .click({force: true})

    // try to get menu items within link 'Menu'
    // try to click on dropdown menu item 'Edit Review'
    cy.get('[data-target^="#reviewModal"]')
      .should('exist')
      .click({force: true})

    // try to uncheck 'star_5' in opened module 'Edit Review'
    cy.get('[name="review[rating]"]')
      .eq(0)
      .should('exist')
      .click({force: true})
      .get('[name="review[rating]"]')
      .eq(1)
      .should('exist')
      .click({force: true})

    // try to modify comments in text-area 'Comments' in opened module 'Write a Review for...'
    cy.get('#addCommentsTextArea')
      .should('exist')
      .clear({force: true})
      .type('Cy - Good Job! Thanks! But could be better', {force: true})

    // try to click button 'Submit Review'
    cy.get('[data-disable-with="Submit Review"]')
      .should('exist')
      .click({force: true})
  })
})

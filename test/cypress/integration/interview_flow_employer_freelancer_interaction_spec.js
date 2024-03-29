/// <reference types="Cypress" />

describe('Interview flow: employer - freelancer interaction', () => {

  it('Interview flow: employer - freelancer interaction',  { retries: 2 }, function () {
    // via factory job_questions.rb create job with questions, employer, employer_profile, freelancer, freelancer_profile
    cy.appFactories([
      ['create', 'job_question'],
      ['create', 'freelancer_profile']

    ])
    // try to login as just created employer
    cy.gui_login('tetyanaEmpl@gmail.com')

    // 'Find Talent' tab on //employer/talent has to be reached

    // try to click button 'Request Interview' on /employer/talent tab
    cy.get('[id^=interview-request-]').click()

    // try to clear default interview request text in text-area and add your own text to this text-area
    cy.get('#addPersonalMessageTextArea').clear()
      .type('Cy new text for interview request for TetyanaFree from TetyanaEmpl!')

    // try to click button 'Send Invitation'
    cy.get('.form-group > .d-flex > .btn')
      .should('exist')
      .click()

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
      .click()

    // try cancel removing of accepted request
    cy.get('[id^=removeInterviewRequest] > .modal-dialog > .modal-content > .modal-footer > .btn-link')
      .should('exist')
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
    cy.get(':nth-child(5) > .nav-link')
      .should('exist')
      .click()

  })
})

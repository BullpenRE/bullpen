/// <reference types="Cypress" />

describe('To get /employer/talent page with job + job_questions created via factory job_questions.rb and as employer go through flow "Your Jobs"', () => {

  it('get /employer/talent with job + job_questions created via factory job_questions.rb and as employer go through flow "Your Jobs"', function () {
    // via factory job_questions.rb create job with questions, employer, employer_profile, freelancer, freelancer_profile
    cy.appFactories([
      ['create', 'job_question']

    ])
    // try to login as just created employer
    cy.gui_login('tetyanaEmpl@gmail.com')

    // try click tab 'Your Jobs' on navbar to get /employer/jobs
    cy.get(':nth-child(4) > .nav-link')
      .should('exist')
      .click()

    // try to test menu 'Options'
    // try get dropdown-item 'Show Job Post'
    cy.get('button#dropdownMenu.btn.btn-outline-primary.dropdown-toggle.container-fluid')
      .should('exist').click({force: true})
      .get('div.dropdown-menu.dropdown-menu-right')
      .eq(1)
      .should('exist')
      .find('button.dropdown-item')
      .eq(0)
      .should('exist')
      .click()

    // try to close opened module 'Job Post'
    cy.get('div.modal-dialog.modal-lg')
      .get('div.modal-content')
      .get('div.modal-header')
      .should('be.visible')
      .then(($modal_body)=>{
        cy.wrap($modal_body).find('button').find('span').contains("×").click()
      })

    //try to get dropdown-item 'Edit Job Post'
    cy.get('button#dropdownMenu.btn.btn-outline-primary.dropdown-toggle.container-fluid')
      .should('exist').click({force: true})
      .get('div.dropdown-menu.dropdown-menu-right')
      .eq(1)
      .should('exist')
      .find('a.dropdown-item')
      .eq(0)
      .should('exist')
      .click()

    // try to close opened module 'Post a Job'
    cy.get('div.modal-dialog.modal-lg')
      .get('div.modal-content')
      .get('div.modal-header')
      .should('be.visible')
      .then(($modal_body)=>{
        cy.wrap($modal_body).find('button').find('span').contains("×").click()
      })

    //try to get dropdown-item 'Delete job'
    cy.get('button#dropdownMenu.btn.btn-outline-primary.dropdown-toggle.container-fluid')
      .should('exist').click({force: true})
      .get('div.dropdown-menu.dropdown-menu-right')
      .eq(1)
      .should('exist')
      .find('button.dropdown-item')
      .eq(1)
      .should('exist')
      .click()

    // try to cancel sweet-alert 'Delete Job'
    cy.get('.swal2-cancel')
      .should('exist')
      .click()

  })
})

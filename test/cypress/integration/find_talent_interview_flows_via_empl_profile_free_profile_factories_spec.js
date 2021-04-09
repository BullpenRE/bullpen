/// <reference types="Cypress" />

describe('To get /employer/talent page via factories employer_profile.rb & freelance_rprofile.rb and as employer go through flow "Find Talent" & "Interview"', () => {

  it('get /employer/talent page via factories employer_profile.rb & freelance_rprofile.rb and as employer go through flow "Find Talent" & "Interview"', function () {
    // via factories employer_profile.rb & freelance_rprofile.rb create employer_profile & freelancer_profile
    cy.appFactories([
      ['create', 'employer_profile', {completed: 'true'}],
      ['create', 'freelancer_profile']

    ])
    //try to login as just created employer
    cy.gui_login('tetyanaEmpl@gmail.com')

    // 'Find Talent' tab on /employer/talent has to be reached

    // try to click button 'Show Profile' on /employer/talent
    cy.get('.d-sm-flex > :nth-child(2) > .btn')
      .should('exist')
      .click()

    // try to close opened module 'Show Profile' via 'x'
    cy.get('div.modal-dialog.modal-lg')
      .get('div.modal-content')
      .get('div.modal-body')
      .should('be.visible')
      .then(($modal_body)=>{
        cy.wrap($modal_body).find('button').find('span').contains("×").click()
      })

    // try to click button 'Request Interview' on /employer/talent tab
    cy.get('[id^=interview-request-]')
      .click()

    // try to clear default interview request text in text-area and add your own text to this text-area
    cy.get('#addPersonalMessageTextArea').clear()
      .type('Cy new text for interview request for TetyanaFree from TetyanaEmpl!')

    // try to click button 'Send Invitation'
    cy.get('.form-group > .d-flex > .btn')
      .should('exist')
      .click()

    // try to click link 'Show Filters'
    cy.get('#showFilters')
      .should('exist')
      .click()

    // try to select item 'Affordable Housing' in select 'Sectors'
    cy.get('.select2-search__field', { includeShadowDom: true})
    cy.get('#search_sector_ids.select2.select2-hidden-accessible', { includeShadowDom: true}).first()
      .select('Affordable Housing', {force: true})

    // try to click button 'Apply Filters'
    cy.get('#applyFilters')
      .should('exist')
      .click()

    // try to reset filters
    cy.get('#rejectFilters > .svg-inline--fa')
      .should('exist')
      .click()

    // try click 'Interviews' tab on navbar
    cy.get(':nth-child(4) > .nav-link')
      .should('exist')
      .click()

    // try to click button 'Show Profile'
    cy.get('.d-block.d-sm-inline-block.mr-sm-2.mb-2.mb-sm-0 > .btn.btn-primary.w-100')
      .should('exist')
      .click()

    // try to close opened module 'Show Profile'
    cy.get('div.modal-dialog.modal-lg')
      .get('div.modal-content')
      .get('div.modal-body')
      .should('be.visible')
      .then(($modal_body)=>{
        cy.wrap($modal_body).find('button').find('span').contains("×").click()
      })

    // try to click button 'More'
    // try get dropdown-item 'Edit Request'
    cy.get('button#dropdownMenu.btn.btn-outline-primary.dropdown-toggle.pr-1.w-100')
      .should('exist').click({force: true})
      .get('div.dropdown-menu.dropdown-menu-right')
      .eq(1)
      .should('exist')
      .find('button.dropdown-item')
      .eq(0)
      .should('exist')
      .click()

      // try to clear default interview request text-area and add your own text to this text-area
    cy.get('[id^=interviewRequest]> .modal-dialog > .modal-content > .modal-body > form > .form-group > .w-100 > #addPersonalMessageTextArea').clear()
      .type('Cy modified(!!!) text for interview request for TetyanaFree from TetyanaEmpl!')

    // try to click button 'Modify Invitation'
    cy.get('[id^=interviewRequest] > .modal-dialog > .modal-content > .modal-body > form > .form-group > .d-flex > .btn')
      .should('exist')
      .click()

    //try to get dropdown-item 'Withdraw Request'
    cy.get('button#dropdownMenu.btn.btn-outline-primary.dropdown-toggle.pr-1.w-100')
      .should('exist').click({force: true})
      .get('div.dropdown-menu.dropdown-menu-right')
      .eq(1)
      .should('exist')
      .find('button.dropdown-item')
      .eq(1)
      .should('exist')
      .click()

    // try to cancel sweet-alert 'Withdraw Request'
    cy.get('[id^=withdrawRequest] > .modal-dialog > .modal-content > .modal-footer > .btn-link')
      .should('exist').click()

  })
})
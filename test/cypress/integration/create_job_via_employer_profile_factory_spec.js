/// <reference types="Cypress" />

describe('To get /employer/talent page via factory employer_profile.rb and as employer create a job', () => {

  it('get /employer/talent via factory employer_profile.rb and create a job',  { retries: 2 }, function() {
    // create employer_profile
    cy.appFactories([
      ['create', 'employer_profile', {completed: 'true'}]

    ])
    // try to login as just created employer
    cy.gui_login('tetyanaEmpl@gmail.com')

    // try to click button 'Post job' on navbar to start create to job
    cy.get('.navbar-nav > :nth-child(1) > .btn').click({force: true})

    //try to start create the job
    cy.get('input#jobTitle').type('Test job cy')

    cy.get('#jobShortDescription').type('Short Job Description cy')

    cy.get('.select2-search__field', { includeShadowDom: true})
    cy.get('#sectorMultiselect.select2.select2-hidden-accessible', { includeShadowDom: true}).first()
      .select('HTC', {force: true})

    cy.get('.pt-3 > .btn-primary').click()

    cy.get('a.btn-outline-primary').click()
      .get('.progress-bar').should('have.attr', 'style', 'width: 0%')
      .get('.pt-3 > .btn-primary').click()

    cy.get('input[name="job[position_length]"]').first().check({force: true})

    cy.get('input[name="job[hours_needed]"]').first().check({force: true})

    cy.get('#daytimeRequiredCheck1').check({force: true})

    cy.get('.modal-body > form > .d-flex > .btn-primary').click()

    cy.get('input[name="job[required_experience]"]').first().check({force: true})

    cy.get('#job_job_skills.select2.select2-hidden-accessible', { includeShadowDom: true})
      .select(['Acquisition Diligence', 'Acquisition Underwriting'], {force: true})

    cy.get('#job_job_softwares.select2.select2-hidden-accessible', { includeShadowDom: true})
      .select(['Microsoft Excel', 'Microsoft Suite'], {force: true})

    cy.get('#regionalKnowledge').type('Walnut Creek, CA')

    cy.get('.modal-body > form > .d-flex > .btn-primary').click()

    cy.get('#job_pay_range_low').type('100')

    cy.get('#job_pay_range_high').type('150')

    cy.get('#jobDetailsTextarea').type('Cy Describe responsibilities, provided resources, or any other requirements')
      .wait(2000)
      .get('.pt-3 > .btn-primary')
      .should('exist')
      .click()

    cy.get('#applicantQuestions1').type('Cy Question_1')
    cy.get('#applicantQuestions2').type('Cy Question_2')
    cy.get('#applicantQuestions3').type('Cy Question_3')

    cy.get('.new-question-button').click()
      .get('[name="job[job_questions][description_4]"]').type('Cy Question_4')
      .get('.pt-3 > div > .btn-primary').click()

    // being at 'Preview Job Post' module click button 'Save as Draft'
    cy.get('form > .btn-outline-primary')
      .should('exist')
      .click()

    // try to test menu 'More'
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

    // try to close opened module 'Job Post' via 'x'
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

    // try to close opened module 'Post a Job' via 'x'
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

    // try to post job
    cy.get('[id^=post-job-]', { includeShadowDom: true})
      .should('exist')
      .wait(2000)
      .get('[id^=post-job-]')
      .click({ force: true })

  })
})

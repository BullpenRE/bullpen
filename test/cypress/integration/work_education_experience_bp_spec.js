/// <reference types="Cypress" />

describe('WorkEducationPage', () => {
  beforeEach(() => {
    // seed the database prior to every test
    cy.exec('RAILS_ENV=test rails db:seed')
  })

  it('successfully loads', () => {
    cy.visit('http://localhost:5017', {failOnStatusCode: false})
  })

  const first_name = 'First'
  const last_name = 'Last'
  const email = 'freelancer@yahoo.com'

  it('checks data of nav-bar', () => {
    cy.visit('http://localhost:5017', {failOnStatusCode: false})
      .contains('Apply').click()
      .get('#firstName').type(first_name)
      .get('#lastName').type(last_name)
      .get('#email').type(email)
      .get('button.form-control-lg.btn.btn-outline-secondary.col-md-12.mb-3.nextBtn-2').click()
      .get('input#psw').type('q1234567!Q')
      .get('input#cPwdId').type('q1234567!Q')
      .get('form').submit()

    cy.get('nav.navbar.navbar-expand-lg.navbar-light.bg-white.shadow-sm.mb-5')
      .get('div.container').first()
      .get('a.navbar-brand')
      .should('have.attr', 'href', 'https://bullpenre.com/')
      .find('img')
      .should('have.attr', 'src', '/packs-test/media/images/bullpen-email-logo-64fc4a58c54693e46d0e2e963bd3c9ac.png')
      .should(($img) => {
        expect($img).css('width', '130px')
        expect($img).css('height', '40px')
      })

    cy.get('nav.navbar.navbar-expand-lg.navbar-light.bg-white.shadow-sm.mb-5')
      .get('div.container').first()
      .get('div.collapse.navbar-collapse')
      .get('ul.navbar-nav.ml-auto')
      .get('li.nav-item.dropdown')
      .get('a.nav-link.dropdown-toggle.d-flex.align-items-center')
      .find('svg')
      .should(($svg) => {
        expect($svg).to.have.length(1)
        expect($svg).have.attr('data-prefix', 'fas')
        expect($svg).have.attr('data-icon', 'user-circle')
        expect($svg).have.attr('role', 'img')
      })

    cy.get('a.nav-link.dropdown-toggle.d-flex.align-items-center')
      .get('span.pr-1')
      .should(($span) => {
        expect($span).to.have.length(1)
        expect($span).have.text('First Last')
      })

    cy.get('li.nav-item.dropdown')
      .get('div.dropdown-menu.dropdown-menu-right')
      .get('a.dropdown-item')
      .should('have.attr', 'href', '/users/sign_out')
      .should(($a) => {
        expect($a).to.have.length(1)
        expect($a).have.text('Logout')
      })
      .click({force: true})
  })

  it('checks progress bar & Content card', () => {
    // to get target page professional_history
    cy.visit('http://localhost:5017')
      .contains('Apply').click()
      .get('#firstName').type(first_name)
      .get('#lastName').type(last_name)
      .get('#email').type(email)
      .get('button.form-control-lg.btn.btn-outline-secondary.col-md-12.mb-3.nextBtn-2').click()
      .get('input#psw').type('q1234567!Q')
      .get('input#cPwdId').type('q1234567!Q')
      .get('form').submit()

    cy.get('div.form-group.mb-4')
      .get('div.w-100')
      .get('select.select2.select2-hidden-accessible', { includeShadowDom: true}).first()
      .select(['Underwriting', 'Investment Memo'], {force: true})

    cy.get('div.form-group.mb-5')
      .get('select.select2.select2-hidden-accessible', { includeShadowDom: true})
      .last()
      .select(['HTC','Affordable Housing'], {force: true})

    cy.get('div.d-flex.justify-content-between')
      .get('input.btn.btn-primary')
      .click()

    const bestFixtureFile = 'icons8_trash_can_48.png'
    cy.get('input#uploadProfilePic.d-none')
      .attachFile(bestFixtureFile, { force: true })

    cy.get('div.col-md.text-center.mb-5')
      .get('div.form-group.text-left')
      .get('input#freelancerLocationInput.form-control')
      .type('Walnut Creek, CA')

    cy.get('div.d-flex.justify-content-between')
      .get('input.btn.btn-primary')
      // .click()
      .get('form').submit()

    cy.get('div.row')
      .get('input#professionalTitleInput.form-control')
      .type('Owner')
      .get('div.col-md.cy-experience')
      .find('div.form-group.mb-4')
      .find('label.bp-input-label')
      .should(($label) => {
        expect($label).to.have.length(1)
      })
      .then(($label) => {
        expect($label).to.have.text('Years of professional experience')
        expect($label).have.attr('for', 'yearsExperienceSelect')
      })
      .get('div.w-100.cy-yearsExperienceSelect')
      .find('div.dropdown.bootstrap-select.form-control')
      .find('select#freelancer_profile_professional_years_experience.form-control.selectpicker', { includeShadowDom: true})
      .select('>10', {force: true})

    cy.get('div.form-group.mb-5.cy-summary')
      .get('textarea#professionalSummaryTextarea.form-control')
      .type('Some professional summary')

    cy.get('div.d-flex.justify-content-between')
      .get('input.btn.btn-primary')
      .get('form').submit()

    // at least we got target page work_education_experience

    // progress bar 75%
    cy.get('div.container.mb-4')
      .get('div.progress.bg-white.shadow-sm.mx-auto')
      .get('div.progress-bar')
      .should(($div) => {
        expect($div).to.have.length(1)
      })
      .should('have.attr', 'style', 'width: 75%')

    cy.get('div.container.mb-4')
      .get('div.progress.bg-white.shadow-sm.mx-auto')
      .get('div.text-secondary.font-weight-bold.my-1.text-center')
      .should(($div) => {
        expect($div).to.have.length(1)
      })
      .then(($div) => {
        expect($div).to.have.text('75%')
      })

    // Content Card. Step 4

    cy.get('div.bp-card.mb-5.mx-auto.cy-work-experience')
      .find('div.text-center')
      .find('h2')
      .should(($h2) => {
        expect($h2).to.have.length(1)
      })
      .then(($h2) => {
        expect($h2).to.have.text('Work experience and education')
      })
      .get('p.mb-4.cy-work-experience').first()
      .should(($p) => {
        expect($p).to.have.length(1)
      })
      .then(($p) => {
        expect($p).to.have.text('Tell us about your work experience and educational background.')
      })

    cy.get('div.mb-4.cy-work-experience')
      .find('div.bp-input-label')
      .should(($div) => {
        expect($div).to.have.length(1)
      })
      .then(($div) => {
        expect($div).to.have.text('\n        Work Experience\n      ')
      })
      .get('button.btn.btn-outline-primary').first()
      .should('have.attr', 'data-toggle', 'modal')
      .should('have.attr', 'data-target', '#addWorkExperienceModal')
      .should(($button) => {
        expect($button).to.have.length(1)
      })
      .then(($button) => {
        expect($button).to.have.text('Add Experience')
      })
      .find('svg')
      .should(($svg) => {
        expect($svg).to.have.length(1)
        expect($svg).have.attr('data-prefix', 'fas')
        expect($svg).have.attr('data-icon', 'plus')
        expect($svg).have.attr('role', 'img')
      })

    // => Add work experience modal
    cy.get('button.btn.btn-outline-primary', { includeShadowDom: true}).first()
      .click({force: true})
      .get('div#addWorkExperienceModal.modal.fade.show')
      .get('div.modal-dialog.modal-dialog-centered.modal-md')
      .find('div.modal-content')
      .find('div.modal-header')
      .find('button.close.mt-2').first()
      .should(($button) => {
        expect($button).to.have.length(1)
        expect($button).have.attr('type', 'button')
        expect($button).have.attr('data-dismiss', 'modal')
        expect($button).have.attr('aria-label', 'Close')
      })
      .find('span.cy-close').first()
      .should(($span) => {
        expect($span).to.have.length(1)
        expect($span).have.text('×')
      })
    cy.get('button.close.mt-2').first()
      .should('be.visible')
      .wait(2000)
      .click()

    cy.get('div.mb-4.cy-work-experience')
      .get('button.btn.btn-outline-primary').first()
      .click()
      .get('div#addWorkExperienceModal.modal.fade.show', { includeShadowDom: true})
      .get('div.modal-dialog.modal-dialog-centered.modal-md')
      .find('div.modal-content')
      .find('form.cy-work-experience', { includeShadowDom: true}).first()
      .should(($form) => {
        expect($form).to.have.length(1)
        expect($form).have.attr('action', '/freelancer_profile_steps/work_education_experience')
        expect($form).have.attr('accept-charset', 'UTF-8')
        expect($form).have.attr('method', 'post')
      })
      .find('div.modal-body.pt-0')
      .find('h3')
      .should(($h3) => {
        expect($h3).to.have.length(1)
      })
      .then(($h3) => {
        expect($h3).to.have.text('Add Experience')
      })
      .get('div.form-group.cy-job-title')
      .get('label.bp-input-label.cy-job-title')
      .should(($label) => {
        expect($label).to.have.length(1)
      })
      .then(($label) => {
        expect($label).to.have.text('Job Title')
        expect($label).have.attr('for', 'jobTitleInput')
      })
      .get('input#jobTitleInput.form-control')
      .should((input) => {
        expect(input).to.have.length(1)
      })
      .should('have.attr', 'placeholder', 'Enter your job title')
      .should('have.attr', 'name', 'freelancer_profile_experience[job_title]')
      .should('have.attr', 'type', 'text')
      .should('have.attr', 'required', 'required')
      .type('Software engineer')
      .get('div.form-group.cy-company')
      .get('label.bp-input-label.cy-company')
      .should(($label) => {
        expect($label).to.have.length(1)
      })
      .then(($label) => {
        expect($label).to.have.text('Company')
        expect($label).have.attr('for', 'companyInput')
      })
      .get('input#companyInput.form-control')
      .should((input) => {
        expect(input).to.have.length(1)
      })
      .should('have.attr', 'placeholder', 'Enter the company name')
      .should('have.attr', 'name', 'freelancer_profile_experience[company]')
      .should('have.attr', 'type', 'text')
      .should('have.attr', 'required', 'required')
      .type('Awesome company')
      .get('div.form-group.cy-location')
      .get('label.bp-input-label.cy-location')
      .should(($label) => {
        expect($label).to.have.length(1)
      })
      .then(($label) => {
        expect($label).to.have.text('Location')
        expect($label).have.attr('for', 'locationInput')
      })
      .get('input#locationInput.form-control')
      .should((input) => {
        expect(input).to.have.length(1)
      })
      .should('have.attr', 'placeholder', 'e.g. San Francisco, CA')
      .should('have.attr', 'name', 'freelancer_profile_experience[location]')
      .should('have.attr', 'type', 'text')
      .should('have.attr', 'required', 'required')
      .type('Walnut Creek, CA')
      .get('div.form-group.cy-start-date')
      .get('label.bp-input-label.cy-start-date')
      .should(($label) => {
        expect($label).to.have.length(1)
      })
      .then(($label) => {
        expect($label).to.have.text('Start Date')
        expect($label).have.attr('for', 'startMonth')
      })
      .get('div.row.mb-3.cy-start-date')
      .get('div.col.cy-start-month')
      .get('select#startMonth.form-control.selectpicker')
      .should(($select) => {
        expect($select).to.have.length(1)
      })
      .should('have.attr', 'required', 'required')
      .should('have.attr', 'name', 'freelancer_profile_experience[start_month]')
      .should('have.attr', 'data-style', 'bp-btn-select-border')
      .should('have.attr', 'title', 'Month')
      .select('July', {force: true})
      .get('div.col.cy-start-year')
      .get('div.dropdown.bootstrap-select.form-control')
      .get('select#startYear.form-control.selectpicker')
      .should(($select) => {
        expect($select).to.have.length(1)
      })
      .should('have.attr', 'required', 'required')
      .should('have.attr', 'name', 'freelancer_profile_experience[start_year]')
      .should('have.attr', 'data-style', 'bp-btn-select-border')
      .should('have.attr', 'title', 'Year')
      .select('2007', {force: true})
      .get('div.custom-control.custom-checkbox.cy-current-job')
      .get('input').first()
      .should(($input) => {
        expect($input).to.have.length(1)
      })
      .should('have.attr', 'name', '_method')
      .should('have.attr', 'type', 'hidden')
      .should('have.attr', 'value', 'put')
      .get('input#currentJob.custom-control-input')
      .should(($input) => {
        expect($input).to.have.length(1)
      })
      .should('have.attr', 'type', 'checkbox')
      .should('have.attr', 'data-toggle', 'collapse')
      .should('have.attr', 'data-target', '#endDateToggle')
      .should('have.attr', 'aria-expanded', 'false')
      .should('have.attr', 'aria-controls', 'endDateToggle')
      .should('have.attr', 'value', '1')
      .should('have.attr', 'name', 'freelancer_profile_experience[current_job]')
      .get('label.custom-control-label').first()
      .should(($label) => {
        expect($label).to.have.length(1)
      })
      .then(($label) => {
        expect($label).to.have.text('Current Job')
        expect($label).have.attr('for', 'currentJob')
      })
      .get('div#endDateToggle.form-group.collapse.show')
      .get('label.bp-input-label.cy-end-date')
      .should(($label) => {
        expect($label).to.have.length(1)
      })
      .then(($label) => {
        expect($label).to.have.text('End Date')
        expect($label).have.attr('for', 'endMonth')
      })
      .get('div.form-group.cy-start-date')
      .get('label.bp-input-label.cy-start-date')
      .should(($label) => {
        expect($label).to.have.length(1)
      })
      .then(($label) => {
        expect($label).to.have.text('Start Date')
        expect($label).have.attr('for', 'startMonth')
      })
      .get('div.row.cy-end-date')
      .get('div.col.cy-end-date')
      .find('div.dropdown.bootstrap-select.form-control')
      .get('select#endMonth.form-control.selectpicker')
      .should(($select) => {
        expect($select).to.have.length(1)
      })
      .should('have.attr', 'name', 'freelancer_profile_experience[end_month]')
      .should('have.attr', 'data-style', 'bp-btn-select-border')
      .should('have.attr', 'title', 'Month')
      .select('October', {force: true})
      .get('div.col.cy-end-year')
      .get('div.dropdown.bootstrap-select.form-control')
      .get('select#endYear.form-control.selectpicker')
      .should(($select) => {
        expect($select).to.have.length(1)
      })
      .should('have.attr', 'name', 'freelancer_profile_experience[end_year]')
      .should('have.attr', 'data-style', 'bp-btn-select-border')
      .should('have.attr', 'title', 'Year')
      .select('2020', {force: true})
      .get('div.form-group.mb-0.cy-description')
      .get('label.bp-input-label.cy-description')
      .should(($label) => {
        expect($label).to.have.length(1)
      })
      .then(($label) => {
        expect($label).to.have.text('Description')
        expect($label).have.attr('for', 'jobDescriptionTextarea')
      })
      .get('textarea#jobDescriptionTextarea.form-control')
      .should(($textarea) => {
        expect($textarea).to.have.length(1)
      })
      .then(($textarea) => {
        expect($textarea).have.attr('placeholder', 'Enter your job description')
        expect($textarea).have.attr('rows', '3')
        expect($textarea).have.attr('required', 'required')
        expect($textarea).have.attr('name', 'freelancer_profile_experience[description]')
      })
      .type('Some description of my job')
      .get('div.modal-footer.justify-content-between.cy-work-experience')
      .get('button.btn.btn-link.px-0.text-dark.cy-cancel.cy-work-experience')
      .should(($button) => {
        expect($button).to.have.length(1)
        expect($button).to.have.text('Cancel')
        expect($button).have.attr('type', 'button')
        expect($button).have.attr('data-dismiss', 'modal')
      })
      .get('input.btn.btn-primary.cy-save')
      .should(($input) => {
        expect($input).to.have.length(1)
      })
      .should('have.attr', 'name', 'commit')
      .should('have.attr', 'type', 'submit')
      .should('have.attr', 'value', 'Save')
      .should('have.attr', 'data-disable-with', 'Save')
      .get('form.cy-work-experience').first().submit()
      //  End of work experience modal

    cy.get('div.mb-5.cy-education-experience')
      .find('div.bp-input-label')
      .should(($div) => {
        expect($div).to.have.length(1)
      })
      .then(($div) => {
        expect($div).to.have.text('\n        Education\n      ')
      })
      .get('button.btn.btn-outline-primary.cy-education').last()
      .should('have.attr', 'data-toggle', 'modal')
      .should('have.attr', 'data-target', '#addEducationModal')
      .should(($button) => {
        expect($button).to.have.length(1)
      })
      .then(($button) => {
        expect($button).to.have.text('Add Education')
      })
      .find('svg')
      .should(($svg) => {
        expect($svg).to.have.length(1)
        expect($svg).have.attr('data-prefix', 'fas')
        expect($svg).have.attr('data-icon', 'plus')
        expect($svg).have.attr('role', 'img')
      })

    // => Add education modal
    cy.get('button.btn.btn-outline-primary.cy-education', { includeShadowDom: true})
      .click({force: true})
      .get('div#addEducationModal.modal.fade.show')
      .get('div.modal-dialog.modal-dialog-centered.modal-md.cy-education')
      .find('div.modal-content.cy-education')
      .find('div.modal-header.cy-education')
      .get('button.cy-close.mt-2.cy-education')
      .should(($button) => {
        expect($button).to.have.length(1)
        expect($button).have.attr('type', 'button')
        expect($button).have.attr('data-dismiss', 'modal')
        expect($button).have.attr('aria-label', 'Close')
      })
      .find('span.cy-education.cy-close')
      .should(($span) => {
        expect($span).to.have.length(1)
        expect($span).have.text('×')
      })
    cy.get('button.cy-close.mt-2.cy-education')
      .should('be.visible')
      .wait(2000)
      .click()

    cy.get('div.mb-5.cy-education-experience')
      .get('button.btn.btn-outline-primary.cy-education')
      .click()
      .get('div#addEducationModal.modal.fade.show', { includeShadowDom: true})
      .get('div.modal-dialog.modal-dialog-centered.modal-md.cy-education')
      .get('div.modal-content.cy-education')
      .find('form.cy-education', { includeShadowDom: true}).last()
      .should(($form) => {
        expect($form).to.have.length(1)
        expect($form).have.attr('action', '/freelancer_profile_steps/work_education_experience')
        expect($form).have.attr('accept-charset', 'UTF-8')
        expect($form).have.attr('method', 'post')
      })
      .find('div.modal-body.pt-0')
      .find('h3')
      .should(($h3) => {
        expect($h3).to.have.length(1)
      })
      .then(($h3) => {
        expect($h3).to.have.text('Add Education')
      })
      .get('div.form-group.cy-institution')
      .get('label.bp-input-label.cy-institution')
      .should(($label) => {
        expect($label).to.have.length(1)
      })
      .then(($label) => {
        expect($label).to.have.text('Institution')
        expect($label).have.attr('for', 'institutionInput')
      })
      .get('input#institutionInput.form-control')
      .should((input) => {
        expect(input).to.have.length(1)
      })
      .should('have.attr', 'placeholder', 'Enter the school you attended')
      .should('have.attr', 'name', 'freelancer_profile_education[institution]')
      .should('have.attr', 'type', 'text')
      .type('Some University')
      .get('div.form-group.cy-degree')
      .get('label.bp-input-label.cy-degree')
      .should(($label) => {
        expect($label).to.have.length(1)
      })
      .then(($label) => {
        expect($label).to.have.text('Degree')
        expect($label).have.attr('for', 'degreeSelect')
      })
      .get('div.dropdown.bootstrap-select.form-control')
      .find('select#degreeSelect.form-control.selectpicker')
      .should(($select) => {
        expect($select).to.have.length(1)
      })
      .should('have.attr', 'required', 'required')
      .should('have.attr', 'name', 'freelancer_profile_education[degree]')
      .should('have.attr', 'data-style', 'bp-btn-select-border')
      .should('have.attr', 'title', 'Please make a selection')
      .select('Masters', {force: true})
      .get('div.form-group.cy-course-of-study')
      .get('label.bp-input-label.cy-course-of-study')
      .should(($label) => {
        expect($label).to.have.length(1)
      })
      .then(($label) => {
        expect($label).to.have.text('Course of Study')
        expect($label).have.attr('for', 'courseInput')
      })
      .get('input#courseInput.form-control')
      .should((input) => {
        expect(input).to.have.length(1)
      })
      .should('have.attr', 'placeholder', 'Enter your degree program')
      .should('have.attr', 'name', 'freelancer_profile_education[course_of_study]')
      .should('have.attr', 'type', 'text')
      .type('Some course of study')
      .get('div.form-group.cy-graduation-year')
      .get('label.bp-input-label.cy-graduation-year')
      .should(($label) => {
        expect($label).to.have.length(1)
      })
      .then(($label) => {
        expect($label).to.have.text('Graduation Year')
        expect($label).have.attr('for', 'graduationYear')
      })
      .get('div#graduationDateToggle.row.mb-2.collapse.show')
      .find('div.col')
      .find('div.dropdown.bootstrap-select.form-control')
      .find('select#graduationYear.form-control.selectpicker')
      .should(($select) => {
        expect($select).to.have.length(1)
      })
      .should('have.attr', 'name', 'freelancer_profile_education[graduation_year]')
      .should('have.attr', 'data-style', 'bp-btn-select-border')
      .should('have.attr', 'title', 'Year')
      .select('1982', {force: true})
      .get('div.custom-control.custom-checkbox.cy-current-studying')
      .get('input').first()
      .should(($input) => {
        expect($input).to.have.length(1)
      })
      .should('have.attr', 'name', '_method')
      .should('have.attr', 'type', 'hidden')
      .should('have.attr', 'value', 'put')
      .get('input#currentlyStudying.custom-control-input')
      .should(($input) => {
        expect($input).to.have.length(1)
      })
      .should('have.attr', 'type', 'checkbox')
      .should('have.attr', 'data-toggle', 'collapse')
      .should('have.attr', 'data-target', '#graduationDateToggle')
      .should('have.attr', 'aria-expanded', 'false')
      .should('have.attr', 'aria-controls', 'graduationDateToggle')
      .should('have.attr', 'value', '1')
      .should('have.attr', 'name', 'freelancer_profile_education[currently_studying]')
      .get('label.custom-control-label.cy-current-studying').first()
      .should(($label) => {
        expect($label).to.have.length(1)
      })
      .then(($label) => {
        expect($label).to.have.text('Currently Studying')
        expect($label).have.attr('for', 'currentlyStudying')
      })
      .get('div.form-group.mb-0.cy-education-description')
      .get('label.bp-input-label.cy-education-description')
      .should(($label) => {
        expect($label).to.have.length(1)
      })
      .then(($label) => {
        expect($label).to.have.text('Description (optional)')
        expect($label).have.attr('for', 'educationDescriptionTextarea')
      })
      .get('textarea#educationDescriptionTextarea.form-control')
      .should(($textarea) => {
        expect($textarea).to.have.length(1)
      })
      .then(($textarea) => {
        expect($textarea).have.attr('placeholder', 'Enter a brief description')
        expect($textarea).have.attr('rows', '3')
        expect($textarea).have.attr('name', 'freelancer_profile_education[description]')
      })
      .type('Some description of my education')
      .get('div.modal-footer.justify-content-between.cy-education')
      .get('button.btn.btn-link.px-0.text-dark.cy-cancel.cy-education')
      .should(($button) => {
        expect($button).to.have.length(1)
        expect($button).to.have.text('Cancel')
        expect($button).have.attr('type', 'button')
        expect($button).have.attr('data-dismiss', 'modal')
      })
      .get('input.btn.btn-primary.cy-save-education')
      .should(($input) => {
        expect($input).to.have.length(1)
      })
      .should('have.attr', 'name', 'commit')
      .should('have.attr', 'type', 'submit')
      .should('have.attr', 'value', 'Save')
      .should('have.attr', 'data-disable-with', 'Save')
      .get('form.cy-education').last().submit()
    //  End of education modal

    // Beginning of Work Experience Edit mode
    cy.get('div.d-flex.align-items-center.justify-content-between.mb-3.cy-work-experience-present')
      .get('div.w-100.cy-work-experience-present')
      .get('div.row.cy-work-experience-present.cy-title')
      .get('div.col.mb-1.text.cy-work-experience-present.cy-title')
      .should(($div) => {
        expect($div).to.have.length(1)
      })
      .then(($div) => {
        expect($div).to.have.text('Software engineer')
      })
      .get('div.row.bp-text-sm.cy-work-experience-present.cy-company-location')
      .get('div.col-md.cy-work-experience-present.cy-company-location')
      .should(($div) => {
        expect($div).to.have.length(1)
      })
      .then(($div) => {
        expect($div).to.have.text('Awesome company, Walnut Creek, CA')
      })
      .get('div.col-md.cy-work-experience-present.cy-job')
      .should(($div) => {
        expect($div).to.have.length(1)
      })
      .then(($div) => {
        expect($div).to.have.text('\n                  July, 2007-October, 2020\n                ')
      })
      .get('button.btn.btn-link.cy-edit-work-experience')
      .find('svg')
      .should(($svg) => {
        expect($svg).to.have.length(1)
        expect($svg).have.attr('data-prefix', 'fas')
        expect($svg).have.attr('data-icon', 'pencil-alt')
        expect($svg).have.attr('role', 'img')
      })
      .click()
      .get('div.modal.fade.cy-edit-work-experience.show', { includeShadowDom: true})
      .get('div.modal-dialog.modal-dialog-centered.modal-md.cy-edit-work-experience')
      .get('div.modal-content.cy-edit-work-experience')
      .get('form.cy-edit-work-experience', { includeShadowDom: true})
      .should(($form) => {
        expect($form).to.have.length(1)
        expect($form).have.attr('action', '/freelancer_profile_steps/work_education_experience')
        expect($form).have.attr('accept-charset', 'UTF-8')
        expect($form).have.attr('method', 'post')
      })
      .get('div.modal-footer.justify-content-between.cy-edit-work-experience')

      .get('button.btn.btn-link.px-0.text-dark.cy-edit-work-experience')
      .should(($button) => {
        expect($button).to.have.length(1)
        expect($button).to.have.text('Cancel')
        expect($button).have.attr('type', 'button')
        expect($button).have.attr('data-dismiss', 'modal')
      })
      .click()
    // End of Work Experience Edit mode

    // Beginning of Education Edit mode
    cy.get('div.container.cy-work-education')
      .get('div.bp-card.mb-5.mx-auto.cy-work-experience')
      .get('div.mb-5.cy-education-experience')
      .find('div.d-flex.align-items-center.justify-content-between.mb-3.education-present', { includeShadowDom: true})
      .get('div.w-100.education-present')
      .get('div.row.education-present.institution')
      .get('div.col.mb-1.text.education-present.institution')
      .should(($div) => {
        expect($div).to.have.length(1)
      })
      .then(($div) => {
        expect($div).to.have.text('Some University')
      })
      .get('div.row.bp-text-sm.education-present')
      .get('div.col-md.education-present.degree.course-of-study')
      .should(($div) => {
        expect($div).to.have.length(1)
      })
      .then(($div) => {
        expect($div).to.have.text('Masters, Some course of study')
      })
      .get('div.col-md.graduation-year')
      .should(($div) => {
        expect($div).to.have.length(1)
      })
      .then(($div) => {
        expect($div).to.have.text('1982')
      })
      .get('button.btn.btn-link.education')
      .find('svg')
      .should(($svg) => {
        expect($svg).to.have.length(1)
        expect($svg).have.attr('data-prefix', 'fas')
        expect($svg).have.attr('data-icon', 'pencil-alt')
        expect($svg).have.attr('role', 'img')
      })
      .click()
      .get('form.cy-edit-education', { includeShadowDom: true})
      .should(($form) => {
        expect($form).to.have.length(1)
        expect($form).have.attr('action', '/freelancer_profile_steps/work_education_experience')
        expect($form).have.attr('accept-charset', 'UTF-8')
        expect($form).have.attr('method', 'post')
      })
      .get('div.modal-footer.justify-content-between.cy-edit-education')
      .get('div.cy-edit-education.cy-delete-save-submits')
      .get('input.btn.btn-outline-danger.mr-2.cy-edit-education.cy-delete')
      .should(($input) => {
        expect($input).to.have.length(1)
        expect($input).have.attr('name', 'commit')
        expect($input).have.attr('type', 'submit')
        expect($input).have.attr('value', 'Delete')
        expect($input).have.attr('data-disable-with', 'Delete')
      })
      .get('input.btn.btn-primary.cy-edit-education.cy-save')
      .should(($input) => {
        expect($input).to.have.length(1)
        expect($input).have.attr('name', 'commit')
        expect($input).have.attr('type', 'submit')
        expect($input).have.attr('value', 'Save')
        expect($input).have.attr('data-disable-with', 'Save')
      })
      .get('button.btn.btn-link.px-0.text-dark.cy-edit-education')
      .should(($button) => {
        expect($button).to.have.length(1)
        expect($button).to.have.text('Cancel')
        expect($button).have.attr('type', 'button')
        expect($button).have.attr('data-dismiss', 'modal')
      })
      .click()

    // End of Education Edit mode

    cy.get('div.d-flex.justify-content-between.work-education')
      .get('a.btn.btn-link.px-0.work-education')
      .should(($a) => {
        expect($a).to.have.length(1)
      })
      .then(($a) => {
        expect($a).to.have.text('Back')
      })
      .should('have.attr', 'href', '/freelancer_profile_steps/professional_history')
      .click({force: true})

    cy.wait(3000)
      .get('input.btn.btn-primary')
      .should(($input) => {
        expect($input).to.have.length(1)
        expect($input).have.attr('name', 'commit')
        expect($input).have.attr('type', 'submit')
        expect($input).have.attr('value', 'Next')
        expect($input).have.attr('data-disable-with', 'Next')
      })
      .click({force: true})
      .get('a#NextBtn.btn.btn-primary.work-education')
      .should(($a) => {
        expect($a).to.have.length(1)
      })
      .then(($a) => {
        expect($a).to.have.text('Next')
      })
      .should('have.attr', 'href', '/freelancer_profile_steps/summary')
      .click({force: true})
      .go('back')
      .go('forward')
  })

})
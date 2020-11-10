/// <reference types="Cypress" />

describe('SummaryPage', () => {
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

  it('checks Content card', () => {
    // to get target page - summary
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
      .get('select.select2.select2-hidden-accessible', {includeShadowDom: true}).first()
      .select(['Underwriting', 'Investment Memo'], {force: true})

    cy.get('div.form-group.mb-5')
      .get('select.select2.select2-hidden-accessible', {includeShadowDom: true})
      .last()
      .select(['HTC', 'Affordable Housing'], {force: true})

    cy.get('div.d-flex.justify-content-between')
      .get('input.btn.btn-primary')
      .click()

    const bestFixtureFile = 'icons8_trash_can_48.png'
    cy.get('input#uploadProfilePic.d-none')
      .attachFile(bestFixtureFile, {force: true})

    cy.get('div.col-md.text-center.mb-5')
      .get('div.form-group.text-left')
      .get('input#freelancerLocationInput.form-control')
      .type('Walnut Creek, CA')


    cy.get('div.d-flex.justify-content-between')
      .get('input.btn.btn-primary')
      .get('form').submit()

    // Beginning  of avatar on navbar check
    cy.get('nav.navbar.navbar-expand-lg.navbar-light.bg-white.shadow-sm.mb-5')
      .get('div.container.navbar').first()
      .get('div#navbarSupportedContent.collapse.navbar-collapse')
      .get('ul.navbar-nav.ml-auto')
      .get('li.nav-item.dropdown')
      .get('a#navbarDropdown.nav-link.dropdown-toggle.d-flex.align-items-center', {includeShadowDom: true})
      .find('div').first()
      .should(($div) => {
        expect($div).to.have.length(1)
        expect($div).have.attr('style', 'font-size: 47px; line-height: 0;')
      })
      .find('img').first().invoke('attr', 'src').should('contain', 'http://localhost:5017/rails/active_storage/representations/')
    //  End of avatar on navbar check

    cy.get('div.row')
      .get('input#professionalTitleInput.form-control')
      .type('Owner')
      .get('div.col-md.experience')
      .find('div.form-group.mb-4')
      .find('label.bp-input-label')
      .get('div.w-100.yearsExperienceSelect')
      .find('div.dropdown.bootstrap-select.form-control')
      .find('select#freelancer_profile_professional_years_experience.form-control.selectpicker', {includeShadowDom: true})
      .select('>10', {force: true})

    cy.get('div.form-group.mb-5.summary')
      .get('textarea#professionalSummaryTextarea.form-control')
      .type('Some professional summary')

    cy.get('div.d-flex.justify-content-between')
      .get('input.btn.btn-primary')
      .get('form').submit()

    // => Add work experience modal

    cy.get('div.mb-4.work-experience')
      .get('button.btn.btn-outline-primary').first()
      .click()
      .get('div#addWorkExperienceModal.modal.fade.show', { includeShadowDom: true})
      .get('div.modal-dialog.modal-dialog-centered.modal-md')
      .find('div.modal-content')
      .find('form.work-experience', { includeShadowDom: true}).first()
      .find('div.modal-body.pt-0')
      .find('h3')
      .get('div.form-group.job-title')
      .get('label.bp-input-label.job-title')
      .get('input#jobTitleInput.form-control')
      .type('Software engineer')
      .get('div.form-group.company')
      .get('label.bp-input-label.company')
      .get('input#companyInput.form-control')
      .type('Awesome company')
      .get('div.form-group.location')
      .get('label.bp-input-label.location')
      .get('input#locationInput.form-control')
      .type('Walnut Creek, CA')
      .get('div.form-group.start-date')
      .get('label.bp-input-label.start-date')
      .get('div.row.mb-3.start-date')
      .get('div.col.start-month')
      .get('select#startMonth.form-control.selectpicker')
      .select('July', {force: true})
      .get('div.col.start-year')
      .get('div.dropdown.bootstrap-select.form-control')
      .get('select#startYear.form-control.selectpicker')
      .select('2007', {force: true})
      .get('div.custom-control.custom-checkbox.current-job')
      .get('input').first()
      .get('input#currentJob.custom-control-input')
      .get('label.custom-control-label').first()
      .get('div#endDateToggle.form-group.collapse.show')
      .get('label.bp-input-label.end-date')
      .get('div.form-group.start-date')
      .get('label.bp-input-label.start-date')
      .get('div.row.end-date')
      .get('div.col.end-date')
      .find('div.dropdown.bootstrap-select.form-control')
      .get('select#endMonth.form-control.selectpicker')
      .select('October', {force: true})
      .get('div.col.end-year')
      .get('div.dropdown.bootstrap-select.form-control')
      .get('select#endYear.form-control.selectpicker')
      .select('2020', {force: true})
      .get('div.form-group.mb-0.description')
      .get('label.bp-input-label.description')
      .get('textarea#jobDescriptionTextarea.form-control')
      .type('Some description of my job')
      .get('div.modal-footer.justify-content-between.work-experience')
      .get('button.btn.btn-link.px-0.text-dark.cancel.work-experience')
      .get('input.btn.btn-primary.save')
      .get('form.work-experience').first().submit()
    //  End of work experience modal

    cy.get('div.mb-5.education-experience')
      .get('button.btn.btn-outline-primary.cy-education')
      .click()
      .get('div#addEducationModal.modal.fade.show', { includeShadowDom: true})
      .get('div.modal-dialog.modal-dialog-centered.modal-md.cy-education')
      .get('div.modal-content.cy-education')
      .find('form.cy-education', { includeShadowDom: true}).last()
      .find('div.modal-body.pt-0')
      .find('h3')
      .get('div.form-group.cy-institution')
      .get('label.bp-input-label.cy-institution')
      .get('input#institutionInput.form-control')
      .type('Some University')
      .get('div.form-group.cy-degree')
      .get('label.bp-input-label.cy-degree')
      .get('div.dropdown.bootstrap-select.form-control')
      .find('select#degreeSelect.form-control.selectpicker')
      .select('Masters', {force: true})
      .get('div.form-group.cy-course-of-study')
      .get('label.bp-input-label.cy-course-of-study')
      .get('input#courseInput.form-control')
      .type('Some course of study')
      .get('div.form-group.graduation-year')
      .get('label.bp-input-label.graduation-year')
      .get('div#graduationDateToggle.row.mb-2.collapse.show')
      .find('div.col')
      .find('div.dropdown.bootstrap-select.form-control')
      .find('select#graduationYear.form-control.selectpicker')
      .select('1982', {force: true})
      .get('div.custom-control.custom-checkbox.current-studying')
      .get('input').first()
      .get('input#currentlyStudying.custom-control-input')
      .get('label.custom-control-label.current-studying').first()
      .get('div.form-group.mb-0.education-description')
      .get('label.bp-input-label.education-description')
      .get('textarea#educationDescriptionTextarea.form-control')
      .type('Some description of my education')
      .get('div.modal-footer.justify-content-between.education')
      .get('button.btn.btn-link.px-0.text-dark.cancel.education')
      .get('input.btn.btn-primary.save-education')
      .get('form.cy-education').submit()
    //  End of education modal

    cy.get('a#NextBtn.btn.btn-primary.work-education')
      .click()
    // at least we got target page - summary

    // Beginning of Content Card - summary
    cy.get('div.container.summary')
      .get('div.row.summary')
      .get('div.col-md-12.summary')
      .get('div.row.summary_1')
      .get('div.col-md-4.summary')
      .get('div.card.summary')
      .get('div.card-body.summary')
      .get('p.card-text.summary')
      .get('div.text-light.mb-3.avatar-image.text-center.summary')
      .should(($div) => {
        expect($div).to.have.length(1)
        expect($div).have.attr('style', 'font-size: 170px;line-height: 0;')
      })
      .find('img').first().invoke('attr', 'src').should('contain', 'http://localhost:5017/rails/active_storage/blobs/')
      .get('div.text-center.mb-5.summary')
      .find('h2')
      .should(($h2) => {
        expect($h2).to.have.length(1)
      })
      .then(($h2) => {
        expect($h2).to.have.text(' First Last ')
      })
      .get('div.form-group.mb-3.summary.title')
      .find('label.bp-input-label.summary.professional-title')
      .should(($label) => {
        expect($label).to.have.length(1)
      })
      .then(($label) => {
        expect($label).to.have.text('Professional Title')
      })
      .get('div.summary.professional-title')
      .should(($div) => {
        expect($div).to.have.length(1)
      })
      .then(($div) => {
        expect($div).to.have.text('Owner')
      })
      .get('div.form-group.mb-3.summary-summary')
      .find('label.bp-input-label.summary-professional-summary')
      .should(($label) => {
        expect($label).to.have.length(1)
      })
      .then(($label) => {
        expect($label).to.have.text('Professional Summary')
      })
      .get('div.summary-professional-summary')
      .should(($div) => {
        expect($div).to.have.length(1)
      })
      .then(($div) => {
        expect($div).to.have.text('Some professional summary')
      })
      .get('div.form-group.mb-3.summary.email')
      .find('label.bp-input-label.summary.email')
      .should(($label) => {
        expect($label).to.have.length(1)
      })
      .then(($label) => {
        expect($label).to.have.text('Email')
      })
      .get('div.summary-email')
      .should(($div) => {
        expect($div).to.have.length(1)
      })
      .then(($div) => {
        expect($div).to.have.text('freelancer@yahoo.com')
      })
      .get('div.form-group.mb-3.summary.location')
      .find('label.bp-input-label.summary.location')
      .should(($label) => {
        expect($label).to.have.length(1)
      })
      .then(($label) => {
        expect($label).to.have.text('Location')
      })
      .get('div.summary-location')
      .should(($div) => {
        expect($div).to.have.length(1)
      })
      .then(($div) => {
        expect($div).to.have.text('Walnut Creek, CA')
      })
      .get('div.col-md-8.application-summary')
      .get('div.card.mb-4.application-submit')
      .get('p.card-text.initial-submit')
      .get('div.text-left.mt-2.mb-4.initial-submit')
      .find('h2')
      .should(($h2) => {
        expect($h2).to.have.length(1)
      })
      .then(($h2) => {
        expect($h2).to.have.text('Submit your application')
      })
      .get('div.text-left.mb-4.please-verify')
      .should(($div) => {
        expect($div).to.have.length(1)
      })
      .then(($div) => {
        expect($div).to.have.text('\n                  Please verify your information and click the submit button to complete the application process.\n                ')
      })
      .get('form.please-verify')
      .should(($form) => {
        expect($form).to.have.length(1)
        expect($form).have.attr('action', '/freelancer_profile_steps/summary')
        expect($form).have.attr('accept-charset', 'UTF-8')
        expect($form).have.attr('method', 'post')
      })
      .get('div.row.please-verify')
      .get('div.col.please-verify-back')
      .get('a.btn.btn-link.px-0.please-verify-back')
      .should('have.attr', 'href', '/freelancer_profile_steps/work_education_experience')
      .should(($a) => {
        expect($a).to.have.length(1)
        expect($a).have.text('Back')
      })
      .click()
      .wait(3000)
      .go('back')
      .get('div.col.text-right.please-verify-submit')
      .get('input.btn.btn-primary.please-verify-submit')
      .should((input) => {
        expect(input).to.have.length(1)
      })
      .should('have.attr', 'data-disable-with', 'Submit application')
      .should('have.attr', 'name', 'commit')
      .should('have.attr', 'type', 'submit')
      .should('have.attr', 'value', 'Submit application')
      .click()
      .go('back')
      .get('div.card-body.body-application-summary')
      .get('p.card-text.application-summary')
      .get('div.text-left.mb-4.text-application-summary')
      .find('h2')
      .should(($h2) => {
        expect($h2).to.have.length(1)
      })
      .then(($h2) => {
        expect($h2).to.have.text('Application Summary')
      })
      .get('div.row.row-skills-sector')
      .get('div.col.col-skills')
      .get('div.form-group.mb-3.label-skills')
      .get('label.bp-input-label.label-skills')
      .should(($label) => {
        expect($label).to.have.length(1)
      })
      .then(($label) => {
        expect($label).to.have.text('Skills')
      })
      .get('div.w-100.w-100-skills')
      .get('div.btn.btn-dark.small.mb-1.btn-skills')
      .should(($div) => {
        expect($div).to.have.length(2)
        expect($div.eq(0)).have.attr('style', 'background-color: #005495; border: none; cursor: default;')
        expect($div.eq(1)).have.attr('style', 'background-color: #005495; border: none; cursor: default;')
      })
      .then(($div) => {
        expect($div.eq(0)).to.have.text('\n                            Underwriting\n                          ')
        expect($div.eq(1)).to.have.text('\n                            Investment Memo\n                          ')
      })
      .get('div.col.sector')
      .get('div.form-group.mb-3.form-group-sector')
      .get('label.bp-input-label.label-sector')
      .should(($label) => {
        expect($label).to.have.length(1)
      })
      .then(($label) => {
        expect($label).to.have.text('Sectors')
      })
      .get('div.w-100.w-100-sector')
      .get('div.btn.btn-dark.small.mb-1.btn-sector')
      .should(($div) => {
        expect($div).to.have.length(2)
        expect($div.eq(0)).have.attr('style', 'background-color: #005495; border: none; cursor: default;')
        expect($div.eq(1)).have.attr('style', 'background-color: #005495; border: none; cursor: default;')
      })
      .then(($div) => {
        expect($div.eq(0)).to.have.text('\n                            HTC\n                          ')
        expect($div.eq(1)).to.have.text('\n                            Affordable Housing\n                          ')
      })
      .get('div.row.row-work-experience')
      .get('div.col.col-work-experience')
      .get('div.form-group.mb-3.form-group-work-experience')
      .get('label.bp-input-label.label-work-experience')
      .should(($label) => {
        expect($label).to.have.length(1)
      })
      .then(($label) => {
        expect($label).to.have.text('Work Experience')
      })
      .get('div.work_exp')
      .get('div.work_exp-job-title')
      .should(($div) => {
        expect($div).to.have.length(1)
      })
      .then(($div) => {
        expect($div).to.have.text('Software engineer')
      })
      .get('div.row.bp-text-sm.work_exp')
      .get('div.col-md.work_exp-company-location')
      .should(($div) => {
        expect($div).to.have.length(1)
      })
      .then(($div) => {
        expect($div).to.have.text('\n                            Awesome company, Walnut Creek, CA\n                          ')
      })
      .get('div.col-md.work_exp-start-date')
      .should(($div) => {
        expect($div).to.have.length(1)
      })
      .then(($div) => {
        expect($div).to.have.text('\n                            Jul, 2007-Oct, 2020\n                          ')
      })
      .get('div.hr-under-work-experience')
      .get('hr.under-work-experience')
      .should('be.visible')
      .should(($hr) => {
        expect($hr).to.have.length(1)
      })
      .get('div.col.col-education')
      .get('div.form-group.mb-3.form-group-education')
      .get('label.bp-input-label.label-education')
      .should(($label) => {
        expect($label).to.have.length(1)
      })
      .then(($label) => {
        expect($label).to.have.text('Education')
      })
      .get('div.div-education')
      .get('div.education_exp')
      .should(($div) => {
        expect($div).to.have.length(1)
      })
      .then(($div) => {
        expect($div).to.have.text('Some University')
      })
      .get('div.row.bp-text-sm.row-education_exp')
      .get('div.col-md.education_exp-degree')
      .should(($div) => {
        expect($div).to.have.length(1)
      })
      .then(($div) => {
        expect($div).to.have.text('Masters, Some course of study')
      })
      .get('div.col-md.education_exp-currently-studying')
      .should(($div) => {
        expect($div).to.have.length(1)
      })
      .then(($div) => {
        expect($div).to.have.text('1982')
      })
      .get('div.hr-under-education')
      .get('hr.under-education')
      .should('be.visible')
      .should(($hr) => {
        expect($hr).to.have.length(1)
      })
      .get('div.col-md-8.application-summary')
      .get('div.card.mb-4.application-submit')
      .get('div.card-body.application-submit-card')
      .get('p.card-text.card-text-application-submitted')
      .get('div.text-left.mt-2.mb-4.text-left-application-submitted')
      .get('h2.h2-application-submitted')
      .should(($h2) => {
        expect($h2).to.have.length(1)
      })
      .then(($h2) => {
        expect($h2).to.have.text('Application Submitted')
      })
      .get('div.text-left.mb-4.under-review')
      .should(($div) => {
        expect($div).to.have.length(1)
      })
      .then(($div) => {
        expect($div).to.have.text('\n                  Your information is currently under review. If you\'d like to make corrections you can still do so.\n                ')
      })
      .get('div.row.row-under-review')
      .get('div.col.col-under-review')
      .get('a.btn.btn-primary.btn-under-review')
      .should('have.attr', 'href', '/freelancer_profile_steps/work_education_experience')
      .should(($a) => {
        expect($a).to.have.length(1)
        expect($a).have.text('Modify Application')
      })
      .click()
      .go('back')
    // End of Content Card - summary
  })
})
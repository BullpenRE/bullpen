/// <reference types="Cypress" />

describe('Register', () => {
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
      // .get('div.text-light.avatar-image.navbar')
      // .should(($div) => {
      //   expect($div).to.have.length(1)
      //   expect($div).have.attr('style', 'font-size: 47px; line-height: 0;')
      // })
      // .find('img.rounded-circle.in-navbar')
      // .should(($img) => {
      //   expect($img).to.have.length(1)
      //   expect($img).have.attr('style', 'padding-right: 5px')
      //   expect($img).have.attr('src', 'http://localhost:3000/rails/active_storage/representations/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBJdz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--c315b887f686586ed22a756becd237995949528e/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdCam9MY21WemFYcGxTU0lMTkRkNE5EY2hCam9HUlZRPSIsImV4cCI6bnVsbCwicHVyIjoidmFyaWF0aW9uIn19--04ab6977c83eff5da0ac475e36a66058c0050a1a/mini_magick20201031-95553-1mm3c7o.jpg')
      // })

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
      .get('button.btn.btn-outline-primary.education')
      .click()
      .get('div#addEducationModal.modal.fade.show', { includeShadowDom: true})
      .get('div.modal-dialog.modal-dialog-centered.modal-md.education')
      .get('div.modal-content.education')
      .find('form.education', { includeShadowDom: true}).last()
      .find('div.modal-body.pt-0')
      .find('h3')
      .get('div.form-group.institution')
      .get('label.bp-input-label.institution')
      .get('input#institutionInput.form-control')
      .type('Some University')
      .get('div.form-group.degree')
      .get('label.bp-input-label.degree')
      .get('div.dropdown.bootstrap-select.form-control')
      .find('select#degreeSelect.form-control.selectpicker')
      .select('Masters', {force: true})
      .get('div.form-group.course-of-study')
      .get('label.bp-input-label.course-of-study')
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
      .get('form.education').submit()
    //  End of education modal

    cy.get('a#NextBtn.btn.btn-primary.work-education')
      .click()
    // at least we got target page - summary

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

    // Content Card. Step 4

  })
})
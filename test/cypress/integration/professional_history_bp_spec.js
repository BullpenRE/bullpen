/// <reference types="Cypress" />

describe('ProfessionalHistoryPage', () => {
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
    // at least we got target page professional_history

    // progress bar 50%
    cy.get('div.container.mb-4')
      .get('div.progress.bg-white.shadow-sm.mx-auto')
      .get('div.progress-bar')
      .should(($div) => {
        expect($div).to.have.length(1)
      })
      .should('have.attr', 'style', 'width: 50%')

    cy.get('div.container.mb-4')
      .get('div.progress.bg-white.shadow-sm.mx-auto')
      .get('div.text-secondary.font-weight-bold.my-1.text-center')
      .should(($div) => {
        expect($div).to.have.length(1)
      })
      .then(($div) => {
        expect($div).to.have.text('50%')
      })

      // Content Card. Step 3

    cy.get('div.bp-card.mb-5.mx-auto.professional')
      .find('form.edit_freelancer_profile')
      .find('div.text-center')
      .find('h2').first()
      .should(($h2) => {
        expect($h2).to.have.length(1)
      })
      .then(($h2) => {
        expect($h2).to.have.text('Professional History')
      })
      .get('p.mb-4').first()
      .should(($p) => {
        expect($p).to.have.length(1)
      })
      .then(($p) => {
        expect($p).to.have.text('Tell us about your professional history.')
      })

    cy.get('div.row')
      .get('div.col-md.title')
      .find('div.form-group.mb-4')
      .find('label.bp-input-label')
      .should(($label) => {
        expect($label).to.have.length(1)
      })
      .then(($label) => {
        expect($label).to.have.text('Professional Title')
        expect($label).have.attr('for', 'professionalTitleInput')
      })
      .get('input#professionalTitleInput.form-control')
      .should(($input) => {
        expect($input).to.have.length(1)
        expect($input).have.attr('placeholder', 'e.g. Senior Analyst')
        expect($input).have.attr('required', 'required')
        expect($input).have.attr('type', 'text')
        expect($input).have.attr('name', 'freelancer_profile[professional_title]')
      })
      .type('Owner')
      .get('div.col-md.experience')
      .find('div.form-group.mb-4')
      .find('label.bp-input-label')
      .should(($label) => {
        expect($label).to.have.length(1)
      })
      .then(($label) => {
        expect($label).to.have.text('Years of professional experience')
        expect($label).have.attr('for', 'yearsExperienceSelect')
      })
      .get('div.w-100.yearsExperienceSelect')
      .find('div.dropdown.bootstrap-select.form-control')
      .find('select#freelancer_profile_professional_years_experience.form-control.selectpicker', { includeShadowDom: true})
      .should(($select) => {
        expect($select).to.have.length(1)
      })
      .should('have.attr', 'data-style', 'bp-btn-select-border')
      .should('have.attr', 'style', 'display:block !important')
      .should('have.attr', 'title', 'Please make a selection')
      .should('have.attr', 'required', 'required')
      .should('have.attr', 'name', 'freelancer_profile[professional_years_experience]')
      .select('>10', {force: true})
      .should(($select) => {
        expect($select).to.have.length(1)
      })

    cy.get('div.form-group.mb-5.summary')
      .find('label.bp-input-label')
      .should(($label) => {
        expect($label).to.have.length(1)
      })
      .then(($label) => {
        expect($label).to.have.text('Professional Summary')
        expect($label).have.attr('for', 'professionalSummaryTextarea')
      })
      .get('textarea#professionalSummaryTextarea.form-control')
      .should(($textarea) => {
        expect($textarea).to.have.length(1)
      })
      .then(($textarea) => {
        expect($textarea).have.attr('placeholder', 'Describe your experience in a short elevator pitch')
        expect($textarea).have.attr('rows', '3')
        expect($textarea).have.attr('maxlength', '1000')
        expect($textarea).have.attr('required', 'required')
        expect($textarea).have.attr('name', 'freelancer_profile[professional_summary]')
      })
      .type('Some professional summary')

    cy.get('div.d-flex.justify-content-between')
      .get('a.btn.btn-link.px-0')
      .should(($a) => {
        expect($a).to.have.length(1)
      })
      .then(($a) => {
        expect($a).to.have.text('Back')
      })
      .should('have.attr', 'href', '/freelancer_profile_steps/avatar_location')
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
      .get('input.btn.btn-primary')
      .should(($input) => {
        expect($input).to.have.length(1)
        expect($input).have.attr('name', 'commit')
        expect($input).have.attr('type', 'submit')
        expect($input).have.attr('value', 'Next')
        expect($input).have.attr('data-disable-with', 'Next')
      })
      .get('form').submit()
  })
})

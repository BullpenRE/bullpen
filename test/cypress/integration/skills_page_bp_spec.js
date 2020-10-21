/// <reference types="Cypress" />

describe('Register', () => {
  const first_name = 'First'
  const last_name = 'Last'
  const email = 'freelancer@yahoo.com'

  it('checks Logo "BULLPEN" presence at the view, LOGO has width=175px, height=55px', () => {
    cy.visit('http://localhost:5017', {failOnStatusCode: false})
      .contains('Apply').click()
      .get('div.text-left.mt-2.mb-2.ml-5')
      .find('img')
      .should('have.attr', 'src', '/packs-test/media/images/bullpen-email-logo-64fc4a58c54693e46d0e2e963bd3c9ac.png')
      .should(($img) => {
        expect($img).css('width', '175px')
        expect($img).css('height', '55px')
      })
  });

  it('checks progress bar & Content card', () => {
    cy.visit('http://localhost:5017')
      .contains('Apply').click()
      .get('#firstName').type(first_name)
      .get('#lastName').type(last_name)
      .get('#email').type(email)
      .get('button.form-control-lg.btn.btn-outline-secondary.col-md-12.mb-3.nextBtn-2').click()
      .get('input#psw').type('q1234567!Q')
      .get('input#cPwdId').type('q1234567!Q')
      .get('form').submit()

    cy.get('div.container.mb-4')
      .get('div.progress.bg-white.shadow-sm.mx-auto')
      .get('div.progress-bar')
      .should(($div) => {
        expect($div).to.have.length(1)
      })
      .should('have.attr', 'style', 'width: 0%')

    cy.get('div.container.mb-4')
      .get('div.progress.bg-white.shadow-sm.mx-auto')
      .get('div.text-secondary.font-weight-bold.my-1.text-center')
      .should(($div) => {
        expect($div).to.have.length(1)
      })
      .then(($div) => {
        expect($div).to.have.text('0%')
      })

    cy.get('div.container.first')
      .get('div.bp-card.mb-5.mx-auto')
      .get('form.edit_freelancer_profile')
      .get('div.text-center.for-h2')
      .find('h2')
      .should(($h2) => {
        expect($h2).to.have.length(1)
      })
      .then(($h2) => {
        expect($h2).to.have.text('Tell us about your skills.')
      })

    cy.get('div.text-center.for-h2')
      .find('p.mb-4')
      .should(($p) => {
      expect($p).to.have.length(1)
    })
      .then(($p) => {
        expect($p).to.have.text('Add tags to your application that represent your sector and operating knowledge.')
      })

    cy.get('div.form-group.mb-4')
      .find('label.bp-input-label')
      .should(($label) => {
        expect($label).to.have.length(1)
      })
      .then(($label) => {
        expect($label).to.have.text('Describe your real estate skills')
      })

    cy.get('div.form-group.mb-4')
      .get('div.w-100')
      .find('input').first()
      .should((input) => {
      expect(input).to.have.length(1)
    })
      .should('have.attr', 'type', 'hidden')
      .should('have.attr', 'name', 'freelancer_profile[freelancer_real_estate_skills][]')

    cy.get('div.form-group.mb-4')
      .get('div.w-100')
      .get('select#freelancer_profile_freelancer_real_estate_skills')
      .should((select) => {
        expect(select).to.have.length(1)
      })
      .should('have.attr', 'multiple', 'multiple')
      .should('have.attr', 'required', 'required')
      .should('have.attr', 'name', 'freelancer_profile[freelancer_real_estate_skills][]')
      .should('have.attr', 'class', 'select2 select2-hidden-accessible')
      .should('have.attr', 'data-select2-id', 'freelancer_profile_freelancer_real_estate_skills')
      .should('have.attr', 'tabindex', '-1')
      .should('have.attr', 'aria-hidden', 'true')

    cy.get('div.form-group.mb-4')
      .get('div.w-100')
      .get('span.select2.select2-container.select2-container--default').first()
      .should((span) => {
        expect(span).to.have.length(1)
      })
      .should('have.attr', 'dir', 'ltr')
      .should('have.attr', 'data-select2-id', '1')
      // .should('have.attr', 'style', 'width: 610px;')

    cy.get('div.form-group.mb-4')
      .get('div.w-100')
      .get('span.select2.select2-container.select2-container--default').first()
      .get('span.selection').first()
      .get('span.select2-selection.select2-selection--multiple').first()
      .get('ul.select2-selection__rendered').first().children('.select2-search.select2-search--inline')
      .within(() => {
      cy.get('input').should('have.attr', 'placeholder', 'Select all that apply')
      cy.get('input').focus().click()

      })

    cy.get('div.form-group.mb-4')
      .get('div.w-100')
      .get('select.select2.select2-hidden-accessible', { includeShadowDom: true}).first()
      .select('Underwriting')
      .should(($select) => {
        expect($select).to.have.length(1)
      })
  });

})
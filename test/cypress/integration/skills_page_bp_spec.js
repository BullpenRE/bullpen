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
  });

  it('checks progress bar & Content card', () => {
    // to get target page skill_page
    cy.visit('http://localhost:5017')
      .contains('Apply').click()
      .get('#firstName').type(first_name)
      .get('#lastName').type(last_name)
      .get('#email').type(email)
      .get('button.form-control-lg.btn.btn-outline-secondary.col-md-12.mb-3.nextBtn-2').click()
      .get('input#psw').type('q1234567!Q')
      .get('input#cPwdId').type('q1234567!Q')
      .get('form').submit()
    // at least we got target page skill_page

    // progress bar 0%
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

    // Content Card. Step 1

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
      .should(($select) => {
        expect($select).to.have.length(1)
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
      .should(($span) => {
        expect($span).to.have.length(1)
      })
      .should('have.attr', 'dir', 'ltr')
      .should('have.attr', 'data-select2-id', '1')
      .should('have.attr', 'style', 'width: 660px;')

    cy.get('div.form-group.mb-4')
      .get('div.w-100')
      .get('span.select2.select2-container.select2-container--default').first()
      .get('span.selection').first()
      .get('span.select2-selection.select2-selection--multiple').first()
      .get('ul.select2-selection__rendered').first().children('.select2-search.select2-search--inline')
      .within(() => {
      cy.get('input').should('have.attr', 'placeholder', 'Select all that apply')
      cy.get('input')
        .focus()
        .click()
      })

    cy.get('div.form-group.mb-4')
      .get('div.w-100')
      .get('select.select2.select2-hidden-accessible', { includeShadowDom: true}).first()
      .select(['Underwriting', 'Investment Memo'], {force: true})
      .should(($select) => {
        expect($select).to.have.length(1)
      })

    cy.get('ul.select2-selection__rendered')
      .get('li.select2-selection__choice').first()
      .get('span.select2-selection__choice__remove').first()
      .should(($span) => {
        expect($span).to.have.length(1)
        expect($span).have.text('×')
      })
      .should('have.attr', 'role', 'presentation')
      .click({ force: true })
    cy.focused().blur()

    cy.get('ul.select2-selection__rendered')
      .find('span.select2-selection__clear').first()
      .should(($span) => {
        expect($span).to.have.length(1)
        expect($span).have.text('×')
      })
      .should('have.attr', 'title', 'Remove all items')
      .click({ force: true })
    cy.focused().blur()

    cy.get('div.form-group.mb-4')
      .get('div.w-100')
      .get('select.select2.select2-hidden-accessible', { includeShadowDom: true}).first()
      .select(['Underwriting', 'Investment Memo', 'Brokerage Memo'], {force: true})
      .should(($select) => {
        expect($select).to.have.length(1)
      })

    cy.get('div.form-group.mb-5')
      .find('label.bp-input-label')
      .should(($label) => {
        expect($label).to.have.length(1)
      })
      .then(($label) => {
        expect($label).to.have.text('\n          In what sectors do you have experience?\n        ')
      })

    cy.get('div.form-group.mb-5')
      .find('input').first()
      .should(($input) => {
        expect($input).to.have.length(1)
      })
      .should('have.attr', 'type', 'hidden')
      .should('have.attr', 'name', 'freelancer_profile[freelancer_sectors][]')

    cy.get('div.form-group.mb-5')
      .get('select#freelancer_profile_freelancer_sectors')
      .should(($select) => {
        expect($select).to.have.length(1)
      })
      .should('have.attr', 'multiple', 'multiple')
      .should('have.attr', 'required', 'required')
      .should('have.attr', 'name', 'freelancer_profile[freelancer_sectors][]')
      .should('have.attr', 'class', 'select2 select2-hidden-accessible')
      .should('have.attr', 'data-select2-id', 'freelancer_profile_freelancer_sectors')
      .should('have.attr', 'tabindex', '-1')
      .should('have.attr', 'aria-hidden', 'true')

    cy.get('div.form-group.mb-5')
      .get('span.select2-container.select2-container--default.select2-container--below', { includeShadowDom: true})
      .first()
      .should(($span) => {
        expect($span).to.have.length(1)
      })
      .should('have.attr', 'dir', 'ltr')
      .should('have.attr', 'data-select2-id', '1')
    .should('have.attr', 'style', 'width: 660px;')

    cy.get('div.form-group.mb-5')
      .get('span.select2-container.select2-container--default.select2-container--below', { includeShadowDom: true})
      .first()
      .get('span.selection')
      .first()
      .get('span.select2-selection.select2-selection--multiple')
      .first()
      .get('ul.select2-selection__rendered').last().children('.select2-search.select2-search--inline')
      .within(() => {
        cy.get('input').should('have.attr', 'placeholder', 'Select all that apply')
        cy.get('input')
          .focus()
          .click({force: true})
          .blur()

      })

    cy.get('div.form-group.mb-5')
      .get('select.select2.select2-hidden-accessible', { includeShadowDom: true})
      .last()
      .select(['HTC','Affordable Housing'], {force: true})
      .should(($select) => {
        expect($select).to.have.length(1)
      })

    cy.get('ul.select2-selection__rendered')
      .get('li.select2-selection__choice').last()
      .find('span.select2-selection__choice__remove').first()
      .should(($span) => {
        expect($span).to.have.length(1)
        expect($span).have.text('×')
      })
      .should('have.attr', 'role', 'presentation')
      .click({ force: true })
    cy.focused().blur()

    cy.get('ul.select2-selection__rendered')
      .find('span.select2-selection__clear').last()
      .should(($span) => {
        expect($span).to.have.length(1)
        expect($span).have.text('×')
      })
      .should('have.attr', 'title', 'Remove all items')
      .click({ force: true })
    cy.focused().blur()

    cy.get('div.form-group.mb-5')
      .get('select.select2.select2-hidden-accessible', { includeShadowDom: true})
      .last()
      .select(['HTC','Affordable Housing', 'Condo'], {force: true})
      .should(($select) => {
        expect($select).to.have.length(1)
      })

    cy.get('div.d-flex.justify-content-between', { includeShadowDom: true})
      .get('button.btn.btn-link.px-0.invisible', { includeShadowDom: true})
      .should(($button) => {
        expect($button).to.have.length(1)
      })
      .should('have.attr', 'type', 'button')

    cy.get('div.d-flex.justify-content-between')
      .get('input.btn.btn-primary')
      .should(($input) => {
        expect($input).to.have.length(1)
      })
      .should('have.attr', 'type', 'submit')
      .should('have.attr', 'name', 'commit')
      .should('have.attr', 'value', 'Next')
      .should('have.attr', 'data-disable-with', 'Next')
      // .click()
      .get('form').submit()

  });

})
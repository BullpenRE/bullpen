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
      .should(($input) => {
        expect($input).to.have.length(1)
      })
      .click()

    cy.get('div.container.mb-4')
      .get('div.progress.bg-white.shadow-sm.mx-auto')
      .get('div.progress-bar')
      .should(($div) => {
        expect($div).to.have.length(1)
      })
      .should('have.attr', 'style', 'width: 25%')

    cy.get('div.container.mb-4')
      .get('div.progress.bg-white.shadow-sm.mx-auto')
      .get('div.text-secondary.font-weight-bold.my-1.text-center')
      .should(($div) => {
        expect($div).to.have.length(1)
      })
      .then(($div) => {
        expect($div).to.have.text('25%')
      })

    cy.get('div.bp-card.mb-5.mx-auto')
      .get('form.edit_user')
      .get('div.row').first()
      .get('div.col-md.text-center.mb-5.avatar')
      .find('h2').first()
      .should(($h2) => {
        expect($h2).to.have.length(1)
      })
      .then(($h2) => {
        expect($h2).to.have.text('Profile Picture')
      })
      .get('p.mb-4').first()
      .should(($p) => {
        expect($p).to.have.length(1)
      })
      .then(($p) => {
        expect($p).to.have.text('Users with a clear and recognizable photo are hired more often. (Optional)')
      })
      .find('strong')
      .should(($strong) => {
        expect($strong).to.have.length(1)
      })
      .then(($strong) => {
        expect($strong).to.have.text('(Optional)')
      })

    cy.get('div.text-light.mb-3')
      .should(($div) => {
        expect($div).css('font-size', '170px')
        expect($div).css('line-height', '0px')
      })
      .find('svg.svg-inline--fa.fa-user-circle.fa-w-16')
      .should(($svg) => {
        expect($svg).to.have.length(1)
        expect($svg).have.attr('data-prefix', 'fas')
        expect($svg).have.attr('data-icon', 'user-circle')
        expect($svg).have.attr('role', 'img')
      })

    cy.get('div.custom-file')
      .get('input#uploadProfilePic.d-none')
      .should(($input) => {
        expect($input).to.have.length(1)
        expect($input).have.attr('name', 'avatar')
        expect($input).have.attr('type', 'file')
      })
      .get('label.btn.btn-outline-primary.upload-avatar')
      .should(($label) => {
        expect($label).to.have.length(1)
      })
      .then(($label) => {
        expect($label).to.have.text('\n                Upload your photo\n              ')
        expect($label).have.attr('for', 'uploadProfilePic')
      })

    // cy.clearLocalStorage()
    // const fixtureFile = 'image1.png'
    const bestFixtureFile = 'icons8_trash_can_48.png'

    cy.get('input#uploadProfilePic.d-none')
      // .attachFile(fixtureFile, { force: true })
      .attachFile(bestFixtureFile, { force: true })
      // .clearLocalStorage()

    cy.get('div.text-light.mb-3.avatar-image')
      .find('img.rounded-circle')
      .should(($img) => {
        expect($img).to.have.length(1)
        const className = $img[0].className
        expect(className).to.match(/rounded-circle/)
      })

    cy.get('div.custom-file')
      .find('input#uploadProfilePic.d-none', { includeShadowDom: true})
      .should(($input) => {
      expect($input).to.have.length(1)
      expect($input).have.attr('name', 'avatar')
      expect($input).have.attr('type', 'file')
      })
      .get('label.btn.btn-outline-primary.upload-avatar')
      .should(($label) => {
        expect($label).to.have.length(1)
      })
      .then(($label) => {
        expect($label).to.have.text('\n                Edit your photo\n              ')
        expect($label).have.attr('for', 'uploadProfilePic')
      })
      .get('button#deleteProfilePic.delete-avatar.d-none')
      .should(($button) => {
        expect($button).to.have.length(1)
      })
      .then(($button) => {
        expect($button).have.attr('type', 'button')
      })
      .get('label.btn.btn-outline-danger.mr-2')
      .should(($label) => {
        expect($label).to.have.length(1)
      })
      .then(($label) => {
        expect($label).to.have.text('\n                Delete\n              ')
        expect($label).have.attr('for', 'deleteProfilePic')
      })

    const fixtureFile = 'image1.png'
    // const bestFixtureFile = 'icons8_trash_can_48.png'

    cy.get('input#uploadProfilePic.d-none')
      .attachFile(fixtureFile, { force: true })
      // .attachFile(bestFixtureFile, { force: true })
    // .clearLocalStorage()

    cy.get('div.text-light.mb-3.avatar-image')
      .find('img.rounded-circle')
      .should(($img) => {
        expect($img).to.have.length(1)
        const className = $img[0].className
        expect(className).to.match(/rounded-circle/)
      })

    // cy.get('button#deleteProfilePic.delete-avatar.d-none', { includeShadowDom: true})
    //   .click( {force: true})

    // cy.get('div.text-light.mb-3')
    //   .should(($div) => {
    //     expect($div).css('font-size', '170px')
    //     expect($div).css('line-height', '0px')
    //   })
    //   .find('svg.svg-inline--fa.fa-user-circle.fa-w-16')
    //   .should(($svg) => {
    //     expect($svg).to.have.length(1)
    //     expect($svg).have.attr('data-prefix', 'fas')
    //     expect($svg).have.attr('data-icon', 'user-circle')
    //     expect($svg).have.attr('role', 'img')
    //   })

    cy.get('div.col-md.text-center.mb-5')
      .find('h2.location')
      .should(($h2) => {
        expect($h2).to.have.length(1)
      })
      .then(($h2) => {
        expect($h2).to.have.text('Location')
      })
      .get('p.mb-4').last()
      .should(($p) => {
        expect($p).to.have.length(1)
      })
      .then(($p) => {
        expect($p).to.have.text('Where do you live? Some companies prefer to work with local talent.')
      })
      .get('div.form-group.text-left')
      .get('label.bp-input-label')
      .should(($label) => {
        expect($label).to.have.length(1)
      })
      .then(($label) => {
        expect($label).to.have.text('Location')
        expect($label).have.attr('for', 'freelancerLocationInput')
      })
      .get('input#freelancerLocationInput.form-control')
      .should(($input) => {
        expect($input).to.have.length(1)
        expect($input).have.attr('name', 'user[location]')
        expect($input).have.attr('type', 'text')
        expect($input).have.attr('required', 'required')
        expect($input).have.attr('placeholder', 'City, State abbreviation')
      })

    cy.get('div.d-flex.justify-content-between')
      .get('a.btn.btn-link.px-0')
      .should(($a) => {
        expect($a).to.have.length(1)
      })
      .then(($a) => {
        expect($a).to.have.text('Back')
      })
      .should('have.attr', 'href', '/freelancer_profile_steps/skills_page')
      .get('input.btn.btn-primary')
      .should(($input) => {
        expect($input).to.have.length(1)
        expect($input).have.attr('name', 'commit')
        expect($input).have.attr('type', 'submit')
        expect($input).have.attr('value', 'Next')
        expect($input).have.attr('data-disable-with', 'Next')
      })

  })

})
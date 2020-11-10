/// <reference types="Cypress" />

describe('FreelancerRegistrationPage', () => {
  beforeEach(() => {
    // seed the database prior to every test
    cy.exec('RAILS_ENV=test rails db:seed')

  })
  const first_name = 'First'
  const last_name = 'Last'
  const email = 'freelancer@yahoo.com'

  it('checks Logo "BULLPEN" presence at the view, LOGO has width=175px, height=55px', () => {
    cy.visit('http://localhost:5017')
      .contains('Apply').click()
      .get('div.text-left.mt-2.mb-2.ml-5')
      .find('img')
      .should('have.attr', 'src', '/packs-test/media/images/bullpen-email-logo-64fc4a58c54693e46d0e2e963bd3c9ac.png')
      .should(($img) => {
        expect($img).css('width', '175px')
        expect($img).css('height', '55px')
      })
  });

  it('checks text "Create an Account" presence at the view step-1', () => {
    cy.visit('http://localhost:5017')
      .contains('Apply').click()
      .get('div#step-1')
      .find('h4.mb-5.mt-4.display-5.ml-4.text-primary.text-center')
      .should(($h4) => {
        expect($h4).to.have.length(1)
      })
      .then(($h4) => {
        expect($h4).to.have.text('Create an Account')
      })
  });

  it('checks button "Sign up as a freelancer" presence at the view step-1', () => {
    cy.visit('http://localhost:5017')
      .contains('Apply').click()
      .get('div#step-1')
      .find('button.form-control-lg.btn.btn-outline-secondary.col-md-12.mb-3.nextBtn-2')
      .should(($button) => {
        expect($button).to.have.length(1)
      })
      .then(($button) => {
        expect($button).to.have.text('Sign up as a freelancer')
      })
  });

  it('checks registration of new user as a freelancer', () => {
    cy.visit('http://localhost:5017')
      .contains('Apply').click()
      .get('#firstName').type(first_name)
      .get('#lastName').type(last_name)
      .get('#email').type(email)
      .get('button.form-control-lg.btn.btn-outline-secondary.col-md-12.mb-3.nextBtn-2').click()
      .get('input#psw').type('q1234567!Q')
      .get('input#cPwdId').type('q1234567!Q')
      .get('form').submit()
  });

  it('checks text "Already have an account? Login" presence at the view step-1', () => {
    cy.visit('http://localhost:5017')
      .contains('Apply').click()
      .get('div#step-1')
      .get('footer.col-md-11.border-top.mt-2.pt-lg-4')
      .get('div.text-center')
      .find('h5')
      .should(($h5) => {
        expect($h5).to.have.length(1)
      })
      .then(($h5) => {
        expect($h5).to.have.text('Already have an account? Login')
      })

    cy.get('div.text-center')
      .get('h5')
      .find('a.p-2')
      .should('have.attr', 'href', '/users/sign_in')

  });

  it('checks text "Create an Account" presence at the view step-2', () => {
    cy.visit('http://localhost:5017')
      .contains('Apply').click()
      .get('#firstName').type(first_name)
      .get('#lastName').type(last_name)
      .get('#email').type(email)
      .get('button.form-control-lg.btn.btn-outline-secondary.col-md-12.mb-3.nextBtn-2').click()
      .get('div#step-2')
      .find('h4.mb-5.mt-4.display-5.text-primary.text-center')
      .should(($h4) => {
        expect($h4).to.have.length(1)
      })
      .then(($h4) => {
        expect($h4).to.have.text('Create an Account')
      })
  });

  it('checks change of email', () => {
    cy.visit('http://localhost:5017')
      .contains('Apply').click()
      .get('#firstName').type(first_name)
      .get('#lastName').type(last_name)
      .get('#email').type(email)
      .get('button.form-control-lg.btn.btn-outline-secondary.col-md-12.mb-3.nextBtn-2').click()
      .get('a.prevBtn-2.text-center.text-muted').click()
  });

  it('checks text "By creating your account, you agree to Bullpen\'s..." presence on view', () => {
    cy.visit('http://localhost:5017')
      .contains('Apply').click()
      .get('#firstName').type(first_name)
      .get('#lastName').type(last_name)
      .get('#email').type(email)
      .get('button.form-control-lg.btn.btn-outline-secondary.col-md-12.mb-3.nextBtn-2').click()
      .get('div#step-2')
      .get('div#cy-agree')
      .should(($div) => {
        expect($div).to.have.length(1)
      })
      .then(($div) => {
        expect($div).to.have.text("\n          By creating your account, you agree to Bullpen's\n          \n            Terms of Service\n          ,\n          \n            Privacy Agreement\n          , and Stripe's Connected Accounts Authorization\n        ")
      })
  });

  it('checks "Terms of Service", "Privacy Agreement", "Stripe\'s Connected Accounts Authorization" links', () => {
    cy.visit('http://localhost:5017')
      .contains('Apply').click()
      .get('#firstName').type(first_name)
      .get('#lastName').type(last_name)
      .get('#email').type(email)
      .get('button.form-control-lg.btn.btn-outline-secondary.col-md-12.mb-3.nextBtn-2').click()
      .get('div#step-2')
      .get('div#cy-agree' )
      .get('span#cy-first')
      .find('a')
      .should('have.attr', 'href', 'https://bullpenre.com/terms-of-service/?_ga=2.176404525.943759142.1600229912-339552047.1597271456')

    cy.get('div#step-2')
      .get('div#cy-agree' )
      .get('span#cy-second')
      .find('a')
      .should('have.attr', 'href', 'https://bullpenre.com/privacy-policy/?_ga=2.79419548.943759142.1600229912-339552047.1597271456')

    cy.get('div#step-2')
      .get('div#cy-agree' )
      .get('span#cy-third')
      .find('a')
      .should('have.attr', 'href', 'https://stripe.com/connect-account/legal')
  });

  it('checks empty or not valid first name, last name, email, phone number', () => {
    cy.visit('http://localhost:5017')
    cy.contains('Apply').click()

    cy.get('#firstName').type(first_name).clear()
    cy.get('div.invalid-feedback.has-error-min').contains('Valid first name is required - two symbols minimum.')

    cy.get('#firstName').type('1')
    cy.get('div.invalid-feedback.has-error-min').contains('Valid first name is required - two symbols minimum.')

    cy.get('#firstName').clear().type(first_name).clear()
    cy.get('#lastName').type(last_name)
    cy.get('div.invalid-feedback.has-error-min').contains('Valid first name is required - two symbols minimum.')

    cy.get('#firstName').clear().type(first_name).clear()
    cy.get('#lastName').clear().type(last_name).clear()
    cy.get('div.invalid-feedback.has-error-min').contains('Valid first name is required - two symbols minimum.')
    cy.get('div.invalid-feedback.has-error-min').contains('Valid last name is required - two symbols minimum.')

    cy.get('#firstName').type(first_name)
    cy.get('#lastName').type(last_name).clear()
    cy.get('div.invalid-feedback.has-error-min').contains('Valid last name is required - two symbols minimum.')

    cy.get('#firstName').clear().type(first_name)
    cy.get('#lastName').type('1')
    cy.get('div.invalid-feedback.has-error-min').contains('Valid last name is required - two symbols minimum.')

    cy.get('#firstName').clear().type(first_name).clear()
    cy.get('#lastName').clear().type(last_name).clear()
    cy.get('#email').type(email).clear()
    cy.get('div.invalid-feedback.has-error-min').contains('Valid first name is required - two symbols minimum.')
    cy.get('div.invalid-feedback.has-error-min').contains('Valid last name is required - two symbols minimum.')
    cy.get('div.invalid-feedback.has-error-email').contains('Enter valid email - it has to contain \"@\".')

    cy.get('#firstName').clear().type(first_name)
    cy.get('#lastName').clear().type(last_name)
    cy.get('#email').type(email).clear()
    cy.get('div.invalid-feedback.has-error-email').contains('Enter valid email - it has to contain \"@\".')

    cy.get('#firstName').clear().type(first_name)
    cy.get('#lastName').clear().type(last_name)
    cy.get('#email').clear().type('not-valid-email')
    cy.get('div.invalid-feedback.has-error-email').contains('Enter valid email - it has to contain \"@\".')
  });

  it ('checks password and "eye" icon in input field', () => {
    cy.visit('http://localhost:5017')
    cy.contains('Apply').click()
    cy.get('#firstName').clear().type(first_name)
    cy.get('#lastName').clear().type(last_name)
    cy.get('#email').clear().type(email)
    cy.contains('Sign up as a freelancer').click()
    cy.get('div.input-group')
      .first()
      .find('span')
      .should(($span) => {
        expect($span).to.have.length(1)

        const className = $span[0].className

        expect(className).to.match(/field-icon toggle-password/)
      })

    cy.get('div.input-group')
      .first()
      .find('span')
      .find('svg')
      .should(($svg) => {
        expect($svg).to.have.length(1)
      })

    cy.get('div.input-group')
      .first()
      .find('span')
      .click()
      .find('svg')
      .should(($svg) => {
        expect($svg).to.have.length(1)
      })
  });

  it ('checks password and div#message.div.row.div#special', () => {
    cy.visit('http://localhost:5017')
    cy.contains('Apply').click()
    cy.get('#firstName').clear().type(first_name)
    cy.get('#lastName').clear().type(last_name)
    cy.get('#email').clear().type(email)
    cy.contains('Sign up as a freelancer').click()
    cy.get('div#step-2')
      .find('div.input-group').first()
      .find('input#psw').type('!').clear()
      .get('div#message')
      .find('div.row')
      .find('div#special')
      .should(($div) => {
        expect($div).to.have.length(1)

        const className = $div[0].className

        expect(className).to.match(/col-sm text-muted text-nowrap small invalid/)
      })

    cy.get('div#step-2')
      .find('div.input-group').first()
      .find('input#psw').type('!')
      .get('div#message')
      .find('div.row')
      .find('div#special')
      .should(($div) => {
        expect($div).to.have.length(1)

        const className = $div[0].className

        expect(className).to.match(/col-sm text-muted text-nowrap small valid/)
      })
  });

  it ('checks password and div#message.div.row.div#number', () => {
    cy.visit('http://localhost:5017')
    cy.contains('Apply').click()
    cy.get('#firstName').clear().type(first_name)
    cy.get('#lastName').clear().type(last_name)
    cy.get('#email').clear().type(email)
    cy.contains('Sign up as a freelancer').click()
    cy.get('div#step-2')
      .find('div.input-group').first()
      .find('input#psw').type('!').clear()
      .get('div#message')
      .find('div.row')
      .find('div#number')
      .should(($div) => {
        expect($div).to.have.length(1)

        const className = $div[0].className

        expect(className).to.match(/col-sm text-muted text-nowrap small invalid/)
      })

    cy.get('div#step-2')
      .find('div.input-group').first()
      .find('input#psw').type('1')
      .get('div#message')
      .find('div.row')
      .find('div#number')
      .should(($div) => {
        expect($div).to.have.length(1)

        const className = $div[0].className

        expect(className).to.match(/col-sm text-muted text-nowrap small valid/)
      })
  });

  it ('checks password and div#message.div.row.div#length', () => {
    cy.visit('http://localhost:5017')
    cy.contains('Apply').click()
    cy.get('#firstName').clear().type(first_name)
    cy.get('#lastName').clear().type(last_name)
    cy.get('#email').clear().type(email)
    cy.contains('Sign up as a freelancer').click()
    cy.get('div#step-2')
      .find('div.input-group').first()
      .find('input#psw').type('1qazxsW#').clear()
      .get('div#message')
      .find('div.row')
      .find('div#length')
      .should(($div) => {
        expect($div).to.have.length(1)

        const className = $div[0].className

        expect(className).to.match(/col-sm text-muted text-nowrap small invalid/)
      })

    cy.get('div#step-2')
      .find('div.input-group').first()
      .find('input#psw').type('1qazxsW#')
      .get('div#message')
      .find('div.row')
      .find('div#length')
      .should(($div) => {
        expect($div).to.have.length(1)

        const className = $div[0].className

        expect(className).to.match(/col-sm text-muted text-nowrap small valid/)
      })
  });

  it ('checks password_confirmation and "eye" icon in input field', () => {
    cy.visit('http://localhost:5017')
    cy.contains('Apply').click()
    cy.get('#firstName').clear().type(first_name)
    cy.get('#lastName').clear().type(last_name)
    cy.get('#email').clear().type(email)
    cy.contains('Sign up as a freelancer').click()
    cy.get('div.input-group.mb-4')
      .first()
      .find('span')
      .should(($span) => {
        expect($span).to.have.length(1)

        const className = $span[0].className

        expect(className).to.match(/field-icon toggle-password/)
      })

    cy.get('div.input-group.mb-4')
      .first()
      .find('span')
      .find('svg')
      .should(($svg) => {
        expect($svg).to.have.length(1)
      })

    cy.get('div.input-group.mb-4')
      .first()
      .find('span')
      .click()
      .find('svg')
      .should(($svg) => {
        expect($svg).to.have.length(1)
      })
  });

  it ('checks password-confirmation', () => {
    cy.visit('http://localhost:5017')
    cy.contains('Apply').click()
    cy.get('#firstName').clear().type(first_name)
    cy.get('#lastName').clear().type(last_name)
    cy.get('#email').clear().type(email)
    cy.contains('Sign up as a freelancer').click()
    cy.get('div#step-2')
      .find('div.input-group').first()
      .find('input#psw').type('1qazxsW#')
      .get('div.input-group.mb-4').first()
      .find('input#cPwdId').type('1qazxsW')
      .find('div#same_psw')
      .should('not.be.visible')

    cy.get('div#step-2')
      .find('div.input-group').first()
      .find('input#psw').type('1qazxsW#')
      .get('div.input-group.mb-4').first().type('1qazxsW#')
      // .find('input#cPwdId').first().type('1qazxsW#')
      .get('div#same_psw')
      .should('be.visible')
      .get('div#same_psw').contains('Same as your password')
  })
})

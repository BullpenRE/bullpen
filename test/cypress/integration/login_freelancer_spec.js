/// <reference types="Cypress" />

describe('login test suite', () => {
  const email = 'some@yahoo.com'
  const pass = 'Qwer123!'

  expect(email, 'username was set').to.be.a('string').and.not.be.empty
  expect(pass, 'password was set').to.be.a('string').and.not.be.empty

  it('wrong credentials', () => {
    cy.visit('/')
    cy.get('a.p-2').click()

    // test email
    cy.get('[id = "user_email"]:invalid').should('have.length', 0)
    cy.get('#user_email').type('not_an_email')
    cy.get('[type="submit"]').click()
    cy.get('[id = "user_email"]:invalid').should('have.length', 1)
    cy.get('#user_email').then(($input) => {
      expect($input[0].validationMessage).to.eq('Please include an \'@\' in the email address. \'not_an_email\' is missing an \'@\'.')
    })

    // test password

    cy.get('[id="user_password"]:invalid').should('have.length', 0)
    cy.get('#user_password').type('pass')
    cy.get('[type="submit"]').click()
    cy.get('[id="user_password"]:invalid').should('have.length', 1)
    cy.get('#user_password').then(($input) => {
      expect($input[0].validationMessage).to.eq('mes')
    })

    cy.location('pathname').should('equal','/users/sign_in')
  });

  it('true credentials', () => {
    cy.visit('/')
    cy.get('a.p-2').click()
    cy.get('#user_email').type(email)
    cy.get('#user_password').type(pass)
    cy.get('#new_user').submit()

    cy.location('pathname').should('equal','/users/sign_in')
  });
})

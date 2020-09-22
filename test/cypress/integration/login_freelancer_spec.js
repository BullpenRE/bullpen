/// <reference types="Cypress" />

describe('login test suite', () => {
  const email = 'some@yahoo.com'
  const pass = 'Qwer123!'

  expect(email, 'username was set').to.be.a('string').and.not.be.empty
  expect(pass, 'password was set').to.be.a('string').and.not.be.empty

  it('wrong credentials', () => {
    cy.visit('http://localhost:3000')
    cy.get('a.p-2').click()
    cy.get('#user_email').type('email')

    cy.get('#user_password').type('some') //must have more then 8 symbols

    cy.get('#new_user').submit()

    //cy.contains('.error-message', 'email must be valid')

    cy.location('pathname').should('equal','/users/sign_in')
  });

  it('true credentials', () => {
    cy.visit('http://localhost:3000')
    cy.get('a.p-2').click()
    cy.get('#user_email').type(email)
    cy.get('#user_password').type(pass)
    cy.get('#new_user').submit()

    cy.location('pathname').should('equal','/users/sign_in')
  });
})

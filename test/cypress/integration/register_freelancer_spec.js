/// <reference types="Cypress" />

describe('Register', () => {
  const first_name = 'First'
  const last_name = 'Last'
  const email = 'freelancer@yahoo.com'

  expect(first_name, 'first name was set').to.be.a('string').and.not.be.empty
  expect(last_name, 'last name was set').to.be.a('string').and.not.be.empty
  expect(email, 'email was set').to.be.a('string').and.not.be.empty

  it('register a new user', () => {
    cy.visit('http://localhost:3000')
    cy.contains('Apply').click()

    cy.get('#firstName').type(first_name)
    cy.get('#lastName').type(last_name)
    cy.get('#email').type(email)

    cy.get('form').submit()
  });

  it('empty first name', () => {
    cy.visit('http://localhost:3000')
    cy.contains('Apply').click()

    cy.get('#firstName').type(first_name).clear()
    cy.get('#lastName').type(last_name)
    cy.get('#email').type(email)

    cy.get('form').submit()

    cy.contains('.invalid-feedback','Valid first name is required.')
  });

  it ('empty last name', () => {
    cy.visit('http://localhost:3000')
    cy.contains('Apply').click()

    cy.get('#firstName').type(first_name)
    cy.get('#lastName').type(last_name).clear()
    cy.get('#email').type(email)

    cy.get('form').submit()

    cy.contains('.invalid-feedback','Valid last name is required.')
  });

  it ('empty email', () => {
    cy.visit('http://localhost:3000')
    cy.contains('Apply').click()

    cy.get('#firstName').type(first_name)
    cy.get('#lastName').type(last_name)
    cy.get('#email').type(email).clear()

    cy.get('form').submit()

    cy.contains('.invalid-feedback','Please enter a valid email address.')
  });

  it ('wrong email', () => {
    cy.visit('http://localhost:3000')
    cy.contains('Apply').click()

    cy.get('#firstName').type(first_name)
    cy.get('#lastName').type(last_name)
    cy.get('#email').type('email')

    cy.get('form').submit()

    cy.contains('.invalid-feedback','Please enter a valid email address.')
  });
})

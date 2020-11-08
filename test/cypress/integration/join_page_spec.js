/// <reference types="Cypress" />

describe('Join page', () => {
  it('register a new user', () => {
    cy.visit('/', {failOnStatusCode: false})
  });
})

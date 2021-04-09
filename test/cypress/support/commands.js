// ***********************************************
// This example commands.js shows you how to
// create various custom commands and overwrite
// existing commands.
//
// For more comprehensive examples of custom
// commands please read more here:
// https://on.cypress.io/custom-commands
// ***********************************************
//
//
// -- This is a parent command --
// Cypress.Commands.add("login", (email, password) => { ... })
//
//
// -- This is a child command --
// Cypress.Commands.add("drag", { prevSubject: 'element'}, (subject, options) => { ... })
//
//
// -- This is a dual command --
// Cypress.Commands.add("dismiss", { prevSubject: 'optional'}, (subject, options) => { ... })
//
//
// -- This is will overwrite an existing command --
// Cypress.Commands.overwrite("visit", (originalFn, url, options) => { ... })

import 'cypress-file-upload';
import axios from 'axios'
import 'cypress-xpath'

Cypress.Commands.add('cleanDatabase', (opts = { seed: true }) => {
    return axios({
        method: 'POST',
        url: 'http://localhost:5017/test/clean_database',
        data: { should_seed: opts.seed }
    })
})

Cypress.Commands.add('seedPosts', (count) => {
    return axios({
        method: 'POST',
        url: 'http://localhost:5017/test/seed_posts',
        data: { count }
    })
})

Cypress.Commands.add("resetDatabase", () => {
    cy.request('DELETE', '/cypress/cleanup').as('cleanup')
})

Cypress.Commands.add("factory", (name, attributes) => {
    cy.request('POST', '/cypress/factories', {
        name: name,
        attributes: attributes || {}
    }).as('test data')
})

Cypress.Commands.add("login", (email) => {
    cy.request('POST', '/cypress/sessions', {
        email: email
    })
})

Cypress.Commands.add("gui_login", (email) => {
    cy.visit('http://localhost:5017/users/sign_in', {failOnStatusCode: false})

    cy.get('#user_email')
      .should('exist')
      .type(email)
    cy.get('#user_password')
      .should('exist')
      .type('q1234567!Q')
    cy.get('.actions > .btn')
      .should('exist')
      .click()
})

Cypress.Commands.add("gui_logout", () => {
    cy.get('[rel="nofollow"]')
      .should('exist')
      .wait(2000)
      .get('[rel="nofollow"]')
      .click({force: true})
})

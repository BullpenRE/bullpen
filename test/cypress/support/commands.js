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

import axios from 'axios'

Cypress.Commands.add('cleanDatabase', (opts = { seed: true }) => {
    return axios({
        method: 'POST',
        url: 'http://localhost:3000/test/clean_database',
        data: { should_seed: opts.seed }
    })
})

Cypress.Commands.add('seedPosts', (count) => {
    return axios({
        method: 'POST',
        url: 'http://localhost:3000/test/seed_posts',
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

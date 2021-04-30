/// <reference types="Cypress" />

describe('Create employer_profile via factory employer_profile.rb and test manage account flow', () => {

  it('create employer_profile via factory employer_profile.rb and test manage account flow', function () {
    // via factory employer_profile.rb create employer, employer_profile
    cy.appFactories([
      ['create', 'employer_profile']

    ])
    // try to login as just created employer
    cy.gui_login('tetyanaEmpl@gmail.com')

    // try to click dropdown menu item 'Manage Account' inside user profile menu on navbar
    cy.get('#manage-account')
      .should('exist')
      .click({force: true})

    // try to click edit icon in chapter avatar, profile info
    cy.get('[data-target^="#editEmployerProfileModal"]')
      .should('exist')
      .click()

    // try to upload avatar
    const bestFixtureFile = 'image1.png'

    cy.get('input#uploadProfilePic')
      .should('exist')
      .attachFile(bestFixtureFile, { force: true })

    // try to change first_name
    cy.get('[name="user[first_name]"]')
      .should('exist')
      .clear({force: true})
      .type('TetyanaEmplAmended')

    // try to change last name
    cy.get('[name="user[last_name]"]')
      .should('exist')
      .clear({force: true})
      .type('LastNameAmended')

    // try to click button 'Save Changes'
    cy.get('[data-disable-with="Save Changes"]')
      .eq(0)
      .should('exist')
      .click()

    // try to set bank account as default
    cy.get('[data-method="put"]')
      .should('exist')
      .click({force: true})

    // try to amend data in chapter 'Company Information'
    // try to click edit button
    cy.get('[data-target^="#editEmployerCompanyModal"]')
      .should('exist')
      .wait(2000)
      .get('[data-target^="#editEmployerCompanyModal"]')
      .click()

    // try to amend company name
    cy.get('[name="employer_profile[company_name]"]')
      .should('exist')
      .clear({force: true})
      .type('CompanyNameAmended')

    // try to amend Website
    cy.get('[name="employer_profile[company_website]"]')
      .should('exist')
      .clear({force: true})
      .type('tetyanaEmplAmended.com')

    // try to amend location
    cy.get('[name="employer_profile[user_attributes][location]"]')
      .should('exist')
      .clear({force: true})
      .type('San Francisco, CA')

    // try to amend employee number
    cy.get('[name="employer_profile[employee_count]"]')
      .should('exist')
      .select('51-100', {force: true})

    // try to amend function
    cy.get('[name="employer_profile[category]"]')
      .should('exist')
      .select('Development', {force: true})

    // try to click button 'Save Changes'
    cy.get('[data-disable-with="Save Changes"]')
      .eq(1)
      .should('exist')
      .click()

  })
})

/// <reference types="Cypress" />

describe('Create freelancer_profiles.rb via factory and test freelancer manage account flow', () => {

  it('create freelancer_profiles.rb via factory and test freelancer manage account flow', function () {
    // via freelancer_profiles.rb create freelancer_profile
    cy.appFactories([
      ['create', 'freelancer_profile']

    ])
    //  try to login as just created freelancer
    cy.gui_login('tetyanaFree@gmail.com')

    // try to click dropdown menu item 'Manage Account' inside user profile menu on navbar
    cy.get('#manage-account')
      .should('exist')
      .click({force: true})

    // try to click edit icon in chapter avatar, profile info
    cy.get('[data-target^="#editProfileModal"]')
      .should('exist')
      .click()

    // try to upload avatar in opened module 'Personal Information'
    const bestFixtureFile = 'image1.png'

    cy.get('input#uploadProfilePic')
      .should('exist')
      .attachFile(bestFixtureFile, { force: true })

    // try to change first_name in opened module 'Personal Information'
    cy.get('[name="freelancer_profile[first_name]"]')
      .should('exist')
      .clear({force: true})
      .type('TetyanaFreeAmended')

    // try to change last name in opened module 'Personal Information'
    cy.get('[name="freelancer_profile[last_name]"]')
      .should('exist')
      .clear({force: true})
      .type('LastNameAmended')

    // try to change professional title in opened module 'Personal Information'
    cy.get('[name="freelancer_profile[professional_title]"]')
      .should('exist')
      .clear({force: true})
      .type('ProfessionalTitleAmended')

    // try to amend location in opened module 'Personal Information'
    cy.get('#freelancerLocationInput')
      .should('exist')
      .clear()
      .type('San Francisco, CA')

    // try to amend Professional Summary in opened module 'Personal Information'
    cy.get('[name="freelancer_profile[professional_summary]"]')
      .should('exist')
      .clear()
      .type('Cy - Modified information regarding Professional Summary ')

    // try to amend 'Desired Hourly Rate' in opened module 'Personal Information'
    cy.get('[name="freelancer_profile[desired_hourly_rate]"]')
      .should('exist')
      .clear()
      .type('195')

    // try to change Sectors in opened module 'Personal Information'
    cy.get('#freelancer_profile_freelancer_sectors.select2.custom-validate.select2-hidden-accessible', { includeShadowDom: true})
      .select(['HTC', 'Hospitality', 'Industrial', 'Medical'], {force: true})

    // try to click button 'Save Changes' in opened module 'Personal Information'
    cy.get('#submitWithLocationCheck')
      .should('exist')
      .click()

    // try to click button 'Add a Bank Account'
    // cy.get('a.cy-add-account')
    //   .should('exist')
    //   .should('have.attr', 'href', 'https://connect.stripe.com/express/oauth/authorize?redirect_uri=http://localhost:5017/freelancer/stripe/connect&client_id=ca_F92ZNOQd5VYyop7dz5TP5qB7uf9ljnuk&stripe_user%5Bemail%5D=tetyanafree@gmail.com&stripe_user%5Bfirst_name%5D=TetyanaFreeAmended&stripe_user%5Blast_name%5D=LastNameAmended&stripe_user%5Bphone_number%5D=&stripe_user%5Bcountry%5D=US')
    //   .click()

  })
})

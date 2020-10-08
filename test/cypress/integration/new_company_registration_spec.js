/// <reference types="Cypress" />

describe('Register', () => {
    const first_name = 'First'
    const last_name = 'Last'
    const email = 'freelancer@yahoo.com'
    const phone = '111'

    expect(first_name, 'first name was set').to.be.a('string').and.not.be.empty
    expect(last_name, 'last name was set').to.be.a('string').and.not.be.empty
    expect(email, 'email was set').to.be.a('string').and.not.be.empty

    it('register a new user_company', () => {
        cy.visit('http://localhost:3000')
        cy.contains('Apply').click()

        cy.get('#firstName').type(first_name)
        cy.get('#lastName').type(last_name)
        cy.get('#email').type(email)
        cy.get('#phone').type(phone)

        cy.get('form').submit()
    });

    it('empty first name', () => {
        cy.visit('http://localhost:3000')
        cy.contains('Apply').click()

        cy.get('#firstName').type(first_name).clear()
        cy.get('#lastName').type(last_name)
        cy.get('#email').type(email)
        cy.get('#phone').type(phone)

        cy.get('form').submit()

        cy.contains('li','First name can\'t be blank')
    });

    it ('empty last name', () => {
        cy.visit('http://localhost:3000')
        cy.contains('Apply').click()

        cy.get('#firstName').type(first_name)
        cy.get('#lastName').type(last_name).clear()
        cy.get('#email').type(email)
        cy.get('#phone').type(phone)

        cy.get('form').submit()

        cy.contains('li','Last name can\'t be blank')
    });

    it ('empty phone field', () => {
        cy.visit('http://localhost:3000')
        cy.contains('Apply').click()

        cy.get('#firstName').type(first_name)
        cy.get('#lastName').type(last_name)
        cy.get('#email').type(email)
        cy.get('#phone').type(phone).clear()

        cy.get('form').submit()

        cy.contains('li','Phone can\'t be blank')
    });

    it ('wrong email', () => {
        cy.visit('http://localhost:3000')
        cy.contains('Apply').click()

        // cy.get('[id = "email"]:invalid').should('have.length', 0)
        cy.get('#email').type('not_an_email')
        cy.get('[type="submit"]').click()
        cy.get('[id = "email"]:invalid').should('have.length', 1)
        cy.get('#email').then(($input) => {
            expect($input[0].validationMessage).to.eq('Please include an \'@\' in the email address. \'not_an_email\' is missing an \'@\'.')
        })
    });

    it ('check password', () => {
        cy.visit('http://localhost:3000')
        cy.contains('Apply').click()

        //cy.get('[id = "psw"]:invalid').should('have.length', 0)
        cy.get('#psw').type('!')
        cy.get('[type="submit"]').click()
        cy.get('#psw').then(($input) => {
            expect($input[0].validationMessage).to.eq('Please fill in this field.')
        })
    });
})

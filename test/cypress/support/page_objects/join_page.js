class JoinPage {

  getBullpenNavText(){
    return cy.get('.align-items-center > .text-center');
  }

  getJoinBullpenText(){
    return cy.get('.display-4');
  }

  getFreelancerText(){
    return cy.get('.card-deck > :nth-child(1) > .my-0');
  }

  getIamIndividualText(){
    return cy.get(':nth-child(1) > .card-body > .card-title');
  }

  getApplyLink(){
    return cy.get('.card-body > div > .btn');
  }

  getCompanyText(){
    return cy.get(':nth-child(2) > .my-0');
  }

  getIamCompanyText(){
    return cy.get(':nth-child(2) > .card-body > .card-title');
  }

  getSignUpButton(){
    return cy.get('.card-body > .btn');
  }

  getAlreadyHaveAccountText(){
    return cy.get('.text-center > h5');
  }

  getLoginLink(){
    return cy.get('.p-2');
  }

}
export default JoinPage
class LetterOpener {

  get route() {
    return '/letter_opener';
  }

  clickConfirmEmailLink() {
    cy.get('iframe')
      .then(($iframe) => {
        const $body = $iframe.contents().find('body')[0]

        cy.wrap($body).get('a').contains('Confirm Email').click()
      })
  }
}
export default LetterOpener;
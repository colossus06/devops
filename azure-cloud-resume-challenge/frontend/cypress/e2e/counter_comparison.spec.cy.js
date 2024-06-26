describe('Verify counter value', () => {
  it('loads the site', () => {
    // Load the site and verify it is loaded
    cy.visit('/')
    cy.contains('Gulcan').should('be.visible')


    // Get the initial visitor count
    cy.get('#counter').then(($el) => {
      const initialVisitorCount = parseInt($el.text())
      
      // Reload the site a couple of times and verify visitor count increases
      for (let i = 0; i < 2; i++) {
        cy.reload()
        cy.get('#counter').should(($newEl) => {
          const newVisitorCount = parseInt($newEl.text())
          expect(newVisitorCount).to.be.greaterThan(initialVisitorCount)        
        })
      }
    })
  })
})


// describe(()=> {});

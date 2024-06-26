describe('Test heading', () => {
    beforeEach(() => {

        cy.visit('/')
      
      })
    it('banner', () => {
        cy.get('[data-cy="gulcan"]').contains('Hi, I\'m Gulcan').should('be.visible');
        cy.get('[data-cy="link"]').should('not.exist');
        
    })
    it('test scroll', () => {
        cy.get('[data-cy="endlinks"]');
    })
    it('should have a title', () => {
      cy.title().should('exist')
    })
  
    it('should have a header', () => {
      cy.get('header').should('exist')
    })
  
    it('should have a navigation menu', () => {
      cy.get('nav').should('exist')
    })
  
    it('should have a footer', () => {
      cy.get('footer').should('exist')
    })

    it('Find broken links', () => {    
        cy.get('a').each(link => {    
          if (link.prop('href'))    
            cy.request({    
              url: link.prop('href'),    
              failOnStatusCode: false    
            })    
          cy.log( link.prop('href'))    
        })    
      })
})

// it('', () => {}) 

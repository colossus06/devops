describe('GET request to API', () => {
    it('should return an integer response', () => {
      // Make a GET request to the API endpoint
      cy.request('GET', 'https://funcrctopcug.azurewebsites.net/api/id/?code=<key>').then(response => {
        // Verify that the response status is 200 OK
        expect(response.status).to.equal(200);  
        // Parse the response body as an integer
        const responseInt = parseInt(response.body);  
        // Verify that the response is an integer
        expect(responseInt).to.be.a('number').and.to.not.be.NaN;
      });
    });

    it('visitor count should be greater on revisit ', () => {
      for (let i = 0; i < 2; i++) {
        cy.request('GET', 'https://funcrctopcug.azurewebsites.net/api/id/?code=<key>').then(response => {
          const responseInt = parseInt(response.body); 

          expect(response.status).to.equal(200);
          cy.request('GET', 'https://funcrctopcug.azurewebsites.net/api/id/?code=<key>').then(response => {
            const newResponseInt = parseInt(response.body);
            expect(newResponseInt).to.be.greaterThan(responseInt)
          })

        })
    }
    })
  });
  
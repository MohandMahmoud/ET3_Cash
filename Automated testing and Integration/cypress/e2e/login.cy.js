describe('Login Page Test', () => {
  beforeEach(() => {
      // Visit the login page before each test case
      cy.visit('file:///C:/Users/honda/Downloads/New%20folder/login.html'); // Use the correct path for your local file
  });

  it('Should log in successfully with correct credentials', () => {
      // Enter valid username and password
      cy.get('#username').type('mohand');
      cy.get('#password').type('123456789');

      // Submit the form
      cy.get('input[type="submit"]').click();

      // Assert the success alert and redirection to the dashboard
      cy.on('window:alert', (str) => {
          expect(str).to.equal('Login successful!'); // Assert alert message
      });
      cy.url().should('include', 'file:///E:/ET3/Task%204%20&%205/et3/dashboard.html'); // Assert URL after login
  });

  it('Should display an error with incorrect credentials', () => {
      // Enter invalid username and password
      cy.get('#username').type('wronguser');
      cy.get('#password').type('wrongpassword');

      // Submit the form
      cy.get('input[type="submit"]').click();

      // Assert the failure alert
      cy.on('window:alert', (str) => {
          expect(str).to.equal('Invalid username or password!'); // Assert alert message
      });
  });

  it('Should display an error when username field is empty', () => {
      // Leave the username empty and enter a valid password
      cy.get('#password').type('123456789');

      // Submit the form
      cy.get('input[type="submit"]').click();

      // Assert that the login fails due to missing username
      cy.on('window:alert', (str) => {
          expect(str).to.equal('Invalid username or password!'); // Assert alert message
      });
  });

  it('Should display an error when password field is empty', () => {
      // Enter a valid username and leave the password empty
      cy.get('#username').type('mohand');

      // Submit the form
      cy.get('input[type="submit"]').click();

      // Assert that the login fails due to missing password
      cy.on('window:alert', (str) => {
          expect(str).to.equal('Invalid username or password!'); // Assert alert message
      });
  });

  it('Should navigate to the Forgot Password page', () => {
      // Click on the "Forgot Password?" link
      cy.get('.forgot-password a').click();

      cy.on('window:alert', (str) => {
          expect(str).to.equal('Email Send to your gmail'); // Assert alert message
      });
  });

  it('Should navigate to the Sign Up page', () => {
      // Click on the "Sign Up" link
      cy.get('.redirect a').click();

      // Assert that the page redirects to the correct sign-up page
      cy.url().should('include', 'file:///E:/ET3/Task%204%20&%205/et3/signup.html'); // Assert URL
  });

  it('Should navigate to Google login when clicking on the Google button', () => {
      // Click on the Google login button
      cy.get('.google').click();

      // Assert that it opens the Google login page
      cy.url().should('include', 'https://google.com/'); // Assert URL
  });

  it('Should navigate to Facebook login when clicking on the Facebook button', () => {
      // Click on the Facebook login button
      cy.get('.facebook').click();

      // Assert that it opens the Facebook login page
      cy.url().should('include', 'https://www.facebook.com/login.php/'); // Assert URL
  });

  it('Should navigate to Yahoo login when clicking on the Yahoo button', () => {
      // Click on the Yahoo login button
      cy.get('.yahoo').click();

      // Assert that it opens the Yahoo login page
      cy.url().should('include', 'https://login.yahoo.com/'); // Assert URL
  });
});

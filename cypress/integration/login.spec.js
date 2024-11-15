describe('Login Page', () => {

    beforeEach(() => {
      cy.visit('http://localhost:8000/login');
    });

    // 1. Test the Display of the Login Page
    it('should display the login form', () => {
      cy.get('h2').contains('Login');
      cy.get('input[name="username"]').should('exist');
      cy.get('input[name="password"]').should('exist');
      cy.get('button').contains('Login');
      cy.get('.form-footer').contains("Don't have an account?");
    });

    // 2. Test Required Field Validation
    it('should show validation error if fields are empty', () => {
      cy.get('button[type="submit"]').click();
      cy.get('input[name="username"]:invalid').should('exist');
      cy.get('input[name="password"]:invalid').should('exist');
    });

    // 3. Test Successful Login
    it('should log in successfully with correct credentials', () => {
      cy.get('input[name="username"]').type('mohand');
      cy.get('input[name="password"]').type('mohand55');
      cy.get('button[type="submit"]').click();
      cy.url().should('include', '/dashboard');  // Assuming redirect to /dashboard
    });

    // 4. Test Login with Incorrect Credentials
    it('should show an error for incorrect credentials', () => {
      cy.get('input[name="username"]').type('invalidUsername');
      cy.get('input[name="password"]').type('invalidPassword');
      cy.get('button[type="submit"]').click();
      cy.get('.error-message').should('exist').contains('Invalid username or password');
    });

    // 5. Test Password Visibility Toggle
    it('should toggle password visibility', () => {
      cy.get('input[name="password"]').type('mypassword');
      cy.get('input[name="password"]').should('have.attr', 'type', 'password');
      cy.get('.password-toggle').click();
      cy.get('input[name="password"]').should('have.attr', 'type', 'text');
      cy.get('.password-toggle').click();
      cy.get('input[name="password"]').should('have.attr', 'type', 'password');
    });


    // 7. Test Dark Mode Toggle
    it('should toggle between dark mode and light mode', () => {
      cy.get('body').should('have.class', 'dark-mode');
      cy.get('.dark-mode-toggle').click();
      cy.get('body').should('have.class', 'light-mode');
      cy.get('.dark-mode-toggle').click();
      cy.get('body').should('have.class', 'dark-mode');
    });

    // 8. Test Login with Username and Password Special Characters
    it('should handle special characters in username and password', () => {
      cy.get('input[name="username"]').type('Ali007');
      cy.get('input[name="password"]').type('pass$%^&*');
      cy.get('button[type="submit"]').click();
      cy.url().should('include', '/dashboard');  // Assuming successful login
    });

    // 9. Test Forgot Password Link
    it('should navigate to sign up page when clicked', () => {
      cy.get('.form-footer a').contains('Sign up').click();
      cy.url().should('include', '/signup');
    });

    // 10. Test Form Submission with Keyboard (Enter Key)
    it('should allow form submission using Enter key', () => {
      cy.get('input[name="username"]').type('mohand');
       cy.get('input[name="password"]').type('mohand55{enter}');
      cy.url().should('include', '/dashboard');
    });

    // 11. Test Page Responsiveness
    it('should be responsive on mobile viewports', () => {
      cy.viewport('iphone-6');
      cy.get('h2').contains('Login');
      cy.get('input[name="username"]').should('exist');
      cy.get('input[name="password"]').should('exist');
      cy.get('input[name="username"]').type('testuser');
      cy.get('input[name="password"]').type('testpassword');
      cy.get('button[type="submit"]').click();
    });

  });

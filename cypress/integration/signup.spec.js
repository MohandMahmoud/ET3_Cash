describe('Signup Page Test Suite', () => {
    beforeEach(() => {
        // Visit the signup page before each test
        cy.visit('http://localhost:8000/signup'); // Adjust the URL to your actual signup page
    });

    it('Should load the signup page correctly', () => {
        cy.contains('Create Your Account').should('be.visible');
        cy.get('input[name="username"]').should('be.visible');
        cy.get('input[name="email"]').should('be.visible');
        cy.get('input[name="password"]').should('be.visible');
        cy.get('input[name="password_confirmation"]').should('be.visible');
        cy.get('button[type="submit"]').should('be.visible');
    });

    it('Should display error if the form is submitted with empty fields', () => {
        cy.get('button[type="submit"]').click();
    });

    it('Should display error for invalid email format', () => {
        cy.get('input[name="username"]').type('testuser');
        cy.get('input[name="email"]').type('invalid-email');
        cy.get('input[name="password"]').type('ValidPassword123');
        cy.get('input[name="password_confirmation"]').type('ValidPassword123');
        cy.get('button[type="submit"]').click();
    });

    it('Should display error if password confirmation does not match', () => {
        cy.get('input[name="username"]').type('testuser');
        cy.get('input[name="email"]').type('testuser@example.com');
        cy.get('input[name="password"]').type('ValidPassword123');
        cy.get('input[name="password_confirmation"]').type('MismatchPassword');
        cy.get('button[type="submit"]').click();
    });

    it('Should display error if the password is too short', () => {
        cy.get('input[name="username"]').type('testuser');
        cy.get('input[name="email"]').type('testuser@example.com');
        cy.get('input[name="password"]').type('short');
        cy.get('input[name="password_confirmation"]').type('short');
        cy.get('button[type="submit"]').click();
    });

    it('Should display error if the password is entirely numeric', () => {
        cy.get('input[name="username"]').type('testuser');
        cy.get('input[name="email"]').type('testuser@example.com');
        cy.get('input[name="password"]').type('12345678');
        cy.get('input[name="password_confirmation"]').type('12345678');
        cy.get('button[type="submit"]').click();
    });

    it('Should display error if the password is too common', () => {
        cy.get('input[name="username"]').type('testuser');
        cy.get('input[name="email"]').type('testuser@example.com');
        cy.get('input[name="password"]').type('password');
        cy.get('input[name="password_confirmation"]').type('password');
        cy.get('button[type="submit"]').click();
    });

    it('Should successfully submit the form with valid data', () => {
        cy.get('input[name="username"]').type('validuser');
        cy.get('input[name="email"]').type('validuser@example.com');
        cy.get('input[name="password"]').type('ValidPassword123');
        cy.get('input[name="password_confirmation"]').type('ValidPassword123');
        cy.get('button[type="submit"]').click();
    });

    it('Should toggle dark mode on and off', () => {
        cy.get('body').should('not.have.class', 'dark-mode');
        cy.get('#darkModeToggle').click();
        cy.get('body').should('have.class', 'dark-mode');
        cy.get('#darkModeToggle').click();
        cy.get('body').should('not.have.class', 'dark-mode');
    });

    it('Should visually check the consistency of the form in dark mode', () => {
        cy.get('#darkModeToggle').click(); // Enable dark mode
        cy.get('body').should('have.class', 'dark-mode');
        cy.get('body').should('have.css', 'background-color', 'rgb(18, 18, 18)'); // Check body background color
        cy.get('.container').should('have.css', 'background-color', 'rgb(30, 30, 47)'); // Check container background color
    });

    it('Should ensure that an existing user cannot sign up again (server-side validation)', () => {
        cy.get('input[name="username"]').type('existinguser');
        cy.get('input[name="email"]').type('existinguser@example.com');
        cy.get('input[name="password"]').type('ValidPassword123');
        cy.get('input[name="password_confirmation"]').type('ValidPassword123');
        cy.get('button[type="submit"]').click();
    });
});

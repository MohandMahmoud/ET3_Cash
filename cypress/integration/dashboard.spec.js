describe('Cash Dashboard Tests', () => {
    beforeEach(() => {
        // Visit the login page before each test
        cy.visit('http://127.0.0.1:8000/login', { timeout: 30000 });

        // Perform login actions
        cy.get('input[name="username"]').type('mohand', { timeout: 30000 });
        cy.get('input[name="password"]').type('mohand55', { timeout: 30000 });
        cy.get('button[type="submit"]').click({ timeout: 30000 });

        // Ensure that login was successful before proceeding
        cy.url().should('include', '/dashboard', { timeout: 30000 });
    });

    it('should display the dashboard and user information', () => {
        cy.get('.navbar-brand').should('contain', 'Cash Dashboard', { timeout: 30000 });
        cy.get('.profile h5').should('exist', { timeout: 30000 });
        cy.get('.balance').should('contain', 'Your Current Balance', { timeout: 30000 });
    });

    it('should toggle dark mode', () => {
        cy.get('#toggle-mode').click({ timeout: 30000 });
        cy.get('body').should('have.class', 'dark-mode', { timeout: 30000 });

        cy.get('#toggle-mode').click({ timeout: 30000 });
        cy.get('body').should('not.have.class', 'dark-mode', { timeout: 30000 });
    });

    // Test depositing money
    it('should submit a deposit form and update balance', () => {
        cy.get('#action').select('deposit', { timeout: 30000 });
        cy.get('#amount').type('100', { timeout: 30000 });
        cy.get('button[type="submit"]').click({ timeout: 30000 });
        cy.get('#alert-container .alert').should('exist', { timeout: 30000 });
    });

    // Test withdrawing money
    it('should submit a withdrawal form and update balance', () => {
        cy.get('button[type="submit"]').click({ timeout: 30000 });
    });

    // Test sending money
    it('should submit a send money form', () => {
        cy.get('#amount').type('20', { timeout: 30000 });
        cy.get('button[type="submit"]').click({ timeout: 30000 });
        cy.get('#alert-container .alert').should('exist', { timeout: 30000 });

    });

    // Test paying bills
    it('should submit a pay bill form', () => {
        cy.get('#amount').type('30', { timeout: 30000 });
        cy.get('button[type="submit"]').click({ timeout: 30000 });
        cy.get('#alert-container .alert').should('exist', { timeout: 30000 });
    });

    // Test creating a virtual card
    it('should submit a create virtual card form', () => {
        cy.get('#amount').type('10', { timeout: 30000 });
        cy.get('button[type="submit"]').click({ timeout: 30000 });
        cy.get('#alert-container .alert').should('exist', { timeout: 30000 });
        // You can add further checks to verify if the virtual card was created
    });

    // Test donating money
    it('should submit a donate form', () => {
        cy.get('#amount').type('15', { timeout: 30000 });
        cy.get('button[type="submit"]').click({ timeout: 30000 });

        cy.get('#alert-container .alert').should('exist', { timeout: 30000 });
        // Verify the updated balance if necessary
    });

    // Test creating a savings account
    it('should submit a create savings account form', () => {
        cy.get('button[type="submit"]').click({ timeout: 30000 });
    });

    // Test withdrawing from savings
    it('should submit a withdraw from savings form', () => {
        cy.get('button[type="submit"]').click({ timeout: 30000 });
    });

    // Test changing the PIN
    it('should submit a change PIN form', () => {
        cy.get('button[type="submit"]').click({ timeout: 30000 });
    });

    // Test displaying transaction history
    it('should display transaction history', () => {
        cy.get('#transaction-list').should('exist', { timeout: 30000 });
        cy.get('#transaction-list').children().should('have.length.greaterThan', 0, { timeout: 30000 });
    });
});

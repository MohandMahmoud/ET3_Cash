// cypress/support/e2e.js
// This file can be used to set up global configurations and commands.

// Example of adding a custom command
Cypress.Commands.add('login', (email, password) => {
  cy.get('input[name="email"]').type(email);
  cy.get('input[name="password"]').type(password);
  cy.get('button[type="submit"]').click();
});
Cypress.Commands.add('signup', (username, email, password, confirmPassword) => {
  // Visit the signup page
  cy.visit('/signup'); // Adjust the path to your signup page

  // Fill out the signup form
  cy.get('input[name="username"]').type(username);
  cy.get('input[name="email"]').type(email);
  cy.get('input[name="password"]').type(password);
  cy.get('input[name="confirm_password"]').type(confirmPassword); // Fill out the confirm password field

  // Submit the form
  cy.get('button[type="submit"]').click();

  // Optionally, add assertions to verify successful signup
  cy.url().should('include', '/login'); // Adjust this according to your redirection after signup
  cy.contains('Your account has been created successfully!').should('be.visible'); // Adjust this message
});
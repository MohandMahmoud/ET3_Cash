document.getElementById('loginForm').addEventListener('submit', function(event) {
    event.preventDefault();

    const username = document.getElementById('username').value;
    const password = document.getElementById('password').value;
    if (username === 'mohand' && password === '123456789') {
        alert('Login successful!');
        window.location.href = 'E:\\ET3\\Task 4 & 5\\Devops\\Forntend\\DashBoard.html';
    } else {
        alert('Invalid username or password!');
    }
});
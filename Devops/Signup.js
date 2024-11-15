document.getElementById('signupForm').addEventListener('submit', function(event) {
    event.preventDefault(); 

    const username = document.getElementById('username').value;
    const email = document.getElementById('email').value;
    const password = document.getElementById('password').value;
    const repassword = document.getElementById('repassword').value;

    if (password !== repassword) {
        alert('Passwords do not match!');
        return;
    }

    if (username === 'mohand' && password === '123456789') {
        alert('you have an account');
        return;
    }

    console.log('Username:', username);
    console.log('Email:', email);
    console.log('Password:', password);

    alert('Signup successful! Welcome, ' + username + '!');
    window.location.href = 'E:\\ET3\\Task 4 & 5\\Devops\\Forntend\\Dashboard.html'; 
});
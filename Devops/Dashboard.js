let balance = 0;
        let savingsBalance = 0;
        let transactions = [];
        const transactionsPerPage = 8;
        let currentPage = 1;

        function deposit() {
            const amount = parseFloat(prompt("Enter deposit amount:"));
            if (validateAmount(amount)) {
                balance += amount;
                updateBalance();
                addTransaction(`Deposited: $${amount.toFixed(2)}`);
            }
        }

        function withdraw() {
            const amount = parseFloat(prompt("Enter withdrawal amount:"));
            if (validateAmount(amount) && amount <= balance) {
                balance -= amount;
                updateBalance();
                addTransaction(`Withdrew: $${amount.toFixed(2)}`);
            } else {
                alert("Insufficient funds or invalid amount.");
            }
        }

        function sendMoney() {
            const recipient = prompt("Enter recipient's number:");
            const amount = parseFloat(prompt("Enter amount to send:"));
            if (recipient==="01124762559")
            {
                alert("Invalid Opreation.");
            }
            else if (validateAmount(amount) && amount <= balance) {
                balance -= amount;
                updateBalance();
                addTransaction(`Sent $${amount.toFixed(2)} to ${recipient}`);
            } else {
                alert("Insufficient funds or invalid amount.");
            }
        }

        function payBill() {
            const billers = ["Gas", "Water", "Electric", "Internet"];
            const biller = prompt(`Choose a biller:\n${billers.join("\n")}`);

            if (!billers.includes(biller)) {
                alert("Invalid biller selection.");
                return;
            }

            const amount = parseFloat(prompt("Enter amount to pay:"));

            if (validateAmount(amount) && amount <= balance) {
                balance -= amount;
                updateBalance();
                addTransaction(`Paid $${amount.toFixed(2)} to ${biller}`);
                alert(`You have successfully paid $${amount.toFixed(2)} for your ${biller} bill.`);
            } else {
                alert("Insufficient funds or invalid amount.");
            }
        }
        function createVirtualCard() {
            const cardName = prompt("Enter the amount for the virtual card:");
            if (cardName) {
                addTransaction(`Created virtual card: ${cardName}`);
            } else {
                alert("Please enter a valid card amount.");
            }
        }

        function donate() {
            const charities = ["57357", "Magd yacoub", "orman","Masr Elkhair"];
            const charity = prompt(`Choose a charity:\n${charities.join("\n")}`);
            if (!charities.includes(charity)) {
                alert("Invalid charity.");
                return;
            }

            const amount = parseFloat(prompt("Enter donation amount:"));
            if (validateAmount(amount) && amount <= balance) {
                balance -= amount;
                updateBalance();
                addTransaction(`Donated $${amount.toFixed(2)} to ${charity}`);
            } else {
                alert("Insufficient funds or invalid amount.");
            }
        }

        function createSavingsAccount() {
            const amount = parseFloat(prompt("Enter initial deposit for savings account:"));
            if (!isNaN(amount) && amount > 0 && amount <= balance) {
                savingsBalance += amount;
                balance -= amount;
                updateBalance();
                addTransaction(`Created savings account with deposit: $${amount.toFixed(2)}`);
            } else {
                alert("Please enter a valid amount or insufficient funds.");
            }
        }

        function withdrawSavings() {
            const amount = parseFloat(prompt("Enter amount to withdraw from savings:"));
            if (validateAmount(amount) && amount <= savingsBalance) {
                savingsBalance -= amount;
                updateBalance();
                addTransaction(`Withdrew $${amount.toFixed(2)} from savings`);
            } else {
                alert("Insufficient savings or invalid amount.");
            }
        }

        function clearTransactions() {
            transactions = [];
            localStorage.removeItem("transactions");
            updateTransactionList();
        }

        function validateAmount(amount) {
            if (isNaN(amount) || amount <= 0) {
                alert("Please enter a valid amount.");
                return false;
            }
            return true;
        }

       
        function updateBalance() {
            document.getElementById("balanceAmount").innerText = `$${balance.toFixed(2)}`;
            document.getElementById("savingsBalanceAmount").innerText = `$${savingsBalance.toFixed(2)}`;
            localStorage.setItem("balance", balance.toFixed(2));
            localStorage.setItem("savingsBalance", savingsBalance.toFixed(2));
        }

        function addTransaction(transaction) {
            transactions.push(transaction);
            localStorage.setItem("transactions", JSON.stringify(transactions));
            updateTransactionList();
        }

        function loadSavedData() {
            const savedBalance = parseFloat(localStorage.getItem("balance"));
            const savedSavingsBalance = parseFloat(localStorage.getItem("savingsBalance"));
            const savedTransactions = JSON.parse(localStorage.getItem("transactions"));
            if (!isNaN(savedBalance)) balance = savedBalance;
            if (!isNaN(savedSavingsBalance)) savingsBalance = savedSavingsBalance;
            if (Array.isArray(savedTransactions)) transactions = savedTransactions;
            updateBalance();
            updateTransactionList();
        }

        function updateTransactionList() {
            const transactionList = document.getElementById("transactionList");
            transactionList.innerHTML = "";
            const start = (currentPage - 1) * transactionsPerPage;
            const end = Math.min(start + transactionsPerPage, transactions.length);
            for (let i = start; i < end; i++) {
                const li = document.createElement("li");
                li.classList.add("list-group-item");
                li.innerText = transactions[i];
                transactionList.appendChild(li);
            }
            updatePagination();
        }

        function updatePagination() {
            const pagination = document.getElementById("pagination");
            pagination.innerHTML = "";
            const totalPages = Math.ceil(transactions.length / transactionsPerPage);
            for (let i = 1; i <= totalPages; i++) {
                const li = document.createElement("li");
                li.classList.add("page-item");
                if (i === currentPage) li.classList.add("active");
                const a = document.createElement("a");
                a.classList.add("page-link");
                a.innerText = i;
                a.href = "#";
                a.addEventListener("click", function() {
                    currentPage = i;
                    updateTransactionList();
                });
                li.appendChild(a);
                pagination.appendChild(li);
            }
        }

        function exportTransactions() {
            const csvContent = transactions.join("\n");
            const blob = new Blob([csvContent], { type: "text/csv" });
            const link = document.createElement("a");
            link.href = URL.createObjectURL(blob);
            link.download = "transactions.csv";
            link.click();
        }

        function logout() {
            window.location.href = "E:\\ET3\\Task 4 & 5\\Devops\\Forntend\\login.html";
        }
        window.onload = loadSavedData;
const mysql = require('mysql2');
const bcrypt = require('bcrypt');

const db = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'ipad_db',
    port: 3307
});

async function testAuth() {
    console.log('--- STARTING AUTH TEST ---');

    db.connect(async err => {
        if (err) {
            console.error('Connection failed:', err.message);
            return;
        }
        console.log('1. Database connected.');

        try {
            // Check table
            const [columns] = await db.promise().query('DESCRIBE users');
            console.log('2. Users table check:');
            console.table(columns);

            // Test registration logic
            const username = 'testuser_' + Date.now();
            const password = 'password123';
            const email = username + '@example.com';
            const role = 'Admin';

            console.log('3. Attempting bcrypt hash...');
            const hash = await bcrypt.hash(password, 10);
            console.log('   Hash generated:', hash.substring(0, 10) + '...');

            console.log('4. Attempting insert...');
            const [result] = await db.promise().query(
                'INSERT INTO users (username, email, password_hash, role) VALUES (?, ?, ?, ?)',
                [username, email, hash, role]
            );
            console.log('   Insert successful. ID:', result.insertId);

            // Test login logic
            console.log('5. Attempting fetch...');
            const [rows] = await db.promise().query('SELECT * FROM users WHERE username = ?', [username]);
            const user = rows[0];
            console.log('   User fetched. Role:', user.role);

            console.log('6. Attempting bcrypt compare...');
            const match = await bcrypt.compare(password, user.password_hash);
            console.log('   Comparison result:', match);

            console.log('--- TEST PASSED SUCCESSFULLY ---');
        } catch (error) {
            console.error('--- TEST FAILED ---');
            console.error('Error Code:', error.code);
            console.error('Error Message:', error.message);
            console.error('Stack:', error.stack);
        } finally {
            db.end();
        }
    });
}

testAuth();

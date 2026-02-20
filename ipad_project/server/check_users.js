const mysql = require('mysql2');

const db = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'ipad_db',
    port: 3307
});

db.connect(err => {
    if (err) {
        console.error('Connection error:', err.message);
        process.exit(1);
    }

    db.query('DESCRIBE users', (err, results) => {
        if (err) {
            console.error('Describe error:', err.message);
        } else {
            console.log('--- USERS TABLE STRUCTURE ---');
            console.table(results);
        }

        db.query('SELECT id, username, role FROM users LIMIT 5', (err, rows) => {
            if (err) {
                console.error('Select error:', err.message);
            } else {
                console.log('--- SAMPLE USERS ---');
                console.table(rows);
            }
            db.end();
        });
    });
});

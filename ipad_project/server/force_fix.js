const mysql = require('mysql2');

const db = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'ipad_db',
    port: 3307
});

db.connect(async err => {
    if (err) {
        console.error('Connection error:', err.message);
        process.exit(1);
    }

    console.log('Connected to database.');

    const queryPromise = (q) => new Promise((resolve, reject) => {
        db.query(q, (err, results) => err ? reject(err) : resolve(results));
    });

    try {
        console.log('Checking users table...');
        const results = await queryPromise('DESCRIBE users');
        const existingColumns = results.map(r => r.Field);

        if (!existingColumns.includes('role')) {
            console.log('Adding "role" column...');
            await queryPromise("ALTER TABLE users ADD COLUMN role VARCHAR(20) DEFAULT 'Salesperson' AFTER password_hash");
            console.log('Column added successfully.');
        } else {
            console.log('Column "role" already exists.');
        }
    } catch (err) {
        console.error('Migration failed:', err.message);
    } finally {
        db.end();
    }
});

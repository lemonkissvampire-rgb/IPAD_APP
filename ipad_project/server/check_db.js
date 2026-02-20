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
        console.error('Error connecting to MySQL:', err);
        process.exit(1);
    }
    console.log('Connected to ipad_db');

    const runQuery = (name, query) => {
        return new Promise((resolve, reject) => {
            db.query(query, (err, results) => {
                console.log(`\n=== ${name} ===`);
                if (err) {
                    console.error(`Error: ${err.message}`);
                    reject(err);
                } else {
                    if (Array.isArray(results)) {
                        console.table(results);
                    } else {
                        console.log(JSON.stringify(results, null, 2));
                    }
                    resolve(results);
                }
            });
        });
    };

    try {
        await runQuery('Before Backfill: Recent Visitors', 'SELECT id, name, event, event_id, assigned FROM visitors ORDER BY created_at DESC LIMIT 5');

        console.log('\nRunning Backfill Migration...');
        const backfillResult = await runQuery('Backfill result', `
            UPDATE visitors v
            JOIN events e ON v.event = e.event_name
            SET v.event_id = e.id
            WHERE v.event_id IS NULL
        `);

        await runQuery('After Backfill: Visitors with Event IDs', 'SELECT id, name, event, event_id, assigned FROM visitors WHERE event_id IS NOT NULL ORDER BY created_at DESC LIMIT 5');

        await runQuery('Integrated View (Full Logic)', `
            SELECT 
                v.id, v.name, v.event, 
                COALESCE(e.salesperson_name, v.assigned) as assigned_display
            FROM visitors v 
            LEFT JOIN events e ON v.event_id = e.id 
            ORDER BY v.created_at DESC LIMIT 5
        `);

    } catch (e) {
        console.error('Diagnostic failed:', e);
    } finally {
        db.end();
        process.exit(0);
    }
});

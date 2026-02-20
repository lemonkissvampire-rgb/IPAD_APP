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
                if (err) {
                    console.error(`Error in ${name}: ${err.message}`);
                    reject(err);
                } else {
                    console.log(`Success: ${name} (${results.affectedRows || results.length} rows)`);
                    resolve(results);
                }
            });
        });
    };

    try {
        console.log('\n--- SYNCHRONIZING LEGACY DATA ---');

        // Sync name from full_name
        await runQuery('Sync name', "UPDATE visitors SET name = full_name WHERE (name IS NULL OR name = '') AND full_name IS NOT NULL AND full_name != ''");

        // Sync phone from phone_number
        await runQuery('Sync phone', "UPDATE visitors SET phone = phone_number WHERE (phone IS NULL OR phone = '') AND phone_number IS NOT NULL AND phone_number != ''");

        // Sync role from job_position
        await runQuery('Sync role', "UPDATE visitors SET role = job_position WHERE (role IS NULL OR role = '') AND job_position IS NOT NULL AND job_position != ''");

        // Sync status from priority_status
        await runQuery('Sync status', "UPDATE visitors SET status = priority_status WHERE (status IS NULL OR status = 'Standard') AND priority_status IS NOT NULL AND priority_status != 'Standard'");

        // Final Backfill for event_id
        await runQuery('Backfill event_id', `
            UPDATE visitors v
            JOIN events e ON LOWER(TRIM(v.event)) = LOWER(TRIM(e.event_name))
            SET v.event_id = e.id
            WHERE v.event_id IS NULL
        `);

        console.log('\n--- VERIFICATION ---');
        const results = await runQuery('Final Check', `
            SELECT v.id, v.name, v.event, v.event_id, e.salesperson_name as linked_salesperson, v.assigned as stored_assigned
            FROM visitors v
            LEFT JOIN events e ON v.event_id = e.id
            ORDER BY v.created_at DESC LIMIT 5
        `);
        console.table(results);

    } catch (e) {
        console.error('Migration failed:', e);
    } finally {
        db.end();
        process.exit(0);
    }
});

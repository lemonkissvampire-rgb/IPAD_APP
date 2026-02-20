const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');
const bcrypt = require('bcrypt');

const app = express();
app.use(cors());
app.use(express.json());

app.get('/api/health', (req, res) => {
    res.json({ status: 'ok', version: '1.1.0', timestamp: new Date() });
});

// Database connection
// Database connection pool
const db = mysql.createPool({
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'ipad_db',
    port: 3307,
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0
});

// Test connection
db.getConnection((err, connection) => {
    if (err) {
        console.error('Error connecting to MySQL:', err);
        return;
    }
    console.log('Connected to MySQL database: ipad_db');
    connection.release();
});

// Helper promise-based query function
const queryPromise = (q, params = []) => new Promise((resolve, reject) => {
    db.query(q, params, (err, results) => err ? reject(err) : resolve(results));
});

// Create users table if it doesn't exist
const createUsersTableQuery = `
            CREATE TABLE IF NOT EXISTS users (
                id INT AUTO_INCREMENT PRIMARY KEY,
                username VARCHAR(50) UNIQUE NOT NULL,
                email VARCHAR(255) UNIQUE NOT NULL,
                password_hash VARCHAR(255) NOT NULL,
                role VARCHAR(20) DEFAULT 'Salesperson',
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
    `;
db.query(createUsersTableQuery, async (err) => {
    if (err) console.error('Error creating users table:', err);
    else {
        console.log('Table "users" is ready');
        // Migration for existing users table
        try {
            const results = await queryPromise('DESCRIBE users');
            const existingColumns = results.map(r => r.Field);
            if (!existingColumns.includes('role')) {
                console.log('Adding "role" column to "users" table...');
                await queryPromise("ALTER TABLE users ADD COLUMN role VARCHAR(20) DEFAULT 'Salesperson' AFTER password_hash");
                console.log('Column "role" added successfully.');
            }
        } catch (migrationErr) {
            console.error('Error migrating users table:', migrationErr);
        }
    }
});

// Create visitors table if it doesn't exist
const createTableQuery = `
        CREATE TABLE IF NOT EXISTS visitors (
            id INT AUTO_INCREMENT PRIMARY KEY,
            name VARCHAR(255) NOT NULL,
            phone VARCHAR(20),
            email VARCHAR(255),
            organization VARCHAR(255),
            role VARCHAR(100),
            familiarity INT,
            event VARCHAR(100),
            status VARCHAR(20) DEFAULT 'Standard',
            approval_status VARCHAR(20) DEFAULT 'Pending',
            assigned VARCHAR(100),
            selected_topic VARCHAR(255),
            consent TINYINT(1) DEFAULT 1,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
    `;
db.query(createTableQuery, (err) => {
    if (err) console.error('Error creating table:', err);
    else {
        console.log('Table "visitors" is ready');

        // Robust Schema Migration for visitors table
        const requiredVisitorColumns = [
            { name: 'event_id', type: 'INT', after: 'id' },
            { name: 'name', type: 'VARCHAR(255) NOT NULL', after: 'event_id' },
            { name: 'phone', type: 'VARCHAR(20)', after: 'name' },
            { name: 'organization', type: 'VARCHAR(255)', after: 'email' },
            { name: 'role', type: 'VARCHAR(100)', after: 'organization' },
            { name: 'familiarity', type: 'INT', after: 'role' },
            { name: 'event', type: 'VARCHAR(100)', after: 'familiarity' },
            { name: 'status', type: "VARCHAR(20) DEFAULT 'Standard'", after: 'event' },
            { name: 'approval_status', type: "VARCHAR(20) DEFAULT 'Pending'", after: 'status' },
            { name: 'assigned', type: 'VARCHAR(100)', after: 'approval_status' },
            { name: 'selected_topic', type: 'VARCHAR(255)', after: 'assigned' },
            { name: 'consent', type: 'TINYINT(1) DEFAULT 1', after: 'selected_topic' }
        ];


        const migrate = async () => {
            try {
                const results = await queryPromise('DESCRIBE visitors');
                const existingColumns = results.map(r => r.Field);

                for (const column of requiredVisitorColumns) {
                    if (!existingColumns.includes(column.name)) {
                        console.log(`Adding missing column "${column.name}" to "visitors" table...`);
                        await queryPromise(`ALTER TABLE visitors ADD COLUMN ${column.name} ${column.type} AFTER ${column.after}`);
                        console.log(`Column "${column.name}" added successfully.`);
                    }
                }

                // Backfill event_id for existing records matching by event name string
                const backfillQuery = `
                        UPDATE visitors v
                        JOIN events e ON LOWER(TRIM(v.event)) = LOWER(TRIM(e.event_name))
                        SET v.event_id = e.id
                        WHERE v.event_id IS NULL
                    `;
                const backfillResult = await queryPromise(backfillQuery);
                if (backfillResult.changedRows > 0) {
                    console.log(`Backfilled event_id for ${backfillResult.changedRows} visitor(s).`);
                }
            } catch (err) {
                console.error('Migration error:', err);
            }
        };

        migrate();
    }
});

// Create events table if it doesn't exist
const createEventsTableQuery = `
        CREATE TABLE IF NOT EXISTS events (
            id INT AUTO_INCREMENT PRIMARY KEY,
            salesperson_name VARCHAR(255) NOT NULL,
            event_name VARCHAR(255) NOT NULL,
            address VARCHAR(255) NOT NULL,
            companies JSON NOT NULL,
            dates JSON NOT NULL,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
    `;
db.query(createEventsTableQuery, (err) => {
    if (err) console.error('Error creating events table:', err);
    else {
        console.log('Table "events" is ready');

        // Robust Schema Migration: Check and add missing columns
        const requiredColumns = [
            { name: 'salesperson_name', type: 'VARCHAR(255) NOT NULL', after: 'id' },
            { name: 'event_name', type: 'VARCHAR(255) NOT NULL', after: 'salesperson_name' },
            { name: 'address', type: 'VARCHAR(255) NOT NULL', after: 'event_name' },
            { name: 'companies', type: 'JSON NOT NULL', after: 'address' },
            { name: 'dates', type: 'JSON NOT NULL', after: 'companies' }
        ];

        db.query('DESCRIBE events', (err, results) => {
            if (err) {
                console.error('Error describing events table:', err);
                return;
            }

            const existingColumns = results.map(r => r.Field);

            requiredColumns.forEach(column => {
                if (!existingColumns.includes(column.name)) {
                    console.log(`Adding missing column "${column.name}" to "events" table...`);
                    const alterQuery = `ALTER TABLE events ADD COLUMN ${column.name} ${column.type} AFTER ${column.after}`;
                    db.query(alterQuery, (err) => {
                        if (err) console.error(`Error adding column ${column.name}:`, err);
                        else console.log(`Column "${column.name}" added successfully.`);
                    });
                }
            });
        });
    }
});

// ============ AUTHENTICATION ENDPOINTS ============

// POST: Register new user
app.post('/api/auth/register', async (req, res) => {
    const { username, email, password } = req.body;

    if (!username || !email || !password) {
        return res.status(400).json({ error: 'All fields are required' });
    }

    try {
        // Hash password
        const password_hash = await bcrypt.hash(password, 10);

        const query = 'INSERT INTO users (username, email, password_hash, role) VALUES (?, ?, ?, ?)';
        const role = 'Salesperson';
        db.query(query, [username, email, password_hash, role], (err, result) => {
            if (err) {
                if (err.code === 'ER_DUP_ENTRY') {
                    return res.status(409).json({ error: 'Username or email already exists' });
                }
                return res.status(500).json({ error: err.message });
            }
            res.status(201).json({
                id: result.insertId,
                username,
                email,
                role,
                message: 'User registered successfully'
            });
        });
    } catch (error) {
        console.error('Registration Error:', error);
        res.status(500).json({ error: error.message });
    }
});

// POST: Login user
app.post('/api/auth/login', (req, res) => {
    const { username, password } = req.body;

    console.log(`[LOGIN ATTEMPT] Username: ${username}`);

    if (!username || !password) {
        console.log('[LOGIN ERROR] Missing username or password');
        return res.status(400).json({ error: 'Username and password are required' });
    }

    const query = 'SELECT * FROM users WHERE username = ?';
    db.query(query, [username], async (err, results) => {
        if (err) {
            console.error('[DATABASE ERROR] Login query failed:', err);
            return res.status(500).json({ error: 'Database error during login inspection', details: err.message });
        }

        if (results.length === 0) {
            console.log(`[LOGIN FAILED] User not found: ${username}`);
            return res.status(401).json({ error: 'Invalid username or password' });
        }

        const user = results[0];

        try {
            console.log(`[LOGIN] Verifying password for user: ${user.username} (ID: ${user.id})`);
            if (!user.password_hash) {
                console.error('[LOGIN CRITICAL] User has no password hash!');
                return res.status(500).json({ error: 'User data corrupted (no password hash)' });
            }

            const isMatch = await bcrypt.compare(password, user.password_hash);

            if (!isMatch) {
                console.log(`[LOGIN FAILED] Password mismatch for user: ${username}`);
                return res.status(401).json({ error: 'Invalid username or password' });
            }

            console.log(`[LOGIN SUCCESS] User authenticated: ${username}`);
            res.json({
                id: user.id,
                username: user.username,
                email: user.email,
                role: user.role,
                message: 'Login successful'
            });
        } catch (error) {
            console.error('[LOGIN EXCEPTION] Error during password comparison:', error);
            res.status(500).json({ error: 'Internal server error during authentication', details: error.message });
        }
    });
});

// ============ VISITOR ENDPOINTS ============

// GET: Fetch all visitors for approval list
app.get('/api/approvals', (req, res) => {
    const query = `
        SELECT 
            v.id, v.name, v.phone, v.email, v.organization, v.role, v.familiarity, 
            v.event, v.event_id, v.status, v.approval_status, v.selected_topic, 
            v.consent, v.created_at,
            COALESCE(v.assigned, e.salesperson_name) as assigned 
        FROM visitors v 
        LEFT JOIN events e ON v.event_id = e.id 
        WHERE v.approval_status = "Pending" 
        ORDER BY v.id DESC
    `;
    db.query(query, (err, results) => {
        if (err) return res.status(500).json({ error: err.message });
        console.log('Approvals fetched with assigned salesperson:', results.map(r => ({ id: r.id, name: r.name, assigned: r.assigned })));
        res.json(results);
    });
});

// POST: Register new visitor
app.post('/api/visitors', (req, res) => {
    console.log('--- NEW VISITOR REGISTRATION ---');
    console.log('Data received:', req.body);
    const { name, phone, email, organization, role, familiarity, event, eventId, status, assigned, selectedTopic, consent } = req.body;
    const query = 'INSERT INTO visitors (name, phone, email, organization, role, familiarity, event, event_id, status, assigned, selected_topic, consent) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)';
    db.query(query, [name, phone, email, organization, role, familiarity, event, eventId, status || 'Standard', assigned, selectedTopic, consent], (err, result) => {
        if (err) {
            console.error('DATABASE ERROR:', err);
            return res.status(500).json({ error: err.message });
        }
        console.log('Visitor registered with ID:', result.insertId);
        res.status(201).json({ id: result.insertId, message: 'Visitor registered' });
    });
});

// PUT: Update approval status
app.put('/api/approvals/:id', (req, res) => {
    const { id } = req.params;
    const { status, approval_status } = req.body;

    let query = 'UPDATE visitors SET ';
    const params = [];
    if (status) {
        query += 'status = ? ';
        params.push(status);
    }
    if (approval_status) {
        query += (status ? ', ' : '') + 'approval_status = ? ';
        params.push(approval_status);
    }
    query += 'WHERE id = ?';
    params.push(id);

    db.query(query, params, (err) => {
        if (err) return res.status(500).json({ error: err.message });
        res.json({ message: 'Status updated' });
    });
});

// ============ LEADS ENDPOINTS ============

// GET: Fetch all leads (approved visitors)
app.get('/api/leads', (req, res) => {
    const query = `
        SELECT 
            v.id, v.name, v.phone, v.email, v.organization, v.role, v.familiarity, 
            v.event, v.event_id, v.status, v.approval_status, v.selected_topic, 
            v.consent, v.created_at,
            COALESCE(v.assigned, e.salesperson_name) as assigned 
        FROM visitors v 
        LEFT JOIN events e ON v.event_id = e.id 
        WHERE v.approval_status = "Approved" 
        ORDER BY v.id DESC
    `;
    db.query(query, (err, results) => {
        if (err) return res.status(500).json({ error: err.message });
        console.log('Leads fetched with assigned salesperson:', results.map(r => ({ id: r.id, name: r.name, assigned: r.assigned })));
        res.json(results);
    });
});

// POST: Manually add new lead
app.post('/api/leads', (req, res) => {
    const { name, phone, email, organization, role, event, status, assigned } = req.body;
    const query = 'INSERT INTO visitors (name, phone, email, organization, role, event, status, approval_status, assigned) VALUES (?, ?, ?, ?, ?, ?, ?, "Approved", ?)';
    db.query(query, [name, phone, email, organization, role, event, status || 'Standard', assigned], (err, result) => {
        if (err) return res.status(500).json({ error: err.message });
        res.status(201).json({ id: result.insertId, message: 'Lead added successfully' });
    });
});

// PUT: Update existing lead
app.put('/api/leads/:id', (req, res) => {
    const { id } = req.params;
    const { name, phone, email, organization, role, event, status, assigned } = req.body;

    const query = 'UPDATE visitors SET name = ?, phone = ?, email = ?, organization = ?, role = ?, event = ?, status = ?, assigned = ? WHERE id = ?';
    db.query(query, [name, phone, email, organization, role, event, status, assigned, id], (err) => {
        if (err) return res.status(500).json({ error: err.message });
        res.json({ message: 'Lead updated successfully' });
    });
});

// DELETE: Delete lead (optional)
app.delete('/api/leads/:id', (req, res) => {
    const { id } = req.params;
    const query = 'DELETE FROM visitors WHERE id = ?';
    db.query(query, [id], (err) => {
        if (err) return res.status(500).json({ error: err.message });
        res.json({ message: 'Lead deleted successfully' });
    });
});

// ============ EVENTS ENDPOINTS ============

// GET: Fetch all events
app.get('/api/events', (req, res) => {
    const query = 'SELECT * FROM events ORDER BY created_at DESC';
    db.query(query, (err, results) => {
        if (err) return res.status(500).json({ error: err.message });

        // Parse JSON columns
        const parsedResults = results.map(row => ({
            ...row,
            companies: typeof row.companies === 'string' ? JSON.parse(row.companies) : row.companies,
            dates: typeof row.dates === 'string' ? JSON.parse(row.dates) : row.dates
        }));

        res.json(parsedResults);
    });
});

// POST: Save new event
app.post('/api/events', (req, res) => {
    const { salesperson, eventName, address, companies, dates } = req.body;

    if (!salesperson || !eventName || !address || !companies || !dates) {
        return res.status(400).json({ error: 'All fields are required' });
    }

    const query = 'INSERT INTO events (salesperson_name, event_name, address, companies, dates) VALUES (?, ?, ?, ?, ?)';
    db.query(query, [salesperson, eventName, address, JSON.stringify(companies), JSON.stringify(dates)], (err, result) => {
        if (err) return res.status(500).json({ error: err.message });
        res.status(201).json({ id: result.insertId, message: 'Event saved successfully' });
    });
});

const PORT = 5001;
app.listen(PORT, '0.0.0.0', () => {
    console.log(`Server running on port ${PORT}`);
});

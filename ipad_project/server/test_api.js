const fetch = require('node-fetch');

async function testApi() {
    try {
        const response = await fetch('http://localhost:5001/api/leads');
        const data = await response.json();
        console.log('--- API TEST RESULTS ---');
        data.forEach(lead => {
            console.log(`Lead: ${lead.name}, Event: ${lead.event}, Assigned: ${lead.assigned}`);
        });
    } catch (error) {
        console.error('API Test failed:', error.message);
    }
}

testApi();

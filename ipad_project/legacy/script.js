function showScreen(screenId) {
    console.log("Navigating to:", screenId);
    // Hide all screens
    document.querySelectorAll('.screen').forEach(s => s.classList.remove('active'));

    // Show target screen
    const target = document.getElementById(screenId);
    if (target) {
        target.classList.add('active');
    }
}

// Dropdown Logic
function toggleDropdown(id) {
    const list = document.getElementById(id);
    const isVisible = list.style.display === 'block';

    // Close other dropdowns if any
    document.querySelectorAll('.dropdown-list').forEach(d => d.style.display = 'none');

    list.style.display = isVisible ? 'none' : 'block';
}

function selectCompany(name) {
    const display = document.getElementById('selected-company');
    display.textContent = name;
    display.style.color = '#000'; // Change from placeholder color to black
    document.getElementById('company-list').style.display = 'none';
}

// Counter Logic
function updateCounter(inputId, delta) {
    const input = document.getElementById(inputId);
    let val = parseInt(input.value) || 1;
    val = Math.max(1, val + delta);
    input.value = val;

    if (inputId === 'company-count') generateCompanyFields();
    if (inputId === 'date-count') generateDateFields();
}

// Multi-Company Logic
function toggleMultiCompany() {
    const container = document.getElementById('additional-companies');
    const checkbox = document.getElementById('multi-company-checkbox');
    if (checkbox.checked) {
        container.classList.remove('hidden');
        generateCompanyFields();
    } else {
        container.classList.add('hidden');
    }
}

function generateCompanyFields() {
    const count = parseInt(document.getElementById('company-count').value) || 1;
    const list = document.getElementById('company-fields-list');
    list.innerHTML = '';

    for (let i = 0; i < count; i++) {
        const div = document.createElement('div');
        div.className = 'input-group';
        div.innerHTML = `
            <span class="required-star">*</span>
            <div class="custom-dropdown" onclick="toggleDropdown('company-list-${i}')">
                <span id="selected-company-${i}">COMPANY:</span>
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#851C1C" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="6 9 12 15 18 9"></polyline></svg>
            </div>
            <div id="company-list-${i}" class="dropdown-list">
                <div class="dropdown-item" onclick="selectSubCompany('${i}', 'SF Group of Companies, Inc.')">SF Group of Companies, Inc.</div>
                <div class="dropdown-item" onclick="selectSubCompany('${i}', 'Agridom Solutions Corp.')">Agridom Solutions Corp.</div>
                <div class="dropdown-item" onclick="selectSubCompany('${i}', 'Aerobot Distribution Inc.')">Aerobot Distribution Inc.</div>
                <div class="dropdown-item" onclick="selectSubCompany('${i}', 'DJAS Servitrade Corporation')">DJAS Servitrade Corporation</div>
                <div class="dropdown-item" onclick="selectSubCompany('${i}', 'Agridom Academy')">Agridom Academy</div>
                <div class="dropdown-item" onclick="selectSubCompany('${i}', 'Sunfood Marketing Inc.')">Sunfood Marketing Inc.</div>
                <div class="dropdown-item" onclick="selectSubCompany('${i}', 'Ardent Services Corporation')">Ardent Services Corporation</div>
            </div>
        `;
        list.appendChild(div);
    }
}

function selectSubCompany(index, name) {
    const display = document.getElementById(`selected-company-${index}`);
    display.textContent = name;
    display.style.color = '#000';
    document.getElementById(`company-list-${index}`).style.display = 'none';
}

// Long Event Logic
function toggleLongEvent() {
    const container = document.getElementById('long-event-controls');
    const checkbox = document.getElementById('long-event-checkbox');
    if (checkbox.checked) {
        container.classList.remove('hidden');
        generateDateFields();
    } else {
        container.classList.add('hidden');
        // Reset to only one date row
        const mainContainer = document.getElementById('date-time-container');
        const firstRow = mainContainer.firstElementChild;
        mainContainer.innerHTML = '';
        mainContainer.appendChild(firstRow);
        document.getElementById('date-count').value = 1;
    }
}

function generateDateFields() {
    const count = parseInt(document.getElementById('date-count').value) || 1;
    const container = document.getElementById('date-time-container');
    const firstRow = container.firstElementChild;
    container.innerHTML = '';
    container.appendChild(firstRow);

    for (let i = 1; i < count; i++) {
        const div = document.createElement('div');
        div.className = 'date-time-row';
        div.innerHTML = `
            <div class="input-group date-group">
                <span class="required-star">*</span>
                <input type="text" placeholder="DATE OF THE EVENT:" class="setup-input date-picker-input" readonly onclick="openDatePicker(this)">
            </div>
            <div class="input-group time-group">
                <span class="required-star">*</span>
                <div class="time-inputs">
                    <input type="text" placeholder="TIME STARTED" class="time-input" readonly onclick="openTimePicker(this)">
                    <div class="time-divider"></div>
                    <input type="text" placeholder="TIME ENDED" class="time-input" readonly onclick="openTimePicker(this)">
                </div>
            </div>
        `;
        container.appendChild(div);
    }
}



// Custom Date Picker Logic
let currentActiveInput = null;
let currentMonth = new Date().getMonth();
let currentYear = new Date().getFullYear();

function openDatePicker(input) {
    currentActiveInput = input;
    const rect = input.getBoundingClientRect();
    const picker = document.getElementById('calendar-picker');

    picker.style.top = (rect.bottom + 10) + 'px';
    picker.style.left = rect.left + 'px';
    picker.classList.remove('hidden');

    renderCalendar(currentMonth, currentYear);
}

function renderCalendar(month, year) {
    const monthNames = ["JANUARY", "FEBRUARY", "MARCH", "APRIL", "MAY", "JUNE", "JULY", "AUGUST", "SEPTEMBER", "OCTOBER", "NOVEMBER", "DECEMBER"];
    document.getElementById('current-month-year').textContent = `${monthNames[month]} ${year}`;

    const daysContainer = document.getElementById('calendar-days');
    daysContainer.innerHTML = '';

    const firstDay = new Date(year, month, 1).getDay();
    const daysInMonth = new Date(year, month + 1, 0).getDate();

    // Previous month filler
    const prevMonthDays = new Date(year, month, 0).getDate();
    for (let i = firstDay - 1; i >= 0; i--) {
        const div = document.createElement('div');
        div.className = 'cal-day prev-month';
        div.textContent = prevMonthDays - i;
        daysContainer.appendChild(div);
    }

    // Current month days
    const today = new Date();
    for (let i = 1; i <= daysInMonth; i++) {
        const div = document.createElement('div');
        div.className = 'cal-day';
        if (i === today.getDate() && month === today.getMonth() && year === today.getFullYear()) {
            div.classList.add('today');
        }
        div.textContent = i;
        div.onclick = () => selectDate(i, month, year);
        daysContainer.appendChild(div);
    }
}

function changeMonth(dir) {
    currentMonth += dir;
    if (currentMonth < 0) {
        currentMonth = 11;
        currentYear--;
    } else if (currentMonth > 11) {
        currentMonth = 0;
        currentYear++;
    }
    renderCalendar(currentMonth, currentYear);
}

function selectDate(day, month, year) {
    const formattedDate = `${new Intl.DateTimeFormat('en-US', { month: 'long' }).format(new Date(year, month, day))} ${day}, ${year}`;
    if (currentActiveInput) {
        currentActiveInput.value = formattedDate;
        currentActiveInput.style.color = '#333';
    }
    document.getElementById('calendar-picker').classList.add('hidden');
}

// Custom Time Picker Logic
function openTimePicker(input) {
    currentActiveInput = input;
    const rect = input.getBoundingClientRect();
    const picker = document.getElementById('time-picker');

    picker.style.top = (rect.bottom + 10) + 'px';
    picker.style.left = rect.left + 'px';
    picker.classList.remove('hidden');

    renderTimeList();
}

function renderTimeList() {
    const list = document.getElementById('time-list');
    list.innerHTML = '';

    for (let h = 8; h <= 20; h++) { // 8 AM to 8 PM
        for (let m = 0; m < 60; m += 15) {
            const period = h >= 12 ? 'PM' : 'AM';
            const displayH = h > 12 ? h - 12 : (h === 0 ? 12 : h);
            const timeStr = `${displayH}:${m === 0 ? '00' : m} ${period}`;

            const div = document.createElement('div');
            div.className = 'time-item';
            div.textContent = timeStr;
            div.onclick = () => selectTime(timeStr);
            list.appendChild(div);
        }
    }
}

function selectTime(time) {
    if (currentActiveInput) {
        currentActiveInput.value = time;
        currentActiveInput.style.color = '#333';
    }
    document.getElementById('time-picker').classList.add('hidden');
}




// Window Shopper Logic
function startEvent() {
    // 1. Get Salesperson Name (first input in setup form)
    console.log("Starting Window Shopper Flow");
    const inputs = document.querySelectorAll('.setup-input');
    const salespersonName = inputs[0].value.trim() || "JEK"; // Default to JEK if empty for testing

    // 2. Populate Landing Page
    const nameDisplay = document.getElementById('ws-salesperson-name');
    if (nameDisplay) {
        // Split name to get first name or use full name? Image shows "JEK" (First name/Nickname). 
        // Let's use the first word of the name.
        const firstName = salespersonName.split(' ')[0];
        nameDisplay.textContent = firstName;
    }

    // 3. Navigate to Landing Page
    showScreen('screen-ws-landing');
}

function nextWsScreen(nextScreenId) {
    if (nextScreenId) {
        showScreen(nextScreenId);
    }
}

// Keypad Logic
let currentPhoneNumber = "";

function keypadPress(key) {
    const display = document.getElementById('ws-phone-input');

    if (!display) return;

    if (currentPhoneNumber === "") {
        // Clear placeholder styling on first press
        display.classList.add('active');
        display.classList.remove('placeholder');
    }

    if (currentPhoneNumber.length < 11) { // Limit length
        currentPhoneNumber += key;
        // Format as we type? For now just raw numbers or simple spacing if needed
        // 0912 345 6789 format
        display.textContent = formatPhoneNumber(currentPhoneNumber);
    }
}

function formatPhoneNumber(num) {
    // Simple formatter
    // 09123456789 -> 0912 345 6789
    if (num.length > 4 && num.length <= 7) {
        return num.slice(0, 4) + " " + num.slice(4);
    } else if (num.length > 7) {
        return num.slice(0, 4) + " " + num.slice(4, 7) + " " + num.slice(7);
    }
    return num;
}

function nextWsScreen(nextScreenId) {
    // Simple navigation for now
    if (nextScreenId) {
        showScreen(nextScreenId);
    }
}

document.addEventListener('DOMContentLoaded', () => {
    console.log("Brandsync Prototype Initialized");

    // Close dropdowns/pickers when clicking outside
    window.addEventListener('click', (e) => {
        if (!e.target.closest('.custom-dropdown') && !e.target.closest('.date-picker-input') && !e.target.closest('.time-input') && !e.target.closest('.calendar-picker-modal') && !e.target.closest('.time-picker-modal')) {
            document.querySelectorAll('.dropdown-list').forEach(d => d.style.display = 'none');
            document.getElementById('calendar-picker').classList.add('hidden');
            document.getElementById('time-picker').classList.add('hidden');
        }
    });


});

// Saves options to chrome.storage
function saveOptions() {
    var url = document.getElementById('jira-url').value;
    if (url.slice(-1) == '/') {
        url = url.slice(0, -1);
    }
    var mergeEntriesBy = document.getElementById('merge-entries-by').value;
    var togglApiToken = document.getElementById('toggl-api-token').value;
    var jumpToToday = document.getElementById('jump-to-today').checked;
    var roundType = document.getElementById('round-type').value;
    var roundValue = document.getElementById('round-value').value;
    chrome.storage.sync.set({
        url: url,
        mergeEntriesBy: mergeEntriesBy,
        jumpToToday: jumpToToday,
        togglApiToken: togglApiToken,
        roundType: roundType,
        roundValue: roundValue,
    }, function () {
        // Update status to let user know options were saved.
        var status = document.getElementById('status');
        status.textContent = 'Options saved.';
        setTimeout(function () {
            status.textContent = '';
        }, 750);
    });
}

// Restores select box and checkbox state using the preferences
// stored in chrome.storage.
function restoreOptions() {
    // Use default values
    chrome.storage.sync.get({
        url: 'https://jira.atlassian.net',
        comment: 'Updated via toggl-to-jira https://chrome.google.com/webstore/detail/toggl-to-jira/anbbcnldaagfjlhbfddpjlndmjcgkdpf',
        mergeEntriesBy: 'no-merge',
        jumpToToday: false,
        togglApiToken: ' ',
        roundType: 'no-round',
        roundValue: 15,
    }, function (items) {
        document.getElementById('jira-url').value = items.url;
        document.getElementById('merge-entries-by').value = items.mergeEntriesBy;
        document.getElementById('toggl-api-token').value = items.togglApiToken;
        document.getElementById('jump-to-today').checked = items.jumpToToday;
        document.getElementById('round-type').value = items.roundType;
        document.getElementById('round-value').value = items.roundValue;
        if (items.roundType === 'no-round') {
            document.getElementById('round-val-section').style.display = 'none';
        } else {
            document.getElementById('round-val-section').style.display = 'inline';
        }
    });
}

document.addEventListener('DOMContentLoaded', () => {
    document.getElementById('save').addEventListener('click', () => {
        saveOptions();
        chrome.runtime.sendMessage({ action: 'reloadSettings' });
    });

    document.getElementById('round-type').addEventListener('change', (e) => {
        var section = document.getElementById('round-val-section');
        var label = document.getElementById('round-value-label');
        switch (e.target.value) {
            case 'no-round':
                section.style.display = 'none';
                label.innerText = '';
                break;
            case 'round-up':
                section.style.display = 'inline';
                label.innerText = 'Round duration to next x minutes. (15 will round to to the next quater => 16 will become 30 etc.)';
                break;
            case 'natural-round':
                section.style.display = 'inline';
                label.innerText = 'Round duration naturally to nearest x minutes. (15 will round to to the nearest quater => 16 will become 15 etc.)';
                break;
            case 'smart-round':
                section.style.display = 'inline';
                label.innerText = 'Target daily hours.';
                break;
            default:
                break;
        }
    })

    restoreOptions();
});
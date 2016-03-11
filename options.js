// Saves options to chrome.storage
function saveOptions() {
    var url = document.getElementById('jira-url').value;
    chrome.storage.sync.set({
        url: url
    }, function() {
        // Update status to let user know options were saved.
        var status = document.getElementById('status');
        status.textContent = 'Options saved.';
        setTimeout(function() {
            status.textContent = '';
        }, 750);
    });
}

// Restores select box and checkbox state using the preferences
// stored in chrome.storage.
function restoreOptions() {
    // Use default values
    chrome.storage.sync.get({
        url: 'https://jira.atlassian.net'
    }, function(items) {
        document.getElementById('jira-url').value = items.url;
    });
}

document.addEventListener('DOMContentLoaded', restoreOptions);
document.getElementById('save').addEventListener('click', saveOptions);

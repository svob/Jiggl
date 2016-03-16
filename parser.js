var jiraUrl = '';
var logs = [];

chrome.storage.sync.get({
    url: 'https://jira.atlassian.net'
}, function (items) {
    jiraUrl = items.url;
    console.log('Fetching toggl entries for today.', 'Jira url: ', jiraUrl);
});


String.prototype.toHHMMSS = function () {
    // don't forget the second param
    var secNum = parseInt(this, 10);
    var hours = Math.floor(secNum / 3600);
    var minutes = Math.floor((secNum - (hours * 3600)) / 60);
    var seconds = secNum - (hours * 3600) - (minutes * 60);

    if (hours < 10) {
        hours = '0' + hours;
    }
    if (minutes < 10) {
        minutes = '0' + minutes;
    }
    if (seconds < 10) {
        seconds = '0' + seconds;
    }
    var time = hours + 'h ' + minutes + 'm ' + seconds + 's';
    return time;
}

String.prototype.toHHMM = function () {
    // don't forget the second param
    var secNum = parseInt(this, 10);
    var hours = Math.floor(secNum / 3600);
    var minutes = Math.floor((secNum - (hours * 3600)) / 60);

    if (hours < 10) {
        hours = '0' + hours;
    }
    if (minutes < 10) {
        minutes = '0' + minutes;
    }

    var time = hours + 'h ' + minutes + 'm';
    return time;
}


$(document).ready(function () {

    $.ajaxSetup({
        contentType: 'application/json',
        headers: {
            'forgeme': 'true',
            'X-Atlassian-Token': 'nocheck',
            'Access-Control-Allow-Origin': '*'
        },
        xhrFields: {
            withCredentials: true
        }
    });


    document.getElementById('start-picker').valueAsDate = new Date();
    document.getElementById('end-picker').valueAsDate = new Date().valueOf() + (3600 * 24 * 1000);


    $('#scan-toggle').on('click', fetchEntries);
    $('#submit').on('click', submitEntries);

    fetchEntries();
});

function submitEntries() {

    logs.forEach(function (log) {
        if (!log.submit) {
            return;
        }

        $.post(jiraUrl + '/rest/api/latest/issue/' + log.issue + '/worklog', log.post, function success(response) {
            console.log('success', response);
            $('#result-' + log.id).text('OK').addClass('success');
            $('#input-' + log.id).removeAttr('checked');
        })
    });
}


function toggle() {
    var id = this.id.split('input-')[1];

    logs.forEach(function (log) {
        if (log.id === id) {
            log.submit = this.checked;
        }
    }.bind(this));
}

function fetchEntries() {
    var startDate = document.getElementById('start-picker').valueAsDate.toISOString();
    var endDate = document.getElementById('end-picker').valueAsDate.toISOString();

    var dateQuery = '?start_date=' + startDate + '&end_date=' + endDate;

    $.get('https://www.toggl.com/api/v8/time_entries' + dateQuery, function (entries) {
        console.log('entries', entries);
        logs = [];
        entries.reverse();

        var list = $('#toggle-entries');
        list.children().remove();


        entries.forEach(function (entry) {
            var issue = entry.description.split(' ')[0];
            var timeSpent = entry.duration > 0 ? entry.duration.toString().toHHMM() : 'still running...';

            var dateString = toJiraWhateverDateTime(entry.start);

            var newLog = {
                id: entry.id.toString(),
                issue: issue,
                submit: (entry.duration > 0),
                post: JSON.stringify({
                    timeSpent: timeSpent,
                    comment: 'Updated via toggl to jira',
                    started: dateString
                })
            };

            logs.push(newLog);


            list.append('<tr>');

            if(entry.duration > 0) {
                list.append('<td>' + '<input id="input-' + entry.id + '"  type="checkbox" checked/>' +
                '</td>');
            } else {
                list.append('<td></td>');
            }

            list.append('<td>' + issue + '</td>');
            list.append('<td>' + entry.description + '</td>');
            list.append('<td>' + timeSpent + '</td>');
            list.append('<td  id="result-' + entry.id + '"></td>');
            list.append('</tr>');

            if(entry.duration > 0) {
                $('#input-' + entry.id).on('click', toggle);
            }
        });
    });
}

function toJiraWhateverDateTime(date) {
    // TOGGL:           at: "2016-03-14T11:02:55+00:00"
    // JIRA:    "started": "2012-02-15T17:34:37.937-0600"

    // toggl time should look like jira time (otherwise 500 Server Error is raised)

    var parsedDate = Date.parse(date);
    var jiraDate = Date.now();

    if (parsedDate) {
        jiraDate = new Date(parsedDate);
    }

    var dateString = jiraDate.toISOString();

    // timezone is something fucked up with minus and in minutes
    // thatswhy divide it by -60 to get a positive value in numbers
    // example -60 -> +1 (to convert it to GMT+0100)
    var timeZone = jiraDate.getTimezoneOffset() / (-60);
    var absTimeZone = Math.abs(timeZone);
    var timeZoneString;
    var sign = timeZone > 0 ? '+' : '-';

    // take absolute because it can also be minus
    if (absTimeZone < 10) {
        timeZoneString = sign + '0' + absTimeZone + '00'
    } else {
        timeZoneString = sign + absTimeZone + '00'
    }

    dateString = dateString.replace('Z', timeZoneString);

    return dateString;
}

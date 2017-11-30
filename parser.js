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
String.prototype.toDDMM = function () {
    // don't forget the second param
    var monthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    d = new Date(this);
    return d.getDate() + "." + monthNames[d.getMonth()];
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

    var startString = localStorage.getItem('toggl-to-jira.last-date');
    var startDate = startString ? new Date(startString) : new Date();
    document.getElementById('start-picker').valueAsDate = startDate;
    
    var endString = localStorage.getItem('toggl-to-jira.last-end-date');
    var endDate = endString ? new Date(endString) : new Date(Date.now() + (3600 * 24 * 1000));
    document.getElementById('end-picker').valueAsDate = endDate;

    $('#start-picker').on('change', fetchEntries);
    $('#end-picker').on('change', fetchEntries);
    $('#submit').on('click', submitEntries);

    fetchEntries();
});

function submitEntries() {

    // log time for each jira ticket
    logs.forEach(function (log) {
        if (!log.submit) return;

        var body = JSON.stringify({
            timeSpent: log.timeSpent,
            comment: '',
            started: log.started
        });

        $.post(jiraUrl + '/rest/api/latest/issue/' + log.issue + '/worklog', body,
            function success(response) {
                console.log('success', response);
                $('#result-' + log.id).text('OK').addClass('success');
                $('#input-' + log.id).removeAttr('checked');
            }).fail(function error(error, message) {
                console.log(error, message);
                var e = error.responseText || JSON.stringify(error);
                console.log(e);
                $('p#error').text(e + "\n" + message).addClass('error');
            })
    });
}

// log entry checkbox toggled
function selectEntry() {
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
    localStorage.setItem('toggl-to-jira.last-date', startDate);
    localStorage.setItem('toggl-to-jira.last-end-date', endDate);
    $('p#error').text("").removeClass('error');

    var dateQuery = '?start_date=' + startDate + '&end_date=' + endDate;

    $.get('https://www.toggl.com/api/v8/time_entries' + dateQuery, function (entries) {
        console.log('entries', entries);
        logs = [];
        entries.reverse();

        entries.forEach(function (entry) {
            entry.description = entry.description || 'no-description';
            var issue = entry.description.split(' ')[0];
            var timeSpent = entry.duration;

            var dateString = toJiraWhateverDateTime(entry.start);

            var log;
            log = _.find(logs, function (log) {
                return log.issue === issue;
            });

            if (log) {
                log.timeSpentInt = log.timeSpentInt + timeSpent;
                log.timeSpent = log.timeSpentInt > 0 ? log.timeSpentInt.toString().toHHMM() : 'still running...';
            } else {
                log = {
                    id: entry.id.toString(),
                    issue: issue,
                    description: entry.description,
                    submit: (entry.duration > 0),
                    timeSpentInt: timeSpent,
                    timeSpent: timeSpent > 0 ? entry.duration.toString().toHHMM() : 'still running...',
                    comment: 'Updated via toggl to jira',
                    started: dateString
                };

                logs.push(log);
            }
        });

        renderList();
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

function renderList() {
    var list = $('#toggle-entries');
    list.children().remove();
    var total = 0;

    logs.forEach(function (log) {
        var dom = '<tr>';

        dom += log.timeSpentInt > 0 ?
            '<td>' + '<input id="input-' + log.id + '"  type="checkbox" checked/>' + '</td>'
            :
            '<td></td>';
        
        dom += '<td>' + log.issue + '</td>';
        dom += '<td>' + log.description + '</td>';
        dom += '<td>' + log.started.toDDMM() + '</td>';
        dom += '<td>' + log.timeSpent + '</td>';
        dom += '<td  id="result-' + log.id + '"></td>';
        dom += '</tr>';

        total += log.timeSpentInt;

        list.append(dom);

        if (log.timeSpentInt > 0) {
            $('#input-' + log.id).on('click', selectEntry);
        }
        
    })
    list.append('<tr><td></td><td></td><td></td><td><b>TOTAL</b></td><td>'  + total.toString().toHHMM() + '</td></tr>');

}

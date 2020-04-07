var logs = [];
var config = {};

var myEmailAddress = null;
var myDisplayName = null;

// String.prototype.limit = function (limit) {
//     return this.length > limit ? this.substr(0, limit) + '...' : this;
// }

// String.prototype.toHHMMSS = function () {
//     // don't forget the second param
//     var secNum = parseInt(this, 10);
//     var hours = Math.floor(secNum / 3600);
//     var minutes = Math.floor((secNum - (hours * 3600)) / 60);
//     var seconds = secNum - (hours * 3600) - (minutes * 60);

//     if (hours < 10) {
//         hours = '0' + hours;
//     }
//     if (minutes < 10) {
//         minutes = '0' + minutes;
//     }
//     if (seconds < 10) {
//         seconds = '0' + seconds;
//     }
//     var time = hours + 'h ' + minutes + 'm ' + seconds + 's';
//     return time;
// }

// String.prototype.toHHMM = function () {
//     // don't forget the second param
//     var secNum = parseInt(this, 10);
//     var hours = Math.floor(secNum / 3600);
//     var minutes = Math.floor((secNum - (hours * 3600)) / 60);

//     // set minimum as 1 minute
//     if (hours + minutes === 0) minutes = 1;

//     // pad zero
//     if (hours < 10) {
//         hours = '0' + hours;
//     }
//     // pad zero
//     if (minutes < 10) {
//         minutes = '0' + minutes;
//     }

//     var time = hours + 'h ' + minutes + 'm';
//     return time;
// }
// String.prototype.toHH_MM = function () {
//     // don't forget the second param
//     var secNum = parseInt(this, 10);
//     var hours = Math.floor(secNum / 3600);
//     var minutes = Math.floor((secNum - (hours * 3600)) / 60);

//     if (hours < 10) {
//         hours = '0' + hours;
//     }
//     if (minutes < 10) {
//         minutes = '0' + minutes;
//     }

//     var time = hours + ':' + minutes;
//     return time;
// }
// String.prototype.toDDMM = function () {
//     // don't forget the second param
//     var monthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
//     var d = new Date(this);
//     return monthNames[d.getMonth()] + ' ' + d.getDate();
//     // return d.getDate() + '.' + (d.getMonth() + 1) + '.';
// }

function createDateKey(date) {
    var concatZero = (value) => {
        if (value < 10) {
            return '0' + value;
        } else {
            return '' + value;
        }
    }

    var d = new Date(date);
    return '' + d.getFullYear() + concatZero(d.getMonth() + 1) + concatZero(d.getDate());
}

$(document).ready(function () {

    chrome.storage.sync.get({
        url: 'https://jira.atlassian.net',
        comment: 'Updated via toggl-to-jira https://chrome.google.com/webstore/detail/toggl-to-jira/anbbcnldaagfjlhbfddpjlndmjcgkdpf',
        mergeEntriesBy: 'no-merge',
        jumpToToday: false,
        roundValue: 0,
        roundType: 'no-round',
    }, function (items) {
        config = items;
        console.log('Fetching toggl entries for today.', 'Jira url: ', config.url, config);

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
        var startDate = config.jumpToToday || !startString ? new Date() : new Date(startString);
        document.getElementById('start-picker').valueAsDate = startDate;

        var endString = localStorage.getItem('toggl-to-jira.last-end-date');
        var endDate = config.jumpToToday || !endString ? new Date(Date.now() + (3600 * 24 * 1000)) : new Date(endString);
        document.getElementById('end-picker').valueAsDate = endDate;

        $('#start-picker').on('change', fetchEntries);
        $('#end-picker').on('change', fetchEntries);
        $('#submit').on('click', submitEntries);

        getMyData()
        fetchEntries();
    });
});



function getMyData() {
    $.get(config.url + '/rest/api/2/myself',
        function success(response) {
            myEmailAddress = response.emailAddress;
            myDisplayName = response.displayName;

            $('#myDisplayName').html(myDisplayName + ' (' + myEmailAddress + ')')
        });
}

function submitEntries() {

    // log time for each jira ticket
    var timeout = 500;
    logs.forEach(function (log) {
        if (!log.submit) return;
        $('#result-' + log.id).text('Pending...').addClass('info');
        setTimeout(() => {
            var body = JSON.stringify({
                timeSpent: log.timeSpent,
                comment: $("#comment-" + log.id).val() || '',
                started: log.started
            });

            $.post(config.url + '/rest/api/latest/issue/' + log.issue + '/worklog', body,
                function success(response) {
                    console.log('success', response);
                    $('#result-' + log.id).text('OK').addClass('success').removeClass('info');
                    $('#input-' + log.id).removeAttr('checked').attr('disabled', 'disabled');
                    $("#comment-" + log.id).attr('disabled', 'disabled');

                }).fail(function error(error, message) {
                    console.log(error, message);
                    var e = error.responseText || JSON.stringify(error);
                    console.log(e);
                    $('p#error').text(e + "\n" + message).addClass('error');
                })
        }, timeout);
        timeout += 500;
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
        logs = [];
        entries.reverse();

        entries.forEach(function (entry) {
            entry.description = entry.description || 'no-description';
            var issue = entry.description.split(' ')[0];
            var togglTime = entry.duration;

            var dateString = toJiraWhateverDateTime(entry.start);
            var dateKey = createDateKey(entry.start);

            var log = _.find(logs, function (log) {
                if (config.mergeEntriesBy === 'issue-and-date') {
                    return log.issue === issue && log.dateKey === dateKey;
                } else if (config.mergeEntriesBy === 'issue-and-date-and-desc') {
                    return log.issue === issue && log.dateKey === dateKey && log.description === entry.description;
                } else {
                    return log.issue === issue;
                }
            });

            // merge toggl entries by ticket ?
            if (log && config.mergeEntriesBy !== 'no-merge') {
                log.timeSpentInt = log.timeSpentInt + togglTime;
                log.timeSpent = log.timeSpentInt > 0 ? log.timeSpentInt.toString().toHHMM() : 'still running...';
            } else {
                log = {
                    id: entry.id.toString(),
                    issue: issue,
                    description: entry.description,
                    submit: (togglTime > 0),
                    timeSpentInt: togglTime,
                    timeSpent: togglTime > 0 ? togglTime.toString().toHHMM() : 'still running...',
                    comment: entry.description.substr(issue.length),
                    started: dateString,
                    dateKey: dateKey,
                };

                logs.push(log);
            }
        });

        if (config.roundType !== 'no-round') {
            var roundDelegate = (timeSpentInt) => {
                if (config.roundType === 'round-up') {
                    return roundUp(timeSpentInt, config.roundValue);
                } else {
                    return roundNatural(timeSpentInt, config.roundValue);
                }
            };
            logs.forEach((log) => {
                log.timeSpentInt = roundDelegate(log.timeSpentInt);
                log.timeSpent = log.timeSpentInt.toString().toHHMM();
            })
        }

        renderList();
    });
}

/**
* Round duration up to next `minutes`.
* No rounding will be applied if minutes is zero.
*
* @param initialDuration Initial duration in seconds.
* 
* Example: round to next quater:
*  roundUp(22, 15) = 30 // rounded to the next quarter
*  roundUp(35, 60) = 60 // round to full hour
*  roundUp(11, 0) = 11 // ignored rounding
*/
function roundUp(initialDuration, rounding_minutes) {
    var minutesDuration = initialDuration / 60
    if (minutesDuration == 0 || rounding_minutes == 0) {
        return initialDuration;
    } else {
        var roundedDuration = (Math.floor(minutesDuration / rounding_minutes) + 1) * rounding_minutes
        return roundedDuration * 60;
    }
}

/**
* Naturally round duration by rounding_minutes.
* No rounding will be applied if minutes is zero.
*
* @param initialDuration Initial duration in seconds.
*/
function roundNatural(initialDuration, rounding_minutes) {
    var minutesDuration = initialDuration / 60
    if (minutesDuration == 0 || rounding_minutes == 0) {
        return initialDuration;
    } else {
        var roundedDuration = ((minutesDuration + rounding_minutes / 2) / rounding_minutes | 0) * rounding_minutes;
        return roundedDuration * 60;
    }
}

function roundSmart() {
    logs.forEach((log) => {

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
    var totalTime = 0;

    logs.forEach(function (log) {
        var url = config.url + '/browse/' + log.issue;
        var dom = '<tr><td>';

        // checkbox
        if (log.timeSpentInt > 0) dom += '<input id="input-' + log.id + '"  type="checkbox" checked/>';

        dom += '</td>';

        // link to jira ticket
        dom += '<td><a href="' + url + '" target="_blank">' + log.issue + '</a></td>';

        dom += '<td>' + log.description.substr(log.issue.length).limit(35) + '</td>';
        dom += '<td>' + log.started.toDDMM() + '</td>';

        if (log.timeSpentInt > 0) {
            dom += '<td>' + log.timeSpentInt.toString().toHH_MM() + '</td>';
            dom += '<td><input id="comment-' + log.id + '" type="text" value="' + log.comment + '" /></td>';
            dom += '<td  id="result-' + log.id + '"></td>';
        } else {
            dom += '<td colspan="3" style="text-align:center;">still running...</td>';
        }
        dom += '</tr>';

        totalTime += (log.timeSpentInt > 0 && log.timeSpentInt) || 0;

        list.append(dom);

        if (log.timeSpentInt > 0) {
            $('#input-' + log.id).on('click', selectEntry);
        }

    })
    // total time for displayed tickets
    list.append('<tr><td></td><td></td><td></td><td><b>TOTAL</b></td><td>' + totalTime.toString().toHHMM() + '</td></tr>');

    // check if entry was already logged
    logs.forEach(function (log) {
        $.get(config.url + '/rest/api/latest/issue/' + log.issue + '/worklog',
            function success(response) {
                var worklogs = response.worklogs;
                worklogs.forEach(function (worklog) {
                    if (!!myEmailAddress && !!worklog.author && worklog.author.emailAddress !== myEmailAddress) { return; }

                    var diff = Math.floor(worklog.timeSpentSeconds / 60) - Math.floor(log.timeSpentInt / 60);
                    if (
                        // if date and month matches
                        worklog.started.toDDMM() === log.started.toDDMM() &&
                        // if duration is within 4 minutes because JIRA is rounding worklog minutes :facepalm:
                        diff < 4 && diff > -4
                    ) {
                        $('#result-' + log.id).text('OK').addClass('success').removeClass('info');
                        $('#input-' + log.id).removeAttr('checked').attr('disabled', 'disabled');
                        $("#comment-" + log.id).val(worklog.comment || '').attr('disabled', 'disabled');
                        log.submit = false;
                    }
                })
            });
    });

}

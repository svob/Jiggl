import 'dart:core';
import 'dart:html';
import 'package:chrome/chrome_ext.dart' as chrome;
import 'chrome_api.dart';

void main() async {
  _restoreOptions();
  querySelector('#save').onClick.listen((_) => _saveOptions());
  SelectElement roundType = querySelector('#round-type');
  roundType.onChange.listen(_onRoundChange);
}

/// Restores select box and checbox state using the preferences
/// stored in chrome.storage.
void _restoreOptions() {
  chrome.storage.sync.get({
    'url': 'https://jira.atlassian.net',
    'mergeEntriesBy': 'no-merge',
    'jumpToToday': false,
    'togglApiToken': '',
    'roundType': 'no-round',
    'roundValue': '15'
  })
  .then((settings) {
    (querySelector('#jira-url') as InputElement).value = settings['url'];
    (querySelector('#merge-entries-by') as SelectElement).value = settings['mergeEntriesBy'];
    (querySelector('#toggl-api-token') as InputElement).value = settings['togglApiToken'];
    (querySelector('#jump-to-today') as InputElement).checked = settings['jumpToToday'];
    (querySelector('#round-type') as SelectElement).value = settings['roundType'];
    (querySelector('#round-value') as InputElement).value = settings['roundValue'];
    querySelector('#round-val-section').style.display =
      (settings['roundType'] == 'no-round') ? 'none' : 'inline';
  });
}

/// Saves options to chrome.storage.
/// Also sends message to notify background script about changes.
void _saveOptions() {
  var url = (querySelector('#jira-url') as InputElement).value;
  if (url.endsWith('/')) {
    url = url.substring(0, url.length - 1);
  }
  chrome.storage.sync.set({
    'url': url,
    'mergeEntriesBy': (querySelector('#merge-entries-by') as SelectElement).value,
    'jumpToToday': (querySelector('#jump-to-today') as InputElement).checked,
    'togglApiToken': (querySelector('#toggl-api-token') as InputElement).value,
    'roundType': (querySelector('#round-type') as SelectElement).value,
    'roundValue': (querySelector('#round-value') as InputElement).value
  })
  .then((_) {
    var status = querySelector('#status')
      ..text = 'Options saved.';
    Future.delayed(const Duration(milliseconds: 750), () {
      status.text = '';
    });
    sendMessage(Message(action: "reloadSettings"));
  });
}

void _onRoundChange(Event e) {
  var section = querySelector('#round-val-section');
  var label = querySelector('#round-value-label');
  switch ((e.target as SelectElement).value) {
    case 'no-round':
      section.style.display = 'none';
      label.text = '';
      break;
    case 'round-up':
      section.style.display = 'inline';
      label.text = 'Round duration to next x minutes. (15 will round to to the next quater => 16 will become 30 etc.)';
      break;
    case 'natural-round':
      section.style.display = 'inline';
      label.text = 'Round duration naturally to nearest x minutes. (15 will round to to the nearest quater => 16 will become 15 etc.)';
      break;
    case 'smart-round':
      section.style.display = 'inline';
      label.text = 'Target daily hours.';
      break;
    default:
  }
}
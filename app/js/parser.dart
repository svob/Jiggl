import 'dart:convert';
import 'dart:html';

import 'extensions/string_extensions.dart';
import 'package:chrome/chrome_ext.dart' as chrome;

var settings;

void main() async {
  settings = await chrome.storage.sync.get({
    'url': 'https://jira.atlassian.net',
    'mergeEntriesBy': 'no-merge',
    'jumpToToday': false,
    'togglApiToken': '',
    'roundType': 'no-round',
    'roundValue': '15'
  });

  _getMyData();
}

// TODO: get this on options change and save to local storage
void _getMyData() async {
  var repsonse = await HttpRequest.request(
    settings['url'] + '/rest/api/2/myself',
    requestHeaders: {
      'X-Atlassian-Token': 'nocheck',
      'Access-Control-Allow-Origin': '*',
    },
  );
  if (repsonse.status == 200) {
    var j = json.decode(repsonse.responseText);
    print(j['emailAddress']);
  }
}
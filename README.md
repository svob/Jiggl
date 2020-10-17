# Jiggl - Jira & Toggl Tools
Jiggl is an extension for chrome browser that makes it easy to sync worklogs between Toggl and Jira - always for free.

Project is based on original [Toggl-to-jira](https://github.com/fyyyyy/Toggl-to-Jira-Chrome-Extension) extension.


##### Main features:
* Log Toggl time entries to Jira worklog.
* Automatic time round by user preferences.
* Support for multiple Jira servers.
* Start Toggl timer from Jira issue and merge request on Github, Gitlab, ... // TBD

**All contributors are welcome, see [Contributing section](#contributing).**


## Develop build
To build an extension, just run a gradle task
```
./gradlew assemble
```

### Load Extension to Chrome
* go to `chrome://extensions`
* enable Developer mode in the top right corner
* click load unpacked and select your build folder `$PROJECT_DIR/build/extension`

## Distribution build
To pack extension as zip archive run
```
./gradlew bundle
```

## Contributing
* Fell free to take any open [issue](https://github.com/svob/Jiggl/issues), ideally from upcoming milestone
* For new idea, please add new issue, so we can discuss it
##### Before sending PR
* Update changelog
* Make sure your changes are valid in develop build and doesn't break any tests
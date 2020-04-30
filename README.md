# Jiggl
Jira & Toggl Tools.

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
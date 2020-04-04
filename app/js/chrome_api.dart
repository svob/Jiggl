@JS()
library chrome_api;

import 'package:js/js.dart';

@JS()
@anonymous
class Message {
  external factory Message({ action });
  external String get action;
}

@JS('chrome.runtime.sendMessage')
external void sendMessage(Message message);
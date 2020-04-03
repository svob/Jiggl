/* This file has been generated - do not edit */

library chrome.input;

import '../src/common.dart';
import 'windows.dart';

final ChromeInput input = new ChromeInput._();

class ChromeInput {
  ChromeInput._();

  /**
   * Accessor for the `chrome.input.ime` namespace.
   */
  final ChromeInputIme ime = new ChromeInputIme._();
}

/**
 * Use the `chrome.input.ime` API to implement a custom IME for Chrome OS. This
 * allows your extension to handle keystrokes, set the composition, and manage
 * the candidate window.
 */
class ChromeInputIme extends ChromeApi {
  JsObject get _input_ime => chrome['input']['ime'];

  /**
   * This event is sent when an IME is activated. It signals that the IME will
   * be receiving onKeyPress events.
   */
  Stream<OnActivateEvent> get onActivate => _onActivate.stream;
  ChromeStreamController<OnActivateEvent> _onActivate;

  /**
   * This event is sent when an IME is deactivated. It signals that the IME will
   * no longer be receiving onKeyPress events.
   */
  Stream<String> get onDeactivated => _onDeactivated.stream;
  ChromeStreamController<String> _onDeactivated;

  /**
   * This event is sent when focus enters a text box. It is sent to all
   * extensions that are listening to this event, and enabled by the user.
   */
  Stream<InputContext> get onFocus => _onFocus.stream;
  ChromeStreamController<InputContext> _onFocus;

  /**
   * This event is sent when focus leaves a text box. It is sent to all
   * extensions that are listening to this event, and enabled by the user.
   */
  Stream<int> get onBlur => _onBlur.stream;
  ChromeStreamController<int> _onBlur;

  /**
   * This event is sent when the properties of the current InputContext change,
   * such as the the type. It is sent to all extensions that are listening to
   * this event, and enabled by the user.
   */
  Stream<InputContext> get onInputContextUpdate => _onInputContextUpdate.stream;
  ChromeStreamController<InputContext> _onInputContextUpdate;

  /**
   * Fired when a key event is sent from the operating system. The event will be
   * sent to the extension if this extension owns the active IME.
   */
  Stream<OnKeyEventEvent> get onKeyEvent => _onKeyEvent.stream;
  ChromeStreamController<OnKeyEventEvent> _onKeyEvent;

  /**
   * This event is sent if this extension owns the active IME.
   */
  Stream<OnCandidateClickedEvent> get onCandidateClicked => _onCandidateClicked.stream;
  ChromeStreamController<OnCandidateClickedEvent> _onCandidateClicked;

  /**
   * Called when the user selects a menu item
   */
  Stream<OnMenuItemActivatedEvent> get onMenuItemActivated => _onMenuItemActivated.stream;
  ChromeStreamController<OnMenuItemActivatedEvent> _onMenuItemActivated;

  /**
   * Called when the editable string around caret is changed or when the caret
   * position is moved. The text length is limited to 100 characters for each
   * back and forth direction.
   */
  Stream<OnSurroundingTextChangedEvent> get onSurroundingTextChanged => _onSurroundingTextChanged.stream;
  ChromeStreamController<OnSurroundingTextChangedEvent> _onSurroundingTextChanged;

  /**
   * This event is sent when chrome terminates ongoing text input session.
   */
  Stream<String> get onReset => _onReset.stream;
  ChromeStreamController<String> _onReset;

  /**
   * Triggered when the bounds of the IME composition text or cursor are
   * changed. The IME composition text is the instance of text produced in the
   * input method editor.
   */
  Stream<List<Bounds>> get onCompositionBoundsChanged => _onCompositionBoundsChanged.stream;
  ChromeStreamController<List<Bounds>> _onCompositionBoundsChanged;

  ChromeInputIme._() {
    var getApi = () => _input_ime;
    _onActivate = new ChromeStreamController<OnActivateEvent>.twoArgs(getApi, 'onActivate', _createOnActivateEvent);
    _onDeactivated = new ChromeStreamController<String>.oneArg(getApi, 'onDeactivated', selfConverter);
    _onFocus = new ChromeStreamController<InputContext>.oneArg(getApi, 'onFocus', _createInputContext);
    _onBlur = new ChromeStreamController<int>.oneArg(getApi, 'onBlur', selfConverter);
    _onInputContextUpdate = new ChromeStreamController<InputContext>.oneArg(getApi, 'onInputContextUpdate', _createInputContext);
    _onKeyEvent = new ChromeStreamController<OnKeyEventEvent>.twoArgs(getApi, 'onKeyEvent', _createOnKeyEventEvent);
    _onCandidateClicked = new ChromeStreamController<OnCandidateClickedEvent>.threeArgs(getApi, 'onCandidateClicked', _createOnCandidateClickedEvent);
    _onMenuItemActivated = new ChromeStreamController<OnMenuItemActivatedEvent>.twoArgs(getApi, 'onMenuItemActivated', _createOnMenuItemActivatedEvent);
    _onSurroundingTextChanged = new ChromeStreamController<OnSurroundingTextChangedEvent>.twoArgs(getApi, 'onSurroundingTextChanged', _createOnSurroundingTextChangedEvent);
    _onReset = new ChromeStreamController<String>.oneArg(getApi, 'onReset', selfConverter);
    _onCompositionBoundsChanged = new ChromeStreamController<List<Bounds>>.oneArg(getApi, 'onCompositionBoundsChanged', (e) => toList(e, _createBounds));
  }

  bool get available => _input_ime != null;

  /**
   * Set the current composition. If this extension does not own the active IME,
   * this fails.
   */
  Future<bool> setComposition(InputImeSetCompositionParams parameters) {
    if (_input_ime == null) _throwNotAvailable();

    var completer = new ChromeCompleter<bool>.oneArg();
    _input_ime.callMethod('setComposition', [toJS(parameters), completer.callback]);
    return completer.future;
  }

  /**
   * Clear the current composition. If this extension does not own the active
   * IME, this fails.
   */
  Future<bool> clearComposition(InputImeClearCompositionParams parameters) {
    if (_input_ime == null) _throwNotAvailable();

    var completer = new ChromeCompleter<bool>.oneArg();
    _input_ime.callMethod('clearComposition', [toJS(parameters), completer.callback]);
    return completer.future;
  }

  /**
   * Commits the provided text to the current input.
   */
  Future<bool> commitText(InputImeCommitTextParams parameters) {
    if (_input_ime == null) _throwNotAvailable();

    var completer = new ChromeCompleter<bool>.oneArg();
    _input_ime.callMethod('commitText', [toJS(parameters), completer.callback]);
    return completer.future;
  }

  /**
   * Sends the key events.  This function is expected to be used by virtual
   * keyboards.  When key(s) on a virtual keyboard is pressed by a user, this
   * function is used to propagate that event to the system.
   */
  Future sendKeyEvents(InputImeSendKeyEventsParams parameters) {
    if (_input_ime == null) _throwNotAvailable();

    var completer = new ChromeCompleter.noArgs();
    _input_ime.callMethod('sendKeyEvents', [toJS(parameters), completer.callback]);
    return completer.future;
  }

  /**
   * Hides the input view window, which is popped up automatically by system. If
   * the input view window is already hidden, this function will do nothing.
   */
  void hideInputView() {
    if (_input_ime == null) _throwNotAvailable();

    _input_ime.callMethod('hideInputView');
  }

  /**
   * Sets the properties of the candidate window. This fails if the extension
   * doesn't own the active IME
   */
  Future<bool> setCandidateWindowProperties(InputImeSetCandidateWindowPropertiesParams parameters) {
    if (_input_ime == null) _throwNotAvailable();

    var completer = new ChromeCompleter<bool>.oneArg();
    _input_ime.callMethod('setCandidateWindowProperties', [toJS(parameters), completer.callback]);
    return completer.future;
  }

  /**
   * Sets the current candidate list. This fails if this extension doesn't own
   * the active IME
   */
  Future<bool> setCandidates(InputImeSetCandidatesParams parameters) {
    if (_input_ime == null) _throwNotAvailable();

    var completer = new ChromeCompleter<bool>.oneArg();
    _input_ime.callMethod('setCandidates', [toJS(parameters), completer.callback]);
    return completer.future;
  }

  /**
   * Set the position of the cursor in the candidate window. This is a no-op if
   * this extension does not own the active IME.
   */
  Future<bool> setCursorPosition(InputImeSetCursorPositionParams parameters) {
    if (_input_ime == null) _throwNotAvailable();

    var completer = new ChromeCompleter<bool>.oneArg();
    _input_ime.callMethod('setCursorPosition', [toJS(parameters), completer.callback]);
    return completer.future;
  }

  /**
   * Adds the provided menu items to the language menu when this IME is active.
   */
  Future setMenuItems(InputImeSetMenuItemsParams parameters) {
    if (_input_ime == null) _throwNotAvailable();

    var completer = new ChromeCompleter.noArgs();
    _input_ime.callMethod('setMenuItems', [toJS(parameters), completer.callback]);
    return completer.future;
  }

  /**
   * Updates the state of the MenuItems specified
   */
  Future updateMenuItems(InputImeUpdateMenuItemsParams parameters) {
    if (_input_ime == null) _throwNotAvailable();

    var completer = new ChromeCompleter.noArgs();
    _input_ime.callMethod('updateMenuItems', [toJS(parameters), completer.callback]);
    return completer.future;
  }

  /**
   * Deletes the text around the caret.
   */
  Future deleteSurroundingText(InputImeDeleteSurroundingTextParams parameters) {
    if (_input_ime == null) _throwNotAvailable();

    var completer = new ChromeCompleter.noArgs();
    _input_ime.callMethod('deleteSurroundingText', [toJS(parameters), completer.callback]);
    return completer.future;
  }

  /**
   * Indicates that the key event received by onKeyEvent is handled.  This
   * should only be called if the onKeyEvent listener is asynchronous.
   * 
   * [requestId] Request id of the event that was handled.  This should come
   * from keyEvent.requestId
   * 
   * [response] True if the keystroke was handled, false if not
   */
  void keyEventHandled(String requestId, bool response) {
    if (_input_ime == null) _throwNotAvailable();

    _input_ime.callMethod('keyEventHandled', [requestId, response]);
  }

  /**
   * Creates IME window.
   * 
   * [options] The options of the newly created IME window.
   * 
   * Returns:
   * The JavaScript 'window' object of the newly created IME window. It contains
   * the additional 'id' property for the parameters of the other functions like
   * showWindow/hideWindow.
   */
  Future<Window> createWindow(CreateWindowOptions options) {
    if (_input_ime == null) _throwNotAvailable();

    var completer = new ChromeCompleter<Window>.oneArg(_createWindow);
    _input_ime.callMethod('createWindow', [toJS(options), completer.callback]);
    return completer.future;
  }

  /**
   * Shows the IME window. This makes the hidden window visible.
   * 
   * [windowId] The ID of the IME window.
   */
  Future showWindow(int windowId) {
    if (_input_ime == null) _throwNotAvailable();

    var completer = new ChromeCompleter.noArgs();
    _input_ime.callMethod('showWindow', [windowId, completer.callback]);
    return completer.future;
  }

  /**
   * Hides the IME window. This doesn't close the window. Instead, it makes the
   * window invisible. The extension can cache the window and show/hide it for
   * better performance.
   * 
   * [windowId] The ID of the IME window.
   */
  Future hideWindow(int windowId) {
    if (_input_ime == null) _throwNotAvailable();

    var completer = new ChromeCompleter.noArgs();
    _input_ime.callMethod('hideWindow', [windowId, completer.callback]);
    return completer.future;
  }

  /**
   * Activates the IME extension so that it can receive events.
   */
  Future activate() {
    if (_input_ime == null) _throwNotAvailable();

    var completer = new ChromeCompleter.noArgs();
    _input_ime.callMethod('activate', [completer.callback]);
    return completer.future;
  }

  /**
   * Deactivates the IME extension so that it cannot receive events.
   */
  Future deactivate() {
    if (_input_ime == null) _throwNotAvailable();

    var completer = new ChromeCompleter.noArgs();
    _input_ime.callMethod('deactivate', [completer.callback]);
    return completer.future;
  }

  void _throwNotAvailable() {
    throw new UnsupportedError("'chrome.input.ime' is not available");
  }
}

/**
 * This event is sent when an IME is activated. It signals that the IME will be
 * receiving onKeyPress events.
 */
class OnActivateEvent {
  /**
   * ID of the engine receiving the event
   */
  final String engineID;

  /**
   * The screen type under which the IME is activated.
   */
  final ScreenType screen;

  OnActivateEvent(this.engineID, this.screen);
}

/**
 * Fired when a key event is sent from the operating system. The event will be
 * sent to the extension if this extension owns the active IME.
 */
class OnKeyEventEvent {
  /**
   * ID of the engine receiving the event
   */
  final String engineID;

  /**
   * Data on the key event
   */
  final KeyboardEvent keyData;

  OnKeyEventEvent(this.engineID, this.keyData);
}

/**
 * This event is sent if this extension owns the active IME.
 */
class OnCandidateClickedEvent {
  /**
   * ID of the engine receiving the event
   */
  final String engineID;

  /**
   * ID of the candidate that was clicked.
   */
  final int candidateID;

  /**
   * Which mouse buttons was clicked.
   */
  final MouseButton button;

  OnCandidateClickedEvent(this.engineID, this.candidateID, this.button);
}

/**
 * Called when the user selects a menu item
 */
class OnMenuItemActivatedEvent {
  /**
   * ID of the engine receiving the event
   */
  final String engineID;

  /**
   * Name of the MenuItem which was activated
   */
  final String name;

  OnMenuItemActivatedEvent(this.engineID, this.name);
}

/**
 * Called when the editable string around caret is changed or when the caret
 * position is moved. The text length is limited to 100 characters for each back
 * and forth direction.
 */
class OnSurroundingTextChangedEvent {
  /**
   * ID of the engine receiving the event
   */
  final String engineID;

  /**
   * The surrounding information.
   */
  final Map surroundingInfo;

  OnSurroundingTextChangedEvent(this.engineID, this.surroundingInfo);
}

class KeyboardEventType extends ChromeEnum {
  static const KeyboardEventType KEYUP = const KeyboardEventType._('keyup');
  static const KeyboardEventType KEYDOWN = const KeyboardEventType._('keydown');

  static const List<KeyboardEventType> VALUES = const[KEYUP, KEYDOWN];

  const KeyboardEventType._(String str): super(str);
}

/**
 * Type of value this text field edits, (Text, Number, URL, etc)
 */
class InputContextType extends ChromeEnum {
  static const InputContextType TEXT = const InputContextType._('text');
  static const InputContextType SEARCH = const InputContextType._('search');
  static const InputContextType TEL = const InputContextType._('tel');
  static const InputContextType URL = const InputContextType._('url');
  static const InputContextType EMAIL = const InputContextType._('email');
  static const InputContextType NUMBER = const InputContextType._('number');
  static const InputContextType PASSWORD = const InputContextType._('password');

  static const List<InputContextType> VALUES = const[TEXT, SEARCH, TEL, URL, EMAIL, NUMBER, PASSWORD];

  const InputContextType._(String str): super(str);
}

/**
 * The type of menu item. Radio buttons between separators are considered
 * grouped.
 */
class MenuItemStyle extends ChromeEnum {
  static const MenuItemStyle CHECK = const MenuItemStyle._('check');
  static const MenuItemStyle RADIO = const MenuItemStyle._('radio');
  static const MenuItemStyle SEPARATOR = const MenuItemStyle._('separator');

  static const List<MenuItemStyle> VALUES = const[CHECK, RADIO, SEPARATOR];

  const MenuItemStyle._(String str): super(str);
}

/**
 * The type of the underline to modify this segment.
 */
class UnderlineStyle extends ChromeEnum {
  static const UnderlineStyle UNDERLINE = const UnderlineStyle._('underline');
  static const UnderlineStyle DOUBLE_UNDERLINE = const UnderlineStyle._('doubleUnderline');
  static const UnderlineStyle NO_UNDERLINE = const UnderlineStyle._('noUnderline');

  static const List<UnderlineStyle> VALUES = const[UNDERLINE, DOUBLE_UNDERLINE, NO_UNDERLINE];

  const UnderlineStyle._(String str): super(str);
}

/**
 * Where to display the candidate window. If set to 'cursor', the window follows
 * the cursor. If set to 'composition', the window is locked to the beginning of
 * the composition.
 */
class WindowPosition extends ChromeEnum {
  static const WindowPosition CURSOR = const WindowPosition._('cursor');
  static const WindowPosition COMPOSITION = const WindowPosition._('composition');

  static const List<WindowPosition> VALUES = const[CURSOR, COMPOSITION];

  const WindowPosition._(String str): super(str);
}

/**
 * The screen type under which the IME is activated.
 */
class ScreenType extends ChromeEnum {
  static const ScreenType NORMAL = const ScreenType._('normal');
  static const ScreenType LOGIN = const ScreenType._('login');
  static const ScreenType LOCK = const ScreenType._('lock');
  static const ScreenType SECONDARY_LOGIN = const ScreenType._('secondary-login');

  static const List<ScreenType> VALUES = const[NORMAL, LOGIN, LOCK, SECONDARY_LOGIN];

  const ScreenType._(String str): super(str);
}

class CallbackStyle extends ChromeEnum {
  static const CallbackStyle ASYNC = const CallbackStyle._('async');

  static const List<CallbackStyle> VALUES = const[ASYNC];

  const CallbackStyle._(String str): super(str);
}

/**
 * Which mouse buttons was clicked.
 */
class MouseButton extends ChromeEnum {
  static const MouseButton LEFT = const MouseButton._('left');
  static const MouseButton MIDDLE = const MouseButton._('middle');
  static const MouseButton RIGHT = const MouseButton._('right');

  static const List<MouseButton> VALUES = const[LEFT, MIDDLE, RIGHT];

  const MouseButton._(String str): super(str);
}

/**
 * The IME window types.
 */
class InputWindowType extends ChromeEnum {
  static const InputWindowType NORMAL = const InputWindowType._('normal');
  static const InputWindowType FOLLOW_CURSOR = const InputWindowType._('followCursor');

  static const List<InputWindowType> VALUES = const[NORMAL, FOLLOW_CURSOR];

  const InputWindowType._(String str): super(str);
}

class PropertiesInputIme extends ChromeObject {
  PropertiesInputIme({bool visible, bool cursorVisible, bool vertical, int pageSize, String auxiliaryText, bool auxiliaryTextVisible, WindowPosition windowPosition}) {
    if (visible != null) this.visible = visible;
    if (cursorVisible != null) this.cursorVisible = cursorVisible;
    if (vertical != null) this.vertical = vertical;
    if (pageSize != null) this.pageSize = pageSize;
    if (auxiliaryText != null) this.auxiliaryText = auxiliaryText;
    if (auxiliaryTextVisible != null) this.auxiliaryTextVisible = auxiliaryTextVisible;
    if (windowPosition != null) this.windowPosition = windowPosition;
  }
  PropertiesInputIme.fromProxy(JsObject jsProxy): super.fromProxy(jsProxy);

  /**
   * True to show the Candidate window, false to hide it.
   */
  bool get visible => jsProxy['visible'];
  set visible(bool value) => jsProxy['visible'] = value;

  /**
   * True to show the cursor, false to hide it.
   */
  bool get cursorVisible => jsProxy['cursorVisible'];
  set cursorVisible(bool value) => jsProxy['cursorVisible'] = value;

  /**
   * True if the candidate window should be rendered vertical, false to make it
   * horizontal.
   */
  bool get vertical => jsProxy['vertical'];
  set vertical(bool value) => jsProxy['vertical'] = value;

  /**
   * The number of candidates to display per page.
   */
  int get pageSize => jsProxy['pageSize'];
  set pageSize(int value) => jsProxy['pageSize'] = value;

  /**
   * Text that is shown at the bottom of the candidate window.
   */
  String get auxiliaryText => jsProxy['auxiliaryText'];
  set auxiliaryText(String value) => jsProxy['auxiliaryText'] = value;

  /**
   * True to display the auxiliary text, false to hide it.
   */
  bool get auxiliaryTextVisible => jsProxy['auxiliaryTextVisible'];
  set auxiliaryTextVisible(bool value) => jsProxy['auxiliaryTextVisible'] = value;

  /**
   * Where to display the candidate window.
   */
  WindowPosition get windowPosition => _createWindowPosition(jsProxy['windowPosition']);
  set windowPosition(WindowPosition value) => jsProxy['windowPosition'] = toJS(value);
}

class UsageInputIme extends ChromeObject {
  UsageInputIme({String title, String body}) {
    if (title != null) this.title = title;
    if (body != null) this.body = body;
  }
  UsageInputIme.fromProxy(JsObject jsProxy): super.fromProxy(jsProxy);

  /**
   * The title string of details description.
   */
  String get title => jsProxy['title'];
  set title(String value) => jsProxy['title'] = value;

  /**
   * The body string of detail description.
   */
  String get body => jsProxy['body'];
  set body(String value) => jsProxy['body'] = value;
}

/**
 * See http://www.w3.org/TR/DOM-Level-3-Events/#events-KeyboardEvent
 */
class KeyboardEvent extends ChromeObject {
  KeyboardEvent({KeyboardEventType type, String requestId, String extensionId, String key, String code, int keyCode, bool altKey, bool ctrlKey, bool shiftKey, bool capsLock}) {
    if (type != null) this.type = type;
    if (requestId != null) this.requestId = requestId;
    if (extensionId != null) this.extensionId = extensionId;
    if (key != null) this.key = key;
    if (code != null) this.code = code;
    if (keyCode != null) this.keyCode = keyCode;
    if (altKey != null) this.altKey = altKey;
    if (ctrlKey != null) this.ctrlKey = ctrlKey;
    if (shiftKey != null) this.shiftKey = shiftKey;
    if (capsLock != null) this.capsLock = capsLock;
  }
  KeyboardEvent.fromProxy(JsObject jsProxy): super.fromProxy(jsProxy);

  /**
   * One of keyup or keydown.
   */
  KeyboardEventType get type => _createKeyboardEventType(jsProxy['type']);
  set type(KeyboardEventType value) => jsProxy['type'] = toJS(value);

  /**
   * The ID of the request.
   */
  String get requestId => jsProxy['requestId'];
  set requestId(String value) => jsProxy['requestId'] = value;

  /**
   * The extension ID of the sender of this keyevent.
   */
  String get extensionId => jsProxy['extensionId'];
  set extensionId(String value) => jsProxy['extensionId'] = value;

  /**
   * Value of the key being pressed
   */
  String get key => jsProxy['key'];
  set key(String value) => jsProxy['key'] = value;

  /**
   * Value of the physical key being pressed. The value is not affected by
   * current keyboard layout or modifier state.
   */
  String get code => jsProxy['code'];
  set code(String value) => jsProxy['code'] = value;

  /**
   * The deprecated HTML keyCode, which is system- and implementation-dependent
   * numerical code signifying the unmodified identifier associated with the key
   * pressed.
   */
  int get keyCode => jsProxy['keyCode'];
  set keyCode(int value) => jsProxy['keyCode'] = value;

  /**
   * Whether or not the ALT key is pressed.
   */
  bool get altKey => jsProxy['altKey'];
  set altKey(bool value) => jsProxy['altKey'] = value;

  /**
   * Whether or not the CTRL key is pressed.
   */
  bool get ctrlKey => jsProxy['ctrlKey'];
  set ctrlKey(bool value) => jsProxy['ctrlKey'] = value;

  /**
   * Whether or not the SHIFT key is pressed.
   */
  bool get shiftKey => jsProxy['shiftKey'];
  set shiftKey(bool value) => jsProxy['shiftKey'] = value;

  /**
   * Whether or not the CAPS_LOCK is enabled.
   */
  bool get capsLock => jsProxy['capsLock'];
  set capsLock(bool value) => jsProxy['capsLock'] = value;
}

/**
 * Describes an input Context
 */
class InputContext extends ChromeObject {
  InputContext({int contextID, InputContextType type, bool autoCorrect, bool autoComplete, bool spellCheck}) {
    if (contextID != null) this.contextID = contextID;
    if (type != null) this.type = type;
    if (autoCorrect != null) this.autoCorrect = autoCorrect;
    if (autoComplete != null) this.autoComplete = autoComplete;
    if (spellCheck != null) this.spellCheck = spellCheck;
  }
  InputContext.fromProxy(JsObject jsProxy): super.fromProxy(jsProxy);

  /**
   * This is used to specify targets of text field operations.  This ID becomes
   * invalid as soon as onBlur is called.
   */
  int get contextID => jsProxy['contextID'];
  set contextID(int value) => jsProxy['contextID'] = value;

  /**
   * Type of value this text field edits, (Text, Number, URL, etc)
   */
  InputContextType get type => _createInputContextType(jsProxy['type']);
  set type(InputContextType value) => jsProxy['type'] = toJS(value);

  /**
   * Whether the text field wants auto-correct.
   */
  bool get autoCorrect => jsProxy['autoCorrect'];
  set autoCorrect(bool value) => jsProxy['autoCorrect'] = value;

  /**
   * Whether the text field wants auto-complete.
   */
  bool get autoComplete => jsProxy['autoComplete'];
  set autoComplete(bool value) => jsProxy['autoComplete'] = value;

  /**
   * Whether the text field wants spell-check.
   */
  bool get spellCheck => jsProxy['spellCheck'];
  set spellCheck(bool value) => jsProxy['spellCheck'] = value;
}

/**
 * A menu item used by an input method to interact with the user from the
 * language menu.
 */
class MenuItem extends ChromeObject {
  MenuItem({String id, String label, MenuItemStyle style, bool visible, bool checked, bool enabled}) {
    if (id != null) this.id = id;
    if (label != null) this.label = label;
    if (style != null) this.style = style;
    if (visible != null) this.visible = visible;
    if (checked != null) this.checked = checked;
    if (enabled != null) this.enabled = enabled;
  }
  MenuItem.fromProxy(JsObject jsProxy): super.fromProxy(jsProxy);

  /**
   * String that will be passed to callbacks referencing this MenuItem.
   */
  String get id => jsProxy['id'];
  set id(String value) => jsProxy['id'] = value;

  /**
   * Text displayed in the menu for this item.
   */
  String get label => jsProxy['label'];
  set label(String value) => jsProxy['label'] = value;

  /**
   * The type of menu item.
   */
  MenuItemStyle get style => _createMenuItemStyle(jsProxy['style']);
  set style(MenuItemStyle value) => jsProxy['style'] = toJS(value);

  /**
   * Indicates this item is visible.
   */
  bool get visible => jsProxy['visible'];
  set visible(bool value) => jsProxy['visible'] = value;

  /**
   * Indicates this item should be drawn with a check.
   */
  bool get checked => jsProxy['checked'];
  set checked(bool value) => jsProxy['checked'] = value;

  /**
   * Indicates this item is enabled.
   */
  bool get enabled => jsProxy['enabled'];
  set enabled(bool value) => jsProxy['enabled'] = value;
}

/**
 * The options to create an IME window
 */
class CreateWindowOptions extends ChromeObject {
  CreateWindowOptions({InputWindowType windowType, String url, Bounds bounds}) {
    if (windowType != null) this.windowType = windowType;
    if (url != null) this.url = url;
    if (bounds != null) this.bounds = bounds;
  }
  CreateWindowOptions.fromProxy(JsObject jsProxy): super.fromProxy(jsProxy);

  InputWindowType get windowType => _createWindowType(jsProxy['windowType']);
  set windowType(InputWindowType value) => jsProxy['windowType'] = toJS(value);

  String get url => jsProxy['url'];
  set url(String value) => jsProxy['url'] = value;

  Bounds get bounds => _createBounds(jsProxy['bounds']);
  set bounds(Bounds value) => jsProxy['bounds'] = toJS(value);
}

class InputImeSetCompositionParams extends ChromeObject {
  InputImeSetCompositionParams({int contextID, String text, int selectionStart, int selectionEnd, int cursor, List<Map> segments}) {
    if (contextID != null) this.contextID = contextID;
    if (text != null) this.text = text;
    if (selectionStart != null) this.selectionStart = selectionStart;
    if (selectionEnd != null) this.selectionEnd = selectionEnd;
    if (cursor != null) this.cursor = cursor;
    if (segments != null) this.segments = segments;
  }
  InputImeSetCompositionParams.fromProxy(JsObject jsProxy): super.fromProxy(jsProxy);

  /**
   * ID of the context where the composition text will be set
   */
  int get contextID => jsProxy['contextID'];
  set contextID(int value) => jsProxy['contextID'] = value;

  /**
   * Text to set
   */
  String get text => jsProxy['text'];
  set text(String value) => jsProxy['text'] = value;

  /**
   * Position in the text that the selection starts at.
   */
  int get selectionStart => jsProxy['selectionStart'];
  set selectionStart(int value) => jsProxy['selectionStart'] = value;

  /**
   * Position in the text that the selection ends at.
   */
  int get selectionEnd => jsProxy['selectionEnd'];
  set selectionEnd(int value) => jsProxy['selectionEnd'] = value;

  /**
   * Position in the text of the cursor.
   */
  int get cursor => jsProxy['cursor'];
  set cursor(int value) => jsProxy['cursor'] = value;

  /**
   * List of segments and their associated types.
   */
  List<Map> get segments => toList(jsProxy['segments'], toMap);
  set segments(List<Map> value) => jsProxy['segments'] = toJS(value);
}

class InputImeClearCompositionParams extends ChromeObject {
  InputImeClearCompositionParams({int contextID}) {
    if (contextID != null) this.contextID = contextID;
  }
  InputImeClearCompositionParams.fromProxy(JsObject jsProxy): super.fromProxy(jsProxy);

  /**
   * ID of the context where the composition will be cleared
   */
  int get contextID => jsProxy['contextID'];
  set contextID(int value) => jsProxy['contextID'] = value;
}

class InputImeCommitTextParams extends ChromeObject {
  InputImeCommitTextParams({int contextID, String text}) {
    if (contextID != null) this.contextID = contextID;
    if (text != null) this.text = text;
  }
  InputImeCommitTextParams.fromProxy(JsObject jsProxy): super.fromProxy(jsProxy);

  /**
   * ID of the context where the text will be committed
   */
  int get contextID => jsProxy['contextID'];
  set contextID(int value) => jsProxy['contextID'] = value;

  /**
   * The text to commit
   */
  String get text => jsProxy['text'];
  set text(String value) => jsProxy['text'] = value;
}

class InputImeSendKeyEventsParams extends ChromeObject {
  InputImeSendKeyEventsParams({int contextID, List<KeyboardEvent> keyData}) {
    if (contextID != null) this.contextID = contextID;
    if (keyData != null) this.keyData = keyData;
  }
  InputImeSendKeyEventsParams.fromProxy(JsObject jsProxy): super.fromProxy(jsProxy);

  /**
   * ID of the context where the key events will be sent, or zero to send key
   * events to non-input field.
   */
  int get contextID => jsProxy['contextID'];
  set contextID(int value) => jsProxy['contextID'] = value;

  /**
   * Data on the key event.
   */
  List<KeyboardEvent> get keyData => toList(jsProxy['keyData'], _createKeyboardEvent);
  set keyData(List<KeyboardEvent> value) => jsProxy['keyData'] = toJS(value);
}

class InputImeSetCandidateWindowPropertiesParams extends ChromeObject {
  InputImeSetCandidateWindowPropertiesParams({String engineID, PropertiesInputIme properties}) {
    if (engineID != null) this.engineID = engineID;
    if (properties != null) this.properties = properties;
  }
  InputImeSetCandidateWindowPropertiesParams.fromProxy(JsObject jsProxy): super.fromProxy(jsProxy);

  /**
   * ID of the engine to set properties on.
   */
  String get engineID => jsProxy['engineID'];
  set engineID(String value) => jsProxy['engineID'] = value;

  PropertiesInputIme get properties => _createPropertiesInputIme(jsProxy['properties']);
  set properties(PropertiesInputIme value) => jsProxy['properties'] = toJS(value);
}

class InputImeSetCandidatesParams extends ChromeObject {
  InputImeSetCandidatesParams({int contextID, List<Map> candidates}) {
    if (contextID != null) this.contextID = contextID;
    if (candidates != null) this.candidates = candidates;
  }
  InputImeSetCandidatesParams.fromProxy(JsObject jsProxy): super.fromProxy(jsProxy);

  /**
   * ID of the context that owns the candidate window.
   */
  int get contextID => jsProxy['contextID'];
  set contextID(int value) => jsProxy['contextID'] = value;

  /**
   * List of candidates to show in the candidate window
   */
  List<Map> get candidates => toList(jsProxy['candidates'], toMap);
  set candidates(List<Map> value) => jsProxy['candidates'] = toJS(value);
}

class InputImeSetCursorPositionParams extends ChromeObject {
  InputImeSetCursorPositionParams({int contextID, int candidateID}) {
    if (contextID != null) this.contextID = contextID;
    if (candidateID != null) this.candidateID = candidateID;
  }
  InputImeSetCursorPositionParams.fromProxy(JsObject jsProxy): super.fromProxy(jsProxy);

  /**
   * ID of the context that owns the candidate window.
   */
  int get contextID => jsProxy['contextID'];
  set contextID(int value) => jsProxy['contextID'] = value;

  /**
   * ID of the candidate to select.
   */
  int get candidateID => jsProxy['candidateID'];
  set candidateID(int value) => jsProxy['candidateID'] = value;
}

class InputImeSetMenuItemsParams extends ChromeObject {
  InputImeSetMenuItemsParams({String engineID, List<MenuItem> items}) {
    if (engineID != null) this.engineID = engineID;
    if (items != null) this.items = items;
  }
  InputImeSetMenuItemsParams.fromProxy(JsObject jsProxy): super.fromProxy(jsProxy);

  /**
   * ID of the engine to use
   */
  String get engineID => jsProxy['engineID'];
  set engineID(String value) => jsProxy['engineID'] = value;

  /**
   * MenuItems to add. They will be added in the order they exist in the array.
   */
  List<MenuItem> get items => toList(jsProxy['items'], _createMenuItem);
  set items(List<MenuItem> value) => jsProxy['items'] = toJS(value);
}

class InputImeUpdateMenuItemsParams extends ChromeObject {
  InputImeUpdateMenuItemsParams({String engineID, List<MenuItem> items}) {
    if (engineID != null) this.engineID = engineID;
    if (items != null) this.items = items;
  }
  InputImeUpdateMenuItemsParams.fromProxy(JsObject jsProxy): super.fromProxy(jsProxy);

  /**
   * ID of the engine to use
   */
  String get engineID => jsProxy['engineID'];
  set engineID(String value) => jsProxy['engineID'] = value;

  /**
   * Array of MenuItems to update
   */
  List<MenuItem> get items => toList(jsProxy['items'], _createMenuItem);
  set items(List<MenuItem> value) => jsProxy['items'] = toJS(value);
}

class InputImeDeleteSurroundingTextParams extends ChromeObject {
  InputImeDeleteSurroundingTextParams({String engineID, int contextID, int offset, int length}) {
    if (engineID != null) this.engineID = engineID;
    if (contextID != null) this.contextID = contextID;
    if (offset != null) this.offset = offset;
    if (length != null) this.length = length;
  }
  InputImeDeleteSurroundingTextParams.fromProxy(JsObject jsProxy): super.fromProxy(jsProxy);

  /**
   * ID of the engine receiving the event.
   */
  String get engineID => jsProxy['engineID'];
  set engineID(String value) => jsProxy['engineID'] = value;

  /**
   * ID of the context where the surrounding text will be deleted.
   */
  int get contextID => jsProxy['contextID'];
  set contextID(int value) => jsProxy['contextID'] = value;

  /**
   * The offset from the caret position where deletion will start. This value
   * can be negative.
   */
  int get offset => jsProxy['offset'];
  set offset(int value) => jsProxy['offset'] = value;

  /**
   * The number of characters to be deleted
   */
  int get length => jsProxy['length'];
  set length(int value) => jsProxy['length'] = value;
}

OnActivateEvent _createOnActivateEvent(String engineID, String screen) =>
    new OnActivateEvent(engineID, _createScreenType(screen));
InputContext _createInputContext(JsObject jsProxy) => jsProxy == null ? null : new InputContext.fromProxy(jsProxy);
OnKeyEventEvent _createOnKeyEventEvent(String engineID, JsObject keyData) =>
    new OnKeyEventEvent(engineID, _createKeyboardEvent(keyData));
OnCandidateClickedEvent _createOnCandidateClickedEvent(String engineID, int candidateID, String button) =>
    new OnCandidateClickedEvent(engineID, candidateID, _createMouseButton(button));
OnMenuItemActivatedEvent _createOnMenuItemActivatedEvent(String engineID, String name) =>
    new OnMenuItemActivatedEvent(engineID, name);
OnSurroundingTextChangedEvent _createOnSurroundingTextChangedEvent(String engineID, JsObject surroundingInfo) =>
    new OnSurroundingTextChangedEvent(engineID, toMap(surroundingInfo));
Bounds _createBounds(JsObject jsProxy) => jsProxy == null ? null : new Bounds.fromProxy(jsProxy);
Window _createWindow(JsObject jsProxy) => jsProxy == null ? null : new Window.fromProxy(jsProxy);
WindowPosition _createWindowPosition(String value) => WindowPosition.VALUES.singleWhere((ChromeEnum e) => e.value == value);
KeyboardEventType _createKeyboardEventType(String value) => KeyboardEventType.VALUES.singleWhere((ChromeEnum e) => e.value == value);
InputContextType _createInputContextType(String value) => InputContextType.VALUES.singleWhere((ChromeEnum e) => e.value == value);
MenuItemStyle _createMenuItemStyle(String value) => MenuItemStyle.VALUES.singleWhere((ChromeEnum e) => e.value == value);
InputWindowType _createWindowType(String value) => InputWindowType.VALUES.singleWhere((ChromeEnum e) => e.value == value);
KeyboardEvent _createKeyboardEvent(JsObject jsProxy) => jsProxy == null ? null : new KeyboardEvent.fromProxy(jsProxy);
PropertiesInputIme _createPropertiesInputIme(JsObject jsProxy) => jsProxy == null ? null : new PropertiesInputIme.fromProxy(jsProxy);
MenuItem _createMenuItem(JsObject jsProxy) => jsProxy == null ? null : new MenuItem.fromProxy(jsProxy);
ScreenType _createScreenType(String value) => ScreenType.VALUES.singleWhere((ChromeEnum e) => e.value == value);
MouseButton _createMouseButton(String value) => MouseButton.VALUES.singleWhere((ChromeEnum e) => e.value == value);

/* This file has been generated from types.json - do not edit */

/**
 * The `chrome.types` API contains type declarations for Chrome.
 */
library chrome.types;

import '../src/common.dart';

/**
 * Accessor for the `chrome.types` namespace.
 */
final ChromeTypes types = new ChromeTypes._();

class ChromeTypes extends ChromeApi {
  JsObject get _types => chrome['types'];

  ChromeTypes._();

  bool get available => _types != null;
}

/**
 * The scope of the ChromeSetting. One of<ul><li>[regular]: setting for the
 * regular profile (which is inherited by the incognito profile if not
 * overridden elsewhere),</li><li>[regular_only]: setting for the regular
 * profile only (not inherited by the incognito
 * profile),</li><li>[incognito_persistent]: setting for the incognito profile
 * that survives browser restarts (overrides regular
 * preferences),</li><li>[incognito_session_only]: setting for the incognito
 * profile that can only be set during an incognito session and is deleted when
 * the incognito session ends (overrides regular and incognito_persistent
 * preferences).</li></ul>
 */
class ChromeSettingScope extends ChromeEnum {
  static const ChromeSettingScope REGULAR = const ChromeSettingScope._('regular');
  static const ChromeSettingScope REGULAR_ONLY = const ChromeSettingScope._('regular_only');
  static const ChromeSettingScope INCOGNITO_PERSISTENT = const ChromeSettingScope._('incognito_persistent');
  static const ChromeSettingScope INCOGNITO_SESSION_ONLY = const ChromeSettingScope._('incognito_session_only');

  static const List<ChromeSettingScope> VALUES = const[REGULAR, REGULAR_ONLY, INCOGNITO_PERSISTENT, INCOGNITO_SESSION_ONLY];

  const ChromeSettingScope._(String str): super(str);
}

/**
 * One of<ul><li>[not_controllable]: cannot be controlled by any
 * extension</li><li>[controlled_by_other_extensions]: controlled by extensions
 * with higher precedence</li><li>[controllable_by_this_extension]: can be
 * controlled by this extension</li><li>[controlled_by_this_extension]:
 * controlled by this extension</li></ul>
 */
class TypesLevelOfControl extends ChromeEnum {
  static const TypesLevelOfControl NOT_CONTROLLABLE = const TypesLevelOfControl._('not_controllable');
  static const TypesLevelOfControl CONTROLLED_BY_OTHER_EXTENSIONS = const TypesLevelOfControl._('controlled_by_other_extensions');
  static const TypesLevelOfControl CONTROLLABLE_BY_THIS_EXTENSION = const TypesLevelOfControl._('controllable_by_this_extension');
  static const TypesLevelOfControl CONTROLLED_BY_THIS_EXTENSION = const TypesLevelOfControl._('controlled_by_this_extension');

  static const List<TypesLevelOfControl> VALUES = const[NOT_CONTROLLABLE, CONTROLLED_BY_OTHER_EXTENSIONS, CONTROLLABLE_BY_THIS_EXTENSION, CONTROLLED_BY_THIS_EXTENSION];

  const TypesLevelOfControl._(String str): super(str);
}

/**
 * An interface that allows access to a Chrome browser setting. See
 * [accessibilityFeatures] for an example.
 */
class ChromeSetting extends ChromeObject {
  ChromeSetting();
  ChromeSetting.fromProxy(JsObject jsProxy): super.fromProxy(jsProxy);

  /**
   * Gets the value of a setting.
   * 
   * [details] Which setting to consider.
   * 
   * Returns:
   * Details of the currently effective value.
   */
  Future<Map> get(TypesGetParams details) {
    var completer = new ChromeCompleter<Map>.oneArg(toMap);
    jsProxy.callMethod('get', [toJS(details), completer.callback]);
    return completer.future;
  }

  /**
   * Sets the value of a setting.
   * 
   * [details] Which setting to change.
   */
  Future set(TypesSetParams details) {
    var completer = new ChromeCompleter.noArgs();
    jsProxy.callMethod('set', [toJS(details), completer.callback]);
    return completer.future;
  }

  /**
   * Clears the setting, restoring any default value.
   * 
   * [details] Which setting to clear.
   */
  Future clear(TypesClearParams details) {
    var completer = new ChromeCompleter.noArgs();
    jsProxy.callMethod('clear', [toJS(details), completer.callback]);
    return completer.future;
  }
}

class TypesGetParams extends ChromeObject {
  TypesGetParams({bool incognito}) {
    if (incognito != null) this.incognito = incognito;
  }
  TypesGetParams.fromProxy(JsObject jsProxy): super.fromProxy(jsProxy);

  /**
   * Whether to return the value that applies to the incognito session (default
   * false).
   */
  bool get incognito => jsProxy['incognito'];
  set incognito(bool value) => jsProxy['incognito'] = value;
}

class TypesSetParams extends ChromeObject {
  TypesSetParams({var value, ChromeSettingScope scope}) {
    if (value != null) this.value = value;
    if (scope != null) this.scope = scope;
  }
  TypesSetParams.fromProxy(JsObject jsProxy): super.fromProxy(jsProxy);

  /**
   * The value of the setting. <br/>Note that every setting has a specific value
   * type, which is described together with the setting. An extension should
   * _not_ set a value of a different type.
   */
  dynamic get value => jsProxy['value'];
  set value(var value) => jsProxy['value'] = toJS(value);

  /**
   * Where to set the setting (default: regular).
   */
  ChromeSettingScope get scope => _createChromeSettingScope(jsProxy['scope']);
  set scope(ChromeSettingScope value) => jsProxy['scope'] = toJS(value);
}

class TypesClearParams extends ChromeObject {
  TypesClearParams({ChromeSettingScope scope}) {
    if (scope != null) this.scope = scope;
  }
  TypesClearParams.fromProxy(JsObject jsProxy): super.fromProxy(jsProxy);

  /**
   * Where to clear the setting (default: regular).
   */
  ChromeSettingScope get scope => _createChromeSettingScope(jsProxy['scope']);
  set scope(ChromeSettingScope value) => jsProxy['scope'] = toJS(value);
}

ChromeSettingScope _createChromeSettingScope(String value) => ChromeSettingScope.VALUES.singleWhere((ChromeEnum e) => e.value == value);

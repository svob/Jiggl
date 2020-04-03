library chrome_idl_mapping;

import 'package:persistent/persistent.dart';
import 'chrome_idl_model.dart';

/**
 * Map the namespace declaration parse to a [IDLNamespaceDeclaration]
 */
IDLNamespaceDeclaration idlNamespaceDeclarationMapping(var copyrightMaybe, _,
  var documentation, var attributeMaybe, __, var name, var body,
  ___) {

  String nameDotNotation = name.join(".");

  String copyrightSignature =
      copyrightMaybe.isDefined ? copyrightMaybe.value : "";

  IDLFunctionDeclaration functionDeclaration =
      body.firstWhere((e) => e is IDLFunctionDeclaration, orElse: () => null);

  List<IDLTypeDeclaration> typeDeclarations =
      body.where((e) => e is IDLTypeDeclaration).toList();

  IDLEventDeclaration eventDeclaration =
      body.firstWhere((e) => e is IDLEventDeclaration, orElse: () => null);

  List<IDLCallbackDeclaration> callbackDeclarations =
      body.where((e) => e is IDLCallbackDeclaration).toList();

  List<IDLEnumDeclaration> enumDeclarations =
      body.where((e) => e is IDLEnumDeclaration).toList();

  return new IDLNamespaceDeclaration(nameDotNotation,
      functionDeclaration: functionDeclaration,
      typeDeclarations: typeDeclarations,
      eventDeclaration: eventDeclaration,
      callbackDeclarations: callbackDeclarations,
      enumDeclarations: enumDeclarations,
      attribute: attributeMaybe.isDefined ? attributeMaybe.value : null,
      documentation: documentation, copyrightSignature: copyrightSignature);
}

/**
 * Mapping of callback declaration.
 */
IDLCallbackDeclaration idlCallbackDeclarationMapping(
  var documentation, _, __, var name, ___,
  var parameters, ____) =>
    new IDLCallbackDeclaration(name, parameters, documentation: documentation);

IDLFunctionDeclaration idlFunctionDeclarationMapping(var documentation,
  var attributeMaybe, _, __, var methods, ___) =>
  new IDLFunctionDeclaration(methods,
      attribute: attributeMaybe.isDefined ? attributeMaybe.value : null,
      documentation: documentation);

IDLEventDeclaration idlEventDeclarationMapping(var documentation,
  var attributeMaybe, _, __, var methods, ___) =>
  new IDLEventDeclaration(methods,
      attribute: attributeMaybe.isDefined ? attributeMaybe.value : null,
      documentation: documentation);

IDLTypeDeclaration idlTypeDeclarationMapping(var documentation,
  var attributeMaybe, _, var name, var body, __)  {
  IDLAttributeDeclaration attribute =
      attributeMaybe.isDefined ? attributeMaybe.value : null;
  final List<IDLField> members = body.where((e) => e is IDLField).toList();
  final List<IDLMethod> methods = body.where((e) => e is IDLMethod).toList();
  return new IDLTypeDeclaration(name, members, methods: methods,
      attribute: attribute, documentation: documentation);
}

IDLMethod idlMethodParameterMapping(var documentation,
  var attribute, _, var type, var name,
  var parameters, ___) =>
    new IDLMethod(name, type, parameters,
        attribute: attribute.isDefined ? attribute.value : null,
        documentation: documentation);

/**
 * Mapping of parameter with optional flag.
 */
IDLParameter idlParameterMapping(String name, IDLType type,
  bool isOptional, bool isCallback) {

  // Check if its a callback by name.
  if (!isCallback) {
    isCallback = name == 'callback' || name == 'responseCallback';
  }

  return new IDLParameter(name, type, isOptional: isOptional,
        isCallback: isCallback);
}

/*
 * Mapping the type of an attribute.
 */
IDLType _idlAttributeTypeMapping(IDLAttributeDeclaration attribute, {isArray: false}) {
  IDLAttributeTypeEnum t = attribute.attributes[0].attributeType;
  if (t != IDLAttributeTypeEnum.INSTANCE_OF) {
    throw new ArgumentError(
        "attribute was not IDLAttributeTypeEnum.INSTANCE_OF");
  }
  return new IDLType(attribute.attributes[0].attributeValue, isArray: isArray);
}

/**
 * Mapping of parameter with attribute based type specificed.
 */
IDLParameter idlParameterAttributeBasedTypeMapping(String name,
  IDLAttributeDeclaration attribute, {isArray: false}) {

  // Check if its a callback by name.
  bool isCallback = name == 'callback' || name == 'responseCallback';

  return new IDLParameter(name,
      _idlAttributeTypeMapping(attribute, isArray: isArray),
      attribute: attribute, isCallback: isCallback);
}

IDLParameter idlOptionalParameterAttributeRemapTypeMapping(
  var attribute, _, type, name) {
  IDLType t = _idlAttributeTypeMapping(attribute);
  IDLType mixedType = new IDLType(t.name, isArray: type.isArray);

  // Check if its a callback by name.
  bool isCallback = name == 'callback' || name == 'responseCallback';

  return new IDLParameter(name, mixedType, attribute: attribute,
      isOptional: true, isCallback: isCallback);
}

/**
 * Mapping of field based type specificed.
 */
IDLField idlFieldBasedTypeMapping(var documentation,
  var attributeMaybe, var type, var optional, var name,
  _) => new IDLField(name, type, isOptional: optional.isDefined,
        documentation: documentation,
        attribute: attributeMaybe.isDefined ? attributeMaybe.value : null);

/**
 * Mapping of field with attribute based type specificed.
 */
IDLField idlFieldAttributeBasedTypeMapping(var documentation,
  var attribute, __, var name, ___) =>
      new IDLField(name, _idlAttributeTypeMapping(attribute),
          attribute: attribute, documentation: documentation);
/**
 * Mapping of type.
 */
IDLType idlTypeMapping(String name, bool isArray) =>
    new IDLType(name, isArray: isArray);

/**
 * Mapping of `or` type.
 */
IDLType idlTypeOrMapping() => new IDLType("object");

/**
 * Method to help find IDLAttributeTypeEnum by String name.
 */
IDLAttributeTypeEnum _resolveEnum(String name) {
  var attributeEnum = IDLAttributeTypeEnum.values.singleWhere(
      (IDLAttributeTypeEnum e) {
        return e.type == name;
      });

  if (attributeEnum == null) {
    throw new ArgumentError("$name cannot be resolved IDLAttributeTypeEnum");
  }

  return attributeEnum;
}

/**
 * Enum declaration
 */
IDLEnumDeclaration idlEnumDeclarationMapping(var documentation,
   attribute, _,  name, enumValues, __) =>
      new IDLEnumDeclaration(name, enumValues,
          attribute: attribute.isDefined ? attribute.value : null,
          documentation: documentation);

/**
 * Enum value
 */
IDLEnumValue idlEnumValueMapping(var documentation, name) =>
    new IDLEnumValue(name, documentation: documentation);

/**
 * Attribute declaration
 */
IDLAttributeDeclaration idlAttributeDeclarationMapping(List attributes) =>
  new IDLAttributeDeclaration(attributes);

/**
 *  Attribute where [name=value]
 */
IDLAttribute idlAttributeAssignedValueMapping(var name, _, value) =>
    new IDLAttribute(_resolveEnum(name), attributeValue: value);


/**
 *  Attribute where [name="string"]
 */
IDLAttribute idlAttributeAssignedStringLiteral(var name, _, value) =>
    new IDLAttribute(_resolveEnum(name), attributeValue: value);

/**
 *  Attribute where [name=(1,2)]
 */
IDLAttribute idlAttributeAssignedMultiValueMapping(
                                           var name, _, values) =>
    new IDLAttribute(_resolveEnum(name), attributeValues: values);

/**
 * Attribute where [name]
 */
IDLAttribute idlAttributeMapping(String name) =>
    new IDLAttribute(_resolveEnum(name));

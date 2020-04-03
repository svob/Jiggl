/* This file has been generated from bluetooth_low_energy.idl - do not edit */

/**
 * The `chrome.bluetoothLowEnergy` API is used to communicate with Bluetooth
 * Smart (Low Energy) devices using the <a
 * href="https://developer.bluetooth.org/TechnologyOverview/Pages/GATT.aspx">
 * Generic Attribute Profile (GATT)</a>.
 */
library chrome.bluetoothLowEnergy;

import '../src/common.dart';

/**
 * Accessor for the `chrome.bluetoothLowEnergy` namespace.
 */
final ChromeBluetoothLowEnergy bluetoothLowEnergy = new ChromeBluetoothLowEnergy._();

class ChromeBluetoothLowEnergy extends ChromeApi {
  JsObject get _bluetoothLowEnergy => chrome['bluetoothLowEnergy'];

  Stream<Service> get onServiceAdded => _onServiceAdded.stream;
  ChromeStreamController<Service> _onServiceAdded;

  Stream<Service> get onServiceChanged => _onServiceChanged.stream;
  ChromeStreamController<Service> _onServiceChanged;

  Stream<Service> get onServiceRemoved => _onServiceRemoved.stream;
  ChromeStreamController<Service> _onServiceRemoved;

  Stream<Characteristic> get onCharacteristicValueChanged => _onCharacteristicValueChanged.stream;
  ChromeStreamController<Characteristic> _onCharacteristicValueChanged;

  Stream<Descriptor> get onDescriptorValueChanged => _onDescriptorValueChanged.stream;
  ChromeStreamController<Descriptor> _onDescriptorValueChanged;

  Stream<OnCharacteristicReadRequestEvent> get onCharacteristicReadRequest => _onCharacteristicReadRequest.stream;
  ChromeStreamController<OnCharacteristicReadRequestEvent> _onCharacteristicReadRequest;

  Stream<OnCharacteristicWriteRequestEvent> get onCharacteristicWriteRequest => _onCharacteristicWriteRequest.stream;
  ChromeStreamController<OnCharacteristicWriteRequestEvent> _onCharacteristicWriteRequest;

  Stream<OnDescriptorReadRequestEvent> get onDescriptorReadRequest => _onDescriptorReadRequest.stream;
  ChromeStreamController<OnDescriptorReadRequestEvent> _onDescriptorReadRequest;

  Stream<OnDescriptorWriteRequestEvent> get onDescriptorWriteRequest => _onDescriptorWriteRequest.stream;
  ChromeStreamController<OnDescriptorWriteRequestEvent> _onDescriptorWriteRequest;

  ChromeBluetoothLowEnergy._() {
    var getApi = () => _bluetoothLowEnergy;
    _onServiceAdded = new ChromeStreamController<Service>.oneArg(getApi, 'onServiceAdded', _createService);
    _onServiceChanged = new ChromeStreamController<Service>.oneArg(getApi, 'onServiceChanged', _createService);
    _onServiceRemoved = new ChromeStreamController<Service>.oneArg(getApi, 'onServiceRemoved', _createService);
    _onCharacteristicValueChanged = new ChromeStreamController<Characteristic>.oneArg(getApi, 'onCharacteristicValueChanged', _createCharacteristic);
    _onDescriptorValueChanged = new ChromeStreamController<Descriptor>.oneArg(getApi, 'onDescriptorValueChanged', _createDescriptor);
    _onCharacteristicReadRequest = new ChromeStreamController<OnCharacteristicReadRequestEvent>.twoArgs(getApi, 'onCharacteristicReadRequest', _createOnCharacteristicReadRequestEvent);
    _onCharacteristicWriteRequest = new ChromeStreamController<OnCharacteristicWriteRequestEvent>.twoArgs(getApi, 'onCharacteristicWriteRequest', _createOnCharacteristicWriteRequestEvent);
    _onDescriptorReadRequest = new ChromeStreamController<OnDescriptorReadRequestEvent>.twoArgs(getApi, 'onDescriptorReadRequest', _createOnDescriptorReadRequestEvent);
    _onDescriptorWriteRequest = new ChromeStreamController<OnDescriptorWriteRequestEvent>.twoArgs(getApi, 'onDescriptorWriteRequest', _createOnDescriptorWriteRequestEvent);
  }

  bool get available => _bluetoothLowEnergy != null;

  /**
   * Establishes a connection between the application and the device with the
   * given address. A device may be already connected and its GATT services
   * available without calling `connect`, however, an app that wants to access
   * GATT services of a device should call this function to make sure that a
   * connection to the device is maintained. If the device is not connected, all
   * GATT services of the device will be discovered after a successful call to
   * `connect`.
   * [deviceAddress]: The Bluetooth address of the remote device to which a GATT
   * connection should be opened.
   * [properties]: Connection properties (optional).
   * [callback]: Called when the connect request has completed.
   */
  Future connect(String deviceAddress, [ConnectProperties properties]) {
    if (_bluetoothLowEnergy == null) _throwNotAvailable();

    var completer = new ChromeCompleter.noArgs();
    _bluetoothLowEnergy.callMethod('connect', [deviceAddress, toJS(properties), completer.callback]);
    return completer.future;
  }

  /**
   * Closes the app's connection to the device with the given address. Note that
   * this will not always destroy the physical link itself, since there may be
   * other apps with open connections.
   * [deviceAddress]: The Bluetooth address of the remote device.
   * [callback]: Called when the disconnect request has completed.
   */
  Future disconnect(String deviceAddress) {
    if (_bluetoothLowEnergy == null) _throwNotAvailable();

    var completer = new ChromeCompleter.noArgs();
    _bluetoothLowEnergy.callMethod('disconnect', [deviceAddress, completer.callback]);
    return completer.future;
  }

  /**
   * Get the GATT service with the given instance ID.
   * [serviceId]: The instance ID of the requested GATT service.
   * [callback]: Called with the requested Service object.
   */
  Future<Service> getService(String serviceId) {
    if (_bluetoothLowEnergy == null) _throwNotAvailable();

    var completer = new ChromeCompleter<Service>.oneArg(_createService);
    _bluetoothLowEnergy.callMethod('getService', [serviceId, completer.callback]);
    return completer.future;
  }

  /**
   * Create a locally hosted GATT service. This service can be registered to be
   * available on a local GATT server. This function is only available if the
   * app has both the bluetooth:low_energy and the bluetooth:peripheral
   * permissions set to true. The peripheral permission may not be available to
   * all apps.
   * [service]: The service to create.
   * [callback]: Called with the created services's unique ID.
   */
  Future<String> createService(Service service) {
    if (_bluetoothLowEnergy == null) _throwNotAvailable();

    var completer = new ChromeCompleter<String>.oneArg();
    _bluetoothLowEnergy.callMethod('createService', [toJS(service), completer.callback]);
    return completer.future;
  }

  /**
   * Get all the GATT services that were discovered on the remote device with
   * the given device address.
   * [deviceAddress]: The Bluetooth address of the remote device whose GATT
   * services should be returned.
   * [callback]: Called with the list of requested Service objects.
   */
  Future<List<Service>> getServices(String deviceAddress) {
    if (_bluetoothLowEnergy == null) _throwNotAvailable();

    var completer = new ChromeCompleter<List<Service>>.oneArg((e) => toList(e, _createService));
    _bluetoothLowEnergy.callMethod('getServices', [deviceAddress, completer.callback]);
    return completer.future;
  }

  /**
   * Get the GATT characteristic with the given instance ID that belongs to the
   * given GATT service, if the characteristic exists.
   * [characteristicId]: The instance ID of the requested GATT characteristic.
   * [callback]: Called with the requested Characteristic object.
   */
  Future<Characteristic> getCharacteristic(String characteristicId) {
    if (_bluetoothLowEnergy == null) _throwNotAvailable();

    var completer = new ChromeCompleter<Characteristic>.oneArg(_createCharacteristic);
    _bluetoothLowEnergy.callMethod('getCharacteristic', [characteristicId, completer.callback]);
    return completer.future;
  }

  /**
   * Create a locally hosted GATT characteristic. This characteristic must be
   * hosted under a valid service. If the service ID is not valid, the lastError
   * will be set. This function is only available if the app has both the
   * bluetooth:low_energy and the bluetooth:peripheral permissions set to true.
   * The peripheral permission may not be available to all apps.
   * [characteristic]: The characteristic to create.
   * [serviceId]: ID of the service to create this characteristic for.
   * [callback]: Called with the created characteristic's unique ID.
   */
  Future<String> createCharacteristic(Characteristic characteristic, String serviceId) {
    if (_bluetoothLowEnergy == null) _throwNotAvailable();

    var completer = new ChromeCompleter<String>.oneArg();
    _bluetoothLowEnergy.callMethod('createCharacteristic', [toJS(characteristic), serviceId, completer.callback]);
    return completer.future;
  }

  /**
   * Get a list of all discovered GATT characteristics that belong to the given
   * service.
   * [serviceId]: The instance ID of the GATT service whose characteristics
   * should be returned.
   * [callback]: Called with the list of characteristics that belong to the
   * given service.
   */
  Future<List<Characteristic>> getCharacteristics(String serviceId) {
    if (_bluetoothLowEnergy == null) _throwNotAvailable();

    var completer = new ChromeCompleter<List<Characteristic>>.oneArg((e) => toList(e, _createCharacteristic));
    _bluetoothLowEnergy.callMethod('getCharacteristics', [serviceId, completer.callback]);
    return completer.future;
  }

  /**
   * Get a list of GATT services that are included by the given service.
   * [serviceId]: The instance ID of the GATT service whose included services
   * should be returned.
   * [callback]: Called with the list of GATT services included from the given
   * service.
   */
  Future<List<Service>> getIncludedServices(String serviceId) {
    if (_bluetoothLowEnergy == null) _throwNotAvailable();

    var completer = new ChromeCompleter<List<Service>>.oneArg((e) => toList(e, _createService));
    _bluetoothLowEnergy.callMethod('getIncludedServices', [serviceId, completer.callback]);
    return completer.future;
  }

  /**
   * Get the GATT characteristic descriptor with the given instance ID.
   * [descriptorId]: The instance ID of the requested GATT characteristic
   * descriptor.
   * [callback]: Called with the requested Descriptor object.
   */
  Future<Descriptor> getDescriptor(String descriptorId) {
    if (_bluetoothLowEnergy == null) _throwNotAvailable();

    var completer = new ChromeCompleter<Descriptor>.oneArg(_createDescriptor);
    _bluetoothLowEnergy.callMethod('getDescriptor', [descriptorId, completer.callback]);
    return completer.future;
  }

  /**
   * Create a locally hosted GATT descriptor. This descriptor must be hosted
   * under a valid characteristic. If the characteristic ID is not valid, the
   * lastError will be set. This function is only available if the app has both
   * the bluetooth:low_energy and the bluetooth:peripheral permissions set to
   * true. The peripheral permission may not be available to all apps.
   * [descriptor]: The descriptor to create.
   * [characteristicId]: ID of the characteristic to create this descriptor for.
   * [callback]: Called with the created descriptor's unique ID.
   */
  Future<String> createDescriptor(Descriptor descriptor, String characteristicId) {
    if (_bluetoothLowEnergy == null) _throwNotAvailable();

    var completer = new ChromeCompleter<String>.oneArg();
    _bluetoothLowEnergy.callMethod('createDescriptor', [toJS(descriptor), characteristicId, completer.callback]);
    return completer.future;
  }

  /**
   * Get a list of GATT characteristic descriptors that belong to the given
   * characteristic.
   * [characteristicId]: The instance ID of the GATT characteristic whose
   * descriptors should be returned.
   * [callback]: Called with the list of descriptors that belong to the given
   * characteristic.
   */
  Future<List<Descriptor>> getDescriptors(String characteristicId) {
    if (_bluetoothLowEnergy == null) _throwNotAvailable();

    var completer = new ChromeCompleter<List<Descriptor>>.oneArg((e) => toList(e, _createDescriptor));
    _bluetoothLowEnergy.callMethod('getDescriptors', [characteristicId, completer.callback]);
    return completer.future;
  }

  /**
   * Retrieve the value of a specified characteristic from a remote peripheral.
   * [characteristicId]: The instance ID of the GATT characteristic whose value
   * should be read from the remote device.
   * [callback]: Called with the Characteristic object whose value was
   * requested. The `value` field of the returned Characteristic object contains
   * the result of the read request.
   */
  Future<Characteristic> readCharacteristicValue(String characteristicId) {
    if (_bluetoothLowEnergy == null) _throwNotAvailable();

    var completer = new ChromeCompleter<Characteristic>.oneArg(_createCharacteristic);
    _bluetoothLowEnergy.callMethod('readCharacteristicValue', [characteristicId, completer.callback]);
    return completer.future;
  }

  /**
   * Write the value of a specified characteristic from a remote peripheral.
   * [characteristicId]: The instance ID of the GATT characteristic whose value
   * should be written to.
   * [value]: The value that should be sent to the remote characteristic as part
   * of the write request.
   * [callback]: Called when the write request has completed.
   */
  Future writeCharacteristicValue(String characteristicId, ArrayBuffer value) {
    if (_bluetoothLowEnergy == null) _throwNotAvailable();

    var completer = new ChromeCompleter.noArgs();
    _bluetoothLowEnergy.callMethod('writeCharacteristicValue', [characteristicId, toJS(value), completer.callback]);
    return completer.future;
  }

  /**
   * Enable value notifications/indications from the specified characteristic.
   * Once enabled, an application can listen to notifications using the
   * [onCharacteristicValueChanged] event.
   * [characteristicId]: The instance ID of the GATT characteristic that
   * notifications should be enabled on.
   * [properties]: Notification session properties (optional).
   * [callback]: Called when the request has completed.
   */
  Future startCharacteristicNotifications(String characteristicId, [NotificationProperties properties]) {
    if (_bluetoothLowEnergy == null) _throwNotAvailable();

    var completer = new ChromeCompleter.noArgs();
    _bluetoothLowEnergy.callMethod('startCharacteristicNotifications', [characteristicId, toJS(properties), completer.callback]);
    return completer.future;
  }

  /**
   * Disable value notifications/indications from the specified characteristic.
   * After a successful call, the application will stop receiving
   * notifications/indications from this characteristic.
   * [characteristicId]: The instance ID of the GATT characteristic on which
   * this app's notification session should be stopped.
   * [callback]: Called when the request has completed (optional).
   */
  Future stopCharacteristicNotifications(String characteristicId) {
    if (_bluetoothLowEnergy == null) _throwNotAvailable();

    var completer = new ChromeCompleter.noArgs();
    _bluetoothLowEnergy.callMethod('stopCharacteristicNotifications', [characteristicId, completer.callback]);
    return completer.future;
  }

  /**
   * Notify a remote device of a new value for a characteristic. If the
   * shouldIndicate flag in the notification object is true, an indication will
   * be sent instead of a notification. Note, the characteristic needs to
   * correctly set the 'notify' or 'indicate' property during creation for this
   * call to succeed. This function is only available if the app has both the
   * bluetooth:low_energy and the bluetooth:peripheral permissions set to true.
   * The peripheral permission may not be available to all apps.
   * [characteristicId]: The characteristic to send the notication for.
   * [notifcation]: The notification to send.
   * [callback]: Callback called once the notification or indication has been
   * sent successfully.
   */
  Future notifyCharacteristicValueChanged(String characteristicId, Notification notification) {
    if (_bluetoothLowEnergy == null) _throwNotAvailable();

    var completer = new ChromeCompleter.noArgs();
    _bluetoothLowEnergy.callMethod('notifyCharacteristicValueChanged', [characteristicId, toJS(notification), completer.callback]);
    return completer.future;
  }

  /**
   * Retrieve the value of a specified characteristic descriptor from a remote
   * peripheral.
   * [descriptorId]: The instance ID of the GATT characteristic descriptor whose
   * value should be read from the remote device.
   * [callback]: Called with the Descriptor object whose value was requested.
   * The `value` field of the returned Descriptor object contains the result of
   * the read request.
   */
  Future<Descriptor> readDescriptorValue(String descriptorId) {
    if (_bluetoothLowEnergy == null) _throwNotAvailable();

    var completer = new ChromeCompleter<Descriptor>.oneArg(_createDescriptor);
    _bluetoothLowEnergy.callMethod('readDescriptorValue', [descriptorId, completer.callback]);
    return completer.future;
  }

  /**
   * Write the value of a specified characteristic descriptor from a remote
   * peripheral.
   * [descriptorId]: The instance ID of the GATT characteristic descriptor whose
   * value should be written to.
   * [value]: The value that should be sent to the remote descriptor as part of
   * the write request.
   * [callback]: Called when the write request has completed.
   */
  Future writeDescriptorValue(String descriptorId, ArrayBuffer value) {
    if (_bluetoothLowEnergy == null) _throwNotAvailable();

    var completer = new ChromeCompleter.noArgs();
    _bluetoothLowEnergy.callMethod('writeDescriptorValue', [descriptorId, toJS(value), completer.callback]);
    return completer.future;
  }

  /**
   * Register the given service with the local GATT server. If the service ID is
   * invalid, the lastError will be set. This function is only available if the
   * app has both the bluetooth:low_energy and the bluetooth:peripheral
   * permissions set to true. The peripheral permission may not be available to
   * all apps.
   * [serviceId]: Unique ID of a created service.
   * [callback]: Callback with the result of the register operation.
   */
  Future registerService(String serviceId) {
    if (_bluetoothLowEnergy == null) _throwNotAvailable();

    var completer = new ChromeCompleter.noArgs();
    _bluetoothLowEnergy.callMethod('registerService', [serviceId, completer.callback]);
    return completer.future;
  }

  /**
   * Unregister the given service with the local GATT server. If the service ID
   * is invalid, the lastError will be set. This function is only available if
   * the app has both the bluetooth:low_energy and the bluetooth:peripheral
   * permissions set to true. The peripheral permission may not be available to
   * all apps.
   * [serviceId]: Unique ID of a current registered service.
   * [callback]: Callback with the result of the register operation.
   */
  Future unregisterService(String serviceId) {
    if (_bluetoothLowEnergy == null) _throwNotAvailable();

    var completer = new ChromeCompleter.noArgs();
    _bluetoothLowEnergy.callMethod('unregisterService', [serviceId, completer.callback]);
    return completer.future;
  }

  /**
   * Remove the specified service, unregistering it if it was registered. If the
   * service ID is invalid, the lastError will be set. This function is only
   * available if the app has both the bluetooth:low_energy and the
   * bluetooth:peripheral permissions set to true. The peripheral permission may
   * not be available to all apps.
   * [serviceId]: Unique ID of a current registered service.
   * [callback]: Callback called once the service is removed.
   */
  Future removeService(String serviceId) {
    if (_bluetoothLowEnergy == null) _throwNotAvailable();

    var completer = new ChromeCompleter.noArgs();
    _bluetoothLowEnergy.callMethod('removeService', [serviceId, completer.callback]);
    return completer.future;
  }

  /**
   * Create an advertisement and register it for advertising. To call this
   * function, the app must have the bluetooth:low_energy and
   * bluetooth:peripheral permissions set to true. Additionally this API is only
   * available to auto launched apps in Kiosk Mode of by setting the
   * 'enable-ble-advertising-in-apps' flag. See
   * https://developer.chrome.com/apps/manifest/bluetooth Note: On some
   * hardware, central and peripheral modes at the same time is supported but on
   * hardware that doesn't support this, making this call will switch the device
   * to peripheral mode. In the case of hardware which does not support both
   * central and peripheral mode, attempting to use the device in both modes
   * will lead to undefined behavior or prevent other central-role applications
   * from behaving correctly (including the discovery of Bluetooth Low Energy
   * devices).
   * [advertisement]: The advertisement to advertise.
   * [callback]: Called once the registeration is done and we've started
   * advertising. Returns the id of the created advertisement.
   */
  Future<int> registerAdvertisement(Advertisement advertisement) {
    if (_bluetoothLowEnergy == null) _throwNotAvailable();

    var completer = new ChromeCompleter<int>.oneArg();
    _bluetoothLowEnergy.callMethod('registerAdvertisement', [toJS(advertisement), completer.callback]);
    return completer.future;
  }

  /**
   * Unregisters an advertisement and stops its advertising. If the
   * advertisement fails to unregister the only way to stop advertising might be
   * to restart the device.
   * [advertisementId]: Id of the advertisement to unregister.
   * [callback]: Called once the advertisement is unregistered and is no longer
   * being advertised.
   */
  Future unregisterAdvertisement(int advertisementId) {
    if (_bluetoothLowEnergy == null) _throwNotAvailable();

    var completer = new ChromeCompleter.noArgs();
    _bluetoothLowEnergy.callMethod('unregisterAdvertisement', [advertisementId, completer.callback]);
    return completer.future;
  }

  /**
   * Sends a response for a characteristic or descriptor read/write request.
   * This function is only available if the app has both the
   * bluetooth:low_energy and the bluetooth:peripheral permissions set to true.
   * The peripheral permission may not be available to all apps.
   * [response]: The response to the request.
   */
  void sendRequestResponse(Response response) {
    if (_bluetoothLowEnergy == null) _throwNotAvailable();

    _bluetoothLowEnergy.callMethod('sendRequestResponse', [toJS(response)]);
  }

  void _throwNotAvailable() {
    throw new UnsupportedError("'chrome.bluetoothLowEnergy' is not available");
  }
}

class OnCharacteristicReadRequestEvent {
  final Request request;

  final String characteristicId;

  OnCharacteristicReadRequestEvent(this.request, this.characteristicId);
}

class OnCharacteristicWriteRequestEvent {
  final Request request;

  final String characteristicId;

  OnCharacteristicWriteRequestEvent(this.request, this.characteristicId);
}

class OnDescriptorReadRequestEvent {
  final Request request;

  final String descriptorId;

  OnDescriptorReadRequestEvent(this.request, this.descriptorId);
}

class OnDescriptorWriteRequestEvent {
  final Request request;

  final String descriptorId;

  OnDescriptorWriteRequestEvent(this.request, this.descriptorId);
}

/**
 * Values representing the possible properties of a characteristic.
 * Characteristic permissions are inferred from these properties. Please see the
 * Bluetooth 4.x spec to see the meaning of each individual property.
 */
class CharacteristicProperty extends ChromeEnum {
  static const CharacteristicProperty BROADCAST = const CharacteristicProperty._('broadcast');
  static const CharacteristicProperty READ = const CharacteristicProperty._('read');
  static const CharacteristicProperty WRITE_WITHOUT_RESPONSE = const CharacteristicProperty._('writeWithoutResponse');
  static const CharacteristicProperty WRITE = const CharacteristicProperty._('write');
  static const CharacteristicProperty NOTIFY = const CharacteristicProperty._('notify');
  static const CharacteristicProperty INDICATE = const CharacteristicProperty._('indicate');
  static const CharacteristicProperty AUTHENTICATED_SIGNED_WRITES = const CharacteristicProperty._('authenticatedSignedWrites');
  static const CharacteristicProperty EXTENDED_PROPERTIES = const CharacteristicProperty._('extendedProperties');
  static const CharacteristicProperty RELIABLE_WRITE = const CharacteristicProperty._('reliableWrite');
  static const CharacteristicProperty WRITABLE_AUXILIARIES = const CharacteristicProperty._('writableAuxiliaries');
  static const CharacteristicProperty ENCRYPT_READ = const CharacteristicProperty._('encryptRead');
  static const CharacteristicProperty ENCRYPT_WRITE = const CharacteristicProperty._('encryptWrite');
  static const CharacteristicProperty ENCRYPT_AUTHENTICATED_READ = const CharacteristicProperty._('encryptAuthenticatedRead');
  static const CharacteristicProperty ENCRYPT_AUTHENTICATED_WRITE = const CharacteristicProperty._('encryptAuthenticatedWrite');

  static const List<CharacteristicProperty> VALUES = const[BROADCAST, READ, WRITE_WITHOUT_RESPONSE, WRITE, NOTIFY, INDICATE, AUTHENTICATED_SIGNED_WRITES, EXTENDED_PROPERTIES, RELIABLE_WRITE, WRITABLE_AUXILIARIES, ENCRYPT_READ, ENCRYPT_WRITE, ENCRYPT_AUTHENTICATED_READ, ENCRYPT_AUTHENTICATED_WRITE];

  const CharacteristicProperty._(String str): super(str);
}

/**
 * Values representing possible permissions for a descriptor. Please see the
 * Bluetooth 4.x spec to see the meaning of each individual permission.
 */
class DescriptorPermission extends ChromeEnum {
  static const DescriptorPermission READ = const DescriptorPermission._('read');
  static const DescriptorPermission WRITE = const DescriptorPermission._('write');
  static const DescriptorPermission ENCRYPTED_READ = const DescriptorPermission._('encryptedRead');
  static const DescriptorPermission ENCRYPTED_WRITE = const DescriptorPermission._('encryptedWrite');
  static const DescriptorPermission ENCRYPTED_AUTHENTICATED_READ = const DescriptorPermission._('encryptedAuthenticatedRead');
  static const DescriptorPermission ENCRYPTED_AUTHENTICATED_WRITE = const DescriptorPermission._('encryptedAuthenticatedWrite');

  static const List<DescriptorPermission> VALUES = const[READ, WRITE, ENCRYPTED_READ, ENCRYPTED_WRITE, ENCRYPTED_AUTHENTICATED_READ, ENCRYPTED_AUTHENTICATED_WRITE];

  const DescriptorPermission._(String str): super(str);
}

/**
 * Type of advertisement. If 'broadcast' is chosen, the sent advertisement type
 * will be ADV_NONCONN_IND and the device will broadcast with a random MAC
 * Address. If set to 'peripheral', the advertisement type will be ADV_IND or
 * ADV_SCAN_IND and the device will broadcast with real Bluetooth Adapter's MAC
 * Address.
 */
class AdvertisementType extends ChromeEnum {
  static const AdvertisementType BROADCAST = const AdvertisementType._('broadcast');
  static const AdvertisementType PERIPHERAL = const AdvertisementType._('peripheral');

  static const List<AdvertisementType> VALUES = const[BROADCAST, PERIPHERAL];

  const AdvertisementType._(String str): super(str);
}

/**
 * Represents a bluetooth central device that is connected to the local GATT
 * server.
 */
class Device extends ChromeObject {
  Device({String address, String name, int deviceClass}) {
    if (address != null) this.address = address;
    if (name != null) this.name = name;
    if (deviceClass != null) this.deviceClass = deviceClass;
  }
  Device.fromProxy(JsObject jsProxy): super.fromProxy(jsProxy);

  String get address => jsProxy['address'];
  set address(String value) => jsProxy['address'] = value;

  String get name => jsProxy['name'];
  set name(String value) => jsProxy['name'] = value;

  int get deviceClass => jsProxy['deviceClass'];
  set deviceClass(int value) => jsProxy['deviceClass'] = value;
}

/**
 * Represents a peripheral's Bluetooth GATT Service, a collection of
 * characteristics and relationships to other services that encapsulate the
 * behavior of part of a device.
 */
class Service extends ChromeObject {
  Service({String uuid, bool isPrimary, String instanceId, String deviceAddress}) {
    if (uuid != null) this.uuid = uuid;
    if (isPrimary != null) this.isPrimary = isPrimary;
    if (instanceId != null) this.instanceId = instanceId;
    if (deviceAddress != null) this.deviceAddress = deviceAddress;
  }
  Service.fromProxy(JsObject jsProxy): super.fromProxy(jsProxy);

  String get uuid => jsProxy['uuid'];
  set uuid(String value) => jsProxy['uuid'] = value;

  bool get isPrimary => jsProxy['isPrimary'];
  set isPrimary(bool value) => jsProxy['isPrimary'] = value;

  String get instanceId => jsProxy['instanceId'];
  set instanceId(String value) => jsProxy['instanceId'] = value;

  String get deviceAddress => jsProxy['deviceAddress'];
  set deviceAddress(String value) => jsProxy['deviceAddress'] = value;
}

/**
 * Represents a GATT characteristic, which is a basic data element that provides
 * further information about a peripheral's service.
 */
class Characteristic extends ChromeObject {
  Characteristic({String uuid, Service service, List<CharacteristicProperty> properties, String instanceId, ArrayBuffer value}) {
    if (uuid != null) this.uuid = uuid;
    if (service != null) this.service = service;
    if (properties != null) this.properties = properties;
    if (instanceId != null) this.instanceId = instanceId;
    if (value != null) this.value = value;
  }
  Characteristic.fromProxy(JsObject jsProxy): super.fromProxy(jsProxy);

  String get uuid => jsProxy['uuid'];
  set uuid(String value) => jsProxy['uuid'] = value;

  Service get service => _createService(jsProxy['service']);
  set service(Service value) => jsProxy['service'] = toJS(value);

  List<CharacteristicProperty> get properties => toList(jsProxy['properties'], _createCharacteristicProperty);
  set properties(List<CharacteristicProperty> value) => jsProxy['properties'] = toJS(value);

  String get instanceId => jsProxy['instanceId'];
  set instanceId(String value) => jsProxy['instanceId'] = value;

  ArrayBuffer get value => _createArrayBuffer(jsProxy['value']);
  set value(ArrayBuffer value) => jsProxy['value'] = toJS(value);
}

/**
 * Represents a GATT characteristic descriptor, which provides further
 * information about a characteristic's value.
 */
class Descriptor extends ChromeObject {
  Descriptor({String uuid, Characteristic characteristic, List<DescriptorPermission> permissions, String instanceId, ArrayBuffer value}) {
    if (uuid != null) this.uuid = uuid;
    if (characteristic != null) this.characteristic = characteristic;
    if (permissions != null) this.permissions = permissions;
    if (instanceId != null) this.instanceId = instanceId;
    if (value != null) this.value = value;
  }
  Descriptor.fromProxy(JsObject jsProxy): super.fromProxy(jsProxy);

  String get uuid => jsProxy['uuid'];
  set uuid(String value) => jsProxy['uuid'] = value;

  Characteristic get characteristic => _createCharacteristic(jsProxy['characteristic']);
  set characteristic(Characteristic value) => jsProxy['characteristic'] = toJS(value);

  List<DescriptorPermission> get permissions => toList(jsProxy['permissions'], _createDescriptorPermission);
  set permissions(List<DescriptorPermission> value) => jsProxy['permissions'] = toJS(value);

  String get instanceId => jsProxy['instanceId'];
  set instanceId(String value) => jsProxy['instanceId'] = value;

  ArrayBuffer get value => _createArrayBuffer(jsProxy['value']);
  set value(ArrayBuffer value) => jsProxy['value'] = toJS(value);
}

/**
 * The connection properties specified during a call to [connect].
 */
class ConnectProperties extends ChromeObject {
  ConnectProperties({bool persistent}) {
    if (persistent != null) this.persistent = persistent;
  }
  ConnectProperties.fromProxy(JsObject jsProxy): super.fromProxy(jsProxy);

  bool get persistent => jsProxy['persistent'];
  set persistent(bool value) => jsProxy['persistent'] = value;
}

/**
 * Optional characteristic notification session properties specified during a
 * call to [startCharacteristicNotifications].
 */
class NotificationProperties extends ChromeObject {
  NotificationProperties({bool persistent}) {
    if (persistent != null) this.persistent = persistent;
  }
  NotificationProperties.fromProxy(JsObject jsProxy): super.fromProxy(jsProxy);

  bool get persistent => jsProxy['persistent'];
  set persistent(bool value) => jsProxy['persistent'] = value;
}

/**
 * Represents an entry of the "Manufacturer Specific Data" field of Bluetooth LE
 * advertisement data.
 */
class ManufacturerData extends ChromeObject {
  ManufacturerData({int id, List<int> data}) {
    if (id != null) this.id = id;
    if (data != null) this.data = data;
  }
  ManufacturerData.fromProxy(JsObject jsProxy): super.fromProxy(jsProxy);

  int get id => jsProxy['id'];
  set id(int value) => jsProxy['id'] = value;

  List<int> get data => toList(jsProxy['data']);
  set data(List<int> value) => jsProxy['data'] = toJS(value);
}

/**
 * Represents an entry of the "Service Data" field of Bluetooth LE advertisement
 * data.
 */
class ServiceData extends ChromeObject {
  ServiceData({String uuid, List<int> data}) {
    if (uuid != null) this.uuid = uuid;
    if (data != null) this.data = data;
  }
  ServiceData.fromProxy(JsObject jsProxy): super.fromProxy(jsProxy);

  String get uuid => jsProxy['uuid'];
  set uuid(String value) => jsProxy['uuid'] = value;

  List<int> get data => toList(jsProxy['data']);
  set data(List<int> value) => jsProxy['data'] = toJS(value);
}

/**
 * Represents a Bluetooth LE advertisement instance.
 */
class Advertisement extends ChromeObject {
  Advertisement({AdvertisementType type, List<String> serviceUuids, List<ManufacturerData> manufacturerData, List<String> solicitUuids, List<ServiceData> serviceData}) {
    if (type != null) this.type = type;
    if (serviceUuids != null) this.serviceUuids = serviceUuids;
    if (manufacturerData != null) this.manufacturerData = manufacturerData;
    if (solicitUuids != null) this.solicitUuids = solicitUuids;
    if (serviceData != null) this.serviceData = serviceData;
  }
  Advertisement.fromProxy(JsObject jsProxy): super.fromProxy(jsProxy);

  AdvertisementType get type => _createAdvertisementType(jsProxy['type']);
  set type(AdvertisementType value) => jsProxy['type'] = toJS(value);

  List<String> get serviceUuids => toList(jsProxy['serviceUuids']);
  set serviceUuids(List<String> value) => jsProxy['serviceUuids'] = toJS(value);

  List<ManufacturerData> get manufacturerData => toList(jsProxy['manufacturerData'], _createManufacturerData);
  set manufacturerData(List<ManufacturerData> value) => jsProxy['manufacturerData'] = toJS(value);

  List<String> get solicitUuids => toList(jsProxy['solicitUuids']);
  set solicitUuids(List<String> value) => jsProxy['solicitUuids'] = toJS(value);

  List<ServiceData> get serviceData => toList(jsProxy['serviceData'], _createServiceData);
  set serviceData(List<ServiceData> value) => jsProxy['serviceData'] = toJS(value);
}

/**
 * Represents a an attribute read/write request.
 */
class Request extends ChromeObject {
  Request({int requestId, Device device, ArrayBuffer value}) {
    if (requestId != null) this.requestId = requestId;
    if (device != null) this.device = device;
    if (value != null) this.value = value;
  }
  Request.fromProxy(JsObject jsProxy): super.fromProxy(jsProxy);

  int get requestId => jsProxy['requestId'];
  set requestId(int value) => jsProxy['requestId'] = value;

  Device get device => _createDevice(jsProxy['device']);
  set device(Device value) => jsProxy['device'] = toJS(value);

  ArrayBuffer get value => _createArrayBuffer(jsProxy['value']);
  set value(ArrayBuffer value) => jsProxy['value'] = toJS(value);
}

/**
 * Represents a response to an attribute read/write request.
 */
class Response extends ChromeObject {
  Response({int requestId, bool isError, ArrayBuffer value}) {
    if (requestId != null) this.requestId = requestId;
    if (isError != null) this.isError = isError;
    if (value != null) this.value = value;
  }
  Response.fromProxy(JsObject jsProxy): super.fromProxy(jsProxy);

  int get requestId => jsProxy['requestId'];
  set requestId(int value) => jsProxy['requestId'] = value;

  bool get isError => jsProxy['isError'];
  set isError(bool value) => jsProxy['isError'] = value;

  ArrayBuffer get value => _createArrayBuffer(jsProxy['value']);
  set value(ArrayBuffer value) => jsProxy['value'] = toJS(value);
}

/**
 * Represents a notification to be sent to a remote device.
 */
class Notification extends ChromeObject {
  Notification({ArrayBuffer value, bool shouldIndicate}) {
    if (value != null) this.value = value;
    if (shouldIndicate != null) this.shouldIndicate = shouldIndicate;
  }
  Notification.fromProxy(JsObject jsProxy): super.fromProxy(jsProxy);

  ArrayBuffer get value => _createArrayBuffer(jsProxy['value']);
  set value(ArrayBuffer value) => jsProxy['value'] = toJS(value);

  bool get shouldIndicate => jsProxy['shouldIndicate'];
  set shouldIndicate(bool value) => jsProxy['shouldIndicate'] = value;
}

Service _createService(JsObject jsProxy) => jsProxy == null ? null : new Service.fromProxy(jsProxy);
Characteristic _createCharacteristic(JsObject jsProxy) => jsProxy == null ? null : new Characteristic.fromProxy(jsProxy);
Descriptor _createDescriptor(JsObject jsProxy) => jsProxy == null ? null : new Descriptor.fromProxy(jsProxy);
OnCharacteristicReadRequestEvent _createOnCharacteristicReadRequestEvent(JsObject request, String characteristicId) =>
    new OnCharacteristicReadRequestEvent(_createRequest(request), characteristicId);
OnCharacteristicWriteRequestEvent _createOnCharacteristicWriteRequestEvent(JsObject request, String characteristicId) =>
    new OnCharacteristicWriteRequestEvent(_createRequest(request), characteristicId);
OnDescriptorReadRequestEvent _createOnDescriptorReadRequestEvent(JsObject request, String descriptorId) =>
    new OnDescriptorReadRequestEvent(_createRequest(request), descriptorId);
OnDescriptorWriteRequestEvent _createOnDescriptorWriteRequestEvent(JsObject request, String descriptorId) =>
    new OnDescriptorWriteRequestEvent(_createRequest(request), descriptorId);
CharacteristicProperty _createCharacteristicProperty(String value) => CharacteristicProperty.VALUES.singleWhere((ChromeEnum e) => e.value == value);
ArrayBuffer _createArrayBuffer(/*JsObject*/ jsProxy) => jsProxy == null ? null : new ArrayBuffer.fromProxy(jsProxy);
DescriptorPermission _createDescriptorPermission(String value) => DescriptorPermission.VALUES.singleWhere((ChromeEnum e) => e.value == value);
AdvertisementType _createAdvertisementType(String value) => AdvertisementType.VALUES.singleWhere((ChromeEnum e) => e.value == value);
ManufacturerData _createManufacturerData(JsObject jsProxy) => jsProxy == null ? null : new ManufacturerData.fromProxy(jsProxy);
ServiceData _createServiceData(JsObject jsProxy) => jsProxy == null ? null : new ServiceData.fromProxy(jsProxy);
Device _createDevice(JsObject jsProxy) => jsProxy == null ? null : new Device.fromProxy(jsProxy);
Request _createRequest(JsObject jsProxy) => jsProxy == null ? null : new Request.fromProxy(jsProxy);

@file:JsQualifier("chrome.storage")

package chrome.storage

import kotlin.js.Promise

/**
 * Items in the sync storage area are synced using Chrome Sync.
 */
external val sync: StorageArea

/**
 * Items in the local storage area are local to each machine.
 */
external val local: StorageArea

/**
 * Items in the managed storage area are set by the domain administrator,
 * and are read-only for the extension; trying to modify this namespace results in an error.
 *
 * Since Chrome 33.
 */
external val managed: StorageArea

external interface StorageArea {

    /**
     * Gets one or more items from storage.
     *
     * @param keys A single key to get, list of keys to get, or a dictionary specifying default values
     *      (see description of the object).
     *      An empty list or object will return an empty result object.
     *      Pass in null to get the entire contents of storage.
     *
     * @param callback Callback with storage items, or on failure (in which case runtime.lastError will be set).
     *      he callback parameter should be a function that looks like this:
     *      function(object items) {...};
     *      where: items: Object with items in their key-value mappings.
     */
    fun get(keys: dynamic = definedExternally, callback: (dynamic) -> Unit)

    /**
     * Stores one or more items in the storage area, or update existing items.
     *
     * When you store or update a value using this API, the storage.onChanged event will fire.
     *
     * @param keys An object containing one or more key/value pairs to be stored in storage.
     *      If an item already exists, its value will be updated.
     *
     *      - Values of primitive types (number, string, boolean, null, undefined) will serialize
     *        (omitting any custom properties)
     *        Note: in Chrome passing undefined will leave the existing value untouched,
     *        whereas Firefox will set it to null)
     *      - Dates, and Arrays, will serialize (omitting any custom properties)
     *      - In Firefox, RegExps, ArrayBuffers, Typed Arrays/Array Views (they make a copy
     *        of their buffer), Maps, and Set s will also serialize (omitting any custom properties)
     *      - Objects containing only the above types will serialize recursively,
     *        but will lose class information (and so prototypes) for all but the above types
     *      - Objects containing properties with unsupported types will be rejected with a
     *        DataCloneError (Firefox) or have each unsupported property replaced by the
     *        empty object (other implementations)
     *      - Unsupported types (Functions, SharedArrayBuffers, Promises, WeakSets,
     *        Errors, Proxys, etc) will be rejected with a DataCloneError (Firefox) or are
     *        accepted and silently replaced by the empty object (other implementations)
     *
     * @return A Promise that will be fulfilled with no arguments if the operation succeeded.
     *      If the operation failed, the promise will be rejected with an error message.
     */
    fun set(keys: dynamic): Promise<Unit>

    /**
     * Removes one or more items from the storage area.
     *
     * @param keys A string, or array of strings, representing the key(s) of the item(s) to be
     *      removed.
     *
     * @return A Promise that will be fulfilled with no arguments if the operation succeeded.
     *      If the operation failed, the promise will be rejected with an error message.
     */
    fun remove(keys: dynamic): Promise<Unit>

    /**
     * Removes all items from the storage area.
     *
     * @return A Promise that will be fulfilled with no arguments if the operation succeeded.
     *      If the operation failed, the promise will be rejected with an error message.
     */
    fun clear(): Promise<Unit>
}

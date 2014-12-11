
package com.dcx.game.component.collection
{
import flash.errors.IllegalOperationError;
import flash.events.Event;

/**
 * Simple enumerator for iterating over the elements of an array.
 */
public class ArrayEnumerator implements Enumerator
{

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
    * @param An array of elements to enumerate.
    */
    public function ArrayEnumerator(array:ProxyArray)
    {
        reset();
        this.array = array;
        this.array.addEventListener(CollectionEvent.COLLECTION_CHANGE,
                                    array_collectionChangeHandler,
                                    false, 0, true);
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    /**
    * @private
    */
    private var isInvalidated:Boolean = false;

    /**
    * @private
    * The internal array to enumerate.
    */
    private var array:ProxyArray;

    /**
    * @private
    * The pointer to the current element.
    */
    private var pointer:int;

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    /**
    * @private
    */
    private var _current:*;

    /**
    * Gets the current element in the collection.
    * <p>After an enumerator is created or after the reset method is called, the
    * moveNext method must be called to advance the enumerator to the first
    * element of the collection before reading the value of the current
    * property; otherwise, current is undefined.</p>
    * <p>Current does not move the position of the enumerator, and consecutive
    * calls to current return the same object until either moveNext or reset is
    * called.</p>
    * @throws IllegalOperationError <code>IllegalOperationError</code> if the
    * last call to moveNext returned false, which indicates the end of the
    * collection -or- if reset has been invoked.</p>
    */
    public function get current():Object
    {
        if (this.array[this.pointer] == undefined)
        {
            throw new IllegalOperationError("Current pointer is undefined.");
        }

        return _current;
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
    * Advances the enumerator to the next element of the collection.
    * @return true if the enumerator was successfully advanced to the next
    * element; false if the enumerator has passed the end of the collection.
    * @throws IllegalOperationError <code>IllegalOperationError</code>If changes
    * are made to the collection, such as adding, modifying, or deleting
    * elements, the enumerator is irrecoverably invalidated and the next call
    * to moveNext or reset throws the exception.
    */
    public function moveNext():Boolean
    {
        if (isInvalidated)
        {
            throwInvalidationError();
        }

        _current = this.array[++this.pointer];
        return _current != undefined;
    }

    /**
    * Sets the enumerator to its initial position, which is before the first
    * element in the collection.
    * @throws IllegalOperationError <code>IllegalOperationError</code>If changes
    * are made to the collection, such as adding, modifying, or deleting
    * elements, the enumerator is irrecoverably invalidated and the next call
    * to moveNext or reset throws the exception.
    */
    public function reset():void
    {
        if (isInvalidated)
        {
            throwInvalidationError();
        }

        this.pointer = -1;
    }

    /**
    * @private
    */
    private function throwInvalidationError():void
    {
        throw new IllegalOperationError("Changes detected in collection.");
    }

    //--------------------------------------------------------------------------
    //
    //  Event handlers
    //
    //--------------------------------------------------------------------------

    /**
    * @private
    */
    private function array_collectionChangeHandler(event:Event):void
    {
        if (event is CollectionEvent)
        {
            isInvalidated = true;
        }
    }

}

}

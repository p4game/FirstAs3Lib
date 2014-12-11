package com.dcx.game.component.collection
{

/**
 * Supports a simple iteration over a nongeneric collection.
 */
public interface Enumerator
{

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    /**
     * The current element in the collection.
     *
     * @throws InvalidOperationException <code>InvalidOperationException</code>
     * The enumerator is positioned before the first element of the collection
     * or after the last element.
     */
    function get current():Object;

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     * Advances the enumerator to the next element of the collection.
     *
     * @return true if the enumerator was successfully advanced to the next
     * element; false if the enumerator has passed the end of the collection.
     * @throws InvalidOperationException <code>InvalidOperationException</code>
     * The collection was modified after the enumerator was created.
     */
    function moveNext():Boolean;

    /**
     * Sets the enumerator to its initial position, which is before the first
     * element in the collection.
     *
     * @throws InvalidOperationException <code>InvalidOperationException</code>
     * The collection was modified after the enumerator was created.
     */
    function reset():void;
}

}

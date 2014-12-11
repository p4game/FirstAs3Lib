
package com.dcx.game.component.collection
{

/**
 * Defines size and enumerators for all nongeneric collections.
 */
public interface Collection extends Enumerable
{

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    /**
    * Gets the number of elements contained in the ICollection.
    */
    function get count():int

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
    * Converts the ICollection to a simple Array.
    * @return an array of the items in the ICollection
    */
    function toArray():Array;
}

}

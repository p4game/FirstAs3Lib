
package com.dcx.game.component.collection
{

/**
 * Represents a non-generic collection of objects that can be individually
 * accessed by index.
 */
public interface List extends Collection, Enumerable
{

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    /**
    * Gets a obj indicating whether the IList has a fixed size.
    */
    function get isFixedSize():Boolean

    /**
    * Gets a obj indicating whether the IList is read-only.
    */
    function get isReadOnly():Boolean;

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
    * Adds an element to the IList.
    * @param obj The element to add.
    */
    function add(obj:Object):int;

    /**
    * Removes all element from the IList.
    */
    function clear():void;

    /**
    * Determines whether the IList contains a specific element.
    */
    function contains(obj:Object):Boolean;

    /**
    * Gets the IList element at the specified index.
    */
    function getItem(index:int):Object;

    /**
    * Determines the index of a specific element in the IList.
    */
    function indexOf(obj:Object):int;

    /**
    * Inserts an element to the IList at the specified index.
    */
    function insert(index:int, obj:Object):void;

    /**
    * Removes the first occurrence of a specific element from the IList.
    */
    function remove(obj:Object):void;

    /**
    * Removes the IList element at the specified index.
    */
    function removeAt(index:int):void;

    /**
    * Sets the IList element at the specified index with the value provided.
    */
    function setItem(index:int, obj:Object):void;
}

}

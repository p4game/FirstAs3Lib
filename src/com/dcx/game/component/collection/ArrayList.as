
package com.dcx.game.component.collection
{

/**
 * Implements the IList interface.
 */
public class ArrayList implements List
{

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    /**
    * @private
    * The internal collection of elements for the ArrayList
    */
    private var elements:ProxyArray = new ProxyArray();

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  count
    //----------------------------------

    /**
    * Returns the number of elements contained in the ArrayList.
    */
    public function get count():int
    {
        return elements.length;
    }

    //----------------------------------
    //  isFixedSize
    //----------------------------------

    /**
    * Gets a value indicating whether the ArrayList has a fixed size.
    */
    public function get isFixedSize():Boolean
    {
        return false;
    }

    //----------------------------------
    //  isReadOnly
    //----------------------------------

    /**
    * Gets a value indicating whether the ArrayList is read-only.
    */
    public function get isReadOnly():Boolean
    {
        return false;
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
    * Adds a new element ot the ArrayList.
    * @param obj The object to add.
    * @return int The updated count of ArrayList elements.
    * @throws ArgumentNullException <code>ArgumentNullException</code> if obj is
    * null.
    */
    public function add(obj:Object):int
    {
        if (obj == null)
        {
            throw new Error();
        }

        return elements.push(obj);
    }

    /**
    * TODO: write documentation
    */
    public function clear():void
    {
        this.elements = new ProxyArray();
    }

    /**
    * TODO: write documentation
    */
    public function contains(obj:Object):Boolean
    {
        return this.elements.indexOf(obj) != -1;
    }

    /**
    * Returns an enumerator that iterates through a collection.
    * @return An IEnumerator object that can be used to iterate through the
    * collection.
    */
    public function getEnumerator():Enumerator
    {
        return new ArrayEnumerator(this.elements);
    }

    /**
    * Gets the element at the specified index.
    * @param The zero-based index of the element to get.
    */
    public function getItem(index:int):Object
    {
        if (index < 0 || index >= this.elements.length)
        {
            throw new Error("Index " + index +
                                                  " is out of range.");
        }

        return this.elements[index];
    }

    /**
    * TODO: write documentation
    */
    public function indexOf(obj:Object):int
    {
        return this.elements.indexOf(obj);
    }

    /**
    * TODO: write documentation
    */
    public function insert(index:int, obj:Object):void
    {
        if (obj == null)
        {
            throw new Error();
        }
        else if (index < 0 || index > this.elements.length)
        {
            throw new Error("Index " + index +
                                                  " is out of range.");
        }

        this.elements.splice(index, 0, obj);
    }

    /**
    * Removes the first occurrence of a specific object from the ArrayList.
    * @param item The object to remove.
    */
    public function remove(obj:Object):void
    {
		var index:int = this.elements.indexOf(obj);
		if (index > -1) this.elements.splice(index, 1);
    }

    /**
    * Removes the element at the specified index of the ArrayList.
    * @param index The zero-based index of the element to remove.
    */
    public function removeAt(index:int):void
    {
        if (index < 0 || index >= this.elements.length)
        {
            throw new Error("Index " + index +
                                                  " is out of range.");
        }

        this.elements.splice(index, 1);
    }

    /**
    * Sets the element at the specified index.
    * @param The zero-based index of the element to set.
    */
    public function setItem(index:int, obj:Object):void
    {
        if (index < 0 || index >= this.elements.length)
        {
            throw new Error("Index " + index +
                                                  " is out of range.");
        }

        this.elements[index] = obj;
    }

    /**
    * TODO: write documentation
    */
    public function toArray():Array
    {
        return this.elements.concat();
    }

}

}

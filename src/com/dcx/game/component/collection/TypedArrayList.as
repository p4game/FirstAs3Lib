
package com.dcx.game.component.collection
{
import flash.utils.getQualifiedClassName;

/**
 * TypeSafe version of ArrayList supports type validation and only allows
 * classes (or subclasses) of the declared type to be used in operations.
 */
public class TypedArrayList extends ArrayList
{

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    public function TypedArrayList(type:Class)
    {
        _type = type;
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  type
    //----------------------------------

    /**
     * @private
     */
    private var _type:Class;

    /**
    * The type to enforce in this collection.
    */
    public function get type():Class
    {
        return _type;
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------

    /**
    * Validates obj type in addition to inherited operations.
    * @throws TypeError <code>TypeError</code> if the instance type is invalid.
    */
    override public function add(obj:Object):int
    {
        validateType(obj);
        return super.add(obj);
    }

    /**
    * Validates obj type in addition to inherited operations.
    * @see ArrayList#contains
    * @throws TypeError <code>TypeError</code> if the instance type is invalid.
    */
    override public function contains(obj:Object):Boolean
    {
        validateType(obj);
        return super.contains(obj);
    }

    /**
    * Validates obj type in addition to inherited operations.
    * @see ArrayList#indexOf
    * @throws TypeError <code>TypeError</code> if the instance type is invalid.
    */
    override public function indexOf(obj:Object):int
    {
        validateType(obj);
        return super.indexOf(obj);
    }

    /**
    * Validates obj type in addition to inherited operations.
    * @see ArrayList#insert
    * @throws TypeError <code>TypeError</code> if the instance type is invalid.
    */
    override public function insert(index:int, obj:Object):void
    {
        validateType(obj);
        super.insert(index, obj);
    }

    /**
    * Validates obj type in addition to inherited operations.
    * @see ArrayList#remove
    * @throws TypeError <code>TypeError</code> if the instance type is invalid.
    */
    override public function remove(obj:Object):void
    {
        validateType(obj);
        super.remove(obj);
    }

    /**
    * Validates obj type in addition to inherited operations.
    * @see ArrayList#setItem
    * @throws TypeError <code>TypeError</code> if the instance type is invalid.
    */
    override public function setItem(index:int, obj:Object):void
    {
        validateType(obj);
        super.setItem(index, obj);
    }

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
    * Validates the type of instance against the declared type of this list.
    * @param instance The object to validate.
    * @throws TypeError <code>TypeError</code> if the instance type is invalid.
    */
    public function validateType(instance:*):void
    {
        if (!(instance is type))
        {
            throw new TypeError(getQualifiedClassName(instance) +
                                " is not of Type " +
                                getQualifiedClassName(type));
        }
    }
}

}

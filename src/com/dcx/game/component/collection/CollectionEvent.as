////////////////////////////////////////////////////////////////////////////////
//
//  MICROSOFT CORPORATION
//  Copyright (c) Microsoft Corporation.
//  All Rights Reserved.
//
//  NOTICE: Microsoft Confidential. Intended for Internal Use Only.
//
////////////////////////////////////////////////////////////////////////////////

package com.dcx.game.component.collection
{
import flash.events.Event;

/**
 * The CollectionEvent class defines events that are associated with changes in
 * a ProxyArray.
 */
public class CollectionEvent extends Event
{

    //--------------------------------------------------------------------------
    //
    //  Class constants
    //
    //--------------------------------------------------------------------------

    public static const COLLECTION_CHANGE:String = "collectionChange";

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
    * Creates a new CollectionEvent object.
    */
    public function CollectionEvent(type:String)
    {
        super(type, false, false);
    }

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------

    /**
    * Creates a copy of the CollectionEvent object and sets the value of each
    * parameter to match the original.
    * @return A copy of the CollectionEvent instance.
    */
    override public function clone():Event
    {
        return new CollectionEvent(this.type);
    }

    /**
    * Returns a string that contains all the properties of the CollectionEvent
    * object.
    * @return A string representation of the CollectionEvent object.
    */
    override public function toString():String
    {
        return formatToString("CollectionEvent", "type", "bubbles",
                              "cancelable");
    }

}

}

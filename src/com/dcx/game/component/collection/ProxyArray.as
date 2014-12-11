
package com.dcx.game.component.collection
{

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;
import flash.utils.Proxy;
import flash.utils.flash_proxy;

/**
 * Overrides indexed property accessors and mutators to detect changes to the
 * internal array collection. Dispatched a CollectionEvent if the collection or
 * any elements in the collection have been modified.
 */
public dynamic class ProxyArray extends Proxy implements IEventDispatcher
{
    //TODO Support enumeration of the proxied array's properties
    //     e.g. for...in (name) and for...each (value)

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
    * Create a new ProxyArray.
    */
    public function ProxyArray(... rest)
    {
        // Clone the args to ensure we're not assigning a pointer to another
        // array somewhere.
        this.items = rest.concat();
    }

    //--------------------------------------------------------------------------
    //
    //  Variables
    //
    //--------------------------------------------------------------------------

    /**
    * @private
    * The internal collection.
    */
    private var items:Array = [];
    
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	private var _dispatcher:IEventDispatcher = null;
	
	/**
	 * Returns the composited IEventDispatcher instance.
	 */
	protected function get dispatcher():IEventDispatcher
    {
        return _dispatcher || (_dispatcher = createDispatcher());
    }

    //--------------------------------------------------------------------------
    //
    //  Overridden methods
    //
    //--------------------------------------------------------------------------

    /**
    * @private
    * Delegate method calls to the internal array.
    */
    override flash_proxy function callProperty(methodName:*, ... rest):*
    {
        var eventRequired:Boolean = false;
        var result:* = items[methodName].apply(items, rest);

        if (methodName is QName)
        {
            methodName = QName(methodName).localName;
        }

        switch (methodName)
        {
            case "pop":
            case "push":
            case "reverse":
            case "shift":
            case "sort":
            case "sortOn":
            case "splice":
            case "unshift":
            {
                dispatchEvent(new CollectionEvent(
                        CollectionEvent.COLLECTION_CHANGE));
                break;
            }
            default:
            {
                break;
            }
        }

        return result;
    }

    /**
    * @private
    * Delegate accessors to the internal array.
    */
    override flash_proxy function getProperty(name:*):*
    {
        return this.items[name];
    }

    /**
    * @private
    * Delegate mutators to the internal array and dispatch change event.
    */
    override flash_proxy function setProperty(name:*, value:*):void
    {
        this.items[name] = value;
        dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE));
    }

    /**
    * @private
    * Delegate delete operations to internal array.
    */
    override flash_proxy function deleteProperty(name:*):Boolean
    {
        var success:Boolean = delete this.items[name];
        dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE));
        return success;
    }

    /**
    * @private
    */
    override flash_proxy function nextNameIndex(index:int):int
    {
        if (index < this.items.length)
        {
            return index + 1;
        }
        else
        {
            return 0;
        }
    }

    /**
    * @private
    */
    override flash_proxy function nextName(index:int):String
    {
        return this.items[index - 1];
    }

    /**
    * @private
    */
    override flash_proxy function nextValue(index:int):*
    {
        return this.items[index - 1];
    }

	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * Registers an event listener object with an EventDispatcher object so that
	 * the listener receives notification of an event.
	 *
	 * @see flash.events.IEventDispatcher#addEventListener
	 */
	public function addEventListener(type:String, listener:Function,
	                                 useCapture:Boolean = false, priority:int = 0,
	                                 useWeakReference:Boolean = false):void
	{
	    this.dispatcher.addEventListener(type, listener, useCapture, priority,
	                                     useWeakReference);
    }
    
    /**
     * Removes a listener from the EventDispatcher object.
     *
     * @see flash.events.IEventDispatcher#removeEventListener
     */
    public function removeEventListener(type:String, listener:Function,
                                        useCapture:Boolean = false):void
    {
        this.dispatcher.removeEventListener(type, listener, useCapture);
    }
    
    /**
     * Dispatches an event into the event flow.
     *
     * @see flash.events.IEventDispatcher#dispatchEvent
     */
    public function dispatchEvent(event:Event):Boolean
    {
        return this.dispatcher.dispatchEvent(event);
    }
    
    /**
     * Checks whether the EventDispatcher object has any listeners registered
     * for a specific type of event.
     *
     * @see flash.events.IEventDispatcher#hasEventListener
     */
    public function hasEventListener(type:String):Boolean
    {
        return this.dispatcher.hasEventListener(type);
    }
    
    /**
     * Checks whether an event listener is registered with this EventDispatcher
     * object or any of its ancestors for the specified event type.
     *
     * @see flash.events.IEventDispatcher#willTrigger
     */
    public function willTrigger(type:String):Boolean
    {
        return this.dispatcher.willTrigger(type);
    }
    
    /**
     * Create new EventDispatcher; override this method for endo-testing, etc.
     */
    protected function createDispatcher():IEventDispatcher
    {
        return new EventDispatcher(this);
    }

}

}

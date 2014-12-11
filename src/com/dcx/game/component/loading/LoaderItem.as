package com.dcx.game.component.loading
{

import com.dcx.game.component.queue.QueueEvent;
import com.dcx.game.events.AssetTotalBytesEvent;

import flash.display.Loader;
import flash.events.Event;
import flash.events.IEventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLRequest;
import flash.system.LoaderContext;

//--------------------------------------
//  Events
//--------------------------------------
/**
 * Dispatched when data has loaded successfully.
 * @eventType flash.events.Event.COMPLETE
 */
[Event(name="complete", type="flash.events.Event")]

/**
 * Dispatched when the properties and methods of
 * a loaded SWF or image file are accessible.
 * @eventType flash.events.Event.INIT
 */
[Event(name="init", type="flash.events.Event")]

/**
 * Dispatched when data is received as the download operation progresses.
 * @eventType flash.events.ProgressEvent.PROGRESS
 */
[Event(name="progress", type="flash.events.ProgressEvent")]

/**
 * Dispatched when bytesTotal data is changed
 * during the download operation progresses.
 * @eventType AssetTotalBytesEvent.CHANGE
 */
[Event(name="change", type="com.dcx.game.events.AssetTotalBytesEvent")]

/**
 * Dispatched when an input or output error occurs
 * that causes a load operation to fail.
 * @eventType flash.events.IOErrorEvent.IO_ERROR
 */
[Event(name="ioError", type="flash.events.IOErrorEvent")]

/**
 * Dispatched if a call to LoaderItem.start() results in a fatal
 * network error that terminates the download.
 * @eventType flash.events.IOErrorEvent.NETWORK_ERROR
 */
[Event(name="networkError", type="flash.events.IOErrorEvent")]

/**
 * Dispatched if a call to LoaderItem.start() results in a fatal
 * disk error that terminates the download.
 * @eventType flash.events.IOErrorEvent.DISK_ERROR
 */
[Event(name="diskError", type="flash.events.IOErrorEvent")]

/**
 * Dispatched if a call to LoaderItem.start() results in a fatal
 * verify error that terminates the download.
 * @eventType flash.events.IOErrorEvent.VERIFY_ERROR
 */
[Event(name="verifyError", type="flash.events.IOErrorEvent")]

/**
 * Dispatched if a call to LoaderItem.start() attempts to load
 * data from a server outside the security sandbox.
 * @eventType flash.events.SecurityErrorEvent.SECURITY_ERROR
 */
[Event(name="securityError", type="flash.events.SecurityErrorEvent")]

/**
 * Leaf node of asset loading composite system; used to load SWF files or
 * image (JPG, PNG, or GIF) files.
 *
 */
public class LoaderItem extends AbstractLoader
{

    private var _url:String;
    private var _bytesTotal:uint;
    private var _loader:Loader;
    private var _loaderContext:LoaderContext;

    private function get loader():Loader
    {
        return _loader || (_loader = createLoader());
    }

//--------------------------------------------------------------------------
//
//  Constructor
//
//--------------------------------------------------------------------------

    /**
     * LoaderItem is a wrapper class for <code>flash.display.Loader</code>,
     * and is a leaf node in the composite asset loading system.
     *
     * @param url URL to load.
     * @param bytesTotal Total size of asset in bytes (optional).
     * @param loader Override default internal <code>Loader</code>.
     * (optional)
     */
    public function LoaderItem(url:String, bytesTotal:uint = 0)
    {
        super(this);

        _url = url;
        _bytesTotal = bytesTotal;
        _loaderContext = null;
    }

//--------------------------------------------------------------------------
//
//  Property Overrides
//
//--------------------------------------------------------------------------

    /**
     * Returns the total bytes.
     *
     * @return <code>uint</code> of total bytes.
     */
    override public function get bytesTotal():uint
    {
        return _bytesTotal;
    }

    /**
     * Returns the total bytes loaded.
     *
     * @return <code>uint</code> of bytes currently loaded.
     */
    override public function get bytesLoaded():uint
    {
        return this.loader.contentLoaderInfo.bytesLoaded;
    }

    /**
     * Returns the native <code>Loader</code> object.
     * @see flash.display.Loader
     * @return <code>Loader</code> containing the loaded content.
     */
    override public function get content():*
    {
        return this.loader;
    }

    /**
     * Returns url to load.
     *
     * @return <code>String</code> URL of the asset to load.
     */
    override public function get url():String
    {
        return _url;
    }

    /**
     * Gets the LoaderContext for this LoaderItem
     */
    override public function get loaderContext():LoaderContext
    {
        return _loaderContext;
    }

    /**
     * Sets the LoaderContext for this LoaderItem
     */
    override public function set loaderContext(value:LoaderContext):void
    {
        _loaderContext = value;
    }

//--------------------------------------------------------------------------
//
//  Method Overrides
//
//--------------------------------------------------------------------------

    /**
     * Begins load() method operation for internal Loader instance.
     */
	public static var loadCount:int = 0;
    override public function start():void
    {
		LoadEnum.count++;
        addAllListeners();
        this.loader.load(new URLRequest(this.url), _loaderContext);
    }

    /**
     * Cancels load() method operation that is currently in progress for
     * the internal Loader instance.
     */
    override public function stop():void
    {
        removeAllListeners();

        try
        {
            this.loader.close();
        }
        catch (error:Error)
        {
            // Likely thrown due to the URLStream object bitching about not
            // having an open stream. Safe to ignore.
        }
    }

//--------------------------------------------------------------------------
//
//  Virtual Methods
//
//--------------------------------------------------------------------------

    protected function createLoader():Loader
    {
        return new Loader();
    }

    protected function get contentDispatcher():IEventDispatcher
    {
        return this.loader.contentLoaderInfo;
    }

//--------------------------------------------------------------------------
//
//  Event Handling
//
//--------------------------------------------------------------------------

    private function addListener(type:String, listener:Function):void
    {
        this.contentDispatcher.addEventListener(type, listener);
    }

    private function removeListener(type:String, listener:Function):void
    {
        this.contentDispatcher.removeEventListener(type, listener);
    }

    private function addAllListeners():void
    {
        addListener(Event.COMPLETE, dispatcher_completeHandler);
        addListener(Event.INIT, dispatcher_initHandler);
        addListener(ProgressEvent.PROGRESS, dispatcher_progressHandler);
        addListener(IOErrorEvent.IO_ERROR, dispatcher_errorHandler);
        addListener(IOErrorEvent.NETWORK_ERROR, dispatcher_errorHandler);
        addListener(IOErrorEvent.DISK_ERROR, dispatcher_errorHandler);
        addListener(IOErrorEvent.VERIFY_ERROR, dispatcher_errorHandler);
        addListener(SecurityErrorEvent.SECURITY_ERROR, dispatcher_errorHandler);
    }

    private function removeAllListeners():void
    {
        removeListener(Event.COMPLETE, dispatcher_completeHandler);
        removeListener(Event.INIT, dispatcher_initHandler);
        removeListener(ProgressEvent.PROGRESS, dispatcher_progressHandler);
        removeListener(IOErrorEvent.IO_ERROR, dispatcher_errorHandler);
        removeListener(IOErrorEvent.NETWORK_ERROR, dispatcher_errorHandler);
        removeListener(IOErrorEvent.DISK_ERROR, dispatcher_errorHandler);
        removeListener(IOErrorEvent.VERIFY_ERROR, dispatcher_errorHandler);
        removeListener(SecurityErrorEvent.SECURITY_ERROR,
                       dispatcher_errorHandler);
    }

    private function dispatchEventAndRemoveListeners(event:Event):void
    {
        dispatchEvent(event);
        removeAllListeners();
    }

    private function dispatcher_progressHandler(event:ProgressEvent):void
    {
        if (event.bytesTotal != this.bytesTotal)
        {
            _bytesTotal = event.bytesTotal;
            dispatchEvent(new AssetTotalBytesEvent(AssetTotalBytesEvent.CHANGE,
                                                   _bytesTotal));
        }
        dispatchEvent(event);
    }

    private function dispatcher_initHandler(event:Event):void
    {
        dispatchEvent(event);
    }

    private function dispatcher_completeHandler(event:Event):void
    {
		LoadEnum.count--;
        dispatchEventAndRemoveListeners(event);
		dispatchEvent(new QueueEvent(QueueEvent.ITEM_COMPLETE));
    }

    private function dispatcher_errorHandler(event:Event):void
    {
		LoadEnum.count--;
        dispatchEventAndRemoveListeners(event);
		dispatchEvent(new QueueEvent(QueueEvent.ITEM_COMPLETE));
    }
}

}

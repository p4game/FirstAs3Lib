package com.dcx.game.component.loading
{

import com.dcx.game.component.queue.QueueEvent;
import com.dcx.game.events.AssetTotalBytesEvent;

import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;

//--------------------------------------
//  Events
//--------------------------------------
/**
 * Dispatched when the download operation commences
 * following a call to the URLLoaderItem.start() method.
 * @eventType flash.events.Event.OPEN
 */
[Event(name="open", type="flash.events.Event")]

/**
 * Dispatched after all the received data is decoded and placed
 * in the data property of the URLLoaderItem object.
 * @eventType flash.events.Event.COMPLETE
 */
[Event(name="complete", type="flash.events.Event")]

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
 * Dispatched if a call to URLLoaderItem.start() results in a fatal
 * error that terminates the download.
 * @eventType flash.events.IOErrorEvent.IO_ERROR
 */
[Event(name="ioError", type="flash.events.IOErrorEvent")]

/**
 * Dispatched if a call to URLLoaderItem.start() results in a fatal
 * network error that terminates the download.
 * @eventType flash.events.IOErrorEvent.NETWORK_ERROR
 */
[Event(name="networkError", type="flash.events.IOErrorEvent")]

/**
 * Dispatched if a call to URLLoaderItem.start() results in a fatal
 * disk error that terminates the download.
 * @eventType flash.events.IOErrorEvent.DISK_ERROR
 */
[Event(name="diskError", type="flash.events.IOErrorEvent")]

/**
 * Dispatched if a call to URLLoaderItem.start() results in a fatal
 * verify error that terminates the download.
 * @eventType flash.events.IOErrorEvent.VERIFY_ERROR
 */
[Event(name="verifyError", type="flash.events.IOErrorEvent")]

/**
 * Dispatched if a call to URLLoaderItem.start() attempts to load
 * data from a server outside the security sandbox.
 * @eventType flash.events.SecurityErrorEvent.SECURITY_ERROR
 */
[Event(name="securityError", type="flash.events.SecurityErrorEvent")]

/**
 * Leaf node of asset loading composite system; downloads data from a URL as
 * text, binary data, or URL-encoded variables.
 *
 */
public class URLLoaderItem extends AbstractLoader
{

	/**
	 * Builder method for creating a URLLoaderItem with custom request object.
	 */
	public static function createWithRequest(request:URLRequest,
	                                         estimatedBytesTotal:int = 0
	                                         ):URLLoaderItem
	{
		var loader:URLLoaderItem = new URLLoaderItem(null, estimatedBytesTotal);
		loader.request = request;
		return loader;
	}

    /**
    * Represents the internal URLRequest object
    */
	private var request:URLRequest;
	protected function set _url(value:String):void
	{
		request.url = value;
	}

    /**
     * @return loader
     */
    private var _loader:URLLoader;
    private function get loader():URLLoader
    {
    	// return obj if not null else assign and return
        return _loader ||= createLoader();
    }

	public function set dataFormat(value:String):void
	{
		loader.dataFormat = value;
	}
    public function URLLoaderItem(url:String, bytesTotal:uint = 0)
    {
        super(this);
        request = url ? new URLRequest(url) : null;
        _bytesTotal = bytesTotal;
    }

    /**
     * instantiates a new loader and returns it
     *
     * @return a new URLLoader ready to be used.
     */
    protected function createLoader():URLLoader
    {
        return new URLLoader();
    }

    /**
     * Begins the load
     */
    override public function start():void
    {
    	if (null == request)
    	{
    		throw new Error("Invalid loader state -- " +
    		        "target url is null or undefined.");
        }
		LoadEnum.count++;
        addLoaderListeners();
        loader.load(request);
    }

    /**
     * Stops the load immediately
     */
    override public function stop():void
    {
        removeLoaderListeners();

        try
        {
            loader.close();
        }
        catch (error:Error)
        {
            // Likely thrown due to the URLStream object bitching about not
            // having an open stream. Safe to ignore.
        }
    }

    /**
     * Returns the untyped content of the loader
     *
     * @return
     */
    override public function get content():*
    {
        return loader.data;
    }

    /**
    * Return the url to load
    *
    * @return String url
    */
    override public function get url():String
    {
        return request.url;
    }

    private function dispatchEventAndRemoveListeners(event:Event):void
    {
        dispatchEvent(event);
        removeLoaderListeners();
    }

    private function loader_progressHandler(event:ProgressEvent):void
    {
        if (event.bytesTotal != _bytesTotal)
        {
            _bytesTotal = event.bytesTotal;
            var assetEvent:AssetTotalBytesEvent =
                new AssetTotalBytesEvent(AssetTotalBytesEvent.CHANGE,
                                         _bytesTotal)
            dispatchEvent(assetEvent);
        }
        dispatchEvent(event);
    }

    private function loader_startHandler(event:Event):void
    {
        dispatchEvent(event);
    }

    private function addLoaderListeners():void
    {
        loader.addEventListener(Event.COMPLETE, loader_completeHandler);
        loader.addEventListener(Event.INIT, loader_startHandler);
        loader.addEventListener(ProgressEvent.PROGRESS,
                                     loader_progressHandler);
        loader.addEventListener(IOErrorEvent.IO_ERROR,
                                     loader_errorHandler);
        loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,
                                     loader_errorHandler);
        loader.addEventListener(IOErrorEvent.NETWORK_ERROR,
                                     loader_errorHandler);
        loader.addEventListener(IOErrorEvent.DISK_ERROR,
                                     loader_errorHandler);
        loader.addEventListener(IOErrorEvent.VERIFY_ERROR,
                                     loader_errorHandler);
    }

    private function removeLoaderListeners():void
    {
        loader.removeEventListener(Event.COMPLETE, loader_completeHandler);
        loader.removeEventListener(Event.INIT, loader_startHandler);
        loader.removeEventListener(ProgressEvent.PROGRESS,
                                        loader_progressHandler);
        loader.removeEventListener(IOErrorEvent.IO_ERROR,
                                        loader_errorHandler);
        loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,
                                        loader_errorHandler);
        loader.removeEventListener(IOErrorEvent.NETWORK_ERROR,
                                        loader_errorHandler);
        loader.removeEventListener(IOErrorEvent.DISK_ERROR,
                                        loader_errorHandler);
        loader.removeEventListener(IOErrorEvent.VERIFY_ERROR,
                                        loader_errorHandler);
    }

    /**
     * Invoked when the download is complete.
     * This can be overridden in the inherited class
     */
    protected function loader_completeHandler(event:Event):void
    {
		LoadEnum.count--;
		dispatchEvent(new QueueEvent(QueueEvent.ITEM_COMPLETE));
        dispatchEventAndRemoveListeners(event);
    }

    /**
     * Invoked when there is a fatalerror that terminates the download.
     * This can be overridden in the inherited class
     */
    protected function loader_errorHandler(event:Event):void
    {
		LoadEnum.count--;
        dispatchEventAndRemoveListeners(event);
    }

    /**
     * Returns the total bytes of all children
     * @return
     */
    private var _bytesTotal:uint;
    override public function get bytesTotal():uint
    {
        return _bytesTotal;
    }

    /**
     * Returns the total bytes loaded of all children
     * @return
     */
    override public function get bytesLoaded():uint
    {
        return loader.bytesLoaded;
    }
}

}

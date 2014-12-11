package com.dcx.game.component.loading
{

import com.dcx.game.component.collection.Enumerator;
import com.dcx.game.core.UnsupportedMethodException;
import com.dcx.game.events.AssetTotalBytesEvent;

import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;

//--------------------------------------
//  Events
//--------------------------------------
/**
 * Dispatched when all AbstractLoader objects have completed.
 * @eventType flash.events.Event.COMPLETE
 */
[Event(name="complete", type="flash.events.Event")]

/**
 * Dispatched when the download operation commences
 * following a call to the ConcurrentLoader.start() method.
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
 * Composite class for loading AbstractLoader objects all at the same time
 *
 */
public class ConcurrentLoader extends AbstractLoaderComposite
{

    private var numFinished:uint = 0;

    public function ConcurrentLoader()
    {
        super(this);
    }

    /**
     * Adds item to list
     *
     * @param item AbstractLoader to be added to the list
     */
    override public function add(loader:AbstractLoader):void
    {
        super.add(loader);

        if (this.isRunning)
        {
            loader.start();
        }
    }

    /**
     * Starts to load exiting item in the queue
     */
    override public function start():void
    {
        dispatchEvent(new Event(Event.INIT));
        this.isRunning = RUNNING;

        if (this.loadQueue.count > 0)
        {
            load();
        }
        else
        {
            dispatchComplete();
        }
    }

    /**
     * Stops the load of all currently loading AbstractLoaders
     */
    override public function stop():void
    {
        this.isRunning = IDLE;
        for(var e:Enumerator = this.loadQueue.getEnumerator(); e.moveNext();)
        {
            AbstractLoader(e.current).stop();
        }
    }

    /**
     *  Pauses the queues of any child composites.  Any non composite will
     * continue to load.
     */
    override public function pause():void
    {
        this.isRunning = IDLE;
        for(var e:Enumerator = this.loadQueue.getEnumerator(); e.moveNext();)
        {
            pauseChildComponent(AbstractLoader(e.current));
        }
    }

    protected function load():void
    {
        for(var e:Enumerator = this.loadQueue.getEnumerator(); e.moveNext();)
        {
            addItemListeners(AbstractLoader(e.current));
            AbstractLoader(e.current).start();
        }
    }

    private function pauseChildComponent(component:AbstractLoader):void
    {
        try
        {
            component.pause();
        }
        catch (e:UnsupportedMethodException)
        { /* Ignore if pause is unimplemented */ }
    }

    private function calcBytesTotal():uint
    {
        var bytesTotal:uint = 0;

        for(var e:Enumerator = this.loadQueue.getEnumerator(); e.moveNext();)
        {
            bytesTotal += AbstractLoader(e.current).bytesTotal;
        }

        return bytesTotal;
    }

    private function calcBytesLoaded():uint
    {
        var bytesLoaded:uint;
        for(var e:Enumerator = this.loadQueue.getEnumerator(); e.moveNext();)
        {
            bytesLoaded += AbstractLoader(e.current).bytesLoaded;
        }

        return bytesLoaded;
    }

    private function completeHandler(e:Event):void
    {
        removeItemListeners(AbstractLoader(e.currentTarget));
        checkIfAllComplete();
    }

    private function ioErrorEventHandler(e:Event):void
    {
        removeItemListeners(AbstractLoader(e.currentTarget));
        checkIfAllComplete();
    }

    private function checkIfAllComplete():void
    {
        this.numFinished++;

        if (this.loadQueue.count == this.numFinished)
        {
             dispatchComplete();
        }
    }

    private function dispatchComplete():void
    {
        this.isLoading = IDLE;
        dispatchEvent(new Event(Event.COMPLETE));
    }

    private function progressHandler(e:ProgressEvent):void
    {
        var progressEvent:ProgressEvent =
            new ProgressEvent(ProgressEvent.PROGRESS);
        progressEvent.bytesLoaded = calcBytesLoaded();
        progressEvent.bytesTotal = calcBytesTotal();

        dispatchEvent(new AssetTotalBytesEvent(AssetTotalBytesEvent.CHANGE,
                                               this.bytesTotal));
        dispatchEvent(progressEvent);
    }

    private function addItemListeners(loadItem:AbstractLoader):void
    {
        loadItem.addEventListener(Event.COMPLETE, completeHandler);
        loadItem.addEventListener(IOErrorEvent.IO_ERROR,
                                  ioErrorEventHandler);
        loadItem.addEventListener(SecurityErrorEvent.SECURITY_ERROR,
                                  ioErrorEventHandler);
        loadItem.addEventListener(IOErrorEvent.NETWORK_ERROR,
                                  ioErrorEventHandler);
        loadItem.addEventListener(IOErrorEvent.DISK_ERROR,
                                  ioErrorEventHandler);
        loadItem.addEventListener(IOErrorEvent.VERIFY_ERROR,
                                  ioErrorEventHandler);
        loadItem.addEventListener(ProgressEvent.PROGRESS, progressHandler);
    }

    private function removeItemListeners(loadItem:AbstractLoader):void
    {
        loadItem.removeEventListener(Event.COMPLETE, completeHandler);
        loadItem.removeEventListener(IOErrorEvent.IO_ERROR,
                                     ioErrorEventHandler);
        loadItem.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,
                                     ioErrorEventHandler);
        loadItem.removeEventListener(IOErrorEvent.NETWORK_ERROR,
                                     ioErrorEventHandler);
        loadItem.removeEventListener(IOErrorEvent.DISK_ERROR,
                                     ioErrorEventHandler);
        loadItem.removeEventListener(IOErrorEvent.VERIFY_ERROR,
                                     ioErrorEventHandler);
        loadItem.removeEventListener(ProgressEvent.PROGRESS,
                                     progressHandler);
    }

    /**
     * Returns the total bytes of all children that will be loaded
     *
     * @return number of bytes that will be loaded for all loaders.
     */
    override public function get bytesTotal():uint
    {
        return calcBytesTotal();
    }

    /**
     * Returns the total bytes loaded of all children
     * @return
     */
    override public function get bytesLoaded():uint
    {
        return calcBytesLoaded();
    }
}

}

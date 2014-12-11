package com.dcx.game.component.loading
{

import com.dcx.game.component.collection.Enumerator;
import com.dcx.game.core.UnsupportedMethodException;
import com.dcx.game.events.AssetTotalBytesEvent;

import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;

/**
 * Dispatched when all AbstractLoader objects have completed.
 * @eventType flash.events.Event.COMPLETE
 */
[Event(name="complete", type="flash.events.Event")]

/**
 * Dispatched when the download operation commences
 * following a call to the QueueLoader.start() method.
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
 * Composite class for loading AbstractLoader objects in sequence
 *
 */
public class QueueLoader extends AbstractLoaderComposite
{

    public static const LOADING:Boolean = true;

    private var loadItemIndex:uint = 0;
    public function get currentIndex():uint
    {
    	return loadItemIndex;
    }

    public function QueueLoader()
    {
        super(this);
    }

    /**
     * Returns the total bytes of all children
     * @return
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

    /**
     * Adds item to list
     *
     * @param item
     */
    override public function add(loader:AbstractLoader):void
    {
        super.add(loader);

        if (this.isRunning && !this.isLoading)
        {
            load();
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
     * Stops the load of the currently loading AbstractLoader and freezes
     * the queue
     */
    override public function stop():void
    {
        if (this.isRunning == LOADING)
        {
            getLoader(this.loadItemIndex).stop();
        }

        this.isRunning = IDLE;
    }

    /**
     * Allows the current AbstractLoader to continue loading but freezes
     * the queue
     */
    override public function pause():void
    {
        if (this.isRunning == LOADING)
        {
            try
            {
                getLoader(this.loadItemIndex).pause();
            }
            catch (error:UnsupportedMethodException)
            {
                // Expected error: pause() not implemented in leaves.
            }
        }

        isRunning = IDLE;
    }

    override public function reset():void
    {
        stop();
        this.isLoading = IDLE;
        this.loadItemIndex = 0;
        super.reset();
    }

    protected function load():void
    {
        this.isLoading = LOADING;
        addItemListeners(getLoader(this.loadItemIndex));
        getLoader(this.loadItemIndex).start();
    }

    private function loadNext(loaderComponent:AbstractLoader):void
    {
        removeItemListeners(loaderComponent);
        this.loadItemIndex++;

        if (this.isRunning)
        {
            if (this.loadItemIndex == this.loadQueue.count)
            {
                dispatchComplete();
            }
            else
            {
                load();
            }
        }
    }

    private function calcBytesTotal():uint
    {
        var bytesTotal:int = 0;

        for(var e:Enumerator = this.loadQueue.getEnumerator(); e.moveNext();)
        {
            bytesTotal += AbstractLoader(e.current).bytesTotal;
        }

        return bytesTotal;
    }

    private function calcBytesLoaded():uint
    {
        var bytesLoaded:uint = 0;
        for(var e:Enumerator = this.loadQueue.getEnumerator(); e.moveNext();)
        {
            bytesLoaded += AbstractLoader(e.current).bytesLoaded;
        }

        return bytesLoaded;
    }

    private function loadItem_completeHandler(e:Event):void
    {
        loadNext(AbstractLoader(e.currentTarget));
    }

    private function loadItem_errorHandler(e:Event):void
    {
        loadNext(AbstractLoader(e.currentTarget));
        dispatchEvent(new LoadEvent(LoadEvent.LOAD_ERROR));
    }

    private function dispatchComplete():void
    {
        this.isLoading = IDLE;
        dispatchEvent(new Event(Event.COMPLETE));
    }

    private function getLoader(index:int):AbstractLoader
    {
        return this.loadQueue.getItem(index) as AbstractLoader;
    }

    private function loadItem_progressHandler(e:ProgressEvent):void
    {
        var progressEvent:ProgressEvent =
            new ProgressEvent(ProgressEvent.PROGRESS);
        progressEvent.bytesLoaded = calcBytesLoaded();
        progressEvent.bytesTotal = calcBytesTotal();
        dispatchEvent(progressEvent);
    }

    private function loadItem_changeHandler(event:Event):void
    {
        dispatchEvent(new AssetTotalBytesEvent(AssetTotalBytesEvent.CHANGE,
                calcBytesTotal()));
    }

    private function addItemListeners(loadItem:AbstractLoader):void
    {
        loadItem.addEventListener(Event.COMPLETE, loadItem_completeHandler);
        loadItem.addEventListener(IOErrorEvent.IO_ERROR,
                                  loadItem_errorHandler);
        loadItem.addEventListener(SecurityErrorEvent.SECURITY_ERROR,
                                  loadItem_errorHandler);
        loadItem.addEventListener(IOErrorEvent.NETWORK_ERROR,
                                  loadItem_errorHandler);
        loadItem.addEventListener(IOErrorEvent.DISK_ERROR,
                                  loadItem_errorHandler);
        loadItem.addEventListener(IOErrorEvent.VERIFY_ERROR,
                                  loadItem_errorHandler);
        loadItem.addEventListener(ProgressEvent.PROGRESS,
                                  loadItem_progressHandler);
        loadItem.addEventListener(AssetTotalBytesEvent.CHANGE,
                                  loadItem_changeHandler);
    }

    private function removeItemListeners(loadItem:AbstractLoader):void
    {
        loadItem.removeEventListener(Event.COMPLETE,
                                     loadItem_completeHandler);
        loadItem.removeEventListener(IOErrorEvent.IO_ERROR,
                                     loadItem_errorHandler);
        loadItem.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,
                                     loadItem_errorHandler);
        loadItem.removeEventListener(IOErrorEvent.NETWORK_ERROR,
                                     loadItem_errorHandler);
        loadItem.removeEventListener(IOErrorEvent.DISK_ERROR,
                                     loadItem_errorHandler);
        loadItem.removeEventListener(IOErrorEvent.VERIFY_ERROR,
                                     loadItem_errorHandler);
        loadItem.removeEventListener(ProgressEvent.PROGRESS,
                                     loadItem_progressHandler);
        loadItem.removeEventListener(AssetTotalBytesEvent.CHANGE,
                                     loadItem_changeHandler);
    }
}

}

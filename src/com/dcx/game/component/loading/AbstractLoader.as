package com.dcx.game.component.loading
{


import com.dcx.game.component.queue.IQueue;
import com.dcx.game.core.UnsupportedMethodException;

import flash.events.EventDispatcher;
import flash.system.LoaderContext;
import flash.utils.getQualifiedClassName;

/**
 * The AbstractLoader abstract class forms the base of all components in
 * the loader composite.
 */
public class AbstractLoader extends EventDispatcher implements IQueue
{

    /**
     * Gets the url for which the loader will be loading.
     * 
     * @throws UnsupportedMethodException  abstract class should not be 
     * instantiated
     */
    public function get url():String
    {
        throw new UnsupportedMethodException();
    }

    /**
     * Sets the url to which the loader will be loading.  The loader is as 
     * generic as possible.  Valid urls are whatever flash can load using
     * a loader whether it be an image, external swf, xml and the like.
     * 
     * @param value : a valid url that will be loading the resource.
     * @throws UnsupportedMethodException  abstract class should not be 
     * instantiated
     */
    public function set url(value:String):void
    {
        throw new UnsupportedMethodException();
    }

    /**
     * Gets the content of the loaded loader.  For example the image bitmap
     * data, or the xml data.
     * 
 	 * @throws UnsupportedMethodException  abstract class should not be 
     * instantiated
     */
    public function get content():*
    {
        throw new UnsupportedMethodException();
    }

    /**
     * Gets the number of bytes loaded for the current loader that is being
     * loaded.
     * 
     * @throws UnsupportedMethodException  abstract class should not be 
     * instantiated
     */
    public function get bytesLoaded():uint
    {
        throw new UnsupportedMethodException();
    }

    /**
     * Gets the total number of bytes that will be loaded for this loader.
     * 
     * @throws UnsupportedMethodException  abstract class should not be 
     * instantiated
     */
    public function get bytesTotal():uint
    {
        throw new UnsupportedMethodException();
    }

    /**
     * Gets the reference to the loader context of the loader that was loaded.
     * 
     * @throws UnsupportedMethodException  abstract class should not be 
     * instantiated
     */
    public function get loaderContext():LoaderContext
    {
        throw new UnsupportedMethodException();
    }
    
    /**
     * Sets the LoaderContext of the loader that is being loaded
     * 
     * @throws UnsupportedMethodException  abstract class should not be 
     * instantiated
     */
    public function set loaderContext(value:LoaderContext):void
    {
        throw new UnsupportedMethodException();
    }
    
    /**
     * Abstract class defines interface for asset loading composites and
     * leaves.
     *
     * @param self Prevents class from being instantiated.
     */
    public function AbstractLoader(self:AbstractLoader)
    {
        if (self != this)
        {
            throw new ArgumentError(getQualifiedClassName(this) +
                                    " cannot be instantiated.");
        }
    }

    /**
     * Composite method to initiate the loading of all the loaders.
     * 
     * @throws UnsupportedMethodException  abstract class should not be 
     * instantiated
     */
    public function start():void
    {
        throw new UnsupportedMethodException();
    }

    /**
     * Immediately stops the loading process and cleans up 
     * 
     * @throws UnsupportedMethodException  abstract class should not be 
     * instantiated
     */
    public function stop():void
    {
        throw new UnsupportedMethodException();
    }

    /**
     * Immediately pauses the loading, but does not clean up so that a resume
     * method can be called.
     * 
     * @throws UnsupportedMethodException  abstract class should not be 
     * instantiated
     */
    public function pause():void
    {
        throw new UnsupportedMethodException();
    }

    /**
     * Adds an abstract loader to the composite hierarchy.  May be a leaf or 
     * branch.
     * 
     * @param item any non null abstract loader that will be added to the 
     * composite
     * @throws UnsupportedMethodException  abstract class should not be 
     * instantiated
     */
    public function add(item:AbstractLoader):void
    {
        throw new UnsupportedMethodException();
    }

    /**
     * Adds and abstract loader to a specific point in the composite hierarchy.
     * Primarily used when the loading order needs to be explicitly handled.
     * 
     * @param item any non null abstract loader that will be added to the 
     * composite
     * @param index to which the loader item will be added
     * @throws UnsupportedMethodException  abstract class should not be 
     * instantiated
     */
    public function insert(item:AbstractLoader, index:int):void
    {
        throw new UnsupportedMethodException();
    }

    /**
     * Removes the abstract loader from the loader composite.  This could also
     * affect all children composites and leaves, depending on the structure
     * of the data being loaded.
     * 
     * @param item that will be removed from the loader hierarchy.
     * @throws UnsupportedMethodException  abstract class should not be 
     * instantiated
     */
    public function remove(item:AbstractLoader):void
    {
        throw new UnsupportedMethodException();
    }

    /**
     * Gets a child of the specified index of the this abstract loader. 
     * 
     * @param index of the abstract loader that is requested
     * @return the abstract loader that matches the index in the hierarchy.
     * null if that index is not found
     * @throws UnsupportedMethodException  abstract class should not be 
     * instantiated
     */
    public function getChild(index:int):AbstractLoader
    {
        throw new UnsupportedMethodException();
    }
}

}

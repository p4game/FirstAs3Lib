package com.dcx.game.component.loading
{



import flash.utils.getQualifiedClassName;

/**
 * Abstract Base Class which handles the list operations for composite
 * AbstractLoaders
 *
 * @see AbstractLoader
 *
 */
public class AbstractLoaderComposite extends AbstractLoader
{

    public var _name:String;

    protected var loadQueue:LoaderCollection = new LoaderCollection();
    protected var isRunning:Boolean = false;
    protected var isLoading:Boolean = false;

    public static const IDLE:Boolean = false;
    public static const RUNNING:Boolean = true;

    /**
     * @param self keeps class from being instantiated
     */
    public function AbstractLoaderComposite(self:AbstractLoaderComposite)
    {
        super(this);

        if (self != this)
        {
            throw new ArgumentError(getQualifiedClassName(this) +
                                    " cannot be instantiated.");
        }
    }

    /**
     * Returns the number of loaders in this list. It does not check the number
     * of child composites that could be added to this composite
     *
     * @return number of loaders in this composite.
     */
    public function get length():uint
    {
        return this.loadQueue.count;
    }

    /**
     * Add AbstractLoader to this list of abstract loaders
     *
     * @param item any abstract loader that is not null.
     */
    override public function add(loader:AbstractLoader):void
    {
        this.loadQueue.add(loader);
    }

    /**
     * Looks up the loader and attempts remove the loader from the loading 
     * bin. If no loader is found, no action is taken
     *
     * @param loader to be removed from the loading bin.
     */
    override public function remove(loader:AbstractLoader):void
    {
        this.loadQueue.remove(loader);
    }

    /**
     * Empties out this loading bin and starts fresh.
     */
    public function reset():void
    {
        this.loadQueue.clear();
    }

    /**
     * Returns the AbstractLoader at the index passed in. 
     *
     * @param index of the requested loader
     * @return the abstract loader that was requested.
     * @throws ArgumentOutOfRangeException if no item is found.
     */
    override public function getChild(index:int):AbstractLoader
    {
        return AbstractLoader(this.loadQueue.getItem(index));
    }

    /**
     * Inserts loader in the list at the specified index.  This will push
     * all subsequent loaders down the list.
     *
     * @param loader of which will be inserted into the loader bin.
     * @param index to where the loader will be inserted.
     * @throws ArgumentNullException if the loader is null
     * @throws ArgumentOutOfRangeException if the specified index is outside the
     * bounds of the loader bin.
     */
    override public function insert(loader:AbstractLoader, index:int):void
    {
        this.loadQueue.insert(index, loader);
    }

}

}

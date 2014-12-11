
package com.dcx.game.core
{

/**
 * Base interface for classes which need to free their memories.
 */
public interface Disposable
{
    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

    /**
     * Frees memory that is used.
     */
    function dispose():void
}
}
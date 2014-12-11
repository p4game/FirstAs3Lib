
package com.dcx.game.component.collection
{

/**
 * Exposes the enumerator, which supports a simple iteration over a non-generic
 * collection.
 */
public interface Enumerable
{

    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    /**
     * Exposes the enumerator, which supports a simple iteration over a
     * non-generic collection.
     */
    function getEnumerator():Enumerator;
}

}

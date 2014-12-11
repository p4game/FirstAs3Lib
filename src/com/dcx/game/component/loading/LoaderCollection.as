package com.dcx.game.component.loading
{

import com.dcx.game.component.collection.TypedArrayList;

/**
 * TypedArrayList for AbstractLoader elements.
 * @see TypedArrayList
 */
public class LoaderCollection extends TypedArrayList
{

    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    public function LoaderCollection()
    {
        super(AbstractLoader);
    }
}

}

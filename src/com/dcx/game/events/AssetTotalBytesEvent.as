
package com.dcx.game.events
{

import flash.events.Event;

public class AssetTotalBytesEvent extends Event
{

    private var _totalBytes:uint;

    public static const CHANGE:String = "change";

    public function AssetTotalBytesEvent(type:String, totalBytes:uint,
                                         bubbles:Boolean = false,
                                         cancelable:Boolean = false)
    {
        super(type, bubbles, cancelable);
        _totalBytes = totalBytes;
    }

    public function get totalBytes():uint
    {
        return _totalBytes;
    }
}

}

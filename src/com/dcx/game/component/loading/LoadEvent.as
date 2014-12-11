package com.dcx.game.component.loading
{
	import flash.events.Event;

	public class LoadEvent extends Event
	{
		//public static const LOAD_COMPLETE:String = "loadComplete";
		public static const LOAD_ERROR:String = "loadError";
		//public static const LOAD_PROGRESS:String = "loadProgress";
		public function LoadEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
package com.dcx.game.component.queue
{
	import flash.events.Event;

	public class QueueEvent extends Event
	{
		public static const ALL_COMPLETE:String = "queueComplete";
		public static const ITEM_START:String = "itemStart";
		public static const ITEM_COMPLETE:String = "itemComplete";
		public function QueueEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}
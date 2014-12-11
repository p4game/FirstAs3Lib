package com.dcx.game.component.queue
{
	import com.dcx.game.core.UnsupportedMethodException;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	[Event(name="itemComplete", type="com.dcx.game.component.queue.QueueEvent")]
	[Event(name="itemStart", type="com.dcx.game.component.queue.QueueEvent")]
	public class QueueItem extends EventDispatcher implements IQueue
	{
		public function QueueItem()
		{
		}
		
		public function start():void
		{
			throw new UnsupportedMethodException(UnsupportedMethodException.OVERRIDE);
		}
		public function complete():void
		{
			dispatchEvent(new QueueEvent(QueueEvent.ITEM_COMPLETE));
		}
	}
}
package com.dcx.game.component.queue
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.ProgressEvent;
	import flash.utils.Dictionary;

	[Event(name="allComplete", type="com.dcx.game.component.queue.QueueEvent")]
	[Event(name="itemComplete", type="com.dcx.game.component.queue.QueueEvent")]
	[Event(name="progress", type="flash.events.ProgressEvent")]
	public class ConcurrentQueue extends EventDispatcher
	{
		public function ConcurrentQueue()
		{
		}
		private var loadedByte:Number = 0;
		private var total:int = 0;
		private var count:int = 0;
		private var isStart:Boolean;
		protected var itemList:Array = [];
		private var progressMap:Dictionary = new Dictionary();
		public function add(item:IQueue):void
		{
			total++;
			itemList.push(item);
			IEventDispatcher(item).addEventListener(QueueEvent.ITEM_COMPLETE, onItemComplete, false, -1);
			IEventDispatcher(item).addEventListener(ProgressEvent.PROGRESS, onProgressEventHandler);
			IEventDispatcher(item).addEventListener(QueueEvent.ITEM_START, onItemStart);
		}
		public function start():void
		{
			if (itemList.length == 0) 
			{
				dispatchEvent(new QueueEvent(QueueEvent.ALL_COMPLETE));
				isStart = false;
				return;
			}
			if (!isStart)
			{
				for (var i:int = 0; i < itemList.length; i++) 
				{
					var item:IQueue = itemList[i];
					item.start();
				}
				isStart = true;
			}
		}
		protected function itemComplete(item:IQueue):void
		{
			
		}
		protected function onItemComplete(event:QueueEvent):void
		{
			count++;
			var item:IQueue = event.target as IQueue;
			IEventDispatcher(event.target).removeEventListener(QueueEvent.ITEM_COMPLETE, onItemComplete);
			IEventDispatcher(event.target).removeEventListener(ProgressEvent.PROGRESS, onProgressEventHandler);
			IEventDispatcher(event.target).removeEventListener(QueueEvent.ITEM_START, onItemStart);
			itemComplete(item);
			if (count == total)
			{
				loadedByte = 0;
				count = 0;
				isStart = false;
				total = 0;
				itemList.splice(0);
				progressMap = new Dictionary();
				var evt:ProgressEvent = new ProgressEvent(ProgressEvent.PROGRESS, false, false,  1, 1);
				dispatchEvent(evt);
				dispatchEvent(new QueueEvent(QueueEvent.ALL_COMPLETE));
			}
			else
			{
				var progress:ProgressEvent = new ProgressEvent(ProgressEvent.PROGRESS, false, false, count, total);
				dispatchEvent(progress);
			}
			
		}
		protected function onItemStart(event:QueueEvent):void
		{
			//dispatchEvent(event);
		}
		
		protected function onProgressEventHandler(event:ProgressEvent):void
		{
			var item:IQueue = event.target as IQueue;
			progressMap[item] = event;
			var bytesLoaded:Number = 0;
			var bytesTotal:Number = 0;
			for each(var event:ProgressEvent in progressMap)
			{
				bytesLoaded = bytesLoaded + event.bytesLoaded;
				bytesTotal = bytesTotal + event.bytesTotal;
			}
			var loaded:Number = bytesLoaded / bytesTotal;
			if (loaded >= loadedByte)
			{
				loadedByte = loaded;
				var evt:ProgressEvent = new ProgressEvent(ProgressEvent.PROGRESS, false, false,  loaded, total);
				dispatchEvent(evt);
			}
		}
	}
	
}
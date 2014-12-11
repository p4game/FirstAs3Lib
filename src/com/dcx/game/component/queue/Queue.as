package com.dcx.game.component.queue
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;

	[Event(name="allComplete", type="com.dcx.game.component.queue.QueueEvent")]
	[Event(name="itemComplete", type="com.dcx.game.component.queue.QueueEvent")]
	[Event(name="progress", type="flash.events.ProgressEvent")]
	public class Queue extends EventDispatcher
	{
		public function Queue()
		{
		}
		private var total:int = 0;
		private var count:int = 0;
		private var isStart:Boolean;
		private var isPause:Boolean;
		protected var itemList:Array = [];
		public function add(item:IQueue):void
		{
			total++;
			itemList.push(item);
			IEventDispatcher(item).addEventListener(QueueEvent.ITEM_COMPLETE, onItemComplete, false, -1);
			IEventDispatcher(item).addEventListener(ProgressEvent.PROGRESS, onProgressEventHandler);
			IEventDispatcher(item).addEventListener(IOErrorEvent.IO_ERROR, dispatcher_errorHandler);
			IEventDispatcher(item).addEventListener(IOErrorEvent.NETWORK_ERROR, dispatcher_errorHandler);
			IEventDispatcher(item).addEventListener(IOErrorEvent.DISK_ERROR, dispatcher_errorHandler);
			IEventDispatcher(item).addEventListener(IOErrorEvent.VERIFY_ERROR, dispatcher_errorHandler);
			IEventDispatcher(item).addEventListener(SecurityErrorEvent.SECURITY_ERROR, dispatcher_errorHandler);
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
				var item:IQueue = itemList[0];
				item.start();
				isStart = true;
			}
		}
		public function pause():void
		{
			isPause = true;
		}
		public function resume():void
		{
			if (isPause)
			{
				isPause = false;
				if (itemList.length > 0)
				{
					var item:IQueue = itemList[0];
					item.start();
				}
			}
		}
		public function removeList(endIndex:int, startIndex:int = 1):void
		{
			var removeCount:int = endIndex - startIndex;
			if (removeCount > 0)
			{
				itemList.splice(startIndex, removeCount);
				count = count + removeCount;
			}
		}
		public function get list():Array
		{
			return itemList; 
		}
		public function get current():IQueue
		{
			if (itemList.length > 0) return itemList[0];
			return null; 
		}
		private function itemEndHandler():void
		{
			count++;
			var item:IQueue = itemList.shift();
			IEventDispatcher(item).removeEventListener(QueueEvent.ITEM_COMPLETE, onItemComplete);
			IEventDispatcher(item).removeEventListener(ProgressEvent.PROGRESS, onProgressEventHandler);
			IEventDispatcher(item).removeEventListener(IOErrorEvent.IO_ERROR, dispatcher_errorHandler);
			IEventDispatcher(item).removeEventListener(IOErrorEvent.NETWORK_ERROR, dispatcher_errorHandler);
			IEventDispatcher(item).removeEventListener(IOErrorEvent.DISK_ERROR, dispatcher_errorHandler);
			IEventDispatcher(item).removeEventListener(IOErrorEvent.VERIFY_ERROR, dispatcher_errorHandler);
			IEventDispatcher(item).removeEventListener(SecurityErrorEvent.SECURITY_ERROR, dispatcher_errorHandler);
			if (itemList.length == 0)
			{
				isStart = false;
				total = 0;
				dispatchEvent(new QueueEvent(QueueEvent.ALL_COMPLETE));
			}
			else
			{
				/*
				var progress:ProgressEvent = new ProgressEvent(ProgressEvent.PROGRESS, false, false, count, total);
				dispatchEvent(progress);*/
				if (!isPause)
				{
					item = itemList[0];
					item.start();
				}
			}
		}
		protected function onItemComplete(event:QueueEvent):void
		{
			itemEndHandler();
				
		}
		private function dispatcher_errorHandler(event:Event):void
		{
			itemEndHandler();
		}
		protected function onProgressEventHandler(event:ProgressEvent):void
		{
			var loaded:Number = count + event.bytesLoaded / event.bytesTotal;
			var event:ProgressEvent = new ProgressEvent(ProgressEvent.PROGRESS, false, false,  loaded, total);
			dispatchEvent(event);
		}
	}

}
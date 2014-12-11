package com.dcx.game.component
{
	import com.dcx.game.component.loading.LoaderItem;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.utils.Dictionary;

	public class ObjectPool
	{
		public function ObjectPool()
		{
			resources = new Dictionary();
		}
		private static var _instance:ObjectPool
		public static function get instance():ObjectPool
		{
			return _instance ||= new ObjectPool;
		}
		private var resources:Dictionary;
		public function getLoadResource(url:String):Object
		{
			if (!resources[url])
			{
				var loader:LoaderItem = new LoaderItem(url);
				loader.start();
				resources[url] = loader;
				loader.addEventListener(Event.COMPLETE, loadComplete);
			}
			return resources[url];
		}
		public function insertLoadResource(url:String, obj:Object):void
		{
			if (resources[url]) throw new Error(url + " is already in pool");
			resources[url] = obj;
		}
		private var tempDict:Dictionary = new Dictionary();
		public function addToStage(parent:DisplayObjectContainer, url:String, x:Number = 0, y:Number = 0, index:int = 0):void
		{
			var icon:Object = getLoadResource(url); 
			var dispObj:DisplayObject;
			if (url.indexOf(".swf") > -1)
			{
				if (icon is LoaderItem)
				{
					dispObj = LoaderItem(icon).content as DisplayObject;
				}
				else if (icon is Loader) 
				{
					dispObj = icon as DisplayObject;
				}
			}
			else
			{
				if (icon is LoaderItem)
				{
					getParentList(url).push({pa:parent,xP:x,yP:y});
				}
				else if (icon is BitmapData) 
				{
					dispObj = new Bitmap(icon as BitmapData);
				}
			}
			if (dispObj)
			{
				if (index >= 0) parent.addChildAt(dispObj, index)
				else parent.addChild(dispObj);
				dispObj.x = x;
				dispObj.y = y;
			}
		}
		private function getParentList(url:String):Array
		{
			var arr:Array = tempDict[url];
			if (!arr)
			{
				arr = [];
				tempDict[url] = arr;
			}
			return arr;
		}
		private function loadComplete(event:Event):void
		{
			var loader:LoaderItem =  event.target as LoaderItem;
			if (loader.content.content is Bitmap) resources[loader.url] = Bitmap(loader.content.content).bitmapData
			else resources[loader.url] = loader.content;
			
			
			var arr:Array = tempDict[loader.url];
			if (arr)
			{
				for (var i:int = 0; i < arr.length; i++) 
				{
					var obj:Object = arr[i];
					var dispObj:DisplayObject = new Bitmap(Bitmap(loader.content.content).bitmapData);
					dispObj.x = obj.xP;
					dispObj.y = obj.yP;
					DisplayObjectContainer(obj.pa).addChildAt(dispObj, 0);
				}
				
				delete tempDict[loader.url];
			}
		}
	}
}
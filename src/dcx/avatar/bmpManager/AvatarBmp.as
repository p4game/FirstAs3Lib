package dcx.avatar.bmpManager
{
	import com.dcx.game.component.loading.LoaderItem;
	import com.dcx.game.component.loading.URLLoaderItem;
	
	import dcx.avatar.bmpManager.AvatarBmpUnit;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	public class AvatarBmp extends EventDispatcher
	{
		public function AvatarBmp(xmlURL:String)
		{
			_xmlURL = xmlURL;
			startLoad();
		}
		private var directions:Dictionary;
		private var frames:int;
		private var xml:XML;
		private var _xmlURL:String;
		public function get xmlURL():String
		{
			return _xmlURL
		}
		private var _isComplete:Boolean;
		public function isComplete():Boolean
		{
			return _isComplete;
		}
		public function getBmds(dir:int):Array
		{
			return directions[dir];
		}
		private function startLoad():void
		{
			var loader:URLLoaderItem = new URLLoaderItem(_xmlURL);
			loader.addEventListener(Event.COMPLETE, xmlLoadComplete);
			loader.start();
		}
		
		private function xmlLoadComplete(event:Event):void
		{
			URLLoaderItem(event.target).removeEventListener(Event.COMPLETE, xmlLoadComplete);
			var str:String = URLLoaderItem(event.target).content as String;
			xml = new XML(str);
			frames = xml.@frames;
			
			var picFile:String = xml.@imagePath.toString();
			var pattern:RegExp = /\w*\.xml+/g; 
			var picURL:String = _xmlURL.replace(pattern, picFile);
			var loader:LoaderItem = new LoaderItem(picURL);
			loader.addEventListener(Event.COMPLETE, picLoadComplete);
			loader.start();
		}
		private function picLoadComplete(event:Event):void
		{
			var loader:LoaderItem = event.target as LoaderItem;
			loader.removeEventListener(Event.COMPLETE, picLoadComplete);
			createBmps(loader.content.content as Bitmap);
			_isComplete = true;
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		private function createBmps(sourceBmp:Bitmap):void
		{
			directions = new Dictionary();
			var spList:XMLList = xml.sprite;
			var len:int = spList.length();
			var dir:int = 0;
			for (var i:int = 0; i < len; i++) 
			{
				var itemXML:XML = spList[i];
				if ((int(i / frames) + 1) != dir)
				{
					dir++;
					directions[dir] = [];
				}
				var tempArr:Array = directions[dir];
				var bmd:BitmapData = new BitmapData(int(itemXML.@w), int(itemXML.@h), true, 0);
				bmd.copyPixels(sourceBmp.bitmapData, 
					new Rectangle(int(itemXML.@x), int(itemXML.@y), bmd.width, bmd.height), new Point(0,0));
				var unit:AvatarBmpUnit = new AvatarBmpUnit();
				unit.bmd = bmd;
				unit.oX = int(xml.@oX) - int(itemXML.@oX);
				unit.oY = int(xml.@oY) - int(itemXML.@oY);
				tempArr.push(unit);
			}
		}
	}
}
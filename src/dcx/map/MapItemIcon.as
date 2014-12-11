package dcx.map
{
	import com.dcx.game.component.ObjectPool;
	import com.dcx.game.component.loading.LoaderItem;
	import com.dcx.game.component.ui.ViewComponet;
	
	import dcx.common.IObject;
	import dcx.common.StaticMapObjects;
	import dcx.utils.Urlf;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.ApplicationDomain;
	
	public class MapItemIcon extends ViewComponet
	{
		public function MapItemIcon()
		{
		
		}
		protected var bmp:Bitmap;
		protected var staticObj:IObject;
		public function getStaticObj():IObject
		{
			return staticObj;
		}
		public function init(obj:IObject):void
		{
			this.buttonMode = true;
			this.staticObj = obj;
			loadResource();
		}
		private function loadResource():void
		{
			var url:String = staticObj.icon;
			var obj:Object = ObjectPool.instance.getLoadResource(url);
			if (obj is LoaderItem) re(obj as LoaderItem, Event.COMPLETE, loadComplete);
			else resourceReady(obj); 
		}
		private function loadComplete(event:Event):void
		{
			var loader:LoaderItem = event.target as LoaderItem;
			rl(loader, Event.COMPLETE, loadComplete);
			resourceReady(ObjectPool.instance.getLoadResource(loader.url));
		}
		private function resourceReady(obj:Object):void
		{
			if (obj is BitmapData)
			{
				bmp = new Bitmap(obj as BitmapData);
				this.addChild(bmp);
				bmp.x = iconx;
				bmp.y = icony;
			}
		}
		protected function get iconx():Number
		{
			return 6;
		}
		protected function get icony():Number
		{
			return 0;
		}
	}
}
package dcx.map
{
	import com.dcx.game.component.ui.ViewComponet;
	import com.friendsofed.isometric.IsoObject;
	import com.friendsofed.isometric.IsoUtils;
	import com.friendsofed.isometric.Point3D;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;

	public class BaseMapItem extends ViewComponet implements InterActive
	{
		public function BaseMapItem(type:int)
		{
			_type = type;
		}
		protected var uiContainer:ViewComponet;
		public function setUIContainer(value:ViewComponet):void
		{
			uiContainer = value;
		}
		protected var _itemUI:MapItemUI
		public function get itemUI():MapItemUI
		{
			if (!_itemUI)
			{
				_itemUI = new MapItemUI();
				_itemUI.mouseChildren = false;
				_itemUI.mouseEnabled = false;
				re (_itemUI, MouseEvent.MOUSE_DOWN, onUIClick);
			}
			return _itemUI;
		}
		public function showItemUI(obj:Object):void
		{
			if (!uiContainer) return;
			if (obj is String) itemUI.setIcon(obj as String)
			else if (obj is DisplayObject) itemUI.addChild(obj as DisplayObject);
			uiContainer.addChild(itemUI);
			refreshUIPosition();
		}
		public function clearItemUI():void
		{
			if (_itemUI && _itemUI.parent) _itemUI.parent.removeChild(_itemUI);
		}
		private function onUIClick(event:MouseEvent):void
		{
			
		}
		public function refreshUIPosition():void
		{
			if (!_itemUI || !uiContainer) return;
			var globalPoint:Point = this.parent.localToGlobal(new Point(x,y));
			var localPoint:Point = uiContainer.globalToLocal(globalPoint);
			_itemUI.x = localPoint.x - 30;
			_itemUI.y = localPoint.y - 100;
		}
		public function get typeID():int
		{
			return -1;
		}
		/*
		private var _mapID:int;
		public function set mapID(value:int):void
		{
			_mapID = value;
		}
		public function get mapID():int
		{
			return _mapID;
		}*/
		
		private var _type:int;
		public function get type():int
		{
			return _type;
		}
		protected var _xIndex:int = -1;
		public function get xIndex():int
		{
			return _xIndex;
		}
		protected var _zIndex:int = -1;
		public function get zIndex():int
		{
			return _zIndex;
		}
		protected var _yIndex:int = -1;
		public function get yIndex():int
		{
			return _yIndex;
		}
		public function get depth():Number
		{
			var position:Point3D = IsoUtils.screenToIso(new Point(x, y));
			return (position.x + position.z) * .866 - position.y * .707;
		}
		public function get layerType():int
		{
			return 0;
		}
		public function onMouseClick():void
		{
			this.dispatchEvent(new MapItemActiveEvent(MapItemActiveEvent.MOUSE_CLICK, true));
		}
		public function onMouseOver():void
		{
			this.filters = [new GlowFilter(0xffba00, 1, 2, 2, 10, 3)];
		}
		public function onMouseOut():void
		{
			this.filters = null;
		}
		public function onMouseDown():void
		{
			this.dispatchEvent(new MapItemActiveEvent(MapItemActiveEvent.MOUSE_DOWN, true));
		}
		public function isInteractive():Boolean
		{
			return true;
		}
		public function clone():Object
		{
			return new BaseMapItem(_type);
		}
		public function get cols():int
		{
			return 1;
		}
		public function get rows():int
		{
			return 1;
		}
		override public function dispose():void
		{
			if (_itemUI)
			{
				rl(_itemUI, MouseEvent.MOUSE_DOWN, onUIClick)
				if(_itemUI.parent) _itemUI.parent.removeChild(_itemUI);
				_itemUI.dispose();
			}
			super.dispose();
			_itemUI = null;
			uiContainer = null;
		}
	}
}
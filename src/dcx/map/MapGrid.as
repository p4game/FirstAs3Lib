package dcx.map
{
	import com.friendsofed.isometric.DrawnIsoTile;
	import com.friendsofed.isometric.IsoUtils;
	import com.friendsofed.isometric.Point3D;
	
	import flash.geom.Point;
	import flash.text.TextField;

	public class MapGrid extends DrawnIsoTile
	{
		public function MapGrid(size:Number, color:uint, height:Number=0)
		{
			super(size, color, height);
		}
		private var _exitID:int;
		public function set exitID(value:int):void
		{
			_exitID = value;
		}
		public function get exitID():int
		{
			return _exitID;
		}
		private var _exitPoint:Point;
		public function set exitPoint(value:Point):void
		{
			_exitPoint = value;
		}
		public function get exitPoint():Point
		{
			return _exitPoint;
		}
		private var objList:Array;
		
		private var  items:Array = [];
		public function addItem(item:MapItem):void
		{
			if (items.indexOf(item) > -1) return;
			items.push(item);
		}
		public function removeItem(item:MapItem):void
		{
			if (items && items.indexOf(item) > -1) items.splice(items.indexOf(item), 1);
		}
		
		public function isOverlap(layer:int):Boolean
		{
			for (var i:int = 0; i < items.length; i++) 
			{
				var item:MapItem = items[i];
				if (item.layerType == layer && item.overlap == 0) return false;
			}
			return true;
		}
		
		public function get status():int
		{
			for (var i:int = 0; i < items.length; i++) 
			{
				var item:MapItem = items[i];
				if (item.layerType == MapEnum.OBJECT_LAYER || item.layerType == MapEnum.WALL_LAYER)
				{
					if (item.gridStatus == 0) return MapEnum.BLOCK;
				}
			}
			return _status;
		}
		private var _status:int;
		public function set status(value:int):void
		{
			if (value == status) return;
			_status = value;
			switch(status)
			{
				case MapEnum.BLOCK:
					_color = MapEnum.BLOCK_COLOR;
					draw();
					break;
				case MapEnum.PASS:
					_color = MapEnum.PASS_COLOR;
					draw();
					break;
				case MapEnum.DOT:
					_color = MapEnum.DOT_COLOR;
					draw();
					break;
				case MapEnum.ENTER:
					_color = MapEnum.ENTER_COLOR;
					draw();
					break;
				case MapEnum.EXIT:
					_color = MapEnum.EXIT_COLOR;
					draw();
					break;
				case MapEnum.RESURRECT:
					_color = MapEnum.REC_COLOR;
					draw();
					break;
			}
			if (status != MapEnum.EXIT) _exitID = 0;
		}
		public function get key():String
		{
			return xIndex + "," + zIndex;
		}
		public function setIndex(xIndex:int, yIndex:int, zIndex:int):void
		{
			_xIndex = xIndex;
			_yIndex = yIndex;
			_zIndex = zIndex;
			position = new Point3D(xIndex * _size, yIndex, zIndex * _size);
		}
		private var _xIndex:int;
		public function get xIndex():int
		{
			return _xIndex;
		}
		private var _yIndex:int;
		public function get yIndex():int
		{
			return _yIndex;
		}
		
		private var _zIndex:int;
		public function get zIndex():int
		{
			return _zIndex;
		}
		override public function set position(value:Point3D):void
		{
			super.position = value;
			var screenPos:Point = IsoUtils.isoToScreen(_position);
			_screenx = screenPos.x;
			_screeny = screenPos.y;
		}
		private var _screenx:Number;
		public function get screenx():Number
		{
			return _screenx;
		}
		private var _screeny:Number;
		public function get screeny():Number
		{
			return _screeny;
		}
	}
}
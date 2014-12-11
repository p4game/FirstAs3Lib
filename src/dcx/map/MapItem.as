package dcx.map
{
	import com.dcx.game.component.ObjectPool;
	import com.dcx.game.component.loading.LoaderItem;
	import com.dcx.game.utils.text.isEmpty;
	import com.friendsofed.isometric.IsoUtils;
	import com.friendsofed.isometric.Point3D;
	
	import dcx.common.StaticMapObjects;
	import dcx.utils.InstanceUtils;
	import dcx.utils.Urlf;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.geom.Point;

	public class MapItem extends BaseMapItem
	{
		public function MapItem(obj:Object, size:int)
		{
			_xIndex = -1;
			_yIndex = 0;
			_zIndex = -1;
			
			_size = size;
			halfSize = _size / 2;
			this.staticObj = obj as StaticMapObjects;
			super(staticObj.type);
			loadResource();
			//this.graphics.beginFill(0xdddddd);
			//this.graphics.drawRect(0, 0, 80,40);
		}
		protected var viewObj:DisplayObject;
		private var gridShape:Shape;
		private var gridColor:int;
		protected var staticObj:StaticMapObjects;
		private var _size:int;
		private var halfSize:int;
		private function loadResource():void
		{
			var url:String = Urlf.getUrl(Urlf.MAP_OBJECTS, staticObj.resource);
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
				viewObj = new Bitmap(obj as BitmapData);
			}
			else if (obj is Loader)
			{
				if (!isEmpty(staticObj.cl)) viewObj = InstanceUtils.getInstance(staticObj.cl, Loader(obj).contentLoaderInfo.applicationDomain) as DisplayObject;
			}
			this.addChildAt(viewObj, 0);
			viewObj.x = /*-1 * MapEnum.SIZE * staticObj.rows+ */staticObj.offX;
			viewObj.y = /*-1 * MapEnum.SIZE / 2 +*/ staticObj.offY;
		}
		protected var _grids:Array;
		public function setGrids(grids:Array):void
		{
			_grids = grids;
		}

		private function gridHandler(funName:String, ...args):void
		{
			if (!_grids) return;
			var cs:int = cols + _xIndex;
			var rs:int  = rows + _zIndex;
			for (var i:int = _xIndex; i < cs; i++) 
			{
				for (var j:int = _zIndex; j < rs; j++) 
				{
					var tempGrid:MapGrid = _grids[i][j];
					var fun:Function = tempGrid[funName];
					fun.apply(tempGrid,args);
				}
				
			}
		}
		private function addGrids():void
		{
			gridHandler("addItem", this);
		}
		public function clearGrids():void
		{
			gridHandler("removeItem", this);
		}
		public function setIndex(xIndex:int, zIndex:int, yIndex:int):void
		{
			_xIndex = xIndex;
			_zIndex = zIndex;
			refreshPosition();
			addGrids();
		}
		private var _position:Point3D;
		protected function refreshPosition():void
		{
			var centerCol:int = _xIndex + Math.round(cols / 2) - 1;
			var centerX:int = centerCol * _size;
			if (cols % 2 == 0) centerX = centerX + _size;
			var centerRow:int = _zIndex + Math.round(rows / 2) - 1;
			var centerY:int = centerRow * _size;
			if (rows % 2 == 0) centerY = centerY + halfSize;
			_position = new Point3D(centerX, yIndex, centerY);
			
			
			//_depth = (_xIndex * _size + _zIndex * _size - (cols + rows) * halfSize) * .866 - _zIndex * .707;
			//_depth = 0.5 * (_xIndex + _zIndex+ cols + rows) * 0.866
			_depth = (_position.x + _position.z) * .866 - _position.y * .707;
			
			var screenPos:Point = IsoUtils.isoToScreen(new Point3D(_xIndex * _size, yIndex, _zIndex * _size));
			super.x = screenPos.x;
			super.y = screenPos.y;
		}
		private var _depth:Number;
		override public function get depth():Number
		{
			return _depth;
		}
		public function get offX():int
		{
			return staticObj.offX;
		}
		public function get offY():int
		{
			return staticObj.offY;
		}
		public function set offX(value:int):void
		{
			staticObj.offX = value
			if (viewObj) viewObj.x = staticObj.offX;
		}
		public function set offY(value:int):void
		{
			staticObj.offY = value
			if (viewObj) viewObj.y = staticObj.offY;
		}
		override public function get cols():int
		{
			var v:int = _dir == 1 ? staticObj.cols : staticObj.rows;
			return v;
		}
		override public function get rows():int
		{
			var v:int = _dir == 1 ? staticObj.rows : staticObj.cols;
			return v;
		}
		
		public function get gridStatus():int
		{
			return staticObj.gridStatus;
		}
		public function get overlap():int
		{
			return staticObj.overlap;
		}
		override public function get layerType():int
		{
			return staticObj.layerType;
		}
		private var oldDir:int = 1;
		private var _dir:int = 1;
		public function initDir(value:int):void
		{
			setDir(value);
			oldDir = value;
		}
		protected function  setDir(value:int):void
		{
			oldDir = _dir;
			_dir = value;
			this.scaleX = _dir;
		}
		public function  get dir():int
		{
			return _dir;
		}
		private var _canPlace:Boolean;
		public function get canPlace():Boolean
		{
			return _canPlace;
		}
		public function rotate():void
		{
			setDir(-1 * _dir);
		}
		public function revert():void
		{
			setDir(oldDir);
			setGridColor(false, true);
		}
		public function setGridColor(visable:Boolean, canPlace:Boolean):void
		{
			_canPlace = canPlace;
			if (visable)
			{
				var color:int = _canPlace ? 0x00FF00 : 0xFF0000;
				createGridShape(color);
				if (!this.contains(gridShape)) this.addChild(gridShape)
			}
			else if (gridShape && this.contains(gridShape)) this.removeChild(gridShape);
		}
		override public function get typeID():int
		{
			return staticObj.id;
		}
		override public function clone():Object
		{
			var item:MapItem = new MapItem(staticObj, _size);
			item.initDir(_dir);
			return item;
		}
		private function createGridShape(color:int):void
		{
			if (!gridShape) gridShape = new Shape();
			if (color == gridColor) return;
			gridColor = color;
			gridShape.graphics.clear();
			var halfSize:int = MapEnum.SIZE / 2;
			//gridShape.graphics.lineStyle(1,gridColor);
			gridShape.graphics.beginFill(gridColor,0.5);
			gridShape.graphics.moveTo(MapEnum.SIZE * staticObj.rows, 0);
			gridShape.graphics.lineTo(MapEnum.SIZE * (staticObj.rows + staticObj.cols),halfSize * staticObj.cols);
			gridShape.graphics.lineTo(MapEnum.SIZE * staticObj.cols,halfSize * (staticObj.rows + staticObj.cols));
			gridShape.graphics.lineTo(0,halfSize * staticObj.rows);
			gridShape.graphics.lineTo(MapEnum.SIZE * staticObj.rows, 0);
			gridShape.x = -1 * MapEnum.SIZE * staticObj.rows;
			gridShape.y = -1 * MapEnum.SIZE / 2
		}
		override public function dispose():void
		{
			clearGrids();
			super.dispose();
			_grids = null;
		}
	}
}
package dcx.map
{
	import com.dcx.game.component.ui.ViewComponet;
	import com.friendsofed.isometric.IsoUtils;
	import com.friendsofed.isometric.Point3D;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	public class BaseMap extends ViewComponet
	{
		private var xmlURL:String;
		protected var grid:Array;
		protected var layers:Dictionary;
		protected var layerArrays:Dictionary;
		protected var background:MapBkScroller;
		protected var tileLayer:ViewComponet
		private var gridContainer:ViewComponet;
		protected var world:ViewComponet;
		private var activeManager:InteractiveManager;
		public function BaseMap(id:int = -1)
		{
			layers = new Dictionary();
			layerArrays = new Dictionary();
			
			background = new MapBkScroller;
			addLayer(background, MapEnum.BK_LAYER);
			
			var defaultWallLayer:ViewComponet = new ViewComponet;
			addLayer(defaultWallLayer, MapEnum.DEFAULT_WALL_LAYER);
			
			var wallLayer:ViewComponet = new ViewComponet;
			addLayer(wallLayer, MapEnum.WALL_LAYER);
			
			var wallDecLayer:ViewComponet = new ViewComponet;
			addLayer(wallDecLayer, MapEnum.WALL_DEC_LAYER);
			
			var defaultTileLayer:ViewComponet = new ViewComponet;
			addLayer(defaultTileLayer, MapEnum.DEFAULT_TILE_LAYER);
			
			
			tileLayer = new ViewComponet;
			addLayer(tileLayer, MapEnum.TILE_LAYER);
			
			var tileDecLayer:ViewComponet = new ViewComponet;
			addLayer(tileDecLayer, MapEnum.TILE_DEC_LAYER);
			
			gridContainer = new ViewComponet();
			addLayer(gridContainer, MapEnum.GRID_LAYER);
			
			world = new ViewComponet();
			addLayer(world, MapEnum.OBJECT_LAYER); 
			

			activeManager = new InteractiveManager();
			re(activeManager, InterActiveEvent.MOUSE_DOWN_NO_TARGET, mouseDownHandler);
			//re(activeManager, InterActiveEvent.MOUSE_DOWN_TARGET, clickItemHandler);
			activeManager.initialize(this);
		}
		protected function get allList():Array
		{
			var arr:Array = [];
			for each(var unitList:Array in layerArrays)
			{
				arr = arr.concat(unitList.slice());
			}
			return arr;
		}
		protected function getList(layerType:int):Array
		{
			return layerArrays[layerType].slice();
		}
		private function addLayer(layer:DisplayObject, type:int):void
		{
			addChild(layer);
			layers[type] = layer;
			if (!layerArrays[type]) layerArrays[type] = [];
		}
		
		protected var _staticData:MapStaticData;
		public function get staticData():MapStaticData
		{
			return _staticData;
		}
		/*
		public function getGridByPoint(x:Number, y:Number):MapGrid
		{
			var pos:Point3D = IsoUtils.screenToIso(new Point(x, y));
			var xIndex:int = Math.round(pos.x / _staticData.size);
			var yIndex:int = Math.round(pos.y / _staticData.size);
			var zIndex:int = Math.round(pos.z / _staticData.size);
			return getGrid(xIndex,zIndex);
		}*/
		public function getGridFromSreenPos(x:Number, y:Number):MapGrid
		{
			var pos:Point3D = IsoUtils.screenToIso(new Point(x, y));
			var xIndex:int = Math.round(pos.x / _staticData.size);
			var yIndex:int = Math.round(pos.y / _staticData.size);
			var zIndex:int = Math.round(pos.z / _staticData.size);
			return getGrid(xIndex,zIndex);
		}
		public function getGrid(xIndex:int,zIndex:int):MapGrid
		{
			if (xIndex < 0 || xIndex >= staticData.cols || zIndex < 0 || zIndex >= staticData.rows) return null;
			return grid[xIndex][zIndex];
		}
		public function addComponent(item:BaseMapItem, xIndex:int, zIndex:int, yIndex:int = 0):void
		{
			if (item is MapItem)
			{
				MapItem(item).setGrids(grid);
				MapItem(item).setIndex(xIndex,zIndex, yIndex);
			}
			else
			{
				var grid:MapGrid = getGrid(xIndex, zIndex);
				item.x = grid.screenx;
				item.y = grid.screeny;
			}
			var list:Array = layerArrays[item.layerType];
			if (list.indexOf(item) == -1) list.push(item);
			layers[item.layerType].addChild(item);
		}
		private var sortReady:Array;
		private var needSort:Array;
		protected function sortAll(type:int):void
		{
			sortReady = [];
			needSort = layerArrays[type];
			if (needSort.length > 0)
			{
				sortReady.push(needSort.shift());
				if (needSort.length > 0) loopClist();
			}
			for (var i:int = 0; i < sortReady.length; i++) 
			{
				layers[type].addChildAt(sortReady[i], i);
			}
			layerArrays[type] = sortReady;
		}
		private function loopClist():void
		{
			var startIndex:int = needSort.length - 1;
			for (var i:int = startIndex; i > -1; i--) 
			{
				var tmpItem:BaseMapItem = needSort[i];
				var insertIndex:int;
				for (var j:int = 0; j < sortReady.length; j++) 
				{
					var target:BaseMapItem =  sortReady[j];
					var area:int = newCompareDepth(tmpItem, target);
					if (area == 1)
					{
						needSort.splice(i, 1);
						insertIndex = j
						break;
					}
					else if (area == 2)
					{
						needSort.splice(i, 1);
						insertIndex = j + 1;
					}
				}
				sortReady.splice(insertIndex, 0, tmpItem);
			}
			if (needSort.length > 0)
			{
				sortReady.push(needSort.shift());
				if (needSort.length > 0) loopClist();
			}
		}
		protected function newCompareDepth(item1:BaseMapItem, target:BaseMapItem):int
		{
			var startX:int = target.xIndex;
			var startY:int = target.zIndex;
			var cols:int = target is MapItem ? MapItem(target).cols : 1;
			var rows:int = target is MapItem ? MapItem(target).rows : 1;
			var endX:int = startX + cols;
			var endY:int = startY + rows;
			
			var endX1:int  = item1 is MapItem ? item1.xIndex + MapItem(item1).cols : item1.xIndex + 1; 
			var endY1:int  = item1 is MapItem ? item1.zIndex + MapItem(item1).rows : item1.zIndex + 1; 
			if ((endX1 - 1 < startX && item1.zIndex < endY) || (endY1 -1 < startY && item1.xIndex < endX)) return 1//A
			else if ((item1.xIndex > endX - 1 && endY1 > startY) || (item1.zIndex > endY - 1 && endX1 > startX)) return 2 //B 
			//else if	(item1.zIndex > endY - 1 && endX1 - 1 < startX) return 4//D	
			else return 3//C
		}
		public function removeComponent(item:BaseMapItem, dispose:Boolean = true):void
		{
			var list:Array = layerArrays[item.layerType];
			var index:int = list.indexOf(item);
			if (index > -1) list.splice(index, 1);
			if (dispose) disposeObj(item);
		}
		/*
		private function removeComponentByMapID(mapID:int):void
		{
			for each(var unitList:DictArrayList in layerArrays)
			{
				if (unitList.getObjByID(mapID)) 
				{
					unitList.removeObj(mapID);
					return;
				}
			}
		}
		
		private function setGridStatus(item:MapItem, status:int, overlap:int):void
		{
			if (!item) return;
			var cols:int = MapItem(item).cols + xP;
			var rows:int  = MapItem(item).rows + yP;
			for (var i:int = xP; i < cols; i++) 
			{
				for (var j:int = yP; j < rows; j++) 
				{
					var tempGrid:MapGrid = getGrid(i,j);
					tempGrid.status = MapItem(item).gridStatus;
					tempGrid.overlap = MapItem(item).overlap;
				}
				
			}
		}
		public function sortList(layerType:int = 0):void
		{
			if (layerType > 0)
			{
				try
				{
					var list:Array = DictArrayList(layerArrays[layerType]).toArray();
					list.sortOn("depth", Array.NUMERIC);
					var layerSp:Sprite = layers[layerType];
					for(var i:int = 0; i < list.length; i++)
					{
						var childIndex:int = i;
						if (childIndex >= layerSp.numChildren) childIndex = layerSp.numChildren - 1;
						if (layerSp.contains(list[i])) layerSp.setChildIndex(list[i], childIndex);
					}
				}
				catch(e:Error)
				{
					trace(e);
				}
			}

		}
		public function sortList(layerType:int = 0):void
		{
			if (layerType > 0)
			{
				try
				{
					var list:Array = layerArrays[layerType];
					var layerSp:Sprite = layers[layerType];
					for(var i:int = 0; i < list.length; i++)
					{
						var childIndex:int = i;
						if (childIndex >= layerSp.numChildren) childIndex = layerSp.numChildren - 1;
						if (layerSp.contains(list[i])) layerSp.setChildIndex(list[i], childIndex);
					}
				}
				catch(e:Error)
				{
					trace(e);
				}
			}
			
		}*/
		protected function createGrids():void
		{
			gridContainer.removeAllChild();
			var temp:Array = new Array();
			temp = new Array();
			for(var i:int = 0; i < staticData.cols; i++)
			{
				temp[i] = new Array();
				for(var j:int = 0; j < staticData.rows; j++)
				{
					
					var tile:MapGrid;
					if (grid && i < grid.length && grid[i] && j < grid[i].length)
					{
						tile = grid[i][j];
					}
					else
					{
						tile = createGrid(staticData.size, 0xcccccc);
						tile.status = MapEnum.PASS;
						tile.alpha = 0.3;
						tile.setIndex(i,0,j);
						var statusString:String = _staticData.getGrids()[tile.key];
						if (statusString)
						{
							var arr:Array = statusString.split(",");
							var st:int = arr[0];
							if (st > 0) tile.status = st;
							if (st == MapEnum.EXIT)
							{
								tile.exitID = arr[1];
								tile.exitPoint = new Point(arr[2], arr[3]);
							}
						}
						
					}
					//gridContainer.addChild(tile);
					temp[i][j] = tile;

				}
			}
			grid = temp;
			//Astar.instance.createMap(staticData.cols, grid);
		}

		protected function createGrid(size:Number, color:uint):MapGrid
		{
			return new MapGrid(size, color);
		}
		/*
		private function clickItemHandler(event:InterActiveEvent):void
		{
			clickItem(event.clickItem);
		}
		protected function clickItem(item:BaseMapItem):void
		{

		}*/
		private function mouseDownHandler(event:InterActiveEvent):void
		{
			var grid:MapGrid = getGridFromSreenPos(this.mouseX, this.mouseY) as MapGrid;
			if (grid) mouseDownGrid(grid);
		}
		protected function mouseDownGrid(grid:MapGrid):void
		{
			
		}
	}
}
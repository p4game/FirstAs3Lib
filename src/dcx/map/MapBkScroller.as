package dcx.map
{
	import com.dcx.game.component.loading.LoaderItem;
	import com.dcx.game.component.ui.ViewComponet;
	import com.dcx.game.utils.text.stringf;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	public class MapBkScroller extends ViewComponet
	{
		public function MapBkScroller()
		{
			
		}
		private var data:MapFloorData;
		private var url:String
		private var halfw:int;
		private var halfh:int;
		private var numCol:int;
		private var numRow:int;
		private var startCol:int = -1;
		private var startRow:int;
		private var bmps:Dictionary = new Dictionary();
		public function init(data:MapFloorData, id:int, halfw:int, halfh:int, path:String="maps/"):void
		{
			this.x = data.offsetX;
			this.y = data.offsetY;
			this.data = data;
			url = path + id + "/";
			this.halfw = halfw;
			this.halfh = halfh;
			numCol = Math.ceil(halfw * 2 / data.unitWidth) + 1;
			numRow = Math.ceil(halfh * 2 / data.unitHeight) + 1;
		}
		
		public function refresh(rectx:Number, recty:Number):void
		{
			var imageStartX:Number =  -1 * data.offsetX + rectx;//背景显示的起点坐标
			var imageStartY:Number =  -1 * data.offsetY + recty;
			var tempCol:Number = Math.floor(imageStartX / data.unitWidth);
			var tempRow:Number = Math.floor(imageStartY / data.unitHeight);
			if (tempCol == startCol && tempRow == startRow)
			{
				return;
			}
			
			if(tempCol < 0) tempCol = 0;
			if(tempCol + numCol > data.cols) tempCol = data.cols - numCol;
			startCol = tempCol;
			
			if (tempRow < 0) tempRow = 0;
			if(tempRow + numRow > data.rows) tempRow = data.rows - numRow;
			startRow = tempRow;
			var endCol:int = startCol + numCol;
			var endRow:int = startRow + numRow;
			var bmpindex:int = 0;
			
			for (var i:int = startCol; i < endCol; i++) 
			{
				for (var j:int = startRow; j < endRow; j++) 
				{
					var bmp:Bitmap = bmps[i + "," + j];
					if (bmp)
					{
						this.addChild(bmp);
						bmp.x = i * data.unitWidth;
						bmp.y = j * data.unitHeight;
					}
					else
					{
						loadPic(startCol, startRow, i, j);
					}
				}
			}
		}
		private function loadPic(startCol:int, startRow:int, col:int, row:int):void
		{
			var fileName:String = "{0}{1}.png";
			fileName = stringf(fileName, wrap(row), wrap(col));
			var loader:FloorPicLoadItem = new FloorPicLoadItem(url + fileName);
			loader.startCol = startCol;
			loader.startRow = startRow;
			loader.col = col;
			loader.row = row;
			loader.start();
			re(loader, Event.COMPLETE, picLoadComplete);
		}
		private function picLoadComplete(event:Event):void
		{
			var loader:FloorPicLoadItem = event.target as FloorPicLoadItem;
			rl(loader, Event.COMPLETE, picLoadComplete);
			var bmp:Bitmap = loader.content.content as Bitmap;
			bmps[loader.col + "," + loader.row] = bmp;
			bmp.x = loader.col * data.unitWidth;
			bmp.y = loader.row * data.unitHeight;
			this.addChild(bmp);
		}
		private function wrap(num:int):String
		{
			if (num > 999) throw new Error("failed");
			if (num < 10) return "00" + num;
			if (num < 100) return "0" + num;
			return num.toString();
		}
	}
}
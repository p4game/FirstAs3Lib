package dcx.map
{
	import com.dcx.game.utils.text.stringf;
	public class MapFloorData extends BaseMapData
	{
		public function MapFloorData()
		{
		}
		public var unitWidth:int = 256;
		public var unitHeight:int = 256;
		public var width:int;
		public var height:int;
		public var offsetX:int;
		public var offsetY:int;
		public var sourceFile:String
		override public function getXML():XML
		{
			var str:String = '<floor unitWidth="{0}" unitHeight="{1}" width="{2}" height="{3}" offsetX="{4}" offsetY="{5}"></floor>';
			var xml:XML = new XML(stringf(str, unitWidth, unitHeight, width, height, offsetX, offsetY));
			return xml;
		}
		override public function setData(xml:XML):void
		{
			unitWidth = xml.@unitWidth;
			unitHeight = xml.@unitHeight;
			width = xml.@width;
			height = xml.@height;
			offsetX = xml.@offsetX;
			offsetY = xml.@offsetY;
			sourceFile = xml.@sourceFile.toString();
			_right = width + offsetX;
			_bottom = height + offsetY;
			_cols = int(width / unitWidth);
			if (width % unitWidth > 0) _cols = _cols + 1;
			_rows = int(height / unitHeight);
			if (height % unitHeight > 0) _rows = _rows + 1;
		}
		private var _right:Number;
		public function get right():Number
		{
			return _right;
		}
		private var _bottom:Number;
		public function get bottom():Number
		{
			return _bottom;
		}
		private var _cols:int;
		public function get cols():int
		{
			return _cols;
		}
		private var _rows:int;
		public function get rows():int
		{
			return _rows;
		}
	}
}
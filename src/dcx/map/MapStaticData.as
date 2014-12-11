package dcx.map
{
	import com.dcx.game.utils.text.stringf;
	
	import flash.utils.Dictionary;

	public class MapStaticData extends BaseMapData
	{
		public function MapStaticData()
		{
			grids = new Dictionary();
			_floorData = new MapFloorData();
		}
		public var id:int;
		public var music:int;//背景音乐
		public var auto:int;//自动播放linkid
		public var mapName:String;
		public var born:String;
		public var born_npc:Array;
		public var cols:int;
		public var rows:int;
		public var size:int;
		public var dir:String;
		public var tileBack:int;
		public var items:XMLList
		override public function setData(xml:XML):void
		{
			id = xml.map.@id;
			mapName = xml.map.@mapName;
			cols = xml.map.@cols;
			rows = xml.map.@rows;
			size = xml.map.@size;
			dir = xml.map.@dir.toString();
			tileBack = xml.map.@tileBack;
			born = xml.map.@born.toString();
			born_npc = xml.map.@born_npc.toString().split(",");
			music = xml.map.@music;
			auto = xml.map.@auto;
			items = xml.map.items.item;
			var gridStr:String = xml.map.grids.text();
			var gridArray:Array = gridStr.split(";");
			for (var i:int = 0; i < gridArray.length; i++) 
			{
				var tempArray:Array = gridArray[i].split(":");
				if (tempArray.length == 2)
				{
					grids[tempArray[0]] = tempArray[1];
				}
			}
			
			var list:XMLList = xml.map.floor;
			if (list.length() > 0) _floorData.setData(list[0]);
		}
		protected var _floorData:MapFloorData;
		public function get floorData():MapFloorData
		{
			return _floorData;
		}
		private var grids:Dictionary;
		public function getGrids():Dictionary
		{
			return grids;
		}
		private var itemObjs:Array;
		public function getItemObjs():Array
		{
			if (!itemObjs)
			{
				itemObjs = [];
				for (var i:int = 0; i < items.length(); i++) 
				{
					var xml:XML = items[i]
					var obj:Object = {face:int(xml.@rot),itemid:int(xml.@id),point:int(xml.@col) + "," +int(xml.@row)};
					itemObjs.push(obj);
				}
				
			}
			return itemObjs;
		}
	}
}
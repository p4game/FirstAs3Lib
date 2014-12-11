package dcx.map
{
	public class MapEnum
	{
		public static const BK_LAYER:int = 21;
		public static const GRID_LAYER:int = 22;
		
		public static const WALL_LAYER:int = 1;
		public static const WALL_DEC_LAYER:int = 2;
		public static const TILE_LAYER:int = 3;
		public static const TILE_DEC_LAYER:int = 4;
		public static const OBJECT_LAYER:int = 5;
		
		public static const DEFAULT_WALL_LAYER:int = 6;
		public static const DEFAULT_TILE_LAYER:int = 7;
		
		/*
		public static const BK_LAYER:String = "bkLayer";
		public static const TILE_LAYER:int = "tileLayer";
		public static const TILE_DEC_LAYER:int = "tileLayer";
		public static const GRID_LAYER:String = "gridLayer";
		public static const OBJECT_LAYER:String = "objectLayer";*/
		
		public static const BLOCK_COLOR:int = 0xcccccc;
		public static const PASS_COLOR:int = 0x00ffff;
		public static const DOT_COLOR:int = 0xff00ff;
		public static const ENTER_COLOR:int = 0xff0000;
		public static const EXIT_COLOR:int = 0xffff00;
		public static const REC_COLOR:int = 0xff7722;
		
		//grid Status
		public static const BLOCK:int = 0;
		public static const PASS:int = 1;
		public static const DOT:int = 2;
		public static const ENTER:int = 3;
		public static const EXIT:int = 4;
		public static const RESURRECT:int = 5;
		
		public static var SIZE:int;
		
		public static const MONSTER:int = 3;
		public static const NPX:int = 4;
		
		public static const MAP_READY:String = "mapReady";
	}
}
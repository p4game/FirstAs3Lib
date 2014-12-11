package dcx.map
{
	import com.dcx.game.component.loading.LoaderItem;
	
	public class FloorPicLoadItem extends LoaderItem
	{
		public function FloorPicLoadItem(url:String, bytesTotal:uint=0)
		{
			super(url, bytesTotal);
		}
		public var startCol:int;
		public var startRow:int;
		public var col:int;
		public var row:int;
	}
}
package dcx.map
{
	import com.friendsofed.isometric.IsoUtils;
	
	import flash.geom.Point;

	public class MobileMapItem extends BaseMapItem
	{
		public function MobileMapItem(type:int)
		{
			super(type);
		}
		
		public function setIndex(xIndex:int, zIndex:int, yIndex:int = 0):void
		{
			_xIndex = xIndex;
			_zIndex = zIndex;
			refreshUIPosition();
		}
		public function get gridPoint():Point
		{
			return IsoUtils.screenToGrid(x,y);
		}
	}
}
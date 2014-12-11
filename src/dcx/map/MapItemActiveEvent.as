package dcx.map
{
	import flash.events.Event;
	
	public class MapItemActiveEvent extends Event
	{
		public static const MOUSE_DOWN:String = "mapItemmouseDown";
		public static const MOUSE_CLICK:String = "mapItemmouseClick";
		public static const MOUSE_OVER:String = "mapItemmouseOver";
		public static const MOUSE_OUT:String = "mapItemmouseOut";
		
		public static const ROTATE_CLICK:String = "mapItemRotateClick";
		public function MapItemActiveEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
package dcx.avatar.bmpManager
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;

	public class AvatarBmps extends EventDispatcher
	{
		public static const STATUS:String = "status";
		
		public static const START_LOAD:int = 1;
		public function AvatarBmps()
		{
			bmps = new Dictionary();
		}
		private var bmps:Dictionary;
		private static var _instance:AvatarBmps
		public static function get instance():AvatarBmps
		{
			return _instance ||= new AvatarBmps;
		}
		public function getBmps(xmlURL:String):AvatarBmp
		{
			if (!bmps[xmlURL])
			{
				var item:AvatarBmp = new AvatarBmp(xmlURL)
				bmps[xmlURL] = item;
			}
			return bmps[xmlURL];
		}
	}
}
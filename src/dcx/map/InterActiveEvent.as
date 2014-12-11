package dcx.map
{
	import dcx.avatar.BaseAvatar;
	
	import flash.events.Event;
	
	public class InterActiveEvent extends Event
	{
		public static const MOUSE_DOWN_NO_TARGET:String = "mouseDownNoTarget";
		//public static const MOUSE_DOWN_TARGET:String = "mouseDownTarget";
		public function InterActiveEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		public var clickItem:BaseAvatar;
	}
}
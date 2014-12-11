package dcx.avatar.status
{
	import flash.events.Event;
	public class AvatarStatusEvent extends Event
	{
		public static const AVATAR_STATUS_END:String = "avatarStatusEnd";
		public function AvatarStatusEvent(type:String, statusName:String = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_statusName = statusName;
		}
		private var _statusName:String
		public function get statusName():String
		{
			return _statusName
		}
	}
}
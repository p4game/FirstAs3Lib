package dcx.events
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	public class DragEvent extends Event
	{
		public static const COMPONENT_START_DRAG:String = "componentStartDrag";
		public function DragEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		public var dragObj:Object;
	}
}
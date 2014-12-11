package dcx.map
{
	import flash.events.Event;
	
	public class DataRefreshEvent extends Event
	{
		public static const DATA_REFRESH:String = "dataRefresh";
		public function DataRefreshEvent(attrName:String, value:Object, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(DATA_REFRESH, bubbles, cancelable);
			_attrName = attrName;
			_attrValue = value;
		}
		private var _attrName:String;
		public function get attrName():String
		{
			return _attrName;
		}
		private var _attrValue:Object;
		public function get attrValue():Object
		{
			return _attrValue;
		}
	}
}
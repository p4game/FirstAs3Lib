package dcx.common
{
	import com.dcx.game.utils.text.isEmpty;
	
	import dcx.utils.Urlf;
	
	import flash.utils.Dictionary;

	public class StaticMapObjects extends BaseStaticObj implements IObject
	{
		public function StaticMapObjects()
		{
			
		}
		public var cols:int;
		public var rows:int;
		public var resource:String;
		public var cl:String;
		public var offX:int;
		public var offY:int;
		public var layerType:int;
		public var gridStatus:int;//同MapEnum
		public var overlap:int;//0不可叠加1可叠加
		public var place:int
		public var buy:int;
		public var sell:int;
		public var action:String;
		public var defaultAction:int;
		public var link:int;
		public var events:String;
		private var _events:Array
		public function  getEvents():Array
		{
			if (!_events && !isEmpty(events))
			{
				_events = events.split(",");
			}
			return _events
		}
		private var _actions:Dictionary
		private function  getActions():Dictionary
		{
			if (!_actions)
			{
				var arr:Array = action.split(";");
				_actions = new Dictionary();
				for (var i:int = 0; i < arr.length; i++) 
				{
					var temp:Array = arr[i].split(",");
					_actions[int(temp[0])] = arr[i];
				}
			}
			return _actions
		}
		
		public function getdefaultAction():String
		{
			if (isEmpty(action)) return null;
			return getActions()[defaultAction];
		}
		public function getAction(actionID:int):String
		{
			if (isEmpty(action)) return null;
			return getActions()[actionID];
		}
		
		private var _type:int;
		public function set type(value:int):void
		{
			_type = value;
		}
		public function get type():int
		{
			return _type;
		}
		private var _icon:String;
		public function set icon(value:String):void
		{
			if (isEmpty(value)) value = id.toString();
			_icon = Urlf.getUrl(Urlf.MAP_OBJECTS, "icons/" + value + ".png");
		}
		public function get icon():String
		{
			return _icon;
		}
		
		private var _kind:int;
		public function set kind(value:int):void
		{
			_kind = value;
		}
		public function get kind():int
		{
			return _kind;
		}
		
		private var _des:String;
		public function set des(value:String):void
		{
			_des = value;
		}
		public function get des():String
		{
			return _des;
		}
		private var _itemName:String;
		public function set itemName(value:String):void
		{
			_itemName = value;
		}
		public function get itemName():String
		{
			return _itemName;
		}
	}
}
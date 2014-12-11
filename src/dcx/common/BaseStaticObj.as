package dcx.common
{
	public class BaseStaticObj extends XMLValueObj
	{
		public function BaseStaticObj()
		{
		}
		private var _id:int;
		public function get id():int
		{
			return _id;
		}
		public function set id(value:int):void
		{
			_id = value;
		}
	}
}
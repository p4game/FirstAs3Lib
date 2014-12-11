package com.dcx.game.component.loading
{
	public class LoadEnum
	{
		private static var _count:int = 0;
		public static function set count(value:int):void
		{
			_count = value;
		}
		public static function get count():int
		{
			return _count;
		}
	}
}
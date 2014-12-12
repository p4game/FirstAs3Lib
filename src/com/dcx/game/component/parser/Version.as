package com.dcx.game.component.parser
{
	import flash.utils.Dictionary;
	public class Version
	{
		public function Version()
		{
		}
		private static var map:Dictionary = new Dictionary();
		public static function init(dataStr:String):void
		{
			var line:RegExp = /\n/;
			var space:RegExp = /\s/;
			var arr:Array = dataStr.split(line);
			for (var i:int = 0; i < arr.length; i++) 
			{
				var str:String = arr[i];
				var tempArr:Array = str.split("*");
				map[tempArr[1]] = tempArr[0];
			}
		}
		public static function set data(value:Dictionary):void
		{
			map = value;
		}
		public static function get data():Dictionary
		{
			return map;
		}
		public static function v(url:String):String
		{
			if (url.charAt(0) != "/") url = "/"+url;
			return map[url]
		}
		

	}
}
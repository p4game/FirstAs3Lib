package dcx.utils
{
	public class Urlf
	{
		public function Urlf()
		{
		}
		public static const UI:String = "ui/";
		public static const IMAGE:String = "images/";
		public static const ICON:String = "icons/";
		public static const MAP:String = "maps/";
		public static const MAP_OBJECTS:String = "mapObjects/";
		public static const AVATAR_PARTS:String = "avatar/";
		public static const XML:String = "data/";
		public static const ROLE:String = "roles/";
		public static const ROLE_IMAGE:String = "roleImage/";
		public static const SOUND:String = "sound/";
		private static var _resourcesPath:String="";
		public static function set resourcesPath(value:String):void
		{
			_resourcesPath = value;
		}
		private static var _serverPath:String="";
		public static function set serverPath(value:String):void
		{
			_serverPath = value;
		}
		public static function getUrl(path:String, file:String, language:String = null):String
		{
			var ver:String = Version.v(path + file);
			var url:String = _resourcesPath + path + file + "?ver="+ver;
			return url;
		}
		public static function getServerUrl(path:String, file:String, language:String = null):String
		{
			var ver:String = Version.v(path + file);
			var url:String = _serverPath + path + file + "?ver="+ver;
			return url;
		}
	}
}
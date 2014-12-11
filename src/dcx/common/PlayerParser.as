
package dcx.common
{
	import flash.utils.Dictionary;
	
	public class PlayerParser extends BaseParser
	{
		public function PlayerParser()
		{
		}
		private static var _instance:PlayerParser
		public static function get instance():PlayerParser
		{
			return _instance ||= new PlayerParser;
		}
		override protected function createObj():BaseStaticObj
		{
			var obj:RoleStaticObject = new RoleStaticObject();
			obj.type = RoleType.PLAYER;
			return obj;
		}
	}
}
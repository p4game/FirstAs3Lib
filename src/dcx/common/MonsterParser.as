package dcx.common
{
	import flash.utils.Dictionary;
	
	public class MonsterParser extends BaseParser
	{
		public function MonsterParser()
		{
		}
		private static var _instance:MonsterParser
		public static function get instance():MonsterParser
		{
			return _instance ||= new MonsterParser;
		}
		override protected function createObj():BaseStaticObj
		{
			var obj:RoleStaticObject = new RoleStaticObject();
			obj.type = RoleType.MONSTER;
			return obj;
		}
	}
}
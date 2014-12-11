package dcx.common
{
	import flash.utils.Dictionary;

	public class RoleListParser
	{
		public function RoleListParser()
		{
		}
		private static var _instance:RoleListParser
		public static function get instance():RoleListParser
		{
			return _instance ||= new RoleListParser;
		}
		public function getItem(id:int, type:int):Object
		{
			if (type == RoleType.MONSTER)
			{
				return MonsterParser.instance.getItem(id);
			}
			else if (type == RoleType.PLAYER)
			{
				return PlayerParser.instance.getItem(id);
			}
			return null;
		}
		
	}
}
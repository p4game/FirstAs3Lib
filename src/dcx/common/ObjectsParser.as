package dcx.common
{
	import flash.utils.Dictionary;
	
	public class ObjectsParser extends BaseParser
	{
		public function ObjectsParser()
		{
		}
		private static var _instance:ObjectsParser
		public static function get instance():ObjectsParser
		{
			return _instance ||= new ObjectsParser;
		}
		override protected function createObj():BaseStaticObj
		{
			var obj:StaticMapObjects = new StaticMapObjects();
			obj.kind = 1;
			return obj;
		}
	}
}
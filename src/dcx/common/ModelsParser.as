package dcx.common
{
	import flash.utils.Dictionary;

	public class ModelsParser extends BaseParser
	{
		public function ModelsParser()
		{
		}
		private static var _instance:ModelsParser
		public static function get instance():ModelsParser
		{
			return _instance ||= new ModelsParser;
		}
		override protected function createObj():BaseStaticObj
		{
			return new ModelStaticObj();
		}
	}
}
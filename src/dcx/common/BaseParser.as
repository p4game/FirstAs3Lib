package dcx.common
{
	import com.dcx.game.component.collection.DictArrayList;
	import com.dcx.game.core.Injector;
	
	import flash.utils.Dictionary;
	
	public class BaseParser
	{
		public function BaseParser()
		{
		}
		private static var _instance:ModelsParser
		public static function get instance():ModelsParser
		{
			return _instance ||= new ModelsParser;
		}
		public var list:DictArrayList = new DictArrayList();
		public function set data(value:Object):void
		{
			
			var _xml:XML = value as XML;
			var xmlList:XMLList = _xml.item;
			for (var i:int = 0; i < xmlList.length(); i++) 
			{
				var itemXMl:XML = xmlList[i];
				var obj:BaseStaticObj = createObj();
				injectData(obj, itemXMl);
				list.addObj(obj.id, obj);
			}
			
		}
		protected function injectData(obj:BaseStaticObj, xml:XML):void
		{
			obj.data = xml;
		}
		public function getItem(id:int):Object
		{
			return list.getObjByID(id);
		}
		protected function createObj():BaseStaticObj
		{
			return null;
		}
	}
}
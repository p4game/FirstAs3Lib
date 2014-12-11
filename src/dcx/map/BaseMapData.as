package dcx.map
{
	import flash.events.EventDispatcher;

	public class BaseMapData extends EventDispatcher implements IMapData
	{
		public function BaseMapData()
		{
			
		}
		
		public function refresh(attrName:String, value:Object):void
		{
			this[attrName] = value;
			this.dispatchEvent(new DataRefreshEvent(attrName, value));
		}
		public function setData(xml:XML):void
		{

		}
		public function getXML():XML
		{
			return null;
		}
	}
}
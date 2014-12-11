package dcx.map
{
	public interface IMapData
	{
		function refresh(attrName:String, value:Object):void
		function setData(xml:XML):void
	}
}
package dcx.map
{
	import com.dcx.game.component.loading.LoaderItem;
	import com.dcx.game.component.ui.ViewComponet;
	
	import dcx.map.BaseMapItem;
	import dcx.utils.Urlf;
	
	import flash.utils.Dictionary;

	public class MapItemUI extends ViewComponet
	{
		public function MapItemUI()
		{
			this.buttonMode = true;
		}
		private var _downItem:BaseMapItem;
		public function setDownItem(item:BaseMapItem):void
		{
			_downItem = item;
		}
		public function getDownItem():BaseMapItem
			
		{
			return _downItem;
		}
		private var map:Dictionary = new Dictionary();
		public function setIcon(iconUrl:String):void
		{
			removeAllChild();
			var loader:LoaderItem = map[iconUrl];
			if (!loader)
			{
				loader = new LoaderItem(iconUrl);
				loader.start();
				map[iconUrl] = loader;
			}
			addChild(loader.content);
		}
	}
}
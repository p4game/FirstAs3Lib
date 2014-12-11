package com.dcx.game.component.collection
{
	import flash.utils.Dictionary;
	
	public class DictArrayList extends ArrayList
	{
		public function DictArrayList()
		{
			super();
			map = new Dictionary();
		}
		private var map:Dictionary;
		
		public function getObjByID(id:Object):Object
		{
			return map[id];
		}
		public function addObj(id:Object, obj:Object):void
		{
			map[id] = obj;
			if (this.indexOf(obj) > 0) this.remove(obj);
			super.add(obj);
		}
		public function removeObj(id:Object):void
		{
			var obj:Object = map[id];
			delete map[id];
			super.remove(obj);
		}
		override public function clear():void
		{
			for (var key:Object in map) 
			{
				removeObj(key);
			}
			super.clear();
		}
		public function dispose():void
		{
			clear()
			map = null;
		}
	}
}
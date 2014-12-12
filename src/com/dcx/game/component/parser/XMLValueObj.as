package com.dcx.game.component.parser
{
	import com.dcx.game.core.Injector;
	
	import flash.events.EventDispatcher;

	public class XMLValueObj extends EventDispatcher implements Injector
	{
		public function XMLValueObj()
		{
			
		}
		
		public function set data(value:Object):void
		{
			var xml:XML = value as XML;
			var attNamesList:XMLList = xml.@*;
			for (var i:int = 0; i < attNamesList.length(); i++)
			{ 
				var attNames:String = attNamesList[i].name();
				if (this.hasOwnProperty(attNames))
				{
					this[attNames] = xml.attribute(attNames).toString();
				}
			} 
		}

	}
}
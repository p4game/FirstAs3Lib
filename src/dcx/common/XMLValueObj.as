package dcx.common
{
	import com.dcx.game.component.collection.ArrayList;
	import com.dcx.game.component.collection.TypedArrayList;
	import com.dcx.game.core.Injector;
	import com.dcx.game.utils.text.isEmpty;
	
	import flash.events.EventDispatcher;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;

	public class XMLValueObj extends EventDispatcher implements Injector
	{
		public static const REF:String = "reference";
		public static const DICT:String = "Dictionary";
		public static const STR:String = "String";
		public static const BOOLEAN:String = "Boolean";
		public static const INT:String = "Int";
		public static const ARRAY:String = "Array";
		public static const OBJ:String = "Object";
		public function XMLValueObj()
		{
			
		}
		
		public function set data(value:Object):void
		{
			var xml:XML = value as XML;
			injectCurrencyVar(this, xml)
			var len:int = xml.children().length();
			for (var i:int = 0; i < len; i++)
			{
				var node:XML = xml.children()[i];
				var valName:String = node.@valName.toString();
				var valType:String = node.@valType.toString();
				if (!isEmpty(valName))
				{
					matchValue(valName, valType, node);
				}
			}
		}
		private function matchValue(valName:String, valType:String, xml:XML):void
		{
			if (!this.hasOwnProperty(valName)) return;
			if (isReference(xml))
			{
				this[valName] = injectSubNode(xml);
				return;
			}
			if (valType == DICT)
			{
				var dict:Dictionary = this[valName] ? this[valName] : new Dictionary();
				for (var i:int = 0; i < xml.children().length(); i++)
				{
					var node:XML = xml.children()[i];
					var key:String = node.@valName.toString();
					if (isReference(node))
					{
						dict[key] = injectSubNode(node, xml.@subValue.toString());
						injectCurrencyVar(dict[key], xml);
					}
					else if (node.@valType == XMLValueObj.ARRAY)
					{
						dict[key] = node.@value.toString().split(",");
					}
					else
					{
						dict[key] = node.@value.toString();
					}
				}
				this[valName] = dict ;
				return;
			}
			else if (valType == STR)
			{
				this[valName] = xml.@value.toString();
				return;
			}
			else if (valType == BOOLEAN)
			{
				this[valName] = xml.@value.toString() == "true";
				return;
			}
			else if (valType == XMLValueObj.ARRAY)
			{
				if (this[valName] is ArrayList)
				{
					var arrayList:ArrayList = this[valName];
					for (var j:int = 0; j < xml.children().length(); j++)
					{
						var instance:Injector;
						node = xml.children()[j] as XML;
						if (arrayList is TypedArrayList)
						{
							instance = new (arrayList as TypedArrayList).type() as Injector;
						}
						else
						{
							var className:String = !isEmpty(node.@value) ? node.@value.toString() : xml.@subValue.toString()
							instance = InstanceUtils.getInstanceByDomain(ApplicationDomain.currentDomain, className) as Injector;
						}
						if (!instance) continue;
						instance.data = node;
						injectCurrencyVar(instance, xml);
						arrayList.add(instance)
					}
				}
				return
			}
		}
		private function injectSubNode(node:XML, className:String = null):Object
		{
			var str:String
			if (isEmpty(className))
			{
				str = node.@value.toString();
			}
			else
			{
				str = className;
			}
			var obj:Object = InstanceUtils.getInstance(str);
			if (obj && obj is Injector)
			{
				Injector(obj).data = node;
			}
			return obj;
		}
		private function isReference(node:XML):Boolean
		{
			return node.@valType.toString() == REF;
		}
		//赋予子对象公共变量
		protected function injectCurrencyVar(obj:Object, xml:XML):void
		{
			var attNamesList:XMLList = xml.@*;
			for (var i:int = 0; i < attNamesList.length(); i++)
			{ 
				var attNames:String = attNamesList[i].name();
				if (attNames != "valName" && attNames != "valType" && attNames != "subValue" 
					&& obj.hasOwnProperty(attNames) && !obj[attNames])
				{
					obj[attNames] = xml.attribute(attNames).toString();
				}
			} 
		}
	}
}
package dcx.common
{
	public class RoleStaticObject extends BaseStaticObj
	{
		public function RoleStaticObject()
		{
			
		}
		public var type:int;
		public var model:int;
		public var nickName:String;
		public var chaseRadius:int;
		public var mvSpeed:int;
		public function get modelObj():ModelStaticObj
		{
			return ModelsParser.instance.getItem(model) as ModelStaticObj;
		}
		
		public var hp:int;
		public var ap:int;
		public var skills:int;
	}
}
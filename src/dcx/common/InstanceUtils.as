package dcx.common
{
	import com.dcx.game.utils.text.isEmpty;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.system.ApplicationDomain;

	public class InstanceUtils
	{ 
		public static function getInstance(className:String, ...args):Object
		{
			if (isEmpty(className)) return null;
			var domain:ApplicationDomain = Global.appDomain;
			try
			{
				
				var instanceClass:Class = domain.getDefinition(className) as Class;
				/*if (args != null && args.length > 0) return new instanceClass(args);
				else */
				return new instanceClass();
			}
			catch(e:Error)
			{
				throw e;
			}
			return null;
		}
		public static function getInstanceByDomain(domain:ApplicationDomain, className:String, ...args):Object
		{
			if (isEmpty(className)) return null;
			try
			{
				var instanceClass:Class = domain.getDefinition(className) as Class;
				return new instanceClass();
			}
			catch(e:Error)
			{
				throw e;
			}
			return null;
		}
		
		public static function getClass(className:String):Class
		{
			if (isEmpty(className)) return null;
			var domain:ApplicationDomain = Global.appDomain;
			try
			{
				return domain.getDefinition(className) as Class;
			}
			catch(e:Error)
			{
				throw e;
			}
			return null;
		}
		
		public static function getClassByDomain(domain:ApplicationDomain, className:String):Class
		{
			if (isEmpty(className)) return null;
			try
			{
				return domain.getDefinition(className) as Class;
			}
			catch(e:Error)
			{
				throw e;
			}
			return null;
		}
		
		public static function getName(className:String):DisplayObject
		{
			if (isEmpty(className)) return null;
			className = "artFont.name.".concat(className)
			try
			{
				var cl:Class = Global.appDomain.getDefinition(className) as Class;
				var obj:DisplayObject;
			}
			catch(e:Error)
			{
				return null;
			}
			try
			{
				obj = new cl();
			
			}
			catch(e:Error)
			{
				obj = new Bitmap(new cl(0,0) as BitmapData);
			}
			return obj;
		}
	}
}
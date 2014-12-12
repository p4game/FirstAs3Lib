package com.dcx.game.utils
{

	import com.dcx.game.utils.text.isEmpty;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.system.ApplicationDomain;
	import flash.utils.getQualifiedSuperclassName;

	public class InstanceUtils
	{ 
		public static var defaultDomain:ApplicationDomain;
		public static function getInstance(className:String, appDomain:ApplicationDomain = null):Object
		{
			var cl:Class = getClass(className, appDomain);
			if (!cl) return null;
			var typeDes:String = getQualifiedSuperclassName(cl);
			if (typeDes == "flash.display::BitmapData")
			{
				return new cl(0, 0);
			}
			else
			{
				return new cl();
			}
		}
		
		public static function getClass(className:String, appDomain:ApplicationDomain = null):Class
		{
			if (isEmpty(className)) return null;
			var domain:ApplicationDomain = appDomain ? appDomain : defaultDomain;
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
	}
}
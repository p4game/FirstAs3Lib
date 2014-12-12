package com.dcx.game.utils
{
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BitmapFilterType;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.filters.GradientGlowFilter;
	
	public class FilterUtil
	{
		public static function get colorMatrixFilter():Array
		{
			var matrix:Array = new Array();
	            matrix = matrix.concat([1, 1, 0, 0, 0]); // red
	            matrix = matrix.concat([0, 0, 0, 0, 0]); // green
	            matrix = matrix.concat([0, 0, 0, 0, 0]); // blue
	            matrix = matrix.concat([0, 0, 0, 0.5, 0]);
			var filter:ColorMatrixFilter = new ColorMatrixFilter(matrix);
	            var filters:Array = new Array();
	            filters.push(filter);
	        return filters;
		}
		private static var _grayFilter:Array;
		public static function grayFilter():Array 
		{
			if (!_grayFilter)
			{
				var matrix:Array = [0, 1, 0, 0, 0,
					0, 1, 0, 0, 0,
					0, 1, 0, 0, 0,
					0, 0, 0, 1, 0];
				_grayFilter = [new ColorMatrixFilter(matrix)];
			}
			return _grayFilter;
		}
		public static function get whiteFilter():Array
		{
			return [new GlowFilter(0x000000, 1, 1.8, 1.8, 3, 1)];
		}
		public static function get blackFilter():Array
		{
			return [new GlowFilter(0xffffff, 1, 2, 2, 3, 1)];
		}
		private static var _glowFilter:Array;
		public static function get glowFilter():Array
		{
			if (!_glowFilter)
			{
				_glowFilter = [new GlowFilter(0xffba00, 1, 2, 2, 10, 3)]
			}
			return _glowFilter;
		}

		public static function getColorGlowFilter(color:uint):Array
		{
			return [new GlowFilter(color, 1, 2, 2, 10, 3)];
		}
		public static function get redGlowFilter():Array
		{
			return [new GlowFilter(0xF15418, 1, 3, 3, 5, 1)];
		}
		public static function get blueGlowFilter():Array
		{
			return [new GlowFilter(0x25E9BC, 1, 3, 3, 5, 1)];
		}
		public static function get grayGlowFilter():Array
		{
			return [new ColorMatrixFilter([0.3,0.6,0,0,0,0.3,0.6,0,0,0,0.3,0.6,0,0,0,0,0,0,1,0])];
		}
		public static function get shadowFilter():Array
		{
			return [new DropShadowFilter(5,68,0,1,5,5,0.3,1)];
		}
		public static function get gradientGlowFilter():Array
		{
			var distance:Number=0;
			var angleInDegress:Number=45;
			var colors:Array=[0xffffff,0xffffbe];
			var alphas:Array=[0,1];
			var ratios:Array=[0,120];
			var blurX:Number=15;
			var blurY:Number=15;
			var strength:Number=1;
			var quality:Number=BitmapFilterQuality.HIGH;
			var type:String=BitmapFilterType.OUTER;
			var knockout:Boolean=false;
			return [new GradientGlowFilter(distance,angleInDegress,colors,alphas,ratios,blurX,blurY,strength,quality,type,knockout)];
		}
		
		public static function get InstanceGlowFilter():Array
		{
			var distance:Number=0;
			var angleInDegress:Number=45;
			var colors:Array=[0xffffff,0xffffbe];
			var alphas:Array=[0,1];
			var ratios:Array=[0,120];
			var blurX:Number=7;
			var blurY:Number=7;
			var strength:Number=1;
			var quality:Number=BitmapFilterQuality.HIGH;
			var type:String=BitmapFilterType.OUTER;
			var knockout:Boolean=false;
			return [new GradientGlowFilter(distance,angleInDegress,colors,alphas,ratios,blurX,blurY,strength,quality,type,knockout)];
		}
		
		public static function lightGlowFilter(start:Number=0x000000, end:Number=0x000000):Array
		{
			var distance:Number=0;
			var angleInDegress:Number=45;
			var colors:Array=[start,end];
			var alphas:Array=[0,1];
			var ratios:Array=[0,120];
			var blurX:Number=7;
			var blurY:Number=7;
			var strength:Number=1;
			var quality:Number=BitmapFilterQuality.HIGH;
			var type:String=BitmapFilterType.OUTER;
			var knockout:Boolean=false;
			return [new GradientGlowFilter(distance,angleInDegress,colors,alphas,ratios,blurX,blurY,strength,quality,type,knockout)];
		}
	}
}
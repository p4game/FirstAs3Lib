package com.dcx.game.utils
{
	import flash.geom.Point;

	public class MathUtils
	{
		public static function distanceOf(x1:Number,y1:Number,x2:Number,y2:Number):Number
		{
			var dx:Number = x1 - x2;
			var dy:Number = y1 - y2;
			var dist:Number = Math.sqrt(dx * dx + dy * dy);
			return dist;
		}
		public static function distanceGridOf(point1:Point,point2:Point):Number
		{
			var dx:Number = point1.x - point2.x;
			var dy:Number = point1.y - point2.y;
			var dist:Number = Math.sqrt(dx * dx + dy * dy);
			return dist;
		}

		public static function inRange(point1:Point,point2:Point, rad:int):Boolean
		{
			var dist:Number = distanceGridOf(point1, point2);
			return dist <= rad + 1;
		}
	}
}
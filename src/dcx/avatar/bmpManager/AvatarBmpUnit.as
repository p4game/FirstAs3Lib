package dcx.avatar.bmpManager
{
	import flash.display.BitmapData;

	public class AvatarBmpUnit
	{
		public function AvatarBmpUnit()
		{
		}
		public var bmd:BitmapData;
		private var _oX:int
		public function set oX(value:int):void
		{
			_oX = value;
		}
		public function get oX():int
		{
			return _oX;
		}
		private var _oY:int
		public function set oY(value:int):void
		{
			_oY = value;
		}
		public function get oY():int
		{
			return _oY;
		}
	}
}
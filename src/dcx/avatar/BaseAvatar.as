package dcx.avatar
{
	import com.friendsofed.isometric.IsoUtils;
	
	import dcx.avatar.bmpManager.AvatarEnum;
	import dcx.avatar.status.BaseAvatarStatus;
	import dcx.avatar.status.RunStatus;
	import dcx.common.RoleStaticObject;
	import dcx.map.BaseMapItem;
	import dcx.utils.Urlf;
	
	import flash.display.Bitmap;
	import flash.geom.Point;
	import flash.utils.Dictionary;

	public class BaseAvatar extends BaseMapItem
	{

		public function BaseAvatar(staticObj:RoleStaticObject, defaultStatus:String = AvatarEnum.STAND)
		{
			super(staticObj.type);
			_staticObj = staticObj;
			_bitmap = new Bitmap(null, "auto", true);
			this.addChild(_bitmap);

			statusMap = new Dictionary();
			setDirection(AvatarEnum.RIGHT);
			setStatus(defaultStatus);
		}
		
		private var _bitmap:Bitmap;
		public function get bitmap():Bitmap
		{
			return _bitmap;
		}
		private var _direction:int;
		public function get direction():int
		{
			return _direction;
		}
		private var _staticObj:RoleStaticObject;
		public var statusName:String;
		protected var status:BaseAvatarStatus;
		protected var statusMap:Dictionary;
		override public function get typeID():int
		{
			return staticObj.id;
		}
		public function get staticObj():RoleStaticObject
		{
			return _staticObj;
		}
		public function get gridPoint():Point
		{
			return IsoUtils.screenToGrid(x,y);
		}
		public function setStatus(newStatusName:String):void
		{
			if (statusName == newStatusName) return;
			if (status) status.end();
			statusName = newStatusName;
			status = getStatus(statusName);
			status.start();
		}
		public function run(path:Array):void
		{
			setStatus(AvatarEnum.RUN); 
			RunStatus(status).moveByPath(path);
		}
		public function stand():void
		{
			setStatus(AvatarEnum.STAND);
		}

		private function setDirection(value:int):void
		{
			_direction = value;
			this.scaleX = _direction > 5 ? -1 : 1;
		}
		public function refreshDirection(toX:Number, toY:Number):void
		{
			var dx:Number = toX - x;
			var dy:Number = y - toY;
			var a:Number = Math.atan2(dy, dx);
			if (a > -Math.PI / 8 && a <= Math.PI / 8) setDirection(AvatarEnum.RIGHT)
			else if (a > Math.PI / 8 && a <= Math.PI * 3 / 8) setDirection(AvatarEnum.UP_RIGHT)
			else if (a > Math.PI * 3 / 8 && a <= Math.PI * 5 / 8) setDirection(AvatarEnum.UP)
			else if (a > Math.PI * 5 / 8 && a <= Math.PI * 7 / 8) setDirection(AvatarEnum.UP_LEFT)	
			else if (a > -Math.PI * 7 / 8 && a <= -Math.PI * 5 / 8) setDirection(AvatarEnum.DOWN_LEFT)	
			else if (a > -Math.PI * 5 / 8 && a <= -Math.PI * 3 / 8) setDirection(AvatarEnum.DOWN)	
			else if (a > -Math.PI * 3 / 8 && a <= -Math.PI / 8) setDirection(AvatarEnum.DOWN_RIGHT)	
			else setDirection(AvatarEnum.LEFT)	
			/*
			if (toX > x && toY < y) setDirection(AvatarEnum.UP_RIGHT)
			else if (toX > x && toY == y) setDirection(AvatarEnum.RIGHT)
			else if (toX > x && toY > y) setDirection(AvatarEnum.DOWN_RIGHT)
			else if (toX < x && toY < y) setDirection(AvatarEnum.UP_LEFT)	
			else if (toX < x && toY == y) setDirection(AvatarEnum.LEFT)	
			else if (toX < x && toY > y) setDirection(AvatarEnum.DOWN_LEFT)	
			else if (toX == x && toY < y) setDirection(AvatarEnum.UP)	
			else if (toX == x && toY > y) setDirection(AvatarEnum.DOWN)	*/
		}
		protected function getStatus(statusName:String):BaseAvatarStatus
		{
			var status:BaseAvatarStatus = statusMap[statusName];
			var xmlURL:String = Urlf.getUrl(Urlf.ROLE, staticObj.modelObj.path +  staticObj.modelObj[statusName]);
			if (statusName == AvatarEnum.RUN)
			{
				if (!status) status = new RunStatus(this, statusName, xmlURL, null);
			}
			else if (statusName == AvatarEnum.STAND)
			{
				if (!status) status = new BaseAvatarStatus(this, statusName, xmlURL);
			}
			statusMap[statusName] = status;
			return status;
		}

		override public function clone():Object
		{
			return new BaseAvatar(staticObj);
		}
	}
}
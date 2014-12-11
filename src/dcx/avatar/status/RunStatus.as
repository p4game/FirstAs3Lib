package dcx.avatar.status
{
	import dcx.avatar.BaseAvatar;
	import dcx.map.MapGrid;
	
	import flash.display.Bitmap;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	public class RunStatus extends BaseAvatarStatus
	{
		private const speed:Number = 8;//像素/祯
		public function RunStatus(avatar:BaseAvatar, statusName:String, xmlURL:String, cameraUpdate:Function)
		{
			super(avatar, statusName, xmlURL);
			this.cameraUpdate = cameraUpdate;
			this.avatar = avatar;
		}
		private var cameraUpdate:Function;
		private var path:Array;
		
		private var moveDx:Number;
		private var moveDy:Number;
		private var moveTotalCount:int;
		private var moveCurrentCount:int;
		
		protected var isMoving:Boolean;
		public function moveByPath(pa:Array):void
		{
			path = pa;
			path.splice(path.length -1);
			var startIndex:int = path.length - 1;
			var current:Point = avatar.gridPoint;
			for (var i:int = startIndex; i > -1; i--) 
			{
				var grid:MapGrid = path[i];
				if (grid.xIndex == current.x && grid.zIndex == current.y)
				{
					path.splice(i);
					break;
				}
			}
			
				
			moveToNextGrid();
			isMoving = true;
		}
		protected function moveToNextGrid():void
		{
			if (path.length == 0) 
			{
				completePath();
				return;
			}
			var grid:MapGrid = path.pop();
			avatar.refreshDirection(grid.screenx, grid.screeny);
			moveDx = grid.screenx - avatar.x;
			moveDy = grid.screeny - avatar.y;
			var dist:Number = Math.sqrt(moveDx * moveDx + moveDy * moveDy);
			moveTotalCount = dist / speed
			moveCurrentCount = 0;
		}
		protected function completePath():void
		{
			avatar.stand();
			isMoving = false;
			dispathEndEvent();
		}
		private function moving():void
		{
			if (!isMoving) return;
			if (moveCurrentCount >= moveTotalCount)
			{
				moveToNextGrid();
				return;
			}
			moveCurrentCount++;
			avatar.x += moveDx / moveTotalCount;
			avatar.y += moveDy / moveTotalCount;
			if (cameraUpdate is Function) cameraUpdate();
		}
		override protected function enterFrame():void
		{
			super.enterFrame();
			moving();
		}
	}
}
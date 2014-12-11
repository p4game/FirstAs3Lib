package dcx.utils
{
	import com.friendsofed.isometric.IsoObject;
	import com.friendsofed.isometric.IsoUtils;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	public class DragComponent
	{
		public function DragComponent()
		{
		}
		
		private var mousex:Number;
		private var mousey:Number;
		private var dragObj:DisplayObject;
		private var _isStart:Boolean;
		public function startDrag(obj:DisplayObject):void
		{
			if (_isStart) return;
			_isStart = true;
			mousex = obj.mouseX;
			mousey = obj.mouseY;
			dragObj = obj;
		}
		public function getDragObj():DisplayObject
		{
			return dragObj;
		}
		public function dragMoving():void
		{
			if (_isStart)
			{
				var disX:Number = (dragObj.mouseX - mousex) * dragObj.scaleX;
				var disY:Number = (dragObj.mouseY - mousey)* dragObj.scaleY;
				if (dragObj is IsoObject)
				{
					var p:Point = IsoUtils.isoToScreen(IsoObject(dragObj).position);
					IsoObject(dragObj).position = IsoUtils.screenToIso(new Point(p.x + disX, p.y + disY));
				}
				else
				{
					dragObj.x = dragObj.x + disX;
					dragObj.y = dragObj.y + disY;
				}
			}
		}
		public function stopDrag():void
		{
			if (_isStart)
			{
				_isStart = false;
				mousex = 0;
				mousey = 0;
				dragObj = null;
			}
		}
	}
}
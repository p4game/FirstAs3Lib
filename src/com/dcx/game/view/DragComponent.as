package com.dcx.game.view
{
	import flash.display.DisplayObject;
	
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
				dragObj.x = dragObj.x + disX;
				dragObj.y = dragObj.y + disY;
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
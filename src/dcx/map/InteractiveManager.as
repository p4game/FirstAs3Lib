package dcx.map
{
	import com.dcx.game.component.listenermanager.EventRegistry;
	
	import dcx.avatar.BaseAvatar;
	import dcx.common.Global;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class InteractiveManager extends EventDispatcher
	{
		public function InteractiveManager()
		{
			
		}
		private var rootContainer:Sprite;
		private var currentItem:InterActive;
		public function setEnable(value:Boolean):void
		{
			if (value)
			{
				EventRegistry.instance.registerEventListener(Global.stage, MouseEvent.MOUSE_UP, onMouseUp);
				EventRegistry.instance.registerEventListener(rootContainer, MouseEvent.MOUSE_DOWN, onMouseDown);
				EventRegistry.instance.registerEventListener(rootContainer, MouseEvent.MOUSE_MOVE, onMouseMove);
			}
			else
			{
				EventRegistry.instance.removeListener(Global.stage, MouseEvent.MOUSE_UP, onMouseUp);
				EventRegistry.instance.removeListener(rootContainer, MouseEvent.MOUSE_DOWN, onMouseDown);
				EventRegistry.instance.removeListener(rootContainer, MouseEvent.MOUSE_MOVE, onMouseMove);
			}
		}
		public function setAvatarMoveEnable(value:Boolean):void
		{
			if (value)
			{
				EventRegistry.instance.registerEventListener(rootContainer, MouseEvent.MOUSE_DOWN, onMouseDown);
			}
			else
			{
				EventRegistry.instance.removeListener(rootContainer, MouseEvent.MOUSE_DOWN, onMouseDown);
			}
		}
		public function initialize(stage:Sprite):void
		{
			EventRegistry.instance.registerEventListener(Global.stage, Event.MOUSE_LEAVE, onMouseLeave);
			this.rootContainer = stage;
			setActionLayer();

		}
		private function setActionLayer():void
		{
			if (!rootContainer.hasEventListener(MouseEvent.MOUSE_MOVE))
			{
				EventRegistry.instance.registerEventListener(Global.stage, MouseEvent.MOUSE_UP, onMouseUp);
				EventRegistry.instance.registerEventListener(rootContainer, MouseEvent.MOUSE_DOWN, onMouseDown);
				EventRegistry.instance.registerEventListener(rootContainer, MouseEvent.MOUSE_MOVE, onMouseMove);
				EventRegistry.instance.registerEventListener(rootContainer, MouseEvent.MOUSE_OUT, onMouseOut);
			}
		}
		public function dispose():void
		{
			EventRegistry.instance.removeListener(Global.stage, MouseEvent.MOUSE_UP, onMouseUp);
			EventRegistry.instance.removeListener(rootContainer, MouseEvent.MOUSE_DOWN, onMouseDown);
			EventRegistry.instance.removeListener(rootContainer, MouseEvent.MOUSE_MOVE, onMouseMove);
			rootContainer = null;
			currentItem = null;
		}
		private function onMouseLeave(event:Event):void
		{
			isDown = false;
			currentItem = null;
			EventRegistry.instance.removeListener(rootContainer, Event.ENTER_FRAME, enterFrame);	
		}
		private function onMouseUp(event:MouseEvent):void
		{
			isDown = false;
			if (currentItem )
			{
				currentItem.onMouseClick();
				/*
				var evt:InterActiveEvent = new InterActiveEvent(InterActiveEvent.MOUSE_DOWN_TARGET);
				evt.clickItem = currentItem as BaseAvatar;
				dispatchEvent(evt);*/
			}
			currentItem = null;
			EventRegistry.instance.removeListener(rootContainer, Event.ENTER_FRAME, enterFrame);	
		}
		private function onMouseOut(event:MouseEvent):void
		{
			if (currentItem) currentItem.onMouseOut();
			currentItem = null;
		}
		private var isDown:Boolean;
		private function onMouseDown(event:MouseEvent):void
		{
			
			isDown = true;
			interactiveMouseMove();
			if (!currentItem)
			{
				dispatchEvent(new InterActiveEvent(InterActiveEvent.MOUSE_DOWN_NO_TARGET));
				EventRegistry.instance.registerEventListener(rootContainer, Event.ENTER_FRAME, enterFrame);	
			}
			else
			{
				currentItem.onMouseDown();
			}
			/*
			var arr:Array = Global.stage.getObjectsUnderPoint(new Point(Global.stage.mouseX, Global.stage.mouseY));
			for (var i:int = arr.length - 1; i > -1; i--)
			{
				var obj:DisplayObject = arr[i] as DisplayObject;
				checkObj(obj)
			}*/
		}
		private function enterFrame(event:Event):void
		{
			//dispatchEvent(new AvatartMoveEvent());
		}
		private function onMouseMove(event:MouseEvent):void
		{
			if (isDown)
			{
				//if (!currentItem) dispatchEvent(new AvatartMoveEvent());
			}
			else
			{
				interactiveMouseMove();
			}
			
		}

		private function interactiveMouseMove():void
		{
			var item:InterActive;
			var arr:Array = Global.stage.getObjectsUnderPoint(new Point(Global.stage.mouseX, Global.stage.mouseY));
			for (var i:int = arr.length - 1; i > -1; i--)
			{
				var obj:DisplayObject = arr[i] as DisplayObject;
				if (obj)
				{
					item = checkObj(obj);
					if (item)
					{
						if (currentItem != item)
						{
							if (currentItem) currentItem.onMouseOut();
							currentItem = item;
							currentItem.onMouseOver();
						}
						return; 
					}
					
				}
			}
			if (currentItem)
			{
				currentItem.onMouseOut();
				currentItem = null;
			}
		}
		private function checkObj(obj:DisplayObject):InterActive
		{
			if (!obj) return null;
			if (obj is InterActive && InterActive(obj).isInteractive())
			{
				if (isHit(obj))
				return obj as InterActive;
			}
			else if (obj != rootContainer)
			{
				return checkObj(obj.parent);
			}
			return null;
		}
		private function isHit(obj:DisplayObject):Boolean
		{
			if (obj is Bitmap)
			{
				if (Bitmap(obj).bitmapData)
				{
					var pixelValue:uint = Bitmap(obj).bitmapData.getPixel32(obj.mouseX, obj.mouseY);
					var alphaValue:uint = pixelValue >> 24 & 0xFF;
					if (alphaValue > 0) return true;
				}
			}
			else if (obj is Shape)
			{
				return true;
			}
			else if (obj is DisplayObjectContainer)
			{
				var len:int = DisplayObjectContainer(obj).numChildren;
				for (var i:int = 0; i < len; i++) 
				{
					if (isHit(DisplayObjectContainer(obj).getChildAt(i))) return true;
				}
				
			}
			return false;
		}
	}
}
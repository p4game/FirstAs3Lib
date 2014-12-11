package com.dcx.game.component
{
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;

	public class SimpleList
	{
		public function SimpleList()
		{
		}
		private var preBtn:DisplayObject;
		private var nextBtn:DisplayObject;
		private var _startIndex:int = 0;
		private var components:Array;
		private var maxShow:int;
		private var offset:int;
		private var isVertical:Boolean;//是否垂直
		private var alwaysShow:Boolean;
		private var initPos:int;
		public function setButtons(preBtn:InteractiveObject, nextBtn:DisplayObject, isVertical:Boolean = false):void
		{
			this.preBtn = preBtn;
			this.nextBtn = nextBtn;
			this.isVertical = isVertical;
			preBtn.addEventListener(MouseEvent.CLICK, pre, false, 1);
			nextBtn.addEventListener(MouseEvent.CLICK, next, false, 1);
		}
		public function setComponents(components:Array, maxShow:int, offset:Number, initP:int, isAlwaysShow:Boolean = true):void
		{
			this.maxShow = maxShow;
			this.offset = offset;
			this.components = components;
			alwaysShow = isAlwaysShow;
			setEnable(preBtn, false);
			if (components.length <= maxShow)
			{
				if (!isAlwaysShow) preBtn.visible = false;
				if (!isAlwaysShow) nextBtn.visible = false;
				setEnable(nextBtn, false);
			}
			else
			{
				setEnable(nextBtn, true);
			}
			initPos = initP;
			for (var i:int = 0; i < components.length; i++) 
			{
				var item:DisplayObject = components[i];
				//if (i == 0) initPos = isVertical ? item.y : item.x;
				refreshVisible(item, i);
			}
			refreshBtnVisible();
			refreshPos();
		}
		private var limitIndex:int = 0;
		public function setLimitIndex(index:int):void
		{
			limitIndex = index;
		}

		private function next(event:MouseEvent):void
		{
			if (_startIndex +  maxShow == components.length + limitIndex) return;
			_startIndex++;
			refreshPos();
			refreshBtnVisible();
		}
		private function pre(event:MouseEvent):void
		{
			if (_startIndex == 0 - limitIndex) return;
			_startIndex--;
			refreshPos();
			refreshBtnVisible();
		}
		private function refreshPos():void
		{
			for (var i:int = 0; i < components.length; i++) 
			{
				var item:DisplayObject = components[i];
				if (isVertical)
				{
					item.y = initPos + (i - _startIndex) * offset;
				}
				else
				{
					item.x = initPos + (i - _startIndex) * offset;
				}
				refreshVisible(item, i);
			}
		}
		private function refreshVisible(item:DisplayObject,index:int):void
		{
			item.visible = index >= _startIndex && index < _startIndex + maxShow;
		}
		
		private function refreshBtnVisible():void
		{
			//preBtn.visible = _startIndex > 0;
			//nextBtn.visible = startIndex +  maxShow < components.length;
			
			setEnable(preBtn, _startIndex > 0);
			setEnable(nextBtn, _startIndex +  maxShow < components.length);
			
		}
		private function setEnable(btn:DisplayObject, value:Boolean):void
		{
			InteractiveObject(btn).mouseEnabled = value;
			btn.filters = value ? null : grayFilter();
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
		public function dispose():void
		{
			preBtn.removeEventListener(MouseEvent.CLICK, pre);
			nextBtn.removeEventListener(MouseEvent.CLICK, next);
			preBtn = null;
			nextBtn = null;
			components = null;
		}
	}
}
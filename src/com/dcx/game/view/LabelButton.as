package com.dcx.game.view
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.text.TextFormatAlign;

	public class LabelButton extends ButtonComponent
	{
		
		public function LabelButton(label:String, button:DisplayObject = null, disableState:DisplayObject = null, vOffset:Number = 2)
		{
			_label = new Label(label);
			_label.y = vOffset;
			_label.align = TextFormatAlign.CENTER;
			if (!button)
			{
				button = new Sprite();
				Sprite(button).buttonMode = true;
				Sprite(button).graphics.beginFill(0x000000, 0);
				Sprite(button).graphics.drawRect(0,0,_label.width, _label.height);
			}
			super(button, disableState)
			_label.mouseEnabled = false;
			_label.width = width;
			_label.height = height - vOffset;
			addChild(_label);
			
			drawBk();
		}
		private var _label:Label;
		public function get label():Label
		{
			return _label;
		}
		public function set labelString(value:String):void
		{
			label.labelString = value;
			drawBk();
		}
		private function drawBk():void
		{
			if (!button)
			{
				graphics.clear();
				graphics.beginFill(0xFFFFFF, 0);
				graphics.drawRect(0, 0, _label.width, _label.height);
			}
		}
	}
}
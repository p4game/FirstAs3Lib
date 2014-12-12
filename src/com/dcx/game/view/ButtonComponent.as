package com.dcx.game.view
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;

	public class ButtonComponent  extends BaseSprite
	{
		public function ButtonComponent(button:DisplayObject, disableState:DisplayObject = null)
		{
			super(button);
			this.button = button;
			this.disableState = disableState;
			if (!disableState && button is SimpleButton) 
			{
				var bmd:BitmapData = new BitmapData(button.width, button.height, true, 0x00000000);
				bmd.draw(SimpleButton(button).downState);
				this.disableState = new Bitmap(bmd);
			}
			if (disableState)
			{
				disableState.x = button.x;
				disableState.y = button.y;
			}
		}
		protected var disableState:DisplayObject;
		protected var button:DisplayObject;
		public function getButton():DisplayObject
		{
			return button;
		}
		public function set enabled(value:Boolean):void
		{
			if (button is SimpleButton) SimpleButton(button).enabled = value;
			this.mouseEnabled = value;
			this.mouseChildren = value;
			
			if (!disableState) return;
			if (!value)
			{
				this.addChildAt(disableState, 1);
				this.button.visible = false ;
			}
			else if (this.contains(disableState))
			{
				this.removeChild(disableState);
				this.button.visible = true ;
			}
		}
	}
}
package dcx.avatar.status
{
	import dcx.avatar.BaseAvatar;
	import dcx.avatar.bmpManager.AvatarBmp;
	import dcx.avatar.bmpManager.AvatarBmpUnit;
	import dcx.avatar.bmpManager.AvatarBmps;
	import dcx.avatar.bmpManager.AvatarEnum;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getTimer;

	public class BaseAvatarStatus
	{
		private var testSP:Sprite;
		public function BaseAvatarStatus(avatar:BaseAvatar, statusName:String, xmlURL:String)
		{
			
			this.url = xmlURL;
			this.avatar = avatar;
			this.statusName = statusName;
			this.bitmap = avatar.bitmap;
			testSP = new Sprite();
			source = AvatarBmps.instance.getBmps(xmlURL);
			if (!source.isComplete())
			{
				source.addEventListener(Event.COMPLETE, bmpLoadComplete);
			}
		}
		protected var avatar:BaseAvatar;
		protected var statusName:String;
		private var isStart:Boolean;
		private var flagIndex:int = -1;
		private var frame:int = 0;
		
		private var bitmap:Bitmap;
		private var url:String;
		private var source:AvatarBmp;
		private function bmpLoadComplete(event:Event):void
		{
			source.removeEventListener(Event.COMPLETE, bmpLoadComplete);
			if (isStart) start();
		}
		private function get bmds():Array
		{
			return source.getBmds(bmpIndex);
		}
		protected function get bmpIndex():int
		{
			var dir:int = avatar.direction
			var index:int = dir;
			if (dir > 5) index = dir - 3;
			return index;
		}
		public function start():void
		{
			if (source.isComplete())
			{
				testSP.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			}	
			isStart = true;
		}
		
		public function end():void
		{
			isStart = false;
			testSP.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		public function dispose():void
		{
			end();
			source.removeEventListener(Event.COMPLETE, bmpLoadComplete);
			bitmap = null;
			source = null;
			
		}
		private function enterFrameHandler(event:Event) : void
		{
			enterFrame();
		}
		protected function enterFrame():void
		{
			var time:int = 800 / bmds.length;
			var index:int = getTimer() / time % bmds.length;
			if (this.flagIndex != index)
			{
				this.flagIndex = index;
				setBitmapData(frame);
				frame++;
				if (frame >= bmds.length)
				{
					frame = 0;
					animationEnd();
				}
			}
		}
		protected function dispathEndEvent():void
		{
			var event:AvatarStatusEvent = new AvatarStatusEvent(AvatarStatusEvent.AVATAR_STATUS_END, statusName);
			avatar.dispatchEvent(event);
		}
		protected function animationEnd():void
		{
			
		}
		private function setBitmapData(index:int):void
		{
			var bmdUnit:AvatarBmpUnit = bmds[index];
			bitmap.bitmapData = bmdUnit.bmd;
			bitmap.y = bmdUnit.oY * -1;
			bitmap.x = bmdUnit.oX * -1;
		}

	}
}
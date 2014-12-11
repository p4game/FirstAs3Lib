package dcx.common
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.system.ApplicationDomain;
	import flash.system.SecurityDomain;
	import flash.utils.Timer;

	
	public class Global
	{
		private static var _appDomain:ApplicationDomain;
		public static function set appDomain(value:ApplicationDomain):void
		{
			_appDomain = value;
		}
		public static function get appDomain():ApplicationDomain
		{
			return _appDomain;
		}
		private static var _stage:Stage;
		public static function set stage(value:Stage):void
		{
			_stage = value;
			_stage.align = StageAlign.TOP_LEFT;
			_stage.scaleMode = StageScaleMode.NO_SCALE;
			_width = _stage.stageWidth;
			_height = _stage.stageHeight;
		}
		public static function get stage():Stage
		{
			return _stage;
		}
		
		public static var preload:DisplayObject;
		public static function hidePreload():void
		{
			if (preload && preload.parent) preload.parent.removeChild(preload);
		}
		public static function showPreload():void
		{
			if (preload) stage.addChild(preload);
		}
		public static function refreshSize(w:int, h:int):void
		{
			_width = w;
			_height = h;
			_dispatcher.dispatchEvent(new Event(Event.RESIZE));
		}
		private static var _dispatcher:EventDispatcher = new EventDispatcher();
		public static function get dispatcher():EventDispatcher
		{
			return _dispatcher;
		}
		private static var _width:int
		public static function get width():int
		{
			return _width;
		}
		private static var _height:int
		public static function get height():int
		{
			return _height;
		}
		
		public static var ddz_url:String;
		
		public static var  timeZone:int = -28800;
		private static var timer:Timer;
		private static var _serverTime:int;
		public static function set serverTime(value:int):void
		{
			_serverTime = value;
			if (!timer)
			{
				timer = new Timer(1000);
				timer.addEventListener(TimerEvent.TIMER, timerHandler);
				timer.start();
			}
		}
		public static function get serverTime():int
		{
			return _serverTime;
		}
		private static function timerHandler(event:TimerEvent):void
		{
			_serverTime++;
		}
	}
}
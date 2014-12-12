package com.dcx.game.view
{
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class Label extends TextField
	{
		private var _format:TextFormat;
		public function Label(text:String = "", color:int = 0xffffff, size:int = 12, width:Number = 0, height:Number = 0, multiline:Boolean = false, bold:Boolean = false)
		{
			super();
			_format = new TextFormat();
			_format.font = "Arial";
			_format.color = color;
			_format.size = size;
			_format.bold = bold;
			defaultTextFormat = _format;
			
			cacheAsBitmap = true;
			selectable = false;
			mouseEnabled = false;
			this.width = width;
			this.height = height;
			labelString = text;
			this.multiline = multiline;
			this.wordWrap = multiline;

		}
		public function set labelString(value:String):void
		{
			text = value;
			if (width <= 0) width = textWidth + 4;
			if (height <= 0) height = textHeight + 4;
		}
		
		public function set htmlLabelString(value:String):void
		{
			htmlText = value;
			if (width <= 0) width = textWidth + 4;
			if (height <= 0) height = textHeight + 4;
		}
		
		public function set font(value:String):void
		{
			_format.font = value;
			defaultTextFormat = _format;
			text = text;
		}
		public function set fontSize(value:int):void
		{
			_format.size = value;
			defaultTextFormat = _format;
			text = text;
		}
		public function set fontColor(color:int):void
		{
			_format.color = color;
			defaultTextFormat = _format;
			text = text;
		}
		public function set align(value:String):void
		{
			_format.align = value;
			defaultTextFormat = _format;
			text = text;
		}
		public function set leading(value:int):void
		{
			_format.leading = value;
			defaultTextFormat = _format;
			text = text;
		}
		public function set bold(value:Boolean):void
		{
			_format.bold = value;
			defaultTextFormat = _format;
			text = text;
			if (width < textWidth + 4) width = textWidth + 4;
		}
		
		public function set underline(value:Boolean):void
		{
			_format.underline = value;
			defaultTextFormat = _format;
			text = text;
			width = textWidth + 4;
		}
	}
}
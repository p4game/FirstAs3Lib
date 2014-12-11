package com.dcx.game.component.ui
{
	import com.dcx.game.component.listenermanager.EventRegistry;
	import com.dcx.game.core.Disposable;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	public class ViewComponet extends Sprite implements Disposable
	{
		public function ViewComponet(view:DisplayObject = null)
		{
			if (!view) return;
 			if (view.parent)
			{
				view.parent.addChild(this);
			}
			this.addChild(view);
			this.x = view.x;
			this.y = view.y;
			view.x = 0;
			view.y = 0;
		}
		private var listerens:Array;
		public function dispose():void
		{
			if (listerens)
			{
				for (var i:int = listerens.length - 1; i > -1; i--) 
				{
					var arr:Array = listerens[i];
					EventRegistry.instance.removeListener(arr[0], arr[1], arr[2], arr[3]);
				}
				listerens.splice(0);
			}
			disposeDisplayObjectContainer(this, true);
			listerens = null;
		}
		private function getListeren():Array
		{
			if (!listerens)
			{
				listerens = [];
			}
			return listerens;
		}
		private function disposeDisplayObjectContainer(root:DisplayObjectContainer, remove:Boolean):void
		{
			for (var i:int = root.numChildren - 1; i > -1; i--) 
			{
				var obj:DisplayObject = root.getChildAt(i);
				if (obj is Disposable)
				{
					Disposable(obj).dispose();
				}
				else if (obj is DisplayObjectContainer && !(obj is Loader))
				{
					disposeDisplayObjectContainer(obj as DisplayObjectContainer, false);
				}
				if (remove) root.removeChild(obj);
			}
		}
		public function disposeObj(obj:Object):void
		{
			if (obj is DisplayObject && DisplayObject(obj).parent)
			{
				DisplayObject(obj).parent.removeChild(DisplayObject(obj))
			}
				
			if (obj is Disposable) Disposable(obj).dispose();
		} 
		
		public function removeAllChild():void
		{
			while(numChildren > 0)
			{
				var obj:DisplayObject = getChildAt(0);
				removeChild(obj);
			}
		}
		/**
		 * alias for EventRegistry.instance.registerEvent
		 *  
		 * @param eventDispatcher
		 * @param type
		 * @param listener
		 * @param useCapture
		 * @param priority
		 * @param useWeakReference
		 * @param persist
		 * 
		 */
		protected function re(eventDispatcher : IEventDispatcher, 
                                                type : String, 
                                                listener : Function,
                                                useCapture : Boolean = false,
                                                priority : int = 0,
                                                useWeakReference : Boolean = false,
                                                persist: Boolean = true) : void {
			getListeren().push([eventDispatcher, type, listener, useCapture]);
        	EventRegistry.instance.registerEventListener(eventDispatcher,type,listener,useCapture,priority,useWeakReference,persist);                               	
        }
        
		/**
		 * alias for EventRegistry.instance.disposeListeners
		 *  
		 * @param eventDispatcher
		 */
		protected function dl(dispatcher : IEventDispatcher) : void 
		{
			if (!listerens) return;
			for (var i:int = listerens.length - 1; i > -1; i--) 
			{
				var arr:Array = listerens[i];
				if (arr[0] == dispatcher)
				{
					EventRegistry.instance.disposeListeners(dispatcher);
					listerens.splice(i, 1);
				}
			}
		}
		
		/**
		 * alias for EventRegistry.instance.removeListener 
		 * 
		 * @param eventDispatcher
		 * @param type
		 * @param listener
		 * @param useCapture
		 */
		protected function rl(dispatcher : IEventDispatcher, 
        									type: String,
        									listener: Function,
        									useCapture: Boolean = false): void 
		{
			if (!listerens) return;
			for (var i:int = 0; i < listerens.length; i++) 
			{
				var arr:Array = listerens[i];
				if (arr[0] == dispatcher && arr[1] == type && arr[2] == listener && arr[3] == useCapture)
				{
					listerens.splice(i, 1);
					EventRegistry.instance.removeListener(dispatcher, type, listener, useCapture);	
				}
			}								
		}
	}
}
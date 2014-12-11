package com.dcx.game.component.listenermanager{
    import flash.display.DisplayObject;
    import flash.events.Event;
    import flash.events.IEventDispatcher;
    import flash.utils.getQualifiedClassName;
    
    /**
     * todo : docs on EventRegistry.
     */
    public class EventRegistry {
    
        private var registeredEventMaps : Array;

        private static var me : EventRegistry = null;

        public function EventRegistry(s : SingletonRegistry) : void {
            if(s) {
               registeredEventMaps = new Array();
               return;
            }
            
            throw new Error("Cannot instantiate Registry. Call EventRegistry.instance");
        }

        /**
         * singleton instance of event registry.
         * 
         * @return : instance of the EventRegistry.
         */
        public static function get instance() : EventRegistry {
            if(me == null) {
            	me = new EventRegistry(new SingletonRegistry());
            	return me;
            }
            return me;
        }

		/**
		 * Registers a new listener to the given IEventDispatcher. Only one reference
		 * of the object is held in the Registry but many events will be attached to 
		 * the one IEventDispatcher.  For any object that extends the DisplayObject,
		 * one event will be added implicitly (Event.REMOVED_FROM_STAGE) that calls
		 * the disposeListeners when removed from the stage, then the DisplayObject is
		 * set to null.  Any other IEventDispatcher must call disposeListeners to 
		 * clean up the listeners in the registry.
		 * 
		 * @param : eventDispatcher - the dispatcher that will hold the attached event
		 * @param : type - type of event @see addEventListener()
		 * @param : listener - listener function @see addEventListener()
		 * @param : useCapture - set use capture phase @see addEventListener()
		 * @param : priority - set priority @see addEventListener()
		 * @param : useWeakReference - @see addEventListener()
		 * @param : persist - the event is not cleared when removed from stage.
		 */
        public function registerEventListener(eventDispatcher : IEventDispatcher, 
                                                type : String, 
                                                listener : Function,
                                                useCapture : Boolean = false,
                                                priority : int = 0,
                                                useWeakReference : Boolean = false,
                                                persist: Boolean = false) : void {

            var eventListener : EventListener = new EventListener(type,
                                                        listener, 
                                                        useCapture, 
                                                        priority,
                                                        useWeakReference,
                                                        persist);
            var listenMap : ListenerMap = getListenerMap(eventDispatcher, useWeakReference);
            listenMap.addNewListener(eventListener);
            
            if(listenMap.listenerList.length == 0) {
    			var removeIndex : uint = registeredEventMaps.indexOf(listenMap);
    			registeredEventMaps.splice(removeIndex, 1);          	
            }
            
        }
        
        public function debug(): String {
        	var counter: Number = 0;
        	var retVal:String = "";
        	for each(var map: ListenerMap in registeredEventMaps) {
        	 	retVal += "[" + getQualifiedClassName(map.eventDispatcher) + "]\n";
        	 	retVal += "==================\n";
        	 	for each(var evt: EventListener in map.listenerList) {
        	 		retVal += evt.type + " : " + evt.persist + "\n";
        	 	}
        	 	counter += map.listenerList.length;
 	        	retVal += "\n";
        	}
        	retVal += "===========================\n";
        	retVal += "number of registered objects : "  + registeredEventMaps.length + "\n";
        	retVal += "number of event listeners : "  + counter + "\n";
        	
        	return retVal;
        }
        
        /**
         * Force removes a specific listener.  The persist option is ignored.
         *  
         * @param dispatcher : the object containing the event
         * @param type : the type of event
         * @param listener : the listener function associated
         * @param useCapture : the useCapture flag associated with the event.
         */
        public function removeListener(dispatcher : IEventDispatcher, 
        									type: String,
        									listener: Function,
        									useCapture: Boolean = false): void {
        	var listenMap: ListenerMap = getExistingListenerMap(dispatcher);
        	if(listenMap) {
        		listenMap.removeEvent(type, listener, useCapture);	
        		if(listenMap.listenerList == null) {
        			var removeIndex : uint = registeredEventMaps.indexOf(listenMap);
        			registeredEventMaps.splice(removeIndex, 1);
        		}
        	}
		}
		
        /**
         * Can be explicity called to remove all listeners from the
         * dispatcher and will set the dispatcher to null.
         * 
         * if the dispatcher does not exist in the registry, nothing happens.
         * 
         * @param : dispatcher - Object that will be destroyed.
         */
        public function disposeListeners(dispatcher : IEventDispatcher) : void {
            var map : ListenerMap = getExistingListenerMap(dispatcher);
            if(map) {
				var removeIndex : uint = registeredEventMaps.indexOf(map);
				map.invalidate(true);
				registeredEventMaps.splice(removeIndex, 1);
            }                        
        } 
        
        /**
         * Event that is called that removes all listeners and set sets the removed
         * from stage object to null.
         * 
         * @Event 
         */
        private function destroy(event : Event) : void {
            var map : ListenerMap = getExistingListenerMap(DisplayObject(event.target));
            if(map) {
            	removeListenersFromList(map);
            }
        }

		/**
		 * Does the dirty work of removing the event listeners from the dispatcher
		 * and sets the dispatcher to null.  Also maintains the cleanliness of the 
		 * registry. If there are any events set to persist the event will still
		 * exist along with the REMOVED_FROM_STAGE event.
		 * 
		 * @param : map - listenerMap that will be operated upon.
		 */
        private function removeListenersFromList(map : ListenerMap) : void {
            //remove the reference in the listener map.  
            var removeIndex : uint = registeredEventMaps.indexOf(map);
			if(!map.deferred()) {
	            map.invalidate();
	            if(!map.hasPersistedEvent()) {
	            	registeredEventMaps.splice(removeIndex, 1);
	            }
   			}
        }
        
        /**
         * Searches the registry for the given dispatcher and returns found listener map
         * or creates a new one if not found.
         * 
         * @param : dispatcher - used as key to look up listeners for the EventDispatcher
         * @param : useWeakReference - used to not attach a default removed from stage event.
         * @return : ListenerMap - found listenerMap or new one.
         */
        protected function getListenerMap(dispatcher : IEventDispatcher, useWeakReference: Boolean = false) : ListenerMap {
            var listenMap : ListenerMap = getExistingListenerMap(dispatcher);
            if(listenMap) {
                return listenMap;
            }
            
            //instatiate a new listenerMap with removed from stage event already registered.
            listenMap = new ListenerMap(dispatcher);
            if(listenMap.eventDispatcher is DisplayObject && !useWeakReference) {
                var eventListener : EventListener = new EventListener(Event.REMOVED_FROM_STAGE, destroy);
                listenMap.addNewListener(eventListener);        
            }  
            //add the map to the registry.
            registeredEventMaps.push(listenMap);
            return listenMap;
        }        
        
        /**
         * sets the options on the Event.REMOVED_FROM_STAGE listener. The default removed from
         * stage listener just uses the defaults.  This is in place to override the default 
         * listener options
         * 
         * @param : dispatcher - the dispatcher that will be changed
         * @param : useCapture - set useCapture
         * @param : priority - set the priority
         * @param : useWeakRefernce - set useWeakReference
         */
        public function destroyOptions(dispatcher : IEventDispatcher, 
                                    useCapture : Boolean, 
                                    priority : int, 
                                    useWeakReference : Boolean) : void {
            var listenerMap : ListenerMap = getExistingListenerMap(dispatcher);
            
            for each(var eventListener : EventListener in listenerMap.listenerList) {
                if(eventListener.type == Event.REMOVED_FROM_STAGE) {
                    //remove the old event listener and add the new one with the 
                    //updated destroy options.
                    listenerMap.eventDispatcher.removeEventListener(
                    								eventListener.type, 
                                                    eventListener.listener, 
                                                    eventListener.useCapture);
                    var newListener : EventListener = new EventListener(
        											eventListener.type,
                                                    eventListener.listener,
                                                    useCapture,
                                                    priority,
                                                    useWeakReference);
                    listenerMap.addNewListener(newListener);   
                }
            }
        }
        
        /**
         * Locates an existing listener map in the registry.
         * 
         * @param : dispatcher - dispatcher to locate
         * @return : ListenerMap - found listener map, null if nothing found.
         */ 
        public function getExistingListenerMap(dispatcher : IEventDispatcher) : ListenerMap {
            for each(var map : ListenerMap in registeredEventMaps) {
                if(map.eventDispatcher == dispatcher) {
                    return map;
                }      
            }

            return null;
        }
        
        /**
         * When a object is moved from one display list to another, the object
         * is removed from the display list and dispatches the REMOVED_FROM_STAGE
         * event.  What this does is that it defers that for one iteration.
         * So you can safely move a display object without having the event
         * listeners removed from the REMOVED_FROM_STAGE event.
         * 
         * @param : dispatcher - the dispatcher that the defer is applied to
         */
        public function deferNext(dispatcher : IEventDispatcher) : void {
			var listenMap : ListenerMap = getListenerMap(dispatcher);
			listenMap.deferNext();       	
        }
    }
}

/**
 * used to prohibit instantiation of the Registry Directly.
 */
class SingletonRegistry {}
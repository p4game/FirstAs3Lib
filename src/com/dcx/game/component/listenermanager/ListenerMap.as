package com.dcx.game.component.listenermanager{
    import flash.events.Event;
    import flash.events.IEventDispatcher;
    
    /**
     * Internal storage facility for the EventRegistry.  Events are passed into
     * this when registered through the EventRegistry.
     */ 
    public class ListenerMap {
        
        private var _dispatcher : IEventDispatcher;
        private var _listenerList : Array;
        private var _isDeferred : Boolean = false;

		/**
		 * creates a new listenermap and initializes the listener map.
		 * 
		 * @param dispatcher : the object that will have it's events applied to 
		 */
        public function ListenerMap(dispatcher : IEventDispatcher) {
            this._dispatcher = dispatcher;
        }
        
        /**
         * Force removes a listener from the dispatcher.  Persist is ignored.
         * 
         * @param type : the event type
         * @param listener : the listener function tied to the dispatcher
         * @param useCapture : the useCapture phase associated
         */
        public function removeEvent(type: String, listener: Function, useCapture: Boolean = false): void {
        	var counter: int = 0;
        	for (counter; counter < _listenerList.length;) {
        		var eventListener: EventListener = _listenerList[counter];
        		if(eventListener.type == type && eventListener.listener == listener && eventListener.useCapture == useCapture) {
        			_dispatcher.removeEventListener(type, listener, useCapture);	
        			_listenerList.splice(counter, 1);
        			eventListener = null;
        			continue;
        		}
        		counter++;
        	}
        	
        	if(_listenerList.length == 0) {
        		_listenerList = null;
        	}
        }

		/**
		 * notifies the map that the next REMOVED_FROM_STAGE event should be 
		 * ignored until the next occurance.
		 */
		public function deferNext() : void {
			this._isDeferred = true;			
		}
		
		/**
		 * notifies the map that the defer has occured and that the next 
		 * REMOVED_FROM_STAGE event should be dispatched.
		 */
		public function deferred() : Boolean {
			if(_isDeferred) {
				_isDeferred = false;
				return true;
			}
			return false;
		}
        
        /**
         * adds a new listener to the registered dispatcher object. You can add
         * multiple listeners with the same event type.  This functionality may
         * change later.
         * 
         * @param listener - the listener to be applied to the dispatcher object
         */ 
        public function addNewListener(listener : EventListener) : void {
        	if(!_listenerList) {
        		_listenerList = [];
        	}
        	
            _dispatcher.addEventListener(listener.type,       
                    listener.listener, 
                    listener.useCapture,
                    listener.priority, 
                    listener.useWeakReference);
         	
         	//THOUGHTS: I'm not registering the event if it's a weak reference.  Maybe I should.
         	//It could be registered and on removeEvent and invalidate, check the eventDispatcher
         	//to see if the listener still exists, if it doesn't remove it from the registry.
         	//It's difficult to keep track because what if there are several events of the same
         	//type registered, some with weak references and some without.
         	if(!listener.useWeakReference) {
            	_listenerList.push(listener);
          	}
        }
        
        /**
         * removes all the event listeners from the dispatcher object.
         * If the object has a persisted event, the object will not have
         * the event removed and the REMOVED_FROM_STAGE event will not 
         * be cleared.
         */ 
        public function invalidate(removePersist:Boolean = false) : void {
        	var hasPersistedEvent: Boolean = false;
        	var removedFromStageListener: EventListener;
        	
        	var counter: int = 0;
        	for(counter; counter < listenerList.length;) {
        		var listener: EventListener = _listenerList[counter];
        		if(listener.type == Event.REMOVED_FROM_STAGE) {
        			removedFromStageListener = listener;
        		}
        		if(!listener.persist || removePersist) {
        			_dispatcher.removeEventListener(listener.type, 
        					listener.listener, 
        					listener.useCapture);
        			_listenerList.splice(counter, 1);
        			listener = null;
        			continue;
        		} else {
        			hasPersistedEvent = true;
        		}
        		counter++;
        	}
        	
        	if(!hasPersistedEvent) {
        		if(_dispatcher.hasEventListener(Event.REMOVED_FROM_STAGE)) {
        			_dispatcher.removeEventListener(removedFromStageListener.type, 
        					removedFromStageListener.listener, 
        					removedFromStageListener.useCapture);
        		}
        		_listenerList = null;
        	}
        }
        
        /**
         * @return checks to see if the dispatcher has a persisted event 
         */
        public function hasPersistedEvent(): Boolean {
        	for each(var listener : EventListener in _listenerList) {
        		if(listener.persist) {
        			return true;
        		}
        	}
        	return false;
        }
        
        /**
         * gets the object that dispatches the registered events
         * 
         * @return eventDispatcher object
         */ 
        public function get eventDispatcher() : IEventDispatcher {
            return _dispatcher;
        }
        
        /**
         * gets the list of listeners that are registered for the event dispatcher
         * 
         * @return array of EventListeners
         */ 
        public function get listenerList() : Array {
            return _listenerList;
        }
    }
}
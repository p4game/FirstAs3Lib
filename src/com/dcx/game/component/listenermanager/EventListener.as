package com.dcx.game.component.listenermanager{
    import flash.display.DisplayObject;
    
    /**
     * Reference object that stores the event listener information.
     */ 
    public class EventListener {
        
        private var _type : String;
        private var _listener : Function;
        private var _useCapture : Boolean;
        private var _priority : int;
        private var _useWeakReference : Boolean;
        private var _persist: Boolean;
        
        /**
         * stores the event listener options.
         * @see Event
         * 
         * @param type
         * @param listener
         * @param useCapture
         * @param priority
         * @param useWeakReference
         */ 
        public function EventListener(type : String, 
                                    listener : Function,
                                    useCapture : Boolean = false,
                                    priority : int = 0,
                                    useWeakReference : Boolean = false,
                                    persist: Boolean = false) {
            this._type = type;
            this._listener = listener;
            this._useCapture = useCapture;
            this._priority = priority;
            this._useWeakReference = useWeakReference;
            this._persist = persist;
        }
        
        /**
         * gets the type of event.
         * @return event type
         */ 
        public function get type() : String {
            return this._type;
        }

        public function get listener() : Function {
            return this._listener;
        }
        
        public function get useCapture() : Boolean {
            return this._useCapture;
        }
        
        public function get priority() : int {
            return this._priority;
        }
        
        public function get useWeakReference() : Boolean {
            return this._useWeakReference;
        }
        
        public function get persist(): Boolean {
        	return this._persist;
        }
    }
    
}
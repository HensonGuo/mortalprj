// Decompiled by AS3 Sorcerer 1.56
// http://www.as3sorcerer.com/

//se7en.core.loader.ExURLLoader

package  word.loader{
    import flash.net.URLLoader;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.URLRequest;

    public class ExURLLoader extends URLLoader {

        private static const LOAD_INIT:uint = 1;
        private static const LOAD_ING:uint = 2;
        private static const LOAD_OK:uint = 3;
        private static const LOAD_ERR:uint = 4;

        protected var _cmp_fn:Function;
        protected var _url:String;
        protected var _loadStatus:uint;
        private var _tryCount:int = 1;

        public function ExURLLoader(_arg1:String="", _arg2:Function=null, _arg3:int=1){
            this._url = _arg1;
            this._cmp_fn = _arg2;
            this._tryCount = _arg3;
            if (this._cmp_fn != null)
            {
                addEventListener(Event.COMPLETE, this.onComplete);
            };
            this.addEventListener(IOErrorEvent.IO_ERROR, this.onError);
            this.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onSecError);
            this._loadStatus = LOAD_INIT;
        }

        protected function startLoad():void{
            if (this._url != "")
            {
                load(new URLRequest(this._url));
                this._loadStatus = LOAD_ING;
                this._tryCount--;
            };
        }

        protected function onComplete(_arg1:Event):void{
            this.clearAllListeners();
            this._loadStatus = LOAD_OK;
        }

        protected function onError(_arg1:IOErrorEvent):void{
            this.onLoaderError();
        }

        protected function onSecError(_arg1:SecurityErrorEvent):void{
            this.onLoaderError();
        }

        private function onLoaderError():void{
            if (this._tryCount >= 1)
            {
                this.startLoad();
                this._tryCount--;
            } else
            {
                this.clearAllListeners();
                this._loadStatus = LOAD_ERR;
            };
        }

        private function clearAllListeners():void{
            if (this._cmp_fn != null)
            {
                this.removeEventListener(Event.COMPLETE, this.onComplete);
            };
            this.removeEventListener(IOErrorEvent.IO_ERROR, this.onError);
            this.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onSecError);
        }

        public function isLoading():Boolean{
            return ((this._loadStatus == LOAD_ING));
        }

        public function cancelLoad():void{
            if (this.isLoading())
            {
                this.clearAllListeners();
            };
            this._loadStatus = LOAD_INIT;
        }


    }
}//package se7en.core.loader


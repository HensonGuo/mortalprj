


//flare.loaders.ByteArrayLoader

package baseEngine.loaders
{
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;
    import flash.net.URLRequest;
    import flash.utils.ByteArray;
    import flash.utils.Endian;
    
    import baseEngine.system.ILibraryExternalItem;

    public class ByteArrayLoader extends EventDispatcher implements ILibraryExternalItem 
    {

        private var _loaded:Boolean;
        private var _request:*;
        private var _loader:URLLoader;
        private var _bytesLoaded:uint;
        private var _bytesTotal:uint;

        public function ByteArrayLoader(_arg1:*)
        {
            this._request = _arg1;
            if ((this._request is String))
            {
                this._request = this._request.replace(/\\/g, "/");
            }
            else
            {
                if ((this._request is ByteArray))
                {
                    this._bytesLoaded = this._request.length;
                    this._bytesTotal = this._request.length;
                    this._request.endian = Endian.LITTLE_ENDIAN;
                    this._loaded = true;
                };
            };
        }
		public function set useMaterial(value:Boolean):void
		{
			
		}
        public function get bytesTotal():uint
        {
            return (((this._loader) ? this._loader.bytesTotal : this._bytesTotal));
        }
        public function get bytesLoaded():uint
        {
            return (((this._loader) ? this._loader.bytesLoaded : this._bytesLoaded));
        }
        public function get loaded():Boolean
        {
            return (this._loaded);
        }
        public function load():void
        {
            if (((this._loaded) || (this._loader)))
            {
                return;
            };
            if ((this._request is String))
            {
                this._loader = new URLLoader();
                this._loader.dataFormat = URLLoaderDataFormat.BINARY;
                this._loader.addEventListener("progress", this.progressEvent, false, 0, true);
                this._loader.addEventListener("complete", this.completeEvent, false, 0, true);
                this._loader.load(new URLRequest(this._request));
            };
        }
        public function close():void
        {
            if (this._loader)
            {
                this._loader.close();
            };
            this._loader = null;
        }
        public function dispose():void
        {
            this._loader = null;
            this._request = null;
        }
        public function get data():*
        {
            return ((((this._request is ByteArray)) ? this._request : this._loader.data));
        }
        private function completeEvent(_arg1:Event):void
        {
            this._loaded = true;
            this._loader.data.endian = Endian.LITTLE_ENDIAN;
            dispatchEvent(_arg1);
        }
        private function progressEvent(_arg1:Event):void
        {
            dispatchEvent(_arg1);
        }

    }
}//package flare.loaders


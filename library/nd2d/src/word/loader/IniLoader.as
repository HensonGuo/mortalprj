// Decompiled by AS3 Sorcerer 1.56
// http://www.as3sorcerer.com/

//se7en.core.loader.IniLoader

package word.loader{
    import flash.net.URLLoaderDataFormat;
    import flash.net.URLRequest;
    import flash.utils.ByteArray;
    import flash.events.Event;

    public class IniLoader extends ExURLLoader {

        private var _compress:Boolean;

        public function IniLoader(_arg1:String="", _arg2:Function=null, _arg3:Boolean=false, _arg4:int=1){
            super(_arg1, _arg2, _arg4);
            if (_arg1 != "")
            {
                this._compress = _arg3;
                if (_arg3)
                {
                    dataFormat = URLLoaderDataFormat.BINARY;
                } else
                {
                    dataFormat = URLLoaderDataFormat.TEXT;
                };
                load(new URLRequest(_arg1));
                startLoad();
            };
        }

        override protected function onComplete(_arg1:Event):void{
            var _local3:ByteArray;
            var _local2:String = _arg1.target._url;
            trace(_local2);
            if (this._compress)
            {
                _local3 = (data as ByteArray);
                _local3.uncompress();
                _cmp_fn(XML((_local3 as Object)));
            } else
            {
                _cmp_fn(XML(data));
            };
            super.onComplete(_arg1);
        }


    }
}//package se7en.core.loader


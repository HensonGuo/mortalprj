// Decompiled by AS3 Sorcerer 1.56
// http://www.as3sorcerer.com/

//se7en.core.loader.ByteLoader

package  word.loader{
    import flash.utils.Endian;
    import flash.net.URLLoaderDataFormat;
    import flash.utils.ByteArray;
    import flash.events.Event;

    public class ByteLoader extends ExURLLoader {

        public var endian:String;

        public function ByteLoader(_arg1:String="", _arg2:Function=null, _arg3:String="", _arg4:int=1){
            super(_arg1, _arg2, _arg4);
            if (_arg3 == "")
            {
                _arg3 = Endian.BIG_ENDIAN;
            };
            this.dataFormat = URLLoaderDataFormat.BINARY;
            this.endian = _arg3;
            startLoad();
        }

        override protected function onComplete(_arg1:Event):void{
            (data as ByteArray).endian = this.endian;
            _cmp_fn((data as ByteArray));
            super.onComplete(_arg1);
        }


    }
}//package se7en.core.loader


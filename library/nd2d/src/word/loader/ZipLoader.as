// Decompiled by AS3 Sorcerer 1.56
// http://www.as3sorcerer.com/

//se7en.core.loader.ZipLoader

package word.loader{

    
    import flash.events.ErrorEvent;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.URLRequest;
    import flash.net.URLStream;
    import flash.utils.ByteArray;
    
    import word.filePath.FilePathUtils;
    import word.log.MyLog;
    import word.zip.ZipEntry;
    import word.zip.ZipFile;


    public class ZipLoader {

        private var _callBack:Function;
        private var _url:String;
        private var _zipFile:ZipFile;
        private var _tryCount:int = 1;

        public function ZipLoader(_arg1:String="", _arg2:Function=null, _arg3:int=1){
            var _local4:URLStream;
            super();
            if (_arg1 != "")
            {
                this._url = _arg1;
                this._tryCount = _arg3;
                this._callBack = _arg2;
                _local4 = new URLStream();
                _local4.addEventListener(Event.COMPLETE, this.onComplete);
                _local4.addEventListener(IOErrorEvent.IO_ERROR, this.onError);
                _local4.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onError);
                _local4.load( FilePathUtils.getUrl(new URLRequest(_arg1)));
                this._tryCount--;
            };
        }

        public static function getXmlDataFromZipFile(_arg1:String, _arg2:ZipFile, _arg3:Function):void{
            var _local5:ByteArray;
            if (_arg2 == null)
            {
                return;
            };
            var _local4:ZipEntry = _arg2.getEntry(("zip/" + _arg1));
            if (_local4 != null)
            {
                _local5 = _arg2.getInput(_local4);
                if (((!((_local5 == null))) && (!((_arg3 == null)))))
                {
                    (_arg3(XML((_local5 as Object))));
                };
            };
        }

        public static function getBinaryDataFromZipFile(_arg1:String, _arg2:ZipFile, _arg3:Function):void{
            var _local5:ByteArray;
            if (_arg2 == null)
            {
                return;
            };
            var _local4:ZipEntry = _arg2.getEntry(("zip/" + _arg1));
            if (_local4 != null)
            {
                _local5 = _arg2.getInput(_local4);
                if (((!((_local5 == null))) && (!((_arg3 == null)))))
                {
                    (_arg3(_local5));
                };
            };
        }


        private function onComplete(_arg1:Event):void{
            var _local2:URLStream = URLStream(_arg1.target);
            this._zipFile = new ZipFile(_local2);
            this._callBack(this._zipFile);
            this._callBack = null;
        }

        private function onError(_arg1:IOErrorEvent):void{
			MyLog.logE(_arg1.toString());
            this.tryAgain();
        }

        private function onSecError(_arg1:ErrorEvent):void{
            MyLog.logE(_arg1.text);
            this.tryAgain();
        }

        private function tryAgain():void{
            var _local1:URLStream;
            if (this._tryCount >= 1)
            {
                this._tryCount--;
                _local1 = new URLStream();
                _local1.addEventListener(Event.COMPLETE, this.onComplete);
                _local1.addEventListener(IOErrorEvent.IO_ERROR, this.onError);
                _local1.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.onError);
                _local1.load( FilePathUtils.getUrl(new URLRequest(this._url) ) );
            } else
            {
                this._callBack = null;
            };
        }


    }
}//package se7en.core.loader





//deng.fzip.FZip

package deng.fzip
{
    import flash.events.EventDispatcher;
    import flash.utils.Dictionary;
    import flash.net.URLStream;
    import flash.utils.ByteArray;
    import flash.utils.Endian;
    import flash.net.URLRequest;
    import flash.events.Event;
    import flash.utils.IDataOutput;
    import flash.utils.IDataInput;
    import flash.events.HTTPStatusEvent;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
    import flash.events.ProgressEvent;
    import flash.events.*;
    import flash.utils.*;

    public class FZip extends EventDispatcher 
    {

		public static const SIG_CENTRAL_FILE_HEADER:uint = 33639248;
		public static const SIG_SPANNING_MARKER:uint = 808471376;
		public static const SIG_LOCAL_FILE_HEADER:uint = 67324752;
		public static const SIG_DIGITAL_SIGNATURE:uint = 84233040;
		public static const SIG_END_OF_CENTRAL_DIRECTORY:uint = 101010256;
		public static const SIG_ZIP64_END_OF_CENTRAL_DIRECTORY:uint = 101075792;
		public static const SIG_ZIP64_END_OF_CENTRAL_DIRECTORY_LOCATOR:uint = 117853008;
		public static const SIG_DATA_DESCRIPTOR:uint = 134695760;
		public static const SIG_ARCHIVE_EXTRA_DATA:uint = 134630224;
		public static const SIG_SPANNING:uint = 134695760;

        protected var filesList:Array;
        protected var filesDict:Dictionary;
        protected var urlStream:URLStream;
        protected var charEncoding:String;
        protected var parseFunc:Function;
        protected var currentFile:FZipFile;
        protected var ddBuffer:ByteArray;
        protected var ddSignature:uint;
        protected var ddCompressedSize:uint;

        public function FZip(_arg1:String="utf-8")
        {
            this.charEncoding = _arg1;
            this.parseFunc = this.parseIdle;
        }
        public function get active():Boolean
        {
            return (!((this.parseFunc === this.parseIdle)));
        }
        public function load(_arg1:URLRequest):void
        {
            if (((!(this.urlStream)) && ((this.parseFunc == this.parseIdle))))
            {
                this.urlStream = new URLStream();
                this.urlStream.endian = Endian.LITTLE_ENDIAN;
                this.addEventHandlers();
                this.filesList = [];
                this.filesDict = new Dictionary();
                this.parseFunc = this.parseSignature;
                this.urlStream.load(_arg1);
            };
        }
        public function loadBytes(_arg1:ByteArray):void
        {
            if (((!(this.urlStream)) && ((this.parseFunc == this.parseIdle))))
            {
                this.filesList = [];
                this.filesDict = new Dictionary();
                _arg1.position = 0;
                _arg1.endian = Endian.LITTLE_ENDIAN;
                this.parseFunc = this.parseSignature;
                if (this.parse(_arg1))
                {
                    this.parseFunc = this.parseIdle;
                    dispatchEvent(new Event(Event.COMPLETE));
                }
                else
                {
                    dispatchEvent(new FZipErrorEvent(FZipErrorEvent.PARSE_ERROR, "EOF"));
                };
            };
        }
        public function close():void
        {
            if (this.urlStream)
            {
                this.parseFunc = this.parseIdle;
                this.removeEventHandlers();
                this.urlStream.close();
                this.urlStream = null;
            };
        }
        public function serialize(_arg1:IDataOutput, _arg2:Boolean=false):void
        {
            var _local3:String;
            var _local4:ByteArray;
            var _local5:uint;
            var _local6:uint;
            var _local7:int;
            var _local8:FZipFile;
            if (((!((_arg1 == null))) && ((this.filesList.length > 0))))
            {
                _local3 = _arg1.endian;
                _local4 = new ByteArray();
                _arg1.endian = (_local4.endian = Endian.LITTLE_ENDIAN);
                _local5 = 0;
                _local6 = 0;
                _local7 = 0;
                while (_local7 < this.filesList.length)
                {
                    _local8 = (this.filesList[_local7] as FZipFile);
                    if (_local8 != null)
                    {
                        _local8.serialize(_local4, _arg2, true, _local5);
                        _local5 = (_local5 + _local8.serialize(_arg1, _arg2));
                        _local6++;
                    };
                    _local7++;
                };
                if (_local4.length > 0)
                {
                    _arg1.writeBytes(_local4);
                };
                _arg1.writeUnsignedInt(SIG_END_OF_CENTRAL_DIRECTORY);
                _arg1.writeShort(0);
                _arg1.writeShort(0);
                _arg1.writeShort(_local6);
                _arg1.writeShort(_local6);
                _arg1.writeUnsignedInt(_local4.length);
                _arg1.writeUnsignedInt(_local5);
                _arg1.writeShort(0);
                _arg1.endian = _local3;
            };
        }
        public function getFileCount():uint
        {
            return (((this.filesList) ? this.filesList.length : 0));
        }
        public function getFileAt(_arg1:uint):FZipFile
        {
            return (((this.filesList) ? (this.filesList[_arg1] as FZipFile) : null));
        }
        public function getFileByName(_arg1:String):FZipFile
        {
            if (!this.filesDict)
            {
                return (null);
            };
            return (((this.filesDict[_arg1]) ? (this.filesDict[_arg1] as FZipFile) : null));
        }
        public function addFile(_arg1:String, _arg2:ByteArray=null, _arg3:Boolean=true):FZipFile
        {
            return (this.addFileAt(((this.filesList) ? this.filesList.length : 0), _arg1, _arg2, _arg3));
        }
        public function addFileFromString(_arg1:String, _arg2:String, _arg3:String="utf-8", _arg4:Boolean=true):FZipFile
        {
            return (this.addFileFromStringAt(((this.filesList) ? this.filesList.length : 0), _arg1, _arg2, _arg3, _arg4));
        }
        public function addFileAt(_arg1:uint, _arg2:String, _arg3:ByteArray=null, _arg4:Boolean=true):FZipFile
        {
            if (this.filesList == null)
            {
                this.filesList = [];
            };
            if (this.filesDict == null)
            {
                this.filesDict = new Dictionary();
            }
            else
            {
                if (this.filesDict[_arg2])
                {
                    throw (new Error((("File already exists: " + _arg2) + ". Please remove first.")));
                };
            };
            var _local5:FZipFile = new FZipFile();
            _local5.filename = _arg2;
            _local5.setContent(_arg3, _arg4);
            if (_arg1 >= this.filesList.length)
            {
                this.filesList.push(_local5);
            }
            else
            {
                this.filesList.splice(_arg1, 0, _local5);
            };
            this.filesDict[_arg2] = _local5;
            return (_local5);
        }
        public function addFileFromStringAt(_arg1:uint, _arg2:String, _arg3:String, _arg4:String="utf-8", _arg5:Boolean=true):FZipFile
        {
            if (this.filesList == null)
            {
                this.filesList = [];
            };
            if (this.filesDict == null)
            {
                this.filesDict = new Dictionary();
            }
            else
            {
                if (this.filesDict[_arg2])
                {
                    throw (new Error((("File already exists: " + _arg2) + ". Please remove first.")));
                };
            };
            var _local6:FZipFile = new FZipFile();
            _local6.filename = _arg2;
            _local6.setContentAsString(_arg3, _arg4, _arg5);
            if (_arg1 >= this.filesList.length)
            {
                this.filesList.push(_local6);
            }
            else
            {
                this.filesList.splice(_arg1, 0, _local6);
            };
            this.filesDict[_arg2] = _local6;
            return (_local6);
        }
        public function removeFileAt(_arg1:uint):FZipFile
        {
            var _local2:FZipFile;
            if (((((!((this.filesList == null))) && (!((this.filesDict == null))))) && ((_arg1 < this.filesList.length))))
            {
                _local2 = (this.filesList[_arg1] as FZipFile);
                if (_local2 != null)
                {
                    this.filesList.splice(_arg1, 1);
                    delete this.filesDict[_local2.filename];
                    return (_local2);
                };
            };
            return (null);
        }
        protected function parse(_arg1:IDataInput):Boolean
        {
            do 
            {
            } while (this.parseFunc(_arg1));
            return ((this.parseFunc === this.parseIdle));
        }
        protected function parseIdle(_arg1:IDataInput):Boolean
        {
            return (false);
        }
        protected function parseSignature(_arg1:IDataInput):Boolean
        {
            var _local2:uint;
            if (_arg1.bytesAvailable >= 4)
            {
                _local2 = _arg1.readUnsignedInt();
                switch (_local2)
                {
                    case SIG_LOCAL_FILE_HEADER:
                        this.parseFunc = this.parseLocalfile;
                        this.currentFile = new FZipFile(this.charEncoding);
                        break;
                    case SIG_CENTRAL_FILE_HEADER:
                    case SIG_END_OF_CENTRAL_DIRECTORY:
                    case SIG_SPANNING_MARKER:
                    case SIG_DIGITAL_SIGNATURE:
                    case SIG_ZIP64_END_OF_CENTRAL_DIRECTORY:
                    case SIG_ZIP64_END_OF_CENTRAL_DIRECTORY_LOCATOR:
                    case SIG_DATA_DESCRIPTOR:
                    case SIG_ARCHIVE_EXTRA_DATA:
                    case SIG_SPANNING:
                        this.parseFunc = this.parseIdle;
                        break;
                    default:
                        throw (new Error(("Unknown record signature: 0x" + _local2.toString(16))));
                };
                return (true);
            };
            return (false);
        }
        protected function parseLocalfile(_arg1:IDataInput):Boolean
        {
            if (this.currentFile.parse(_arg1))
            {
                if (this.currentFile.hasDataDescriptor)
                {
                    this.parseFunc = this.findDataDescriptor;
                    this.ddBuffer = new ByteArray();
                    this.ddSignature = 0;
                    this.ddCompressedSize = 0;
                    return (true);
                };
                this.onFileLoaded();
                if (this.parseFunc != this.parseIdle)
                {
                    this.parseFunc = this.parseSignature;
                    return (true);
                };
            };
            return (false);
        }
        protected function findDataDescriptor(_arg1:IDataInput):Boolean
        {
            var _local2:uint;
            while (_arg1.bytesAvailable > 0)
            {
                _local2 = _arg1.readUnsignedByte();
                this.ddSignature = ((this.ddSignature >>> 8) | (_local2 << 24));
                if (this.ddSignature == SIG_DATA_DESCRIPTOR)
                {
                    this.ddBuffer.length = (this.ddBuffer.length - 3);
                    this.parseFunc = this.validateDataDescriptor;
                    return (true);
                };
                this.ddBuffer.writeByte(_local2);
            };
            return (false);
        }
        protected function validateDataDescriptor(_arg1:IDataInput):Boolean
        {
            var _local2:uint;
            var _local3:uint;
            var _local4:uint;
            if (_arg1.bytesAvailable >= 12)
            {
                _local2 = _arg1.readUnsignedInt();
                _local3 = _arg1.readUnsignedInt();
                _local4 = _arg1.readUnsignedInt();
                if (this.ddBuffer.length == _local3)
                {
                    this.ddBuffer.position = 0;
                    this.currentFile._crc32 = _local2;
                    this.currentFile._sizeCompressed = _local3;
                    this.currentFile._sizeUncompressed = _local4;
                    this.currentFile.parseContent(this.ddBuffer);
                    this.onFileLoaded();
                    this.parseFunc = this.parseSignature;
                }
                else
                {
                    this.ddBuffer.writeUnsignedInt(_local2);
                    this.ddBuffer.writeUnsignedInt(_local3);
                    this.ddBuffer.writeUnsignedInt(_local4);
                    this.parseFunc = this.findDataDescriptor;
                };
                return (true);
            };
            return (false);
        }
        protected function onFileLoaded():void
        {
            this.filesList.push(this.currentFile);
            if (this.currentFile.filename)
            {
                this.filesDict[this.currentFile.filename] = this.currentFile;
            };
            dispatchEvent(new FZipEvent(FZipEvent.FILE_LOADED, this.currentFile));
            this.currentFile = null;
        }
        protected function progressHandler(_arg1:Event):void
        {
            var evt:Event = _arg1;
            dispatchEvent(evt.clone());
            try
            {
                if (this.parse(this.urlStream))
                {
                    this.close();
                    dispatchEvent(new Event(Event.COMPLETE));
                };
            }
            catch(e:Error)
            {
                close();
                if (hasEventListener(FZipErrorEvent.PARSE_ERROR))
                {
                    dispatchEvent(new FZipErrorEvent(FZipErrorEvent.PARSE_ERROR, e.message));
                }
                else
                {
                    throw (e);
                };
            };
        }
        protected function defaultHandler(_arg1:Event):void
        {
            dispatchEvent(_arg1.clone());
        }
        protected function defaultErrorHandler(_arg1:Event):void
        {
            this.close();
            dispatchEvent(_arg1.clone());
        }
        protected function addEventHandlers():void
        {
            this.urlStream.addEventListener(Event.COMPLETE, this.defaultHandler);
            this.urlStream.addEventListener(Event.OPEN, this.defaultHandler);
            this.urlStream.addEventListener(HTTPStatusEvent.HTTP_STATUS, this.defaultHandler);
            this.urlStream.addEventListener(IOErrorEvent.IO_ERROR, this.defaultErrorHandler);
            this.urlStream.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.defaultErrorHandler);
            this.urlStream.addEventListener(ProgressEvent.PROGRESS, this.progressHandler);
        }
        protected function removeEventHandlers():void
        {
            this.urlStream.removeEventListener(Event.COMPLETE, this.defaultHandler);
            this.urlStream.removeEventListener(Event.OPEN, this.defaultHandler);
            this.urlStream.removeEventListener(HTTPStatusEvent.HTTP_STATUS, this.defaultHandler);
            this.urlStream.removeEventListener(IOErrorEvent.IO_ERROR, this.defaultErrorHandler);
            this.urlStream.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.defaultErrorHandler);
            this.urlStream.removeEventListener(ProgressEvent.PROGRESS, this.progressHandler);
        }

    }
}//package deng.fzip


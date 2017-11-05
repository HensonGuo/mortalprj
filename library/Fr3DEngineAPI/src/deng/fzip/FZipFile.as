


//deng.fzip.FZipFile

package deng.fzip
{
    import flash.utils.ByteArray;
    import flash.utils.Dictionary;
    import flash.utils.Endian;
    import flash.utils.IDataInput;
    import flash.utils.IDataOutput;
    import flash.utils.describeType;
    
    import deng.utils.ChecksumUtil;

    public class FZipFile 
    {

        public static const COMPRESSION_NONE:int = 0;
        public static const COMPRESSION_SHRUNK:int = 1;
        public static const COMPRESSION_REDUCED_1:int = 2;
        public static const COMPRESSION_REDUCED_2:int = 3;
        public static const COMPRESSION_REDUCED_3:int = 4;
        public static const COMPRESSION_REDUCED_4:int = 5;
        public static const COMPRESSION_IMPLODED:int = 6;
        public static const COMPRESSION_TOKENIZED:int = 7;
        public static const COMPRESSION_DEFLATED:int = 8;
        public static const COMPRESSION_DEFLATED_EXT:int = 9;
        public static const COMPRESSION_IMPLODED_PKWARE:int = 10;

        protected static var HAS_UNCOMPRESS:Boolean = (describeType(ByteArray).factory.method.(@name == "uncompress").parameter.length() > 0);
        protected static var HAS_INFLATE:Boolean = (describeType(ByteArray).factory.method.(@name == "inflate").length() > 0);

        protected var _versionHost:int = 0;
        protected var _versionNumber:String = "2.0";
        protected var _compressionMethod:int = 8;
        protected var _encrypted:Boolean = false;
        protected var _implodeDictSize:int = -1;
        protected var _implodeShannonFanoTrees:int = -1;
        protected var _deflateSpeedOption:int = -1;
        protected var _hasDataDescriptor:Boolean = false;
        protected var _hasCompressedPatchedData:Boolean = false;
        protected var _date:Date;
        protected var _adler32:uint;
        protected var _hasAdler32:Boolean = false;
        protected var _sizeFilename:uint = 0;
        protected var _sizeExtra:uint = 0;
        protected var _filename:String = "";
        protected var _filenameEncoding:String;
        protected var _extraFields:Dictionary;
        protected var _comment:String = "";
        protected var _content:ByteArray;
		public var _crc32:uint;
		public var _sizeCompressed:uint = 0;
		public var _sizeUncompressed:uint = 0;
        protected var isCompressed:Boolean = false;
        protected var parseFunc:Function;

        public function FZipFile(_arg1:String="utf-8")
        {
            this.parseFunc = this.parseFileHead;
            super();
            this._filenameEncoding = _arg1;
            this._extraFields = new Dictionary();
            this._content = new ByteArray();
            this._content.endian = Endian.BIG_ENDIAN;
        }
        public function get date():Date
        {
            return (this._date);
        }
        public function set date(_arg1:Date):void
        {
            this._date = (((_arg1)!=null) ? _arg1 : new Date());
        }
        public function get filename():String
        {
            return (this._filename);
        }
        public function set filename(_arg1:String):void
        {
            this._filename = _arg1;
        }
		public function get hasDataDescriptor():Boolean
        {
            return (this._hasDataDescriptor);
        }
        public function get content():ByteArray
        {
            if (this.isCompressed)
            {
                this.uncompress();
            };
            return (this._content);
        }
        public function set content(_arg1:ByteArray):void
        {
            this.setContent(_arg1);
        }
        public function setContent(_arg1:ByteArray, _arg2:Boolean=true):void
        {
            if (((!((_arg1 == null))) && ((_arg1.length > 0))))
            {
                _arg1.position = 0;
                _arg1.readBytes(this._content, 0, _arg1.length);
                this._crc32 = ChecksumUtil.CRC32(this._content);
                this._hasAdler32 = false;
            }
            else
            {
                this._content.length = 0;
                this._content.position = 0;
                this.isCompressed = false;
            };
            if (_arg2)
            {
                this.compress();
            }
            else
            {
                this._sizeUncompressed = (this._sizeCompressed = this._content.length);
            };
        }
        public function get versionNumber():String
        {
            return (this._versionNumber);
        }
        public function get sizeCompressed():uint
        {
            return (this._sizeCompressed);
        }
        public function get sizeUncompressed():uint
        {
            return (this._sizeUncompressed);
        }
        public function getContentAsString(_arg1:Boolean=true, _arg2:String="utf-8"):String
        {
            var _local3:String;
            if (this.isCompressed)
            {
                this.uncompress();
            };
            this._content.position = 0;
            if (_arg2 == "utf-8")
            {
                _local3 = this._content.readUTFBytes(this._content.bytesAvailable);
            }
            else
            {
                _local3 = this._content.readMultiByte(this._content.bytesAvailable, _arg2);
            };
            this._content.position = 0;
            if (_arg1)
            {
                this.compress();
            };
            return (_local3);
        }
        public function setContentAsString(_arg1:String, _arg2:String="utf-8", _arg3:Boolean=true):void
        {
            this._content.length = 0;
            this._content.position = 0;
            this.isCompressed = false;
            if (((!((_arg1 == null))) && ((_arg1.length > 0))))
            {
                if (_arg2 == "utf-8")
                {
                    this._content.writeUTFBytes(_arg1);
                }
                else
                {
                    this._content.writeMultiByte(_arg1, _arg2);
                };
                this._crc32 = ChecksumUtil.CRC32(this._content);
                this._hasAdler32 = false;
            };
            if (_arg3)
            {
                this.compress();
            }
            else
            {
                this._sizeUncompressed = (this._sizeCompressed = this._content.length);
            };
        }
        public function serialize(_arg1:IDataOutput, _arg2:Boolean, _arg3:Boolean=false, _arg4:uint=0):uint
        {
            var _local10:Object;
            var _local15:ByteArray;
            var _local16:Boolean;
            if (_arg1 == null)
            {
                return (0);
            };
            if (_arg3)
            {
                _arg1.writeUnsignedInt(FZip.SIG_CENTRAL_FILE_HEADER);
                _arg1.writeShort(((this._versionHost << 8) | 20));
            }
            else
            {
                _arg1.writeUnsignedInt(FZip.SIG_LOCAL_FILE_HEADER);
            };
            _arg1.writeShort(((this._versionHost << 8) | 20));
            _arg1.writeShort((((this._filenameEncoding)=="utf-8") ? 0x0800 : 0));
            _arg1.writeShort(((this.isCompressed) ? COMPRESSION_DEFLATED : COMPRESSION_NONE));
            var _local5:Date = (((this._date)!=null) ? this._date : new Date());
            var _local6:uint = ((uint(_local5.getSeconds()) | (uint(_local5.getMinutes()) << 5)) | (uint(_local5.getHours()) << 11));
            var _local7:uint = ((uint(_local5.getDate()) | (uint((_local5.getMonth() + 1)) << 5)) | (uint((_local5.getFullYear() - 1980)) << 9));
            _arg1.writeShort(_local6);
            _arg1.writeShort(_local7);
            _arg1.writeUnsignedInt(this._crc32);
            _arg1.writeUnsignedInt(this._sizeCompressed);
            _arg1.writeUnsignedInt(this._sizeUncompressed);
            var _local8:ByteArray = new ByteArray();
            _local8.endian = Endian.LITTLE_ENDIAN;
            if (this._filenameEncoding == "utf-8")
            {
                _local8.writeUTFBytes(this._filename);
            }
            else
            {
                _local8.writeMultiByte(this._filename, this._filenameEncoding);
            };
            var _local9:uint = _local8.position;
            for (_local10 in this._extraFields)
            {
                _local15 = (this._extraFields[_local10] as ByteArray);
                if (_local15 != null)
                {
                    _local8.writeShort(uint(_local10));
                    _local8.writeShort(uint(_local15.length));
                    _local8.writeBytes(_local15);
                };
            };
            if (_arg2)
            {
                if (!this._hasAdler32)
                {
                    _local16 = this.isCompressed;
                    if (_local16)
                    {
                        this.uncompress();
                    };
                    this._adler32 = ChecksumUtil.Adler32(this._content, 0, this._content.length);
                    this._hasAdler32 = true;
                    if (_local16)
                    {
                        this.compress();
                    };
                };
                _local8.writeShort(0xDADA);
                _local8.writeShort(4);
                _local8.writeUnsignedInt(this._adler32);
            };
            var _local11:uint = (_local8.position - _local9);
            if (((_arg3) && ((this._comment.length > 0))))
            {
                if (this._filenameEncoding == "utf-8")
                {
                    _local8.writeUTFBytes(this._comment);
                }
                else
                {
                    _local8.writeMultiByte(this._comment, this._filenameEncoding);
                };
            };
            var _local12:uint = ((_local8.position - _local9) - _local11);
            _arg1.writeShort(_local9);
            _arg1.writeShort(_local11);
            if (_arg3)
            {
                _arg1.writeShort(_local12);
                _arg1.writeShort(0);
                _arg1.writeShort(0);
                _arg1.writeUnsignedInt(0);
                _arg1.writeUnsignedInt(_arg4);
            };
            if (((_local9 + _local11) + _local12) > 0)
            {
                _arg1.writeBytes(_local8);
            };
            var _local13:uint;
            if (((!(_arg3)) && ((this._content.length > 0))))
            {
                if (this.isCompressed)
                {
                    if (((HAS_UNCOMPRESS) || (HAS_INFLATE)))
                    {
                        _local13 = this._content.length;
                        _arg1.writeBytes(this._content, 0, _local13);
                    }
                    else
                    {
                        _local13 = (this._content.length - 6);
                        _arg1.writeBytes(this._content, 2, _local13);
                    };
                }
                else
                {
                    _local13 = this._content.length;
                    _arg1.writeBytes(this._content, 0, _local13);
                };
            };
            var _local14:uint = ((((30 + _local9) + _local11) + _local12) + _local13);
            if (_arg3)
            {
                _local14 = (_local14 + 16);
            };
            return (_local14);
        }
		public function parse(_arg1:IDataInput):Boolean
        {
            do 
            {
            } while (((_arg1.bytesAvailable) && (this.parseFunc(_arg1))));
            return ((this.parseFunc === this.parseFileIdle));
        }
        protected function parseFileIdle(_arg1:IDataInput):Boolean
        {
            return (false);
        }
        protected function parseFileHead(_arg1:IDataInput):Boolean
        {
            if (_arg1.bytesAvailable >= 30)
            {
                this.parseHead(_arg1);
                if ((this._sizeFilename + this._sizeExtra) > 0)
                {
                    this.parseFunc = this.parseFileHeadExt;
                }
                else
                {
                    this.parseFunc = this.parseFileContent;
                };
                return (true);
            };
            return (false);
        }
        protected function parseFileHeadExt(_arg1:IDataInput):Boolean
        {
            if (_arg1.bytesAvailable >= (this._sizeFilename + this._sizeExtra))
            {
                this.parseHeadExt(_arg1);
                this.parseFunc = this.parseFileContent;
                return (true);
            };
            return (false);
        }
        protected function parseFileContent(_arg1:IDataInput):Boolean
        {
            var _local2:Boolean = true;
            if (this._hasDataDescriptor)
            {
                this.parseFunc = this.parseFileIdle;
                _local2 = false;
            }
            else
            {
                if (this._sizeCompressed == 0)
                {
                    this.parseFunc = this.parseFileIdle;
                }
                else
                {
                    if (_arg1.bytesAvailable >= this._sizeCompressed)
                    {
                        this.parseContent(_arg1);
                        this.parseFunc = this.parseFileIdle;
                    }
                    else
                    {
                        _local2 = false;
                    };
                };
            };
            return (_local2);
        }
        protected function parseHead(_arg1:IDataInput):void
        {
            var _local2:uint = _arg1.readUnsignedShort();
            this._versionHost = (_local2 >> 8);
            this._versionNumber = ((Math.floor(((_local2 & 0xFF) / 10)) + ".") + ((_local2 & 0xFF) % 10));
            var _local3:uint = _arg1.readUnsignedShort();
            this._compressionMethod = _arg1.readUnsignedShort();
            this._encrypted = !(((_local3 & 1) === 0));
            this._hasDataDescriptor = !(((_local3 & 8) === 0));
            this._hasCompressedPatchedData = !(((_local3 & 32) === 0));
            if ((_local3 & 800) !== 0)
            {
                this._filenameEncoding = "utf-8";
            };
            if (this._compressionMethod === COMPRESSION_IMPLODED)
            {
                this._implodeDictSize = ((((_local3 & 2))!==0) ? 0x2000 : 0x1000);
                this._implodeShannonFanoTrees = ((((_local3 & 4))!==0) ? 3 : 2);
            }
            else
            {
                if (this._compressionMethod === COMPRESSION_DEFLATED)
                {
                    this._deflateSpeedOption = ((_local3 & 6) >> 1);
                };
            };
            var _local4:uint = _arg1.readUnsignedShort();
            var _local5:uint = _arg1.readUnsignedShort();
            var _local6:uint = (_local4 & 31);
            var _local7:uint = ((_local4 & 2016) >> 5);
            var _local8:uint = ((_local4 & 0xF800) >> 11);
            var _local9:uint = (_local5 & 31);
            var _local10:uint = ((_local5 & 480) >> 5);
            var _local11:uint = (((_local5 & 0xFE00) >> 9) + 1980);
            this._date = new Date(_local11, (_local10 - 1), _local9, _local8, _local7, _local6, 0);
            this._crc32 = _arg1.readUnsignedInt();
            this._sizeCompressed = _arg1.readUnsignedInt();
            this._sizeUncompressed = _arg1.readUnsignedInt();
            this._sizeFilename = _arg1.readUnsignedShort();
            this._sizeExtra = _arg1.readUnsignedShort();
        }
        protected function parseHeadExt(_arg1:IDataInput):void
        {
            var _local3:uint;
            var _local4:uint;
            var _local5:ByteArray;
            if (this._filenameEncoding == "utf-8")
            {
                this._filename = _arg1.readUTFBytes(this._sizeFilename);
            }
            else
            {
                this._filename = _arg1.readMultiByte(this._sizeFilename, this._filenameEncoding);
            };
            var _local2:uint = this._sizeExtra;
            while (_local2 > 4)
            {
                _local3 = _arg1.readUnsignedShort();
                _local4 = _arg1.readUnsignedShort();
                if (_local4 > _local2)
                {
                    throw (new Error((("Parse error in file " + this._filename) + ": Extra field data size too big.")));
                };
                if ((((_local3 === 0xDADA)) && ((_local4 === 4))))
                {
                    this._adler32 = _arg1.readUnsignedInt();
                    this._hasAdler32 = true;
                }
                else
                {
                    if (_local4 > 0)
                    {
                        _local5 = new ByteArray();
                        _arg1.readBytes(_local5, 0, _local4);
                        this._extraFields[_local3] = _local5;
                    };
                };
                _local2 = (_local2 - (_local4 + 4));
            };
            if (_local2 > 0)
            {
                _arg1.readBytes(new ByteArray(), 0, _local2);
            };
        }
		public function parseContent(_arg1:IDataInput):void
        {
            var _local2:uint;
            if ((((this._compressionMethod === COMPRESSION_DEFLATED)) && (!(this._encrypted))))
            {
                if (((HAS_UNCOMPRESS) || (HAS_INFLATE)))
                {
                    _arg1.readBytes(this._content, 0, this._sizeCompressed);
                }
                else
                {
                    if (this._hasAdler32)
                    {
                        this._content.writeByte(120);
                        _local2 = ((~(this._deflateSpeedOption) << 6) & 192);
                        _local2 = (_local2 + (31 - (((120 << 8) | _local2) % 31)));
                        this._content.writeByte(_local2);
                        _arg1.readBytes(this._content, 2, this._sizeCompressed);
                        this._content.position = this._content.length;
                        this._content.writeUnsignedInt(this._adler32);
                    }
                    else
                    {
                        throw (new Error("Adler32 checksum not found."));
                    };
                };
                this.isCompressed = true;
            }
            else
            {
                if (this._compressionMethod == COMPRESSION_NONE)
                {
                    _arg1.readBytes(this._content, 0, this._sizeCompressed);
                    this.isCompressed = false;
                }
                else
                {
                    throw (new Error((("Compression method " + this._compressionMethod) + " is not supported.")));
                };
            };
            this._content.position = 0;
        }
        protected function compress():void
        {
            if (!this.isCompressed)
            {
                if (this._content.length > 0)
                {
                    this._content.position = 0;
                    this._sizeUncompressed = this._content.length;
                    if (HAS_INFLATE)
                    {
                        this._content.deflate();
                        this._sizeCompressed = this._content.length;
                    }
                    else
                    {
                        if (HAS_UNCOMPRESS)
                        {
                            this._content.compress.apply(this._content, ["deflate"]);
                            this._sizeCompressed = this._content.length;
                        }
                        else
                        {
                            this._content.compress();
                            this._sizeCompressed = (this._content.length - 6);
                        };
                    };
                    this._content.position = 0;
                    this.isCompressed = true;
                }
                else
                {
                    this._sizeCompressed = 0;
                    this._sizeUncompressed = 0;
                };
            };
        }
        protected function uncompress():void
        {
            if (((this.isCompressed) && ((this._content.length > 0))))
            {
                this._content.position = 0;
                if (HAS_INFLATE)
                {
                    this._content.inflate();
                }
                else
                {
                    if (HAS_UNCOMPRESS)
                    {
                        this._content.uncompress.apply(this._content, ["deflate"]);
                    }
                    else
                    {
                        this._content.uncompress();
                    };
                };
                this._content.position = 0;
                this.isCompressed = false;
            };
        }
        public function toString():String
        {
            return ((((((((((((((((((((((((((("[FZipFile]" + "\n  name:") + this._filename) + "\n  date:") + this._date) + "\n  sizeCompressed:") + this._sizeCompressed) + "\n  sizeUncompressed:") + this._sizeUncompressed) + "\n  versionHost:") + this._versionHost) + "\n  versionNumber:") + this._versionNumber) + "\n  compressionMethod:") + this._compressionMethod) + "\n  encrypted:") + this._encrypted) + "\n  hasDataDescriptor:") + this._hasDataDescriptor) + "\n  hasCompressedPatchedData:") + this._hasCompressedPatchedData) + "\n  filenameEncoding:") + this._filenameEncoding) + "\n  crc32:") + this._crc32.toString(16)) + "\n  adler32:") + this._adler32.toString(16)));
        }

    }
}//package deng.fzip


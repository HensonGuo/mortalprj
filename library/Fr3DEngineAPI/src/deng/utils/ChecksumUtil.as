


//deng.utils.ChecksumUtil

package deng.utils
{
    import flash.utils.ByteArray;

    public class ChecksumUtil 
    {

        private static var crcTable:Array = makeCRCTable();

        private static function makeCRCTable():Array
        {
            var _local2:uint;
            var _local3:uint;
            var _local4:uint;
            var _local1:Array = [];
            _local2 = 0;
            while (_local2 < 0x0100)
            {
                _local4 = _local2;
                _local3 = 0;
                while (_local3 < 8)
                {
                    if ((_local4 & 1))
                    {
                        _local4 = (3988292384 ^ (_local4 >>> 1));
                    }
                    else
                    {
                        _local4 = (_local4 >>> 1);
                    };
                    _local3++;
                };
                _local1.push(_local4);
                _local2++;
            };
            return (_local1);
        }
        public static function CRC32(_arg1:ByteArray, _arg2:uint=0, _arg3:uint=0):uint
        {
            var _local4:uint;
            if (_arg2 >= _arg1.length)
            {
                _arg2 = _arg1.length;
            };
            if (_arg3 == 0)
            {
                _arg3 = (_arg1.length - _arg2);
            };
            if ((_arg3 + _arg2) > _arg1.length)
            {
                _arg3 = (_arg1.length - _arg2);
            };
            var _local5:uint = 0xFFFFFFFF;
            _local4 = _arg2;
            while (_local4 < _arg3)
            {
                _local5 = (uint(crcTable[((_local5 ^ _arg1[_local4]) & 0xFF)]) ^ (_local5 >>> 8));
                _local4++;
            };
            return ((_local5 ^ 0xFFFFFFFF));
        }
        public static function Adler32(_arg1:ByteArray, _arg2:uint=0, _arg3:uint=0):uint
        {
            if (_arg2 >= _arg1.length)
            {
                _arg2 = _arg1.length;
            };
            if (_arg3 == 0)
            {
                _arg3 = (_arg1.length - _arg2);
            };
            if ((_arg3 + _arg2) > _arg1.length)
            {
                _arg3 = (_arg1.length - _arg2);
            };
            var _local4:uint = _arg2;
            var _local5:uint = 1;
            var _local6:uint;
            while (_local4 < (_arg2 + _arg3))
            {
                _local5 = ((_local5 + _arg1[_local4]) % 65521);
                _local6 = ((_local5 + _local6) % 65521);
                _local4++;
            };
            return (((_local6 << 16) | _local5));
        }

    }
}//package deng.utils


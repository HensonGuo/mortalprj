// Decompiled by AS3 Sorcerer 1.56
// http://www.as3sorcerer.com/

//x3d.tools.StringUtil

package word.utils{
    import flash.geom.Vector3D;

    public class StringUtil {


        public static function decomposeFilename(_arg1:String):String{
            var _local2:String;
            _local2 = (((_arg1.indexOf("?"))>0) ? _arg1.split("?")[0] : _arg1);
            var _local3:int = _local2.lastIndexOf(".");
            var _local4:String = _local2.substr(0, _local3);
            var _local5:int = _local4.lastIndexOf("/");
            if (_local5 > 0)
            {
                _local4 = _local4.substr((_local5 + 1));
            } else
            {
                _local5 = _local4.lastIndexOf("\\");
                if (_local5 > 0)
                {
                    _local4 = _local4.substr((_local5 + 1));
                };
            };
            return (_local4);
        }

        public static function decomposeFileExt(_arg1:String):String{
            var _local2:String;
            var _local3:int = _arg1.lastIndexOf(".");
            _local2 = (((_arg1.indexOf("?"))>0) ? _arg1.split("?")[0] : _arg1);
            var _local4:String = _local2.substr(0, _local3);
            return (_local4);
        }

        public static function decomposeFilePath(_arg1:String):String{
            var _local2:String;
            var _local3:int = _arg1.lastIndexOf(".");
            _local2 = (((_arg1.indexOf("?"))>0) ? _arg1.split("?")[0] : _arg1);
            var _local4:String = _local2.substr(0, _local3);
            return (_local4);
        }

        public static function getFileExt(_arg1:String):String{
            var _local2:String;
            var _local3:int = _arg1.lastIndexOf(".");
            _local2 = (((_arg1.indexOf("?"))>0) ? _arg1.split("?")[0] : _arg1);
            var _local4:String = _local2.substr(_local3);
            return (_local4);
        }

        public static function parseVector3D(_arg1:String):Vector3D{
            var _local4:Number;
            var _local5:Number;
            var _local6:Number;
            var _local7:int;
            var _local8:String;
            var _local2:Array = _arg1.split(" ");
            var _local3:Array = [];
            if (_local2 != null)
            {
                _local7 = 0;
                while (_local7 < _local2.length)
                {
                    _local8 = _local2[_local7];
                    if (_local8.length != 0)
                    {
                        _local3.push(_local8);
                    };
                    _local7++;
                };
            };
            if (_local3.length > 0)
            {
                _local4 = parseFloat(_local3[0]);
            } else
            {
                _local4 = 0;
            };
            if (_local3.length > 1)
            {
                _local5 = parseFloat(_local3[1]);
            } else
            {
                _local5 = 0;
            };
            if (_local3.length > 2)
            {
                _local6 = parseFloat(_local3[2]);
            } else
            {
                _local6 = 0;
            };
            return (new Vector3D(_local4, _local5, _local6));
        }


    }
}//package x3d.tools


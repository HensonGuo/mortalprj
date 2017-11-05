// Decompiled by AS3 Sorcerer 1.56
// http://www.as3sorcerer.com/

//x2d.core.astar.IMapTileModel

package word.interfaces.astar{
    public interface IMapTileModel {

        function isBlock(_arg1:uint, _arg2:uint, _arg3:int, _arg4:int, _arg5:uint, _arg6:uint, _arg7:int, _arg8:int):int;
        function getArounds(_arg1:uint, _arg2:uint, _arg3:int, _arg4:int):Array;
        function getGValue(_arg1:uint, _arg2:uint, _arg3:int, _arg4:int, _arg5:uint, _arg6:uint, _arg7:int, _arg8:int):int;
        function getHValue(_arg1:uint, _arg2:uint, _arg3:int, _arg4:int, _arg5:uint, _arg6:uint, _arg7:int, _arg8:int):int;

    }
}//package x2d.core.astar


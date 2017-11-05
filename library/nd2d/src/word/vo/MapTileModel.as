// Decompiled by AS3 Sorcerer 1.56
// http://www.as3sorcerer.com/

//x2d.world.vo.MapTileModel

package word.vo{
    import __AS3__.vec.Vector;
    
    import word.interfaces.astar.IMapTileModel;

    public class MapTileModel implements IMapTileModel {

        private const COST_STRAIGHT:int = 10;
        private const COST_DIAGONAL:int = 14;

        private var m_map:Vector.<Vector.<int>>;


        public function get map():Vector.<Vector.<int>>{
            return (this.m_map);
        }

        public function set map(_arg1:Vector.<Vector.<int>>):void{
            this.m_map = _arg1;
        }

        public function isBlock(_arg1:uint, _arg2:uint, _arg3:int, _arg4:int, _arg5:uint, _arg6:uint, _arg7:int, _arg8:int):int
		{
            var _local9:int = this.m_map.length;
            var _local10:int = this.m_map[0].length;
            if ((((((((_arg7 < 0)) || ((_arg7 >= _local9)))) || ((_arg8 < 0)))) || ((_arg8 >= _local10))))
            {
                return (0);
            };
            var _local11:int = ((((!(((this.m_map[_arg7][_arg8] & MapTileTypeDict.TILE_TERRAIN) == 0))) || (!(((this.m_map[_arg7][_arg8] & MapTileTypeDict.TILE_DYNAMIC) == 0))))) ? 0 : 1);
            return (_local11);
        }

        public function getArounds(_arg1:uint, _arg2:uint, _arg3:int, _arg4:int):Array{
            var _local6:int;
            var _local7:int;
            var _local8:Boolean;
            var _local5:Array = [];
            _local6 = (_arg3 + 1);
            _local7 = _arg4;
            var _local9 :Boolean = (this.isBlock(_arg1, _arg2, _arg3, _arg4, _arg1, _arg2, _local6, _local7) == 1);
            if (_local9)
            {
                _local5.push([_arg1, _arg2, _local6, _local7]);
            };
            _local6 = _arg3;
            _local7 = (_arg4 + 1);
            var _local10 :Boolean = (this.isBlock(_arg1, _arg2, _arg3, _arg4, _arg1, _arg2, _local6, _local7) == 1);
            if (_local10)
            {
                _local5.push([_arg1, _arg2, _local6, _local7]);
            };
            _local6 = (_arg3 - 1);
            _local7 = _arg4;
            var _local11 :Boolean = (this.isBlock(_arg1, _arg2, _arg3, _arg4, _arg1, _arg2, _local6, _local7) == 1);
            if (_local11)
            {
                _local5.push([_arg1, _arg2, _local6, _local7]);
            };
            _local6 = _arg3;
            _local7 = (_arg4 - 1);
            var _local12 :Boolean = (this.isBlock(_arg1, _arg2, _arg3, _arg4, _arg1, _arg2, _local6, _local7) == 1);
            if (_local12)
            {
                _local5.push([_arg1, _arg2, _local6, _local7]);
            };
            _local6 = (_arg3 + 1);
            _local7 = (_arg4 + 1);
            _local8 = (this.isBlock(_arg1, _arg2, _arg3, _arg4, _arg1, _arg2, _local6, _local7) == 1);
            if (_local8)
            {
                _local5.push([_arg1, _arg2, _local6, _local7]);
            };
            _local6 = (_arg3 - 1);
            _local7 = (_arg4 + 1);
            _local8 = (this.isBlock(_arg1, _arg2, _arg3, _arg4, _arg1, _arg2, _local6, _local7) == 1);
            if (_local8)
            {
                _local5.push([_arg1, _arg2, _local6, _local7]);
            };
            _local6 = (_arg3 - 1);
            _local7 = (_arg4 - 1);
            _local8 = (this.isBlock(_arg1, _arg2, _arg3, _arg4, _arg1, _arg2, _local6, _local7) == 1);
            if (_local8)
            {
                _local5.push([_arg1, _arg2, _local6, _local7]);
            };
            _local6 = (_arg3 + 1);
            _local7 = (_arg4 - 1);
            _local8 = (this.isBlock(_arg1, _arg2, _arg3, _arg4, _arg1, _arg2, _local6, _local7) == 1);
            if (_local8)
            {
                _local5.push([_arg1, _arg2, _local6, _local7]);
            };
            return (_local5);
        }

        public function getGValue(_arg1:uint, _arg2:uint, _arg3:int, _arg4:int, _arg5:uint, _arg6:uint, _arg7:int, _arg8:int):int{
            return ((((((_arg7 == _arg3)) || ((_arg8 == _arg4)))) ? this.COST_STRAIGHT : this.COST_DIAGONAL));
        }

        public function getHValue(_arg1:uint, _arg2:uint, _arg3:int, _arg4:int, _arg5:uint, _arg6:uint, _arg7:int, _arg8:int):int{
            var _local9:int = (((_arg7 - _arg3) * (_arg7 - _arg3)) + ((_arg8 - _arg4) * (_arg8 - _arg4)));
            _local9 = (Math.sqrt(_local9) * this.COST_STRAIGHT);
            return (_local9);
        }


    }
}//package x2d.world.vo


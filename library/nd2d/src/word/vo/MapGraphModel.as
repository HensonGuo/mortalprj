// Decompiled by AS3 Sorcerer 1.56
// http://www.as3sorcerer.com/

//x2d.world.vo.MapGraphModel

package word.vo{
    import flash.geom.Point;
    import flash.utils.Dictionary;
    
    import __AS3__.vec.Vector;
    
    import word.interfaces.astar.IMapTileModel;

    public class MapGraphModel implements IMapTileModel {

        private var nodeList:Vector.<Point>;
        private var nodeMapIdList:Vector.<int>;
        private var nodeFlagList:Vector.<int>;
        private var nodeCountryList:Vector.<uint>;
        private var nodeMap:Dictionary;

        public function MapGraphModel(){
            this.nodeMap = new Dictionary();
            this.nodeList = new Vector.<Point>();
            this.nodeMapIdList = new Vector.<int>();
            this.nodeCountryList = new Vector.<uint>();
            this.nodeFlagList = new Vector.<int>();
        }

        public static function key(_arg1:uint, _arg2:uint, _arg3:int, _arg4:int):int{
            return (((((_arg1 * 100000000) + (_arg2 * 1000000)) + (_arg3 * 1000)) + _arg4));
        }


        public function addNode(_arg1:uint, _arg2:int, _arg3:int, _arg4:int, _arg5:int):int{
            this.nodeList.push(new Point(_arg3, _arg4));
            this.nodeMapIdList.push(_arg2);
            this.nodeCountryList.push(_arg1);
            this.nodeFlagList.push(_arg5);
            var _local6:int = (this.nodeList.length - 1);
            return (_local6);
        }

        public function clone():MapGraphModel{
            var _local3:GraphNode;
            var _local4:Vector.<GraphNode>;
            var _local5:Vector.<int>;
            var _local6:int;
            if (this.nodeCountryList.length != this.nodeMapIdList.length)
            {
                throw ("grpha data list length error");
            };
            if (this.nodeCountryList.length != this.nodeList.length)
            {
                throw ("grpha data list length error");
            };
            var _local1:MapGraphModel = new MapGraphModel();
            var _local2:int;
            while (_local2 < this.nodeList.length)
            {
                _local1.addNode(this.nodeCountryList[_local2], this.nodeMapIdList[_local2], this.nodeList[_local2].x, this.nodeList[_local2].y, this.nodeFlagList[_local2]);
                _local2++;
            };
            for each (_local3 in this.nodeMap)
            {
                _local4 = _local3.getAllAdjences();
                _local5 = _local3.getAllDistance();
                _local6 = 0;
                while (_local6 < _local4.length)
                {
                    _local1.addItemAsIdx(_local3.index, _local4[_local6].index, _local5[_local6]);
                    _local6++;
                };
            };
            return (_local1);
        }

        public function addItemAsIdx(_arg1:int, _arg2:int, _arg3:int):void{
            var _local4:int = this.nodeList[_arg1].x;
            var _local5:int = this.nodeList[_arg1].y;
            var _local6:int = this.nodeMapIdList[_arg1];
            var _local7:int = this.nodeFlagList[_arg1];
            var _local8:uint = this.nodeCountryList[_arg1];
            var _local9:int = this.nodeList[_arg2].x;
            var _local10:int = this.nodeList[_arg2].y;
            var _local11:int = this.nodeMapIdList[_arg2];
            var _local12:int = this.nodeFlagList[_arg2];
            var _local13:uint = this.nodeCountryList[_arg2];
            var _local14:int = key(_local8, _local6, _local4, _local5);
            var _local15:int = key(_local13, _local11, _local9, _local10);
            if (this.nodeMap[_local14] == null)
            {
                this.nodeMap[_local14] = new GraphNode(_local6, _local4, _local5, _arg1, _local7, _local8);
            };
            if (this.nodeMap[_local15] == null)
            {
                this.nodeMap[_local15] = new GraphNode(_local11, _local9, _local10, _arg2, _local12, _local13);
            };
            this.nodeMap[_local14].addAdjence(this.nodeMap[_local15], _arg3);
        }

        public function removeAllAdjences(_arg1:int):void{
            var _local2:int = this.nodeList[_arg1].x;
            var _local3:int = this.nodeList[_arg1].y;
            var _local4:int = this.nodeMapIdList[_arg1];
            var _local5:int = this.nodeFlagList[_arg1];
            var _local6:uint = this.nodeCountryList[_arg1];
            var _local7:int = key(_local6, _local4, _local2, _local3);
            if (this.nodeMap[_local7] != null)
            {
                this.nodeMap[_local7].removAllAdjences();
            };
        }

        public function removeLink(_arg1:int, _arg2:int):void{
            if (this.nodeMap[_arg1] == null)
            {
                throw ("0");
            };
            var _local3:GraphNode = this.nodeMap[_arg2];
            if (!this.nodeMap[_arg1].removeAdjence(_local3))
            {
            };
        }

        public function findNode(_arg1:uint, _arg2:int, _arg3:int, _arg4:int):int{
            var _local5:int = key(_arg1, _arg2, _arg3, _arg4);
            if (this.nodeMap[_local5] == null)
            {
                return (-1);
            };
            return (this.nodeMap[_local5].index);
        }

        public function getNodeFlag(_arg1:uint, _arg2:uint, _arg3:int, _arg4:int):int{
            var _local5:int = key(_arg1, _arg2, _arg3, _arg4);
            if (this.nodeMap[_local5] == null)
            {
                return (-1);
            };
            return (this.nodeMap[_local5].nodeFlag);
        }

        public function keyx(_arg1:int):int{
            var _local2:uint = (_arg1 % 1000000);
            return ((_local2 / 1000));
        }

        public function keyy(_arg1:int):int{
            var _local2:uint = (_arg1 % 1000000);
            return ((_local2 % 1000));
        }

        public function keymapId(_arg1:int):int{
            var _local2:uint = (_arg1 % 100000000);
            return ((_local2 / 1000000));
        }

        public function keycountry(_arg1:int):int{
            var _local2:uint = (_arg1 / 100000000);
            return (_local2);
        }

        public function isBlock(_arg1:uint, _arg2:uint, _arg3:int, _arg4:int, _arg5:uint, _arg6:uint, _arg7:int, _arg8:int):int{
            var _local9:int = key(_arg1, _arg2, _arg3, _arg4);
            var _local10:int = key(_arg5, _arg6, _arg7, _arg8);
            var _local11:GraphNode = this.nodeMap[_local9];
            var _local12:GraphNode = this.nodeMap[_local10];
            if (((((_local11) && (_local12))) && (_local11.hasAdjence(_local12))))
            {
                return (1);
            };
            return (0);
        }

        public function getArounds(_arg1:uint, _arg2:uint, _arg3:int, _arg4:int):Array{
            var _local5:Array = [];
            var _local6:int = key(_arg1, _arg2, _arg3, _arg4);
            var _local7:GraphNode = this.nodeMap[_local6];
            var _local8:Vector.<GraphNode> = _local7.getAllAdjences();
            var _local9:int;
            while (_local9 < _local8.length)
            {
                _local5.push([_local8[_local9].country, _local8[_local9].mapId, _local8[_local9].x, _local8[_local9].y]);
                _local9++;
            };
            return (_local5);
        }

        public function getGValue(_arg1:uint, _arg2:uint, _arg3:int, _arg4:int, _arg5:uint, _arg6:uint, _arg7:int, _arg8:int):int{
            var _local9:int = key(_arg1, _arg2, _arg3, _arg4);
            var _local10:int = key(_arg5, _arg6, _arg7, _arg8);
            return (this.nodeMap[_local9].getDistance(this.nodeMap[_local10]));
        }

        public function getHValue(_arg1:uint, _arg2:uint, _arg3:int, _arg4:int, _arg5:uint, _arg6:uint, _arg7:int, _arg8:int):int{
            var _local9:int = key(_arg1, _arg2, _arg3, _arg4);
            var _local10:int = key(_arg5, _arg6, _arg7, _arg8);
            return (this.nodeMap[_local9].getDistance(this.nodeMap[_local10]));
        }


    }
}//package x2d.world.vo


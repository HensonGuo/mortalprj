// Decompiled by AS3 Sorcerer 1.56
// http://www.as3sorcerer.com/

//x2d.world.vo.GraphNode

package word.vo{
    import __AS3__.vec.Vector;
    import __AS3__.vec.*;

    public class GraphNode {

        private var _x:int;
        private var _y:int;
        private var _mapId:int;
        private var _index:int;
        private var _nodeFlag:int;
        private var _country:uint;
        private var adjences:Vector.<GraphNode>;
        private var distance:Vector.<int>;

        public function GraphNode(_arg1:int, _arg2:int, _arg3:int, _arg4:int, _arg5:int, _arg6:uint){
            this._x = _arg2;
            this._y = _arg3;
            this._mapId = _arg1;
            this._index = _arg4;
            this._nodeFlag = _arg5;
            this._country = _arg6;
            this.adjences = new Vector.<GraphNode>();
            this.distance = new Vector.<int>();
        }

        public function get x():int{
            return (this._x);
        }

        public function get y():int{
            return (this._y);
        }

        public function get mapId():int{
            return (this._mapId);
        }

        public function get index():int{
            return (this._index);
        }

        public function get nodeFlag():int{
            return (this._nodeFlag);
        }

        public function get country():uint{
            return (this._country);
        }

        public function getAllAdjences():Vector.<GraphNode>{
            return (this.adjences);
        }

        public function getAllDistance():Vector.<int>{
            return (this.distance);
        }

        public function addAdjence(_arg1:GraphNode, _arg2:int):void{
            var _local5:int;
            var _local3:int = -1;
            var _local4:int;
            while (_local4 < this.adjences.length)
            {
                if (this.adjences[_local4] == _arg1)
                {
                    _local3 = _local4;
                    break;
                };
                _local4++;
            };
            if (_local3 != -1)
            {
                trace(((((((this._x + ",") + this._y) + "已经有adjence:") + _arg1.x) + ",") + _arg1.y));
                throw ("重复记录GraphNode");
            };
            if ((((_arg1.x == 9)) && ((_arg1.y == 152))))
            {
                _local5 = 0;
            };
            this.adjences.push(_arg1);
            this.distance.push(_arg2);
        }

        public function removAllAdjences():void{
            if (this.nodeFlag != 2)
            {
                throw ("0");
            };
            var _local1:int = this.country;
            var _local2:int = this.mapId;
            var _local3:int;
            while (_local3 < this.adjences.length)
            {
                if (this.adjences[_local3].mapId == _local2)
                {
                    throw ("0");
                };
                this.adjences.splice(_local3, 1);
            };
            if (this.adjences.length != 0)
            {
                throw ("0");
            };
        }

        public function removeAdjence(_arg1:GraphNode):Boolean{
            var _local2:int;
            while (_local2 < this.adjences.length)
            {
                if (this.adjences[_local2] == _arg1)
                {
                    this.adjences.splice(_local2, 1);
                    return (true);
                };
                _local2++;
            };
            return (false);
        }

        public function hasAdjence(_arg1:GraphNode):Boolean{
            var _local2:int;
            while (_local2 < this.adjences.length)
            {
                if (this.adjences[_local2] == _arg1)
                {
                    return (true);
                };
                _local2++;
            };
            return (false);
        }

        public function getDistance(_arg1:GraphNode):int{
            var _local2:int;
            while (_local2 < this.adjences.length)
            {
                if (this.adjences[_local2] == _arg1)
                {
                    return (this.distance[_local2]);
                };
                _local2++;
            };
            return (10000000);
        }


    }
}//package x2d.world.vo


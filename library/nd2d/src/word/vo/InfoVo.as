// Decompiled by AS3 Sorcerer 1.56
// http://www.as3sorcerer.com/

//x2d.world.vo.InfoVo

package word.vo{
    import flash.geom.Point;

    public class InfoVo {

        public var tempId:int;
        public var name:String;
        public var tileX:int;
        public var tileY:int;
        public var dir:Number = 0;
        public var hp:uint;
        public var maxhp:uint;
        public var mp:uint;
        public var maxmp:uint;
        public var meshName:String;
        public var meshScale:Number;
        public var moveSpeed:int;
        public var itemType:int;
        public var resType:int;
        protected var _isDead:Boolean = false;

        public function InfoVo(){
            this.meshScale = 120;
        }

        public function get tilePoint():Point{
            return (new Point(this.tileX, this.tileY));
        }

        public function get isDead():Boolean{
            return (this._isDead);
        }

        public function set isDead(_arg1:Boolean):void{
            this._isDead = _arg1;
        }


    }
}//package x2d.world.vo


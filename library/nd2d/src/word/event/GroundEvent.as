// Decompiled by AS3 Sorcerer 1.56
// http://www.as3sorcerer.com/

//se7en.world.event.GroundEvent

package  word.event{
    import flash.events.Event;

    public class GroundEvent extends Event {

        public static const BRICK_TOTALCOUNT:String = "TotalGround";

        public var brickTotalCount:int;

        public function GroundEvent(_arg1:String, _arg2:uint){
            super(_arg1, false, false);
            this.brickTotalCount = _arg2;
        }

    }
}//package se7en.world.event


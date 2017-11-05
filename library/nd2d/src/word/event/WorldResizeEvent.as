// Decompiled by AS3 Sorcerer 1.56
// http://www.as3sorcerer.com/

//se7en.world.event.WorldResizeEvent

package  word.event{
    public class WorldResizeEvent extends WorldEvent {

        public static const RESIZE:String = "WorldResizeEvent";

        public var oldWidth:Number = NaN;
        public var oldHeight:Number = NaN;
        public var newWidth:Number = NaN;
        public var newHeight:Number = NaN;

        public function WorldResizeEvent(_arg1:String, _arg2:Number=NaN, _arg3:Number=NaN, _arg4:Number=NaN, _arg5:Number=NaN){
            super(_arg1, false, false);
            this.oldHeight = _arg3;
            this.oldWidth = _arg2;
            this.newHeight = _arg5;
            this.newWidth = _arg4;
        }

    }
}//package se7en.world.event


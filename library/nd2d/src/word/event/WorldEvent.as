// Decompiled by AS3 Sorcerer 1.56
// http://www.as3sorcerer.com/

//se7en.world.event.WorldEvent

package  word.event{
    import flash.events.Event;

    public class WorldEvent extends Event {

        public static const WORLD_CLICK:String = "world_click";
        public static const SHAKE_CAMERA:String = "shake_camera";
        public static const CLICK_MAP:String = "click_map";
        public static const MAGIC_END:String = "magic_end";
        public static const MAGIC_HURT:String = "magic_hurt";
        public static const MAGIC_OVER:String = "magic_over";
        public static const MOVE_CAMERA:String = "move_camera";

        public var value0:Object;
        public var value1:Object;

        public function WorldEvent(_arg1:String, _arg2:Boolean=false, _arg3:Boolean=false){
            super(_arg1, _arg2, _arg3);
        }

    }
}//package se7en.world.event


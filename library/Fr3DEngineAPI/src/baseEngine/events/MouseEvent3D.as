


//flare.events.MouseEvent3D

package baseEngine.events
{
    import flash.events.Event;
    import baseEngine.collisions.CollisionInfo;

    public class MouseEvent3D extends Event 
    {

        public static const CLICK:String = "click";
        public static const MOUSE_DOWN:String = "mouseDown";
        public static const MOUSE_MOVE:String = "mouseMove";
        public static const MOUSE_OUT:String = "mouseOut";
        public static const MOUSE_OVER:String = "mouseOver";
        public static const MOUSE_UP:String = "mouseUp";
        public static const MOUSE_WHEEL:String = "mouseWheel";

        public var info:CollisionInfo;

        public function MouseEvent3D(_arg1:String, _arg2:CollisionInfo=null)
        {
            this.info = new CollisionInfo();
            this.info = _arg2;
            super(_arg1);
        }
        override public function clone():Event
        {
            return (new MouseEvent3D(type, this.info));
        }
        override public function toString():String
        {
            return ((('[MouseEvent3D type="' + type) + '"]'));
        }

    }
}//package flare.events


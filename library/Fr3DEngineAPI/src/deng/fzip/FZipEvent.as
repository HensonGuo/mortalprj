


//deng.fzip.FZipEvent

package deng.fzip
{
    import flash.events.Event;

    public class FZipEvent extends Event 
    {

        public static const FILE_LOADED:String = "fileLoaded";

        public var file:FZipFile;

        public function FZipEvent(_arg1:String, _arg2:FZipFile=null, _arg3:Boolean=false, _arg4:Boolean=false)
        {
            this.file = _arg2;
            super(_arg1, _arg3, _arg4);
        }
        override public function clone():Event
        {
            return (new FZipEvent(type, this.file, bubbles, cancelable));
        }
        override public function toString():String
        {
            return ((((((((((('[FZipEvent type="' + type) + '" filename="') + this.file.filename) + '" bubbles=') + bubbles) + " cancelable=") + cancelable) + " eventPhase=") + eventPhase) + "]"));
        }

    }
}//package deng.fzip


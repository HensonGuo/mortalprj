


//deng.fzip.FZipErrorEvent

package deng.fzip
{
    import flash.events.Event;

    public class FZipErrorEvent extends Event 
    {

        public static const PARSE_ERROR:String = "parseError";

        public var text:String;

        public function FZipErrorEvent(_arg1:String, _arg2:String="", _arg3:Boolean=false, _arg4:Boolean=false)
        {
            this.text = _arg2;
            super(_arg1, _arg3, _arg4);
        }
        override public function clone():Event
        {
            return (new FZipErrorEvent(type, this.text, bubbles, cancelable));
        }

    }
}//package deng.fzip


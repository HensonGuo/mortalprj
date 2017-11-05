


//flare.core.Label3D

package baseEngine.core
{

    public class Label3D 
    {

        public var from:int;
		public var fightOnFrame:int;
        public var to:int;
		public var length:int;
		//public var hasSetup:Boolean;
		public var trackName:String;
        public function Label3D( $from:int, $to:int,$trackName:String,$fightOnFrame:uint)
        {
			trackName=$trackName;
			fightOnFrame=$fightOnFrame;
			change($from,$to);
			
        }
        public function toString():String
        {
            return ((((((("[object Label3D " + this.trackName) + " from:") + this.from) + ", to:") + this.to) + "]"));
        }
		public function change($from:int,$to:int):void
		{
			this.from = $from;
			this.to = $to;
			this.length=this.to-this.from+1;
		}

    }
}//package flare.core


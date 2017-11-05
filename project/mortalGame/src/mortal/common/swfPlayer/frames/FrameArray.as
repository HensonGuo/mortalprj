package mortal.common.swfPlayer.frames
{
	import mortal.common.swfPlayer.data.ActionInfo;
	

	public  dynamic  class FrameArray extends Array
	{
		public var isTurn:Boolean;
		public var isTurnY:Boolean;
		
		private var _actionInfo:ActionInfo;
		
		private var _delay:int = 2;
		
		public function FrameArray( actionInfo:ActionInfo = null  )
		{
			super();
			_actionInfo  = actionInfo;
		}
		
		public function get actionInfo():ActionInfo
		{
			return _actionInfo;
		}

		public function set actionInfo(value:ActionInfo):void
		{
			_actionInfo = value;
		}

		public function get delay():int
		{
			if( _actionInfo )
			{
				return _actionInfo.delay;
			}
			return 10;
		}
		
		public function get dirNum():int
		{
			if( _actionInfo )
			{
				return _actionInfo.dir;
			}
			return 8;
		}

		public function clone():FrameArray
		{
			var ary:FrameArray = new FrameArray(_actionInfo);
			for( var i:int=0;i<this.length;i++ )
			{
				ary[i] = this[i];
			}
			return ary;
		}
	}
}

package mortal.game.scene3D.events
{
	import flash.events.Event;

	public class SceneEvent extends Event
	{
		/**
		 * 初始化 
		 */		
		public static const INIT:String = "init";
		public static const NPCTASK:String = "npctask";
		
		private var _data:Object;
		
		public function SceneEvent(type:String,data:Object=null)
		{
			super(type,false,false);
			_data = data;
		}

		public function get data():Object
		{
			return _data;
		}

	}
}
package mortal.game.resource
{
	import com.gengine.resource.ConfigManager;
	
	import flash.utils.Dictionary;
	
	import mortal.game.scene.modle.data.ActionInfo;

	public class FrameTypeAction
	{
		private static var _instance:FrameTypeAction;
		
		private var _map:Dictionary = new Dictionary();
		
		public function FrameTypeAction()
		{
			if( _instance != null )
			{
				throw new Error(" FrameTypeConfig 单例 ");
			}
			init();
		}
		
		public static function get instance():FrameTypeAction
		{
			if( _instance == null )
			{
				_instance = new FrameTypeAction();
			}
			return _instance;
		}
		
		/**
		 *  读取模型数据
		 * @param object
		 * @return 
		 * 
		 */		
		private function write( dic:Object ):void
		{
			var actionInfo:ActionInfo;
			var actionObject:Object;
			var info:Object;
			for each( var modle:Object in dic.modle  )
			{
				if( modle.action is Array )
				{
					for each( info in modle.action )
					{
						_map[ modle.name+"_"+info.type ] = new ActionInfo( info.type,info.startFrame,info.endFrame,info.frameRate,info.delay,info.dir);
					}
				}
				else
				{
					info = modle.action;
					_map[ modle.name+"_"+info.type ] = new ActionInfo( info.type,info.startFrame,info.endFrame,info.frameRate,info.delay,info.dir);
				}
			}
		}
		
		public function init():void
		{
			var obj:Object =  ConfigManager.instance.getObjectByFileName("frameType.xml");
			write( obj );
		}
		
		public function getActionInfo( name:String,type:int ):ActionInfo
		{
			return _map[name+"_"+type];
		}
	}
}
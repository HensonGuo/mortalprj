package mortal.game.resource
{
	import com.gengine.resource.ConfigManager;
	
	import flash.utils.Dictionary;
	
	import mortal.common.swfPlayer.data.ActionInfo;
	import mortal.common.swfPlayer.frames.SwfFrames;
	
	public class FrameTypeConfig
	{
		private static var _instance:FrameTypeConfig;
		
		private var _map:Dictionary = new Dictionary();
		
		private var _nameMap:Dictionary = new Dictionary();
		
		public function FrameTypeConfig()
		{
			if( _instance != null )
			{
				throw new Error(" FrameTypeConfig 单例 ");
			}
			init();
		}
		
		public static function get instance():FrameTypeConfig
		{
			if( _instance == null )
			{
				_instance = new FrameTypeConfig();
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
			var frame:SwfFrames;
			var actionInfo:ActionInfo;
			var actionObject:Object;
			var objAry:Array = [];
			if(dic.modle is Array)
			{
				objAry = dic.modle;
			}
			else
			{
				objAry.push(dic.modle);
			}
			for each( var modle:Object in objAry )
			{
				frame = new SwfFrames(modle.frameType,modle.name);
				frame.createAction(modle);
				_map[ frame.frameType+"_"+frame.type ] = frame;
				_nameMap[ frame.name ]= frame;
			}
		}
		
		public function init():void
		{
			var object:Object =  ConfigManager.instance.getObjectByFileName("frameType.xml");
			write( object );
		}
		
		public function getFramesByType( frameType:String ,type:int=0):SwfFrames
		{
			return _map[ frameType+"_"+type ];
		}
		
		public function getFramesByName( name:String ):SwfFrames
		{
			return _nameMap[ name ];
		}
	}
}
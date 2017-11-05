/**
 * 模型攻击帧配置
 * 
 */	
package mortal.game.resource
{
	import com.gengine.resource.ConfigManager;
	
	import flash.utils.Dictionary;
	
	import mortal.game.resource.info.ModelAttackFrameInfo;


	public class ModelAttackFrameConfig
	{
		private static var _instance:ModelAttackFrameConfig;
		
		private var _map:Dictionary = new Dictionary();
		
		public function ModelAttackFrameConfig()
		{
			if( _instance != null )
			{
				throw new Error(" ResConfig 单例 ");
			}
			init();
		}
		
		
		public static function get instance():ModelAttackFrameConfig
		{
			if( _instance == null )
			{
				_instance = new ModelAttackFrameConfig();
			}
			return _instance;
		}
		
		/**
		 *  
		 * @param object
		 * @return 
		 * 
		 */		
		private function write( dic:Object ):void
		{
			var info:ModelAttackFrameInfo;
			for each( var o:Object in dic.fireFrames  )
			{
				for each(var item:Object in o)
				{
					info = new ModelAttackFrameInfo();
					info.career = item.career;
					info.sex = item.sex;
					info.action = item.action;
					info.fireFrame = item.fireFrame;
					if(item.hasOwnProperty("handsEndFrame"))
					{
						info.handsEndFrame = item.handsEndFrame;
					}
					if(item.hasOwnProperty("attackEndFrame"))
					{
						info.attackEndFrame = item.attackEndFrame;
					}
					if(item.hasOwnProperty("waitEndFrame"))
					{
						info.waitEndFrame = item.waitEndFrame;
					}
					_map[ info.career +""+info.sex + info.action ] = info;
				}
			}
		}
		
		public function init():void
		{
			var object:Object =  ConfigManager.instance.getObjectByFileName("modelAttackFrame.xml");
			write( object );
		}
		
		/**
		 * 获取文件资源信息
		 * @param value
		 * @return 
		 * 
		 */
		public function getAttackFrameInfo( career:int, sex:int, action:String):ModelAttackFrameInfo
		{
			return _map[career + "" + sex + action];
		}
	}
}

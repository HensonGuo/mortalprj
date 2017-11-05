package mortal.game.resource
{
	import com.gengine.resource.ConfigManager;
	import com.gengine.utils.StringHelper;
	
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import frEngine.math.StringUtils;
	
	import mortal.game.resource.info.DramaEffectInfo;
	
	public class DramaEffectConfig
	{
		
		private static var _instance:DramaEffectConfig;
		
		private var _map:Dictionary = new Dictionary();
		
		public function DramaEffectConfig()
		{
			if( _instance != null )
			{
				throw new Error(" ResConfig 单例 ");
			}
			init();
		}
		
		
		public static function get instance():DramaEffectConfig
		{
			if( _instance == null )
			{
				_instance = new DramaEffectConfig();
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
			var info:DramaEffectInfo;
			for each( var o:Object in dic.drama  )
			{
				info = new DramaEffectInfo();
				info.code = o.code;
				info.src = o.src;
				info.points = toPointArray(o.points);
				info.moveType = toNumberArray(o.moveType);
				info.moveTime = toNumberArray(o.moveTime);
				info.repeatCount = o.repeatCount;
				info.repeatInterval = o.repeatInterval;
				info.sound = o.sound;
				info.scale = toNumberArray(o.scale);
				info.delay = o.delay;
				info.effectType = o.effectType;
				
				_map[ o.code ] = info;
			}
		}
		
		/**
		 * 字符串转化为坐标数组 
		 * @param strPoints
		 * @return 
		 * 
		 */		
		private function toPointArray(str:String):Array
		{
			str = StringHelper.trim(str);
			var points:Array = [];
			if(str.length > 2)
			{
				var strArray:Array = str.split(";");
				for(var i:int = 0; i < strArray.length;i++)
				{
					var strPoint:String = strArray[i];
					var aryNumber:Array = toNumberArray(strPoint);
					if(aryNumber.length == 2)
					{
						points.push( new Point(aryNumber[0],aryNumber[1]));
					}
				}
			}
			return points;
		}
		
		/**
		 * 字符串转化为数字数组 
		 * @param str
		 * @return 
		 * 
		 */
		private function toNumberArray(str:String):Array
		{
			str = StringHelper.trim(str);
			var strArray:Array = str.split(",");
			var numberArray:Array = [];
			for(var i:int = 0; i < strArray.length;i++)
			{
				numberArray.push(Number(strArray[i]));
			}
			return numberArray;
		}
		
		public function init():void
		{
			var object:Object =  ConfigManager.instance.getObjectByFileName("dramaEffect.xml");
			write( object );
		}
		
		public function getDramaEffectInfo( code:Object ):DramaEffectInfo
		{
			return _map[code];
		}
	}
}
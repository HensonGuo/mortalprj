package mortal.game.resource.tableConfig
{
	import Message.DB.Tables.TMarket;
	
	import com.gengine.resource.ConfigManager;
	
	import flash.utils.Dictionary;
	
	import mortal.game.view.common.ClassTypesUtil;

	/**
	 * 市场配置文件
	 * @author lizhaoning
	 */
	public class MarketConfig
	{
		private static var _instance:MarketConfig;
		
		private var _map:Dictionary = new Dictionary();
		
		public function MarketConfig()
		{
			if( _instance != null )
			{
				throw new Error(" MarketConfig 单例 ");
			}
			init();
		}
		
		public static function get instance():MarketConfig
		{
			if( _instance == null )
			{
				_instance = new MarketConfig();
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
			var info:TMarket;
			
			for each( var o:Object in dic  )
			{
				if(_map[o.market1]  == null)
				{
					_map[o.market1] = new Dictionary();
				}
				
				info = new TMarket();
				ClassTypesUtil.copyValue(info,o);
				_map[ info.market1 ][ info.market2 ] = info;
			}
		}
		
		public function init():void
		{
			var object:Object = ConfigManager.instance.getJSONByFileName("t_market.json");
			write( object );
		}
		
		/**
		 * 获取文件资源信息
		 * @param value
		 * @return 
		 * 
		 */		
		public function getInfoById( marketId:int ):TMarket
		{
			return _map[marketId];
		}
		
		public function get map():Dictionary
		{
			return _map;
		}
		
		public static function decodeItemType(tMarket:TMarket):Array
		{
			var arr:Array = [];
			
			var arr1:Array = tMarket.itemType.split("&");
			
			for (var i:int = 0; i < arr1.length; i++) 
			{
				var str:String = arr1[i];
				str += "#";
				arr.push(str);
			}
			
			return arr;
		}

	}
}
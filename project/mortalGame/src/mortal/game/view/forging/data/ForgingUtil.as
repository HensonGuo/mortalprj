package mortal.game.view.forging.data
{
	import com.gengine.utils.HashMap;
	
	import mortal.game.resource.GameDefConfig;

	/**
	 * @date   2014-4-3 上午10:58:53
	 * @author dengwj
	 */	 
	public class ForgingUtil
	{
		private static var _instance:ForgingUtil;
	
		private var _gemPropNameMap:HashMap;
		
		public function ForgingUtil()
		{
			if(_instance != null)
			{
				throw new Error("ForgingUtil 单例");	
			}
			init();
		}
		
		public static function get instance():ForgingUtil
		{
			if(_instance == null)
			{
				_instance = new ForgingUtil();
			}
			return _instance;
		}
		
		private function init():void
		{
			_gemPropNameMap = new HashMap();
			_gemPropNameMap.push(1,GameDefConfig.instance.getAttributeName("attack"));
			_gemPropNameMap.push(2,GameDefConfig.instance.getAttributeName("life"));
			_gemPropNameMap.push(4,GameDefConfig.instance.getAttributeName("physDefense"));
			_gemPropNameMap.push(5,GameDefConfig.instance.getAttributeName("magicDefense"));
			_gemPropNameMap.push(6,GameDefConfig.instance.getAttributeName("penetration"));
			_gemPropNameMap.push(7,GameDefConfig.instance.getAttributeName("jouk"));
			_gemPropNameMap.push(8,GameDefConfig.instance.getAttributeName("hit"));
			_gemPropNameMap.push(9,GameDefConfig.instance.getAttributeName("crit"));
			_gemPropNameMap.push(10,GameDefConfig.instance.getAttributeName("toughness"));
			_gemPropNameMap.push(11,GameDefConfig.instance.getAttributeName("block"));
			_gemPropNameMap.push(12,GameDefConfig.instance.getAttributeName("expertise"));
		}
		
		public function getGemPropName(type:int):String
		{
			return this._gemPropNameMap.getValue(type) as String;
		}
	}
}
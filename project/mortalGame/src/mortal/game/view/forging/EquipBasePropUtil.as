package mortal.game.view.forging
{
	import Message.DB.Tables.TItemEquip;
	
	import com.gengine.utils.HashMap;
	
	import flash.utils.Dictionary;
	
	import mortal.game.resource.GameDefConfig;
	import mortal.game.resource.info.item.ItemEquipInfo;

	/**
	 * @date   2014-3-19 下午2:56:20
	 * @author dengwj
	 */	 
	public class EquipBasePropUtil
	{
		private static var _instance:EquipBasePropUtil;
		
		/** 属性集合 */
		private var propsMap:HashMap = new HashMap();
		
		public function EquipBasePropUtil()
		{
			if( _instance != null )
			{
				throw new Error(" EquipBasePropUtil 单例 ");
			}
			init();
		}
		
		private function init():void
		{
			propsMap.push("attack",GameDefConfig.instance.getAttributeName("attack"));
			propsMap.push("life",GameDefConfig.instance.getAttributeName("life"));
			propsMap.push("mana",GameDefConfig.instance.getAttributeName("mana"));
			propsMap.push("physDefense",GameDefConfig.instance.getAttributeName("physDefense"));
			propsMap.push("magicDefense",GameDefConfig.instance.getAttributeName("magicDefense"));
			propsMap.push("penetration",GameDefConfig.instance.getAttributeName("penetration"));
			propsMap.push("crit",GameDefConfig.instance.getAttributeName("crit"));
			propsMap.push("toughness",GameDefConfig.instance.getAttributeName("toughness"));
			propsMap.push("hit",GameDefConfig.instance.getAttributeName("hit"));
			propsMap.push("jouk",GameDefConfig.instance.getAttributeName("jouk"));
			propsMap.push("expertise",GameDefConfig.instance.getAttributeName("expertise"));
			propsMap.push("block",GameDefConfig.instance.getAttributeName("block"));
			propsMap.push("damageReduce",GameDefConfig.instance.getAttributeName("damageReduce"));
		}
		
		public static function get instance():EquipBasePropUtil
		{
			if( _instance == null )
			{
				_instance = new EquipBasePropUtil();
			}
			return _instance;
		}
		
		/**
		 * 获取强化相关的属性 
		 * @param itemEquip      装备基本属性信息
		 * @param propPercent    当前总属性百分比(随进度递增)
		 * @return propUpPercent 下级总属性百分比(不变)
		 */		
		public function getStrengthenProps(itemEquip:ItemEquipInfo,propPercent:Number,propNextPercent:Number):Array
		{
			var propArr:Array = [];
			var count:int;
			var keys:Array = this.propsMap.getKeys();
			for each(var prop:String in keys)
			{
				if(itemEquip[prop] != 0)
				{
					var obj:Object  = {};
					obj.propName    = this.propsMap.getValue(prop);
					obj.propValue   = Math.ceil(itemEquip[prop] * propPercent);
					obj.propUpValue = Math.ceil(itemEquip[prop] * propNextPercent);
					propArr.push(obj);
					count++;
					if(count == 3)
					{
						break;
					}
				}
			}
			return propArr;
		}
	}
}
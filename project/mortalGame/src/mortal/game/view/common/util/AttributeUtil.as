/**
 * 2014-4-18
 * @author chenriji
 **/
package mortal.game.view.common.util
{
	import extend.language.Language;
	
	import mortal.game.resource.info.item.AttributeData;

	public class AttributeUtil
	{
		//			"攻击 生命 暴击 坚韧 闪避 命中 穿透 格挡 精准 物理防御 法术防御 法力",
		public static var attrNames:Array = Language.getString(20217).split(" ");
		public static var attrs:Array = [
			"attack",
			"life",
			"mana",
			"physDefense",
			"magicDefense",
			"penetration",
			"crit",
			"toughness",
			"hit",
			"jouk",
			"expertise",
			"block",
			"damageReduce"
		];
		
		public function AttributeUtil()
		{
		}
		
		/**
		 * 获取装备、坐骑、宠物等的基础属性 
		 * @param equip ItemMountInfo,ItemEquipInfo
		 * @return 
		 * 
		 */		
		public static function getEquipmentBasicAttrs(obj:Object):Vector.<AttributeData>
		{
			var res:Vector.<AttributeData> = new Vector.<AttributeData>();
			for(var i:int = 0; i < attrs.length; i++)
			{
				var value:int = obj[attrs[i]];
				if(value > 0)
				{
					var data:AttributeData = new AttributeData();
					data.value = value;
					data.type = i;
					data.name = attrNames[i] as String;
					res.push(data)
				}
			}
			return res;
		}
	}
}
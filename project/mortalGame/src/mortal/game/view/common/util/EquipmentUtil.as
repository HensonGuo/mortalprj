/**
 * 2014-4-1
 * @author chenriji
 **/
package mortal.game.view.common.util
{
	import extend.language.Language;
	
	import mortal.game.cache.Cache;
	import mortal.game.resource.info.item.AttributeData;
	import mortal.game.resource.info.item.EquipmentSuitData;
	import mortal.game.resource.info.item.ItemData;
	import mortal.game.resource.info.item.ItemEquipInfo;
	import mortal.game.view.common.tooltip.tooltips.equipment.ToolTipStoneData;
	import mortal.game.view.forging.data.ForgingConst;

	public class EquipmentUtil
	{
		public function EquipmentUtil()
		{
		}
		
		/**
		 * 获取装备通过强化增加的基础属性比例
		 * @param equip
		 * @return 
		 * 
		 */		
		public static function getStrengthenAddRatio(equip:ItemData):Number
		{
			var currStrengthenProgress:int = equip.extInfo.currentStrengthen;// 当前强化进度
			var currStrengthenLevel:int    = equip.extInfo.strengthen;// 当前强化等级
			var currProgressPercent:Number = currStrengthenProgress / ForgingConst.TotalStrengProgress;// 当前进度百分比
			
			var currRewardPercent:int;// 当前强化等级奖励百分比
			var nextRewardPercent:int;// 下一强化等级奖励百分比
			var propPercent:Number;// 当前总属性百分比(基本属性+强化属性)
			var propNextPercent:Number;// 下级总属性百分比
			
			if(currStrengthenLevel == 0)// 当前强化等级
			{
				currRewardPercent = 0;
				nextRewardPercent = Cache.instance.forging.getPropAddPercentByLevel(currStrengthenLevel + 1);
			}
			else if(currStrengthenLevel < ForgingConst.MaxStrengLevel)
			{
				currRewardPercent = Cache.instance.forging.getPropAddPercentByLevel(currStrengthenLevel);
				nextRewardPercent = Cache.instance.forging.getPropAddPercentByLevel(currStrengthenLevel + 1);
			}
			else
			{
				currRewardPercent = Cache.instance.forging.getPropAddPercentByLevel(currStrengthenLevel);
				nextRewardPercent = currRewardPercent;
			}
			propPercent = currRewardPercent / 100 + (nextRewardPercent - currRewardPercent) / 100 * currProgressPercent;
			return propPercent;
		}
		
		/**
		 * 获取玩家装备的洗练属性
		 * @param equip
		 * @return 
		 * 
		 */		
		public static function getEquipmentXiLianAttrs(equip:ItemData):Vector.<AttributeData>
		{
			var res:Vector.<AttributeData> = new Vector.<AttributeData>();
//			for(var i:int = 0; i < attrs.length; i++)
//			{
//				var value:int = equip.extInfo[attrs[i]];
//				if(value > 0)
//				{
//					var data:AttributeData = new AttributeData();
//					data.value = value;
//					data.type = i;
//					data.name = attrNames[i] as String;
//					res.push(data)
//				}
//			}
			// 测试用
			var data:AttributeData = new AttributeData();
			data.value = 1000;
			data.type = 0;
			data.name = "生命";
			res.push(data);
			
			data = new AttributeData();
			data.value = 10;
			data.type = 1;
			data.name = "暴击";
			res.push(data);
			
			data = new AttributeData();
			data.value = 100;
			data.type = 2;
			data.name = "攻击";
			res.push(data);
			
			data = new AttributeData();
			data.value = 1099;
			data.type = 3;
			data.name = "物理防御";
			res.push(data);
			
			data = new AttributeData();
			data.value = 900;
			data.type = 4;
			data.name = "法术防御";
			res.push(data);
			
			data = new AttributeData();
			data.value = 66;
			data.type = 5;
			data.name = "闪避";
			res.push(data);
			
			return res;
		}
		
		/**
		 * 获取装备中的宝石数据 
		 * @param equip
		 * @return 
		 * 
		 */		
		public static function getEquipmentStonesData(equip:ItemData):Array
		{
			var res:Array = [];
			var max:int = getMaxStoneHoleNum(equip) + 1;
			for(var i:int = 1; i < max; i++)
			{
				var uid:String = equip.extInfo["h" + i.toString()];
				var data:ToolTipStoneData = new ToolTipStoneData();
				data.isLocked = (i > equip.extInfo.hole_num);
				res.push(data);
				
				if(uid == null || uid == "") // 为开孔的，要提示完美+x开启
				{
					var tmp:int = 3;
					if(i < 3)
					{
						tmp = 3;
					}
					else if(i < 5)
					{
						tmp = 6;
					}
					else if(i < 7)
					{
						tmp = 9;
					}
					else 
					{
						tmp = 12;
					}
					data.openTips = Language.getStringByParam(20204, tmp);
					continue;
				}
				data.itemData = Cache.instance.pack.embedPackCache.getGemByUid(uid);
			}
			
			return res;
		}
		
		public static function getMaxStoneHoleNum(item:ItemData):int
		{
			return 8;
			if(item.itemInfo.level >= 80)
			{
				return 8;
			}
			if(item.itemInfo.level >= 70)
			{
				return 6;
			}
			if(item.itemInfo.level >= 60)
			{
				return 4;
			}
			if(item.itemInfo.level >= 40)
			{
				return 2;
			}
			return 0;
		}
		
		public static function getEquipmentSuitData(_data:ItemData):EquipmentSuitData
		{
			// 测试
			var res:EquipmentSuitData = new EquipmentSuitData();
			res.codes = [100000001, 100000004, 100000006, 100000007, 100000008, 100000009, 100000010];
			res.codeHas = [100000001, 100000004, 100000010];
			res.color = 2;
			res.name = "且行且珍套装";
			res.suitDes = ["[2件套]    牛B了+500攻击力", "[4件套]    我比前面那货低调+501攻击力",
				"[7件套]    你们好假我真的+800吨颤抖力"];
			return res;
		}
	}
}
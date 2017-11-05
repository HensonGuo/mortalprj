/**
 * @date 2013-7-26 下午05:46:18
 * @author chenriji
 */
package mortal.game.view.common.tooltip
{
	import Message.DB.Tables.TCareer;
	import Message.DB.Tables.TItem;
	import Message.Public.EColor;
	
	import com.gengine.utils.HTMLUtil;
	
	import mortal.common.global.ParamsConst;
	import mortal.common.global.ProxyType;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.info.item.ItemData;
	import mortal.game.resource.info.item.ItemInfo;

	public class ToolTipUtil
	{
		public function ToolTipUtil()
		{
		}
		
		/**
		 *获取物品说明字符串 
		 * @return 
		 * 
		 */		
		public static function getItemDescText(itemData:ItemData):String
		{
			if(itemData == null || itemData.itemInfo == null)
			{
				return "";
			}
			var itemInfo:ItemInfo = itemData.itemInfo;
			var rtnStr:String = "";
			if(itemInfo)
			{
				var desc:String = "";
				//若描述里配的是数字，则从VIP配置表里取
				var descIndex:int = int(itemInfo.descStr);
				if(descIndex > 0)
				{
					desc = "VipDescConfig";///VipDescConfig.instance.getVipFullDescByType(descIndex);
				}
				else
				{
//					if(ItemsUtil.isIllustrate(itemData))
//					{
//						var descArr:Array = itemInfo.descStr.split("$");
//						if(descArr && descArr[0])
//						{
//							desc = descArr[0];
//						}
//					}
//					else
					{
						desc = itemInfo.descStr;
					}
				}
				if(desc != "" && desc != "0")
				{
//					desc = ItemsUtil.getGiftBagDes(itemInfo.code, desc);
					rtnStr = "<textFormat leading='5'>"+HTMLUtil.addColor(desc,"#ffffff")+"</textFormat>";
				}
			}
			
			if(ParamsConst.instance.proxyType == ProxyType.TW 
				&& ParamsConst.instance.gameName != null)
			{
				if(rtnStr.indexOf( ParamsConst.instance.gameName) >= 0)
				{
					var pattern1:RegExp = new RegExp(ParamsConst.instance.gameName, "g");
					rtnStr = rtnStr.replace(pattern1, "");
				}
			}
			
			return rtnStr;
		}
		
		/**
		 *获取需求职业名称
		 * @return
		 *
		 */
		public static function getNeedCareerName(tItem:TItem):String
		{
			var needCareer:String=getCareerName(tItem);
			if(needCareer != "")
			{
				var needColor:String="#ff87dc";
				if (tItem)
				{
//					if (!CareerUtil.isCareerSuit(tItem.career,Cache.instance.role.roleInfo.career))
//					{ //职业不符合
//						needColor="#ff0000";
//					}
				}
				needCareer=HTMLUtil.addColor(needCareer, needColor);
			}
			return needCareer;
		}
		
		/**
		 *获取武器所属职业名称
		 * @return
		 *
		 */
		public static function getCareerName(tItem:TItem):String
		{
			var careerName:String="";
			var tCareer:TCareer=null;
			if (tItem)
			{
				if (tItem.career != 0)
				{ 
					//==0为职业不限
//					tCareer = CareerConfig.instance.getInfoByCode(tItem.career);
//					if (tCareer)
//					{
//						careerName=tCareer.name;
//					}
				}
			}
			return careerName;
		}
		
		public static function getBgNameByColor(color:int):String
		{
			switch(color)
			{
				case EColor._EColorWhite:
					return ImagesConst.ToolTipBgBai;
					break;
				case EColor._EColorGreen:
					return ImagesConst.ToolTipBgLv;
					break;
				case EColor._EColorBlue:
					return ImagesConst.ToolTipBgLan;
					break;
				case EColor._EColorPurple:
					return ImagesConst.ToolTipBgZi;
					break;
				case EColor._EColorOrange:
					return ImagesConst.ToolTipBgCheng;
					break;
				case EColor._EColorGold:
					return ImagesConst.ToolTipBgHong;
					break;
			}
			return ImagesConst.ToolTipBg;
		}
	}
}
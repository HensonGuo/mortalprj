/**
 * 2014-1-15
 * @author chenriji
 **/
package mortal.game.view.mainUI.shortcutbar
{
	import Message.DB.Tables.TSkill;
	
	import mortal.game.cache.Cache;
	import mortal.game.resource.info.item.ItemData;
	import mortal.game.resource.tableConfig.SkillConfig;
	import mortal.game.view.common.cd.CDDataType;
	import mortal.game.view.pack.data.PackItemData;
	import mortal.game.view.skill.SkillInfo;

	public class ShortcutBarUtil
	{
		public function ShortcutBarUtil()
		{
		}
		
		/**
		 * 根据source返回对应的快捷栏保存类型  
		 * @param source
		 * @return 参考CDDataType中的枚举
		 * 
		 */		
		public static function parseType(source:Object):int
		{
			return CDDataType.parseType(source);
		}
		
		/**
		 * 根据source返回应该保存的值， 这个值以后通过函数getSource找回source， 用以直接赋值ShortcutBarItem.dragSource
		 * @param source
		 * @return 
		 * 
		 */		
		public static function parseValue(source:Object):*
		{
			if(source is SkillInfo)
			{
				return SkillInfo(source).tSkill.series;
			}
			if(source is TSkill)
			{
				return TSkill(source).series;
			}
			if(source is ItemData)
			{
				return ItemData(source).itemInfo.code;
			}
			if(source is PackItemData)
			{
				return PackItemData(source).itemInfo.code;
			}
		}
		
		public static function getSource(obj:Object, pos:int):*
		{
			var type:int = int(obj["t"]);
			var value:int = obj["v"];
			var res:Object;
			switch(type)
			{
				case CDDataType.skillInfo:
					if(value >= 10000 && value < 99999)
					{
						res = Cache.instance.skill.getSkillBySerialId(value); // 新的保存serialID
					}
					else
					{
//						res = Cache.instance.skill.getSkill(value); // 以前的保存SkillId
						res = SkillConfig.instance.getInfoByName(value);
						if(res == null)
						{
							return null;
						}
						Cache.instance.shortcut.addShortCut(pos, type, TSkill(res).series);
						Cache.instance.shortcut.save();
					}
					break;
				case CDDataType.itemData:
					res = new ItemData(int(value));
					break;
			}
			return res;
		}
	}
}
/**
 * 2014-1-11
 * @author chenriji
 **/
package mortal.game.view.common.cd
{
	import mortal.game.resource.info.item.ItemData;
	import mortal.game.view.common.button.TimeButton;
	import mortal.game.view.pack.data.PackItemData;
	import mortal.game.view.skill.SkillInfo;

	/**
	 * CDData的大类， 例如：技能类、 物品类、按钮倒计时类
	 * @author hdkiller
	 * 
	 */	
	public class CDDataType
	{
		public function CDDataType()
		{
		}
		
		public static const skillInfo:int = 1;
		public static const itemData:int = 2;
		public static const timeButton:int = 3;
		
		public static const backPackLock:int = 4;
		public static const publicCD:int = 5; 
		
		public static function parseType(source:Object):int
		{
			if(source is SkillInfo)
			{
				return CDDataType.skillInfo;
			}
			if(source is ItemData)
			{
				return CDDataType.itemData;
			}
			if(source is PackItemData)
			{
				return CDDataType.backPackLock;
			}
			return CDDataType.timeButton;
		}
		
	}
}
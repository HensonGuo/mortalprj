/**
 * @heartspeak
 * 2014-3-4 
 */   	

package mortal.game.utils
{
	import Message.Game.SPet;
	
	import com.gengine.utils.HTMLUtil;
	
	import mortal.common.global.GlobalStyle;
	import mortal.game.resource.ColorConfig;
	import mortal.game.resource.info.ColorInfo;

	public class PetUtil
	{
		public function PetUtil()
		{
		}
		
		/**
		 * 获取一个成长对应的成长等级
		 * @param value
		 * @return 
		 * 
		 */		
		public static function getGrowLevel(value:int):int
		{
			if(value >= 40)
			{
				return 4;
			}
			else if(value >= 32)
			{
				return 3;
			}
			else if(value >= 24)
			{
				return 2;
			}
			else if(value >= 16)
			{
				return 1;
			}
			return 0;
		}
		
		/**
		 * 获取资质颜色 
		 * @return 
		 * 
		 */		
		public static function getTalentColor(talent:int):ColorInfo
		{
			var color:String;
			if(talent < 600)
			{
				color = ColorConfig.instance.getItemColorString(1);
			}
			else if(talent < 800)
			{
				color = ColorConfig.instance.getItemColorString(2);
			}
			else if(talent < 1200)
			{
				color = ColorConfig.instance.getItemColorString(3);
			}
			else if(talent < 1600)
			{
				color = ColorConfig.instance.getItemColorString(4);
			}
			else
			{
				color = ColorConfig.instance.getItemColorString(5);
			}
			var colorInfo:ColorInfo = new ColorInfo();
			colorInfo.color = color;
			return colorInfo;
		}
		
		/**
		 * 获取宠物名字html 
		 * @return 
		 * 
		 */
		public static function getNameHtmlText(pet:SPet):String
		{
			return HTMLUtil.addColor(pet.publicPet.name,getTalentColor(pet.publicPet.talent).color);
		}
		
		/**
		 * 是否是好宠物 
		 * @param pet
		 * @return 
		 * 
		 */		
		public static function isGoodPet(pet:SPet):Boolean
		{
			return pet.publicPet.level >=50 || pet.publicPet.talent >= 800;
		}
		
		/**
		 * 是否是天赋技能 
		 * @param skillID
		 */		
		public static function isTalentSkill(skillID:int):Boolean
		{
			var str:String = skillID.toString();
			var subStr:String = str.substr(0, 2);
			return subStr == "30"
		}
		
	}
}
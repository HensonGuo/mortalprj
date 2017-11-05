/**
 * @heartspeak
 * 2014-4-14 
 */   	

package mortal.game.utils
{
	import Message.BroadCast.SEntityIdInfo;
	import Message.BroadCast.SEntityInfo;
	
	import com.gengine.utils.HTMLUtil;
	
	import mortal.game.resource.GameDefConfig;
	import mortal.game.resource.info.DefInfo;
	import mortal.game.scene3D.player.info.EntityInfo;

	public class NameUtil
	{
		public static const Spacer:String = "<font size='15' color='#FFFFFF'>·</font>";
		
		public function NameUtil()
		{
		}
		
		/**
		 * 通过entityInfo获取一个Html的名字 
		 * @param entityInfo
		 * @param name
		 * @return 
		 * 
		 */		
		public static function getName(entityInfo:EntityInfo,name:String):String
		{
			return getHtmlCamp(entityInfo) + getNameHtmlByRelation(entityInfo.entityInfo,name);
		}
		
		/**
		 * 获取一个 名字  (和阵营颜色一致) 
		 * @param camp
		 * @param name
		 * @return 
		 */
		public static function getNameByCamp(camp:int,name:String):String
		{
			return HTMLUtil.addColor(name,GameDefConfig.instance.getECamp(camp).text1);
		}
		
		/**
		 * 获取宠物的名字 
		 * @param entityInfo
		 * @param name
		 * @return 
		 * 
		 */		
		public static function getPetName(entityInfo:EntityInfo,name:String):String
		{
			return getHtmlCamp(entityInfo) + getPetNameHtmlByRelation(entityInfo.entityInfo,name);
		}
		
		/**
		 * 获取宠物名字的Html 通过敌我关系判断
		 * @param entityInfo
		 * @return 
		 * 
		 */	
		public static function getPetNameHtmlByRelation(info:SEntityInfo,name:String):String
		{
			var friendLevel:int = EntityRelationUtil.getFriendlyLevel(info);
			if(friendLevel == EntityRelationUtil.FIREND)
			{
				return HTMLUtil.addColor(name,PetUtil.getTalentColor(info.talent).color)
			}
			else
			{
				return getNameHtmlByRelation(info,name);
			}
		}
		
		/**
		 * 获取名字的Html 通过敌我关系判断
		 * @param entityInfo
		 * @return 
		 * 
		 */		
		public static function getNameHtmlByRelation(info:SEntityInfo,name:String):String
		{
			var color:String = "#FFFFFF";
			switch(EntityRelationUtil.getFriendlyLevel(info))
			{
				case EntityRelationUtil.FIREND:
					color = "#FFFFFF";
					break;
				case EntityRelationUtil.NEUTRAL:
					color = "#FFFF00";
					break;
				case EntityRelationUtil.ENEMY:
					color = "#FF0000";
					break;
			}
			return HTMLUtil.addColor(name,color);
		}
		
		/**
		 * 获取阵营的html 
		 * @param entityInfo
		 * @return 
		 * 
		 */
		public static function getHtmlCamp(entityInfo:EntityInfo):String
		{
			var info:DefInfo;
			var camp:int = entityInfo.entityInfo.camp;
			
			if( camp > 0 && camp <=3 )
			{
				return GameDefConfig.instance.getCampHtml(camp) + NameUtil.Spacer;
			}
			return "";
		}
	}
}
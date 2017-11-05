/**
 * 2014-1-11
 * @author chenriji
 **/
package mortal.game.cache
{
	import Message.DB.Tables.TItem;
	import Message.DB.Tables.TSkill;
	
	import flash.utils.Dictionary;
	
	import mortal.game.resource.info.item.ItemData;
	import mortal.game.resource.info.item.ItemInfo;
	import mortal.game.view.common.cd.CDData;
	import mortal.game.view.common.cd.CDDataPublicCD;
	import mortal.game.view.common.cd.CDDataType;
	import mortal.game.view.common.cd.ICDData;
	import mortal.game.view.common.item.CDItem;
	import mortal.game.view.skill.SkillInfo;

	public class CDCache
	{
		public const CHAT:String = "chat";
		public const PET_REBACk:String = "PET_REBACk";//宠物回收
		private var _cdDatas:Dictionary = new Dictionary();
		public var publicCD:CDDataPublicCD = new CDDataPublicCD();
		public var somersaultCd:CDData = new CDData();
		
		public function CDCache()
		{
		}
		
		/**
		 * 根据数据源获取CDData 
		 * @param source 
		 * @param cdDataType CDDataType的枚举
		 * @return 
		 * 
		 */				
		public function getCDData(source:Object, cdDataType:int=-1):ICDData
		{
			if(cdDataType == -1)
			{
				cdDataType = CDDataType.parseType(source);
			}
			var dic:Dictionary = _cdDatas[cdDataType] as Dictionary;
			if(dic == null)
			{
				return null;
			}
			var key:String;
			var res:ICDData;
			
			switch(cdDataType)
			{
				case CDDataType.skillInfo:
					key = getKey(source);
					break;
				case CDDataType.itemData:
					var item:ItemData = source as ItemData;
					key = getKey(item.itemInfo);
					break;
				case CDDataType.timeButton:
					key = String(source);
				case CDDataType.backPackLock:
					key = String(source);
			}
			return dic[key] as ICDData;
		}
		
		public function getCDDataByKeyType(cdDataType:int, key:String):ICDData
		{
			var dic:Dictionary = _cdDatas[cdDataType];
			if(dic == null)
			{
				return null;
			}
			return dic[key] as ICDData;
		}
		
		public static function getKey(data:Object):String
		{
			if(data is TItem || data is ItemInfo)
			{
				return data["category"].toString() + "_" + data["type"].toString() + "_" + data["effect"].toString();
			}
			if(data is TSkill || data is SkillInfo)
			{
				return data["skillId"].toString();
			}
			return "";
		}
		
		/**
		 * 注册新的CDData， 也带有获取的功能（假如已经有了CDData） 
		 * @param cdDataType
		 * @param key
		 * @param data
		 * @return 
		 * 
		 */		
		public function registerCDData(cdDataType:int, key:String, data:ICDData=null):ICDData
		{
			var dic:Dictionary = _cdDatas[cdDataType];
			if(dic == null)
			{
				dic = new Dictionary();
				_cdDatas[cdDataType] = dic;
			}
			if(dic[key] != null)
			{
				return dic[key];
			}
			if(data == null)
			{
				data = createCDData(cdDataType)
			}
			dic[key] = data; 
			return data;
		}
		
		public function unregisterCDData(cdDataType:int, key:String):void
		{
			var dic:Dictionary = _cdDatas[cdDataType];
			if(dic == null)
			{
				return;
			}
			var cdData:ICDData = dic[key] as ICDData;
			if(cdData == null)
			{
				return;
			}
			cdData.stopCoolDown();
			cdData = null;
			delete dic[key];
		}
		
		
		private function createCDData(cdDataType:int):ICDData
		{
			var res:ICDData;
			switch(cdDataType)
			{
				case CDDataType.itemData:
					res = new CDData();
					break;
				case CDDataType.skillInfo:
					res = new CDData();
					break;
				case CDDataType.publicCD:
					res = new CDDataPublicCD();
					break;
				default:
					res = new CDData();
					break;
			}
			return res;
		}
		
	}
}
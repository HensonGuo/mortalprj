package mortal.game.resource
{
	import com.gengine.debug.ThrowError;
	import com.gengine.resource.ConfigManager;
	import com.gengine.ui.timer.GameClock;
	
	import flash.utils.Dictionary;
	
	import mortal.component.gconst.GameConst;
	import mortal.component.gconst.PetConst;
	import mortal.component.gconst.UpdateCode;
	import mortal.game.cache.Cache;

	public class ConstConfig
	{
		
		private static var _instance:ConstConfig;
		
		private var _map:Dictionary = new Dictionary();
		
		private var _updateMap:Dictionary = new Dictionary();
		private var _updateCodeKeyMap:Dictionary = new Dictionary();
		
		public function ConstConfig()
		{
			if( _instance != null )
			{
				throw new Error(" ResConfig 单例 ");
			}
			init();
		}
		
		public static function get instance():ConstConfig
		{
			if( _instance == null )
			{
				_instance = new ConstConfig();
			}
			return _instance;
		}
		
		/**
		 *  
		 * @param object
		 * @return 
		 * 
		 */		
		private function write( dic:Object ):void
		{
			//var info:TConst;
			for each( var o:Object in dic  )
			{
				//info = new TConst();
				//ObjectParser.putObject(o,info);
				_map[ o.constName ] = o;
			}
		}
		
		private function writeUpdate( dic:Object ):void
		{
			for each( var o:Object in dic  )
			{
				//info = new TConst();
				//ObjectParser.putObject(o,info);
				_updateMap[ o.updateName ] = o;
				_updateCodeKeyMap[ o.updateCode ] = o;
			}
		}
		
		public function init():void
		{
			var object:Object =  ConfigManager.instance.getJSONByFileName("t_const.json");
			write( object );
			
			GameConst.somersaultDistance = getValueByName("somersaultDistance");//翻滚距离
			GameConst.somersaultCd = getValueByName("somersaultCd");//翻滚Cd
			Cache.instance.cd.somersaultCd.totalTime = GameConst.somersaultCd * 1000;
			
			GameConst.PetSummonSkill = getValueByName("TConstPetSummonSkill");//出战宠物技能
			GameConst.PlayerMaxLevel = getValueByName("TConstGatePlayerMaxLevel");//玩家最高等级
			
			//市场相关
			GameConst.MarketBroadcastCost = getValueByName("MarketBroadcastCost");//市场广播消费
			GameConst.MarketMinFee = getValueByName("MarketMinFee");//市场最低手续费
			
			object =  ConfigManager.instance.getJSONByFileName("t_update_code.json");
			writeUpdate( object );
			
			
			UpdateCode.EUpdateCodeNULL = getCodeByName("EUpdateCodeNULL"); //未知类型,
			UpdateCode.EUpdateCodeTest = getCodeByName("EUpdateCodeTest"); //测试,
			UpdateCode.EUpdateCodeBossDrop = getCodeByName("EUpdateCodeBossDrop"); //Boss掉落,
			
			//背包物品相关
			UpdateCode.EUpdateCodeLoginPushBag = getCodeByName("EUpdateCodeLoginPushBag"); //登陆推送背包
			UpdateCode.EUpdateCodeBagTidy = getCodeByName("EUpdateCodeBagTidy"); // 整理背包物品更新
			UpdateCode.EUpdateCodeBagUseDrug = getCodeByName("EUpdateCodeBagUseDrug"); //背包药品使用
			UpdateCode.EUpdateCodeBagClientGet = getCodeByName("EUpdateCodeBagClientGet");  //客户端获取背包
			UpdateCode.EUpdateCodeBagUseItem = getCodeByName("EUpdateCodeBagUseItem");// 背包物品使用
			UpdateCode.EUpdateCodeBagDestroyItem = getCodeByName("EUpdateCodeBagDestroyItem"); // 背包摧毁物品
			UpdateCode.EUpdateCodeSellItemToSystem = getCodeByName("EUpdateCodeSellItemToSystem"); // 出售物品给系统
			UpdateCode.EUpdateCodeBagSplit = getCodeByName("EUpdateCodeBagSplit");// 背包物品拆分
			UpdateCode.EUpdateCodeUseDrugBag = getCodeByName("EUpdateCodeUseDrugBag"); //玩家使用血池
			UpdateCode.EUpdateCodeShopBuyItem = getCodeByName("EUpdateCodeShopBuyItem"); // 商店购买物品
			UpdateCode.EUpdateCodeDress = getCodeByName("EUpdateCodeDress"); // 商店购买物品
			UpdateCode.EUpdateCodeBagMove = getCodeByName("EUpdateCodeBagMove"); // 背包移动物品
			UpdateCode.EUpdateCodeMount777 = getCodeByName("EUpdateCodeMount777"); //  坐骑777提升
			
			//宠物技能相关
			PetConst.TALENT_SKILL_START_POS = getValueByName("PetSkillPosRangeGift");
			PetConst.TALENT_SKILL_END_POS = getValueExByName("PetSkillPosRangeGift");
			PetConst.PASSIVE_SKILL_START_POS = getValueByName("PetSkillPosRange");
			PetConst.PASSIVE_SKILL_END_POS = getValueExByName("PetSkillPosRange");
			PetConst.OPEN_SKILL_POS_5_REQUIRE_GROWTH = getValueByName("PetSkillPos5");
			PetConst.OPEN_SKILL_POS_6_REQUIRE_GROWTH = getValueByName("PetSkillPos6");
			PetConst.OPEN_SKILL_POS_7_REQUIRE_BLOODS_REACH_TOP = getValueByName("PetSkillPos7");
			PetConst.OPEN_SKILL_POS_8_REQUIRE_BLOODS_REACH_TOP = getValueByName("PetSkillPos8");
		}
		
		
		
		/**
		 * 获取文件资源信息
		 * @param value
		 * @return 
		 * 
		 */		
		public function getObjectByName( name:String ):Object
		{
			return _map[name];
		}
		
		public function getValueByName( name:String ):int
		{
			var o:Object = _map[name];
			if( o )
			{
				return o.constValue;
			}
			ThrowError.show("constConfig: "+name+" 不存在");
			return 0;
		}
		
		public function getValueExByName( name:String ):int
		{
			var o:Object = _map[name];
			if( o )
			{
				return o.constValueEx;
			}
			ThrowError.show("constConfig: "+name+" 不存在");
			return 0;
		}
		
		public function getCodeByName( name:String ):int
		{
			try
			{
				var o:Object = _updateMap[name];
				return o.updateCode;
			}
			catch(e:Error)
			{
				throw new Error("错误:"+name);
			}
			return 0;
		}
		
		public function getOutUpdateStrByCode( code:int ):String
		{
			try
			{
				var o:Object = _updateCodeKeyMap[code];
				if(o.outUpdateStr)
				{
					return o.outUpdateStr;
				}
				else
				{
					return "";
				}
			}
			catch(e:Error)
			{
				return "";
			}
			return "";
		}
	}
}

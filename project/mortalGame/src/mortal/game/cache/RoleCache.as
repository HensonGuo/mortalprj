/**
 * @date	2011-3-1 下午08:09:35
 * @author  jianglang
 * 
 */	

package mortal.game.cache
{
	import Message.BroadCast.SEntityInfo;
	import Message.Game.SDrugBagInfo;
	import Message.Game.SMoney;
	import Message.Game.SPlayer;
	import Message.Game.SRole;
	import Message.Public.EPrictUnit;
	import Message.Public.SEntityId;
	import Message.Public.SFightAttribute;
	
	import flash.utils.Dictionary;
	
	import mortal.game.scene3D.player.info.EntityInfo;
	
	public class RoleCache
	{
		
		public var attackSpeed:int = 500;
		
		private var _roleInfo:SRole; //角色基本属性
		private var _playerInfo:SPlayer;//玩家基本信息
		private var _money:SMoney;//钱包
		
		private var _fightAttribute:SFightAttribute;//最终战斗属性
		private var _fightAttributeBase:SFightAttribute;//基础战斗属性
		
		private var _roleEntityInfo:EntityInfo;
		private var _entityInfo:SEntityInfo;
		
		//药包
		private var _lifeDrugBagInfo:SDrugBagInfo;
		private var _manaDrugBagInfo:SDrugBagInfo;
		
		public function RoleCache()
		{
			_roleEntityInfo = new EntityInfo();
			_entityInfo = _roleEntityInfo.entityInfo;
		}
		
		public function get manaDrugBagInfo():SDrugBagInfo
		{
			return _manaDrugBagInfo;
		}
		
		public function set manaDrugBagInfo(value:SDrugBagInfo):void
		{
			_manaDrugBagInfo = value;
		}
		
		public function get lifeDrugBagInfo():SDrugBagInfo
		{
			return _lifeDrugBagInfo;
		}
		
		public function set lifeDrugBagInfo(value:SDrugBagInfo):void
		{
			_lifeDrugBagInfo = value;
		}
		
		public function get fightAttributeBase():SFightAttribute
		{
			return _fightAttributeBase;
		}
		
		public function set fightAttributeBase(value:SFightAttribute):void
		{
			_fightAttributeBase = value;
		}
		
		public function get fightAttribute():SFightAttribute
		{
			return _fightAttribute;
		}
		
		public function set fightAttribute(value:SFightAttribute):void
		{
			_fightAttribute = value;
		}
		
		public function get money():SMoney
		{
			return _money;
		}

		public function set money(value:SMoney):void
		{
			_money = value;
		}
		
		public function enoughMoney(moneyType:int, value:int, callback:Function = null):Boolean
		{
			var left:int = 0;
			switch(moneyType)
			{
				case EPrictUnit._EPriceUnitCoin:
					left = money.coin - value;
					break;
				case EPrictUnit._EPriceUnitCoinBind:
					left = money.coinBind + money.coin - value;
					break;
				case EPrictUnit._EPriceUnitGold:
					left = money.gold - value;
					break;
				case EPrictUnit._EPriceUnitGoldBind:
					left = money.goldBind + money.gold - value;
					break;
				case EPrictUnit._EPriceUnitVitalEnergy:
					left = money.vitalEnergy - value;
					break;
				case EPrictUnit._EPriceUnitRunicPower:
					left = money.runicPower - value;
					break;
				case EPrictUnit._EPriceUnitFightEnergy:
					break;
			}
			if (left < 0)
			{
				if (callback != null)
				{
					callback.call(null, Math.abs(left));
				}
			}
			return left >= 0;
		}

		public function get playerInfo():SPlayer
		{
			return _playerInfo;
		}
		
		/**
		 * 登陆初始化自己实体信息 
		 * @param value
		 * 
		 */		
		public function set playerInfo(value:SPlayer):void
		{
			_playerInfo = value;
			_entityInfo.camp = _playerInfo.camp;
			_entityInfo.sex = _playerInfo.sex;
			_entityInfo.name = _playerInfo.name;
			_entityInfo.fightMode = _playerInfo.mode;
		}
		
		public function get roleInfo():SRole
		{
			return _roleInfo;
		}
		
		/**
		 * 登陆初始化自己实体信息 
		 * @param value
		 * 
		 */
		public function set roleInfo(value:SRole):void
		{
			_roleInfo = value;
			_entityInfo.career = _roleInfo.career;
			_entityInfo.life = _roleInfo.life;
			_entityInfo.level = _roleInfo.level;
			_entityInfo.mana = _roleInfo.mana;
		}
		
		public function set entityInfo(value:SEntityInfo):void
		{
			_entityInfo = value;
		}
		
		public function get entityInfo():SEntityInfo
		{
			return _entityInfo;
		}
		
		public function get roleEntityInfo():EntityInfo
		{
			return _roleEntityInfo;
		}
		
	}
}

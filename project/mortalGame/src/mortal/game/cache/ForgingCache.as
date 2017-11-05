package mortal.game.cache
{
	import Message.Public.SPlayerItem;
	
	import flash.utils.Dictionary;
	
	import mortal.game.manager.window3d.Rect3DObject;
	import mortal.game.resource.tableConfig.EquipStrengthenConfig;
	import mortal.game.view.palyer.PlayerEquipItem;

	/**
	 * @date   2014-3-18 下午9:17:10
	 * @author dengwj
	 */	 
	public class ForgingCache
	{
		
		/** 每一件装备强化信息的缓存 */	
		private var _strengthenInfoDic:Dictionary = new Dictionary();
		/** 前四件强化装备uid集合 */
		private var _firstFourStrengthenData:Array = [];
		/** 每个强化等级对应的属性加成百分比  */
		private var _strengPropAddPercent:Dictionary = new Dictionary();
		/** 当前强化属性值 */
		private var _currStrengValueArr:Array = [];
		/** 宝石镶嵌回调信息缓存 */
		private var _embedCallBackData:Object;
		
		public function ForgingCache()
		{
			
		}
		
		/**
		 * 判断是否是前四次强化
		 * @param uid 装备uid
		 * @return 
		 */		
		public function isTheFirstFourStrengthen(uid:String):Boolean
		{
			for each(var id:String in this._firstFourStrengthenData)
			{
				if(uid == id)
				{
					return true;
				}
			}
			return false;
		}
		
		/**
		 * 更新前四次强化数据 
		 */		
		public function updateFirstFourStrengthenData(uids:Array):void
		{
			this._firstFourStrengthenData = uids;
		}
		
		/**
		 * 根据装备uid得装备当前强化等级 
		 * @param uid 装备uid
		 * @return 
		 * 
		 */		
		public function getStrengthenLevelByUid(uid:String):int
		{
			for(var id:String in this._strengthenInfoDic)
			{
				if(uid == id)
				{
					return this._strengthenInfoDic[uid].strengLevel;
				}
			}
			return 0;
		}
		
		/**
		 * 根据uid得强化装备 
		 * @param uid
		 * @return 
		 * 
		 */		
		public function getEquipByUid(uid:String):PlayerEquipItem
		{
			for(var id:String in this._strengthenInfoDic)
			{
				if(uid == id)
				{
					return this._strengthenInfoDic[uid].equip as PlayerEquipItem;
				}
			}
			return null;
		}
		
		/**
		 * 添加一件强化装备 
		 * @param equip 待强化装备
		 */		
		public function addStrengthenEquip(equip:PlayerEquipItem):void
		{
			for(var id:String in this._strengthenInfoDic)
			{
				if(equip.itemData.uid == id)
				{
					return;
				}
			}
			this._strengthenInfoDic[equip.itemData.uid] = equip;
			var obj:Object = {};
			obj.equip = equip;
			obj.currStrengProgress = 0;
			this._strengthenInfoDic[equip.itemData.uid] = obj;
		}
		
		/**
		 * 更新当前强化装备的强化进度 
		 * @param uid
		 * @param progress
		 */		
		public function updateStrengthenProgress(uid:String, progress:int):void
		{
			for(var id:String  in this._strengthenInfoDic)
			{
				if(id == uid)
				{
					this._strengthenInfoDic[id].currStrengProgress = progress;
				}
			}
		}
		
		/**
		 * 获取装备当前强化进度 
		 */		
		public function getCurrStrengProgress(uid:String):int
		{
			for(var id:String  in this._strengthenInfoDic)
			{
				if(id == uid)
				{
					return this._strengthenInfoDic[id].currStrengProgress;
				}
			}
			return 0;
		}
		
		/**
		 * 获取每个强化等级对应的属性加成百分比 
		 * @param strengthenLevel 强化等级
		 */	
		public function getPropAddPercentByLevel(strengthenLevel:int):int
		{
			if(this._strengPropAddPercent[strengthenLevel])
			{
				return this._strengPropAddPercent[strengthenLevel];
			}
			else
			{
				var propAddPercent:int;
				for(var i:int = 1; i <= strengthenLevel; i++)
				{
					var rewardPercent:int = EquipStrengthenConfig.instance.getInfoByLevel(i).rewardPercent;
					propAddPercent += rewardPercent;
				}
				this._strengPropAddPercent[strengthenLevel] = propAddPercent;
				return propAddPercent;
			}
			return 0;
		}
		
		/**
		 * 获取每次强化提升的值 
		 * @param value 当前强化提升至的值
		 * @return 当前强化和前一次强化的差值
		 * 
		 */		
		public function getPerUpValue(value:Array):Array
		{
			var arr:Array = new Array();
			for(var i:int = 0; i < value.length; i++)
			{
				arr.push(value[i] - this._currStrengValueArr[i]);
			}
			this._currStrengValueArr = value;
			return arr;
		}
		
		public function set embedCallBackData(data:Object):void
		{
			this._embedCallBackData = data;
		}
		
		public function get embedCallBackData():Object
		{
			return this._embedCallBackData;
		}
		
		public function get currStrengValue():Array
		{
			return this._currStrengValueArr;
		}
		
		public function set currStrengValue(value:Array):void
		{
			this._currStrengValueArr = value;
		}
	}
}
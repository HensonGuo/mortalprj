package mortal.game.control
{
	import Message.DB.Tables.TEquipStrengthen;
	import Message.DB.Tables.TItemEquip;
	import Message.Game.EOperType;
	import Message.Game.EPriorityType;
	import Message.Game.EStrengthResult;
	import Message.Public.EGroup;
	import Message.Public.EStuff;
	import Message.Public.SPlayerItem;
	
	import com.gengine.utils.HashMap;
	
	import flash.events.Event;
	
	import mortal.component.window.WindowEvent;
	import mortal.game.cache.ForgingCache;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.GameManager;
	import mortal.game.manager.MsgManager;
	import mortal.game.mvc.EventName;
	import mortal.game.mvc.GameController;
	import mortal.game.mvc.GameProxy;
	import mortal.game.mvc.ServerCommand;
	import mortal.game.proxy.EquipProxy;
	import mortal.game.resource.ItemConfig;
	import mortal.game.resource.info.item.ItemData;
	import mortal.game.resource.info.item.ItemEquipInfo;
	import mortal.game.resource.tableConfig.EquipJewelMatchConfig;
	import mortal.game.resource.tableConfig.EquipStrengthenConfig;
	import mortal.game.view.common.item.BaseItem;
	import mortal.game.view.forging.EquipBasePropUtil;
	import mortal.game.view.forging.ForgingModule;
	import mortal.game.view.forging.data.ForgingConst;
	import mortal.game.view.forging.view.EquipRefreshPanel;
	import mortal.game.view.forging.view.GemEmbedPanel;
	import mortal.game.view.forging.view.GemItem;
	import mortal.game.view.forging.view.GemStrengthenPanel;
	import mortal.game.view.palyer.PlayerEquipItem;
	import mortal.game.view.systemSetting.ClientSetting;
	import mortal.game.view.systemSetting.IsDoneType;
	import mortal.mvc.core.Controller;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.core.NetDispatcher;
	import mortal.mvc.interfaces.IView;

	/**
	 * @date   2014-3-18 下午9:12:17
	 * @author dengwj
	 */	
	public class ForgingController extends Controller
	{
		private var _forgingCache:ForgingCache;
		private var _equipProxy:EquipProxy;
		private var _forgingModule:ForgingModule;
		
		public function ForgingController()
		{
			super();
			init();
		}
		
		private function init():void
		{
			_forgingCache = cache.forging;
			_equipProxy = GameProxy.equip;
		}
		
		override protected function initView():IView
		{	
			if(_forgingModule == null)
			{
				_forgingModule = new ForgingModule();
				_forgingModule.addEventListener(WindowEvent.SHOW, onForgingShow);
				_forgingModule.addEventListener(WindowEvent.CLOSE, onForgingClose);
			}
			return _forgingModule;
		}
		
		override protected function initServer():void
		{
			NetDispatcher.addCmdListener(ServerCommand.FirstFourStrengthenInfo, StrengthenValidateHandler);// 强化验证
			Dispatcher.addEventListener(EventName.GetOffEquip, unloadEquipHandler); 
		}
		
		private function onForgingShow(e:Event):void
		{
			updateCombat();
			
			NetDispatcher.addCmdListener(ServerCommand.StrengthenInfoUpdate,StrengthenInfoUpdateHandler);// 强化信息更新
			NetDispatcher.addCmdListener(ServerCommand.UpdateStrengthenEquip,updateEquipByType);// 更新角色装备
			NetDispatcher.addCmdListener(ServerCommand.EmbedInfoUpdate,embedInfoUpdateHandler);// 镶嵌信息更新
			NetDispatcher.addCmdListener(ServerCommand.GemUpgradeInfoUpdate,gemUpgradeHandler);// 宝石升级信息更新
			NetDispatcher.addCmdListener(ServerCommand.BackPackGemUpdate, packGemUpdateHandler);// 宝石包更新
			NetDispatcher.addCmdListener(ServerCommand.RefreshInfoUpdate, refreshInfoUpdateHandler);// 洗练信息更新
			NetDispatcher.addCmdListener(ServerCommand.BackPackItemAdd, backPackGemUpdateHandler);// 背包中添加宝石
			NetDispatcher.addCmdListener(ServerCommand.BackPackItemDel, backPackGemUpdateHandler);// 背包中销毁宝石
			
			Dispatcher.addEventListener(EventName.AddEquipStrengthen, addEquipHandler);// 添加强化装备
			Dispatcher.addEventListener(EventName.EquipStrengthen, equipStrengthenHandler);// 装备强化
			Dispatcher.addEventListener(EventName.AddEquipEmbedGem, addEquipEmbedGemHandler);// 添加装备宝石
			Dispatcher.addEventListener(EventName.EmbeGem, embedGemHandler);// 镶嵌宝石
			Dispatcher.addEventListener(EventName.RemoveGem, removeGemHandler);// 摘除宝石
			Dispatcher.addEventListener(EventName.UpgradeGem, upgradeGemHandler);// 宝石升级
			Dispatcher.addEventListener(EventName.GemPage, gemPageHandler);// 宝石镶嵌面板翻页
			Dispatcher.addEventListener(EventName.AddEquipRefresh, addRefreshEquip);// 添加待洗练的装备
			Dispatcher.addEventListener(EventName.EquipRefresh, equipRefresh);// 装备洗练
		}
		
		private function onForgingClose(e:Event):void
		{
			NetDispatcher.removeCmdListener(ServerCommand.StrengthenInfoUpdate,StrengthenInfoUpdateHandler);
			NetDispatcher.removeCmdListener(ServerCommand.UpdateStrengthenEquip,updateEquipByType);
			NetDispatcher.removeCmdListener(ServerCommand.EmbedInfoUpdate,embedInfoUpdateHandler);
			NetDispatcher.removeCmdListener(ServerCommand.GemUpgradeInfoUpdate,gemUpgradeHandler);
			NetDispatcher.removeCmdListener(ServerCommand.BackPackGemUpdate, packGemUpdateHandler);
			NetDispatcher.removeCmdListener(ServerCommand.RefreshInfoUpdate, refreshInfoUpdateHandler);
			NetDispatcher.removeCmdListener(ServerCommand.BackPackItemAdd, backPackGemUpdateHandler);
			NetDispatcher.removeCmdListener(ServerCommand.BackPackItemDel, backPackGemUpdateHandler);
			
			Dispatcher.removeEventListener(EventName.AddEquipStrengthen, addEquipHandler);
			Dispatcher.removeEventListener(EventName.EquipStrengthen, equipStrengthenHandler);
			Dispatcher.removeEventListener(EventName.AddEquipEmbedGem, addEquipEmbedGemHandler);
			Dispatcher.removeEventListener(EventName.EmbeGem, embedGemHandler);
			Dispatcher.removeEventListener(EventName.RemoveGem, removeGemHandler);
			Dispatcher.removeEventListener(EventName.UpgradeGem, upgradeGemHandler);
			Dispatcher.removeEventListener(EventName.GemPage, gemPageHandler);
			Dispatcher.removeEventListener(EventName.AddEquipRefresh, addRefreshEquip);
			Dispatcher.removeEventListener(EventName.EquipRefresh, equipRefresh);
		}
		
		/**
		 * 添加待强化的装备 
		 * @param e
		 */		
		private function addEquipHandler(e:DataEvent):void
		{
			var equip:PlayerEquipItem = e.data as PlayerEquipItem;
			if(equip && equip.itemData)
			{
				var currStrengthenLevel:int    = equip.itemData.extInfo.strengthen;
				var currStrengthenProgress:int = equip.itemData.extInfo.currentStrengthen;
				
				if(currStrengthenLevel == ForgingConst.MaxStrengLevel)
				{
					this._forgingModule.strengthenPanel.canBeStrengthened = false;
				}
				else
				{
					this._forgingModule.strengthenPanel.canBeStrengthened = true;
				}
				
				//添加到缓存
				if(cache.forging.getEquipByUid(equip.itemData.uid) == null)
				{
					cache.forging.addStrengthenEquip(equip);
				}
				
				//TODO=====================添加极品属性
				this._forgingModule.strengthenPanel.addStrengEquip(equip);
				
				var itemCode:int = equip.itemData.serverData.itemCode;
				var itemEquip:ItemEquipInfo = ItemConfig.instance.getConfig(itemCode) as ItemEquipInfo;
				var propArr:Array = getStrengInfo(equip.itemData,itemEquip);
				this._forgingModule.strengthenPanel.updateEquipProp(propArr);
				this._forgingModule.strengthenPanel.updateProgressBar(currStrengthenProgress, ForgingConst.TotalStrengProgress);
				this._forgingModule.strengthenPanel.updateModel();// 更新装备模型
				cache.forging.currStrengValue = [];
				for each(var item:Object in propArr)
				{
					cache.forging.currStrengValue.push(item.propValue);
				}
				updateStrengthenLevel(currStrengthenLevel);
				updateStrengthenFee(currStrengthenLevel + 1);
				// TODO===================更新装备评分、装备等级
			}
		}
		
		/**
		 * 添加待洗练的装备 
		 * @param e
		 */		
		private function addRefreshEquip(e:DataEvent):void
		{
			var equip:PlayerEquipItem = e.data as PlayerEquipItem;
			(_forgingModule.currentPanel as EquipRefreshPanel).addRefreshEquip(equip);
		}
		
		/**
		 * 装备强化(普通强化、一键强化) 
		 */		
		private function equipStrengthenHandler(e:DataEvent):void
		{
			var strengInfo:Object  = e.data;
			var isAutoBuy:Boolean  = ClientSetting.local.getIsDone(IsDoneType.AutoBuyStrengProp);
			var operType:EOperType = new EOperType(strengInfo.strengType);
			var priority:EPriorityType = new EPriorityType(0);
			GameProxy.equip.strengthen(strengInfo.uid,operType,isAutoBuy,priority);
		}
		
		/**
		 * 装备洗练(普通洗练、批量洗练) 
		 * @param e
		 */		
		private function equipRefresh(e:DataEvent):void
		{
			var args:Object = e.data;
			
			GameProxy.equip.equipRefresh(args.equipUid,args.type,args.autoBuy,args.priority,args.lockDict,args.expectAttr,args.expectAttrAll);
		}
		
		/**
		 * 装备强化信息更新
		 * @param obj
		 */	
		private function StrengthenInfoUpdateHandler(obj:Object):void
		{
			if(obj != null)
			{
				var strengResult:int       = obj.result as int;
				var playerItem:SPlayerItem = obj.resultEquip as SPlayerItem;
				var consumes:Array         = obj.consumes as Array;
				
				var currStrengthenProgress:int;
				var currStrengthenLevel:int;
				var strengthenAmount:int;
				
				cache.pack.packRolePackCache.updateSPlayerItem(playerItem);
				var equipItemData:ItemData = cache.pack.packRolePackCache.getItemDataByUid(playerItem.uid);
				if(equipItemData != null)
				{
					currStrengthenProgress = equipItemData.extInfo.currentStrengthen;
					currStrengthenLevel    = equipItemData.extInfo.strengthen;
					strengthenAmount       = equipItemData.extInfo.strengthenAmount;
				}
				
				displayStrengthenResult(strengResult,currStrengthenLevel);
				
				// 缓存强化进度
				cache.forging.updateStrengthenProgress(playerItem.uid, currStrengthenProgress);
				
				if(strengResult == EStrengthResult._EStrengtheResultFailedAmout || strengResult == EStrengthResult._EStrengthResultSuccess)
				{
					if(equipItemData != null)
					{
						var itemEquipInfo:ItemEquipInfo = ItemConfig.instance.getConfig(equipItemData.itemCode) as ItemEquipInfo;
						var propArr:Array = getStrengInfo(equipItemData,itemEquipInfo);
						var arr:Array = new Array();
						for each(var item:Object in propArr)
						{
							arr.push(item.propValue);
						}
						displayUpValue(cache.forging.getPerUpValue(arr));
						this._forgingModule.strengthenPanel.updateEquipProp(propArr);// 更新显示属性
					}
					updateStrengthenLevel(currStrengthenLevel);
					updateStrengthenFee(currStrengthenLevel + 1);
					if(currStrengthenLevel == ForgingConst.MaxStrengLevel)
					{
						this._forgingModule.strengthenPanel.canBeStrengthened = false;
					}
				}
				
				this._forgingModule.strengthenPanel.updateProgressBar(currStrengthenProgress,ForgingConst.TotalStrengProgress);
				
			}
		}
		
		/**
		 * 装备洗练信息更新 
		 * @param obj
		 */		
		private function refreshInfoUpdateHandler(obj:Object):void
		{
			var resultEquip:SPlayerItem = obj.resultEquip;
			var consumes:Array			= obj.consumes;
			cache.pack.packRolePackCache.updateSPlayerItem(resultEquip);
			(_forgingModule.currentPanel as EquipRefreshPanel).updateRefreshInfo();
		}
		
		/**
		 * 添加装备镶嵌宝石到界面上 
		 * @param e
		 * 
		 */		
		private function addEquipEmbedGemHandler(e:DataEvent):void
		{
			var equip:PlayerEquipItem = e.data as PlayerEquipItem;
			if(equip.itemData)
			{
				updateGemList(equip.itemData);
				this._forgingModule.currentPanel.setGemHoleStatus(equip.itemData.extInfo.hole_num);
				if(this._forgingModule.currSelPage == 1)
				{
					(this._forgingModule.currentPanel as GemStrengthenPanel).clear();
					(this._forgingModule.currentPanel as GemStrengthenPanel).currSelGem = null;
				}
				if(this._forgingModule.currSelPage == 2)
				{
					var equipType:int = equip.itemData.itemInfo.type;
					(this._forgingModule.currentPanel as GemEmbedPanel).pageSelecter.currentPage = 1;
					(this._forgingModule.currentPanel as GemEmbedPanel).clear();
					updateGemInfo(equipType);
				}
				this._forgingModule.currentPanel.update3DModel();
			}
		}
		
		/**
		 * 更新镶嵌面板背包中的宝石信息
		 * @param equipType
		 */		
		private function updateGemInfo(equipType:int = -1):void
		{
			var gemList:Array = getGemsByType(0);
			if(!(equipType < 0))
			{
				gemList.sort(sortOnTypeMatch);				
			}
			else
			{
				gemList.sort(sortOnTypeMatch2);
			}
			(this._forgingModule.currentPanel as GemEmbedPanel).updateGemInfo(gemList);
		}
		
		/**
		 * 按宝石和装备匹配类型排序 
		 */		
		private function sortOnTypeMatch(a:ItemData, b:ItemData):Number
		{
			var currEquip:PlayerEquipItem = this._forgingModule.equipDisplaySpr.currSelEquip;
			if(currEquip && currEquip.itemData)
			{
				var equipType:int = currEquip.itemData.itemInfo.type;
				var jeweltype:int = EquipJewelMatchConfig.instance.getInfoByType(equipType).jeweltype;
			}
			if(a.itemInfo.type == jeweltype && b.itemInfo.type != jeweltype)
			{
				return -1;
			}
			else if(a.itemInfo.type != jeweltype && b.itemInfo.type == jeweltype)
			{
				return 1;
			}
			else
			{
				return 0;
			}
		}
		
		/**
		 * 按宝石是否有匹配装备排序
		 * @param itemData
		 */
		private function sortOnTypeMatch2(a:ItemData, b:ItemData):Number
		{
			var a_typeArr:Array  = EquipJewelMatchConfig.instance.getEquipTypeByJewelType(a.itemInfo.type);
			var b_typeArr:Array  = EquipJewelMatchConfig.instance.getEquipTypeByJewelType(b.itemInfo.type);
			var a_equipArr:Array = [];
			var b_equipArr:Array = [];
			
			for each(var type:int in a_typeArr)
			{
				a_equipArr.push(_forgingModule.equipDisplaySpr.getEquipByType(type));
			}
			for each(type in b_typeArr)
			{
				b_equipArr.push(_forgingModule.equipDisplaySpr.getEquipByType(type));
			}
			
			if(a_equipArr.length > 0 && b_equipArr.length == 0)
			{
				return -1;
			}
			else if(a_equipArr.length == 0 && b_equipArr.length > 0)
			{
				return 1;
			}
			else
			{
				return 0;
			}
			
		}
		
		/**
		 * 更新宝石列表 
		 * @param obj
		 */	
		private function updateGemList(itemData:ItemData):void
		{
			var gemList:Array = new Array();
			for(var i:int = 1; i <= 8; i++)
			{
				var param:String = "h"+i;
				var gemItemData:ItemData = cache.pack.embedPackCache.getItemDataByUid(itemData.extInfo[param]);
				gemList.push(gemItemData);
			}
			this._forgingModule.currentPanel.updateGemList(gemList);
		}
		
		/**
		 * 宝石镶嵌信息更新 
		 * @param data
		 */		
		private function embedInfoUpdateHandler(data:Object):void
		{
			if(data != null)
			{
				var playerItem:SPlayerItem = data.resultEquip;
				cache.pack.packRolePackCache.updateSPlayerItem(playerItem);
				var equipData:ItemData    = cache.pack.packRolePackCache.getItemDataByUid(playerItem.uid);
				var equip:PlayerEquipItem = this._forgingModule.equipDisplaySpr.getEquipById(playerItem.uid);
				if(equip)
				{
					equip.updateEmbedState();
				}
				if(equipData != null)
				{
					var equipType:int = equipData.itemInfo.type;
					var currEmbedGem:GemItem = (this._forgingModule.currentPanel as GemEmbedPanel).currEmbedGem;
					updateGemList(equipData);
					if(data.type == 0)
					{
						(this._forgingModule.currentPanel as GemEmbedPanel).onEmbedSuccHandler();
					}
					else if(data.type == 1)
					{
						(this._forgingModule.currentPanel as GemEmbedPanel).onExciseSuccHandler();
					}
					this._forgingModule.currentPanel.setGemHoleStatus(equipData.extInfo.hole_num);
					updateGemInfo(equipType);//镶嵌背包更新
					
				}
			}
		}
		
		/**
		 * 宝石升级信息更新 
		 * @param data
		 */
		private function gemUpgradeHandler(data:Object):void
		{
			var gemItem:SPlayerItem = data.resultJewel;
			var consumes:Array      = data.consumes;
			cache.pack.embedPackCache.updateSPlayerItem(gemItem);
			var gemItemData:ItemData = cache.pack.embedPackCache.getItemDataByUid(gemItem.uid);
			if(gemItemData != null)
			{
				(this._forgingModule.currentPanel as GemStrengthenPanel).updateGemInfo(gemItemData);
			}
		}
		
		public function packGemUpdateHandler(data:Object):void
		{
//			var equip:PlayerEquipItem = this._forgingModule.equipDisplaySpr.currSelEquip;
//			if(equip && equip.itemData)
//			{
//				updateGemInfo(equip.itemData.itemInfo.type);
//			}
		}
		
		/**
		 * 获取背包中某一类型的所有宝石 
		 * @param type
		 * @return 
		 */		
		private function getGemsByType(type:int):Array
		{
			var gemArr:Array = cache.pack.backPackCache.getGemByType(type);
			return gemArr;
		}
		
		/**
		 * 镶嵌宝石 
		 */		
		private function embedGemHandler(e:DataEvent):void
		{
			var uidArr:Array    = e.data as Array;
			var equipUid:String = this._forgingModule.equipDisplaySpr.currSelEquip.itemData.uid;
			GameProxy.equip.jewelEmbed(equipUid,uidArr);
		}
		
		/**
		 * 摘除宝石 
		 */		
		private function removeGemHandler(e:DataEvent):void
		{
			var uidArr:Array    = e.data as Array;
			var equipUid:String = this._forgingModule.equipDisplaySpr.currSelEquip.itemData.uid;
			GameProxy.equip.jewelRemove(equipUid,uidArr);
		}	
		
		/**
		 * 宝石升级 
		 * @param e
		 */		
		private function upgradeGemHandler(e:DataEvent):void
		{
			var uid:String         = e.data.uid;
			var type:int           = e.data.upgradeType;
			var isAutoBuy:Boolean  = ClientSetting.local.getIsDone(IsDoneType.AutoBuyGemProp);
			var operType:EOperType = new EOperType(type);
			
			GameProxy.equip.jewelUpdate(uid,operType,isAutoBuy);
		}	
		
		/**
		 * 缓存前四件强化装备uid 
		 * @param obj
		 */		
		private function StrengthenValidateHandler(obj:Object):void
		{
			var uids:Array = obj as Array;
			if(uids != null)
			{
				cache.forging.updateFirstFourStrengthenData(uids);
			}
		}
		
		/**
		 * 提示强化结果
		 * @param result 		      结果类型
		 * @param currStrengLevel 当前强化等级(材料不足判断)
		 */		
		private function displayStrengthenResult(result:int, currStrengLevel:int):void
		{
			switch(result)
			{
				case EStrengthResult._EStrengthResultSuccess :// 强化成功
					MsgManager.showRollTipsMsg("强化成功");
					updateStrengthenLevel(currStrengLevel);
					
					// TODO =====================加强化成功特效
					break;
				case EStrengthResult._EStrengthResultFailedMaterial:
					switch(currStrengLevel + 1)
					{
						case 1:
						case 2:
						case 3:
							MsgManager.showRollTipsMsg("初级强化石不够");
							break;
						case 4:
						case 5:
						case 6:
							MsgManager.showRollTipsMsg("中级强化石不够");
							break;
						case 7:
						case 8:
						case 9:
							MsgManager.showRollTipsMsg("高级强化石不够");
							break;
						case 10:
						case 11:
						case 12:
							MsgManager.showRollTipsMsg("顶级强化石不够");
							break;
					}
					break;
				case EStrengthResult._EStrengthResultFailedCoin:
					MsgManager.showRollTipsMsg("铜钱不够");
					break;
				case EStrengthResult._EStrengthResultFailedGold:
					MsgManager.showRollTipsMsg("元宝不够");
					break;
				case EStrengthResult._EStrengtheResultFailedAmout:
					MsgManager.showRollTipsMsg("强化失败,次数不够");
					break;
			}
		}
		
		/**
		 * 更新强化等级 
		 * @return 装备uid
		 * @level  当前强化等级
		 */		
		private function updateStrengthenLevel(level:int):void
		{
			this._forgingModule.strengthenPanel.updateStrengthenLevel(level);
		}
		
		/**
		 * 根据强化等级更新强化提升费用
		 * @param level 当前强化等级 
		 */		
		private function updateStrengthenFee(level:int):void
		{
			var money:int;
			if(level <= ForgingConst.MaxStrengLevel)
			{
				var equip:TEquipStrengthen = getStrengthenInfoByLevel(level);
				money = equip.consumeMoney;
			}
			else
			{
				money = 0;	
			}
			this._forgingModule.strengthenPanel.updateStrengthenFee(money);
		}
		
		/**
		 * 根据强化等级得对应的强化配置信息 
		 * @param level 强化等级
		 */		
		private function getStrengthenInfoByLevel(level:int):TEquipStrengthen
		{
			var equip:TEquipStrengthen = EquipStrengthenConfig.instance.getInfoByLevel(level);
			return equip;
		}
		
		/**
		 * 根据装备强化进度及装备基本属性得强化信息 
		 * @param jsObj 装备当前强化信息
		 * @param equip 装备基本属性信息
		 */		
		private function getStrengInfo(equipItemData:ItemData, equip:ItemEquipInfo):Array
		{
			var currStrengthenProgress:int = equipItemData.extInfo.currentStrengthen;// 当前强化进度
			var currStrengthenLevel:int    = equipItemData.extInfo.strengthen;// 当前强化等级
			var currProgressPercent:Number = currStrengthenProgress / ForgingConst.TotalStrengProgress;// 当前进度百分比
			
			var currRewardPercent:int;// 当前强化等级奖励百分比
			var nextRewardPercent:int;// 下一强化等级奖励百分比
			var propPercent:Number;// 当前总属性百分比(基本属性+强化属性)
			var propNextPercent:Number;// 下级总属性百分比
			
			if(currStrengthenLevel == 0)// 当前强化等级
			{
				currRewardPercent = 0;
				nextRewardPercent = cache.forging.getPropAddPercentByLevel(currStrengthenLevel + 1);
			}
			else if(currStrengthenLevel < ForgingConst.MaxStrengLevel)
			{
				currRewardPercent = cache.forging.getPropAddPercentByLevel(currStrengthenLevel);
				nextRewardPercent = cache.forging.getPropAddPercentByLevel(currStrengthenLevel + 1);
			}
			else
			{
				currRewardPercent = cache.forging.getPropAddPercentByLevel(currStrengthenLevel);
				nextRewardPercent = currRewardPercent;
			}
			propPercent = 1 + currRewardPercent / 100 + (nextRewardPercent - currRewardPercent) / 100 * currProgressPercent;
			propNextPercent = 1 + nextRewardPercent / 100;
			
			var propArr:Array = EquipBasePropUtil.instance.getStrengthenProps(equip,propPercent,propNextPercent);
			return propArr;
		}
		
		/**
		 * 更新角色装备 
		 * @param data
		 * 
		 */		
		private function updateEquipByType(data:int):void
		{
			this._forgingModule.upDateEquipByType(data);
		}
		
		/**
		 * 显示强化时增加的属性 
		 * @param arr
		 * 
		 */		
		private function displayUpValue(arr:Array):void
		{
			this._forgingModule.strengthenPanel.displayUpValue(arr);
		}
		
		/**
		 * 卸下装备 
		 * @param e
		 * 
		 */	
		private function unloadEquipHandler(e:DataEvent):void
		{
			if(this._forgingModule != null)
			{
				var itemData:ItemData = e.data as ItemData;
				var equipItem:PlayerEquipItem = this._forgingModule.strengthenPanel.equipItem;
				if(itemData && equipItem && equipItem.itemData)
				{
					if(itemData.itemCode == equipItem.itemData.itemCode)
					{
						equipItem.setSelEffect(false);
						this._forgingModule.equipDisplaySpr.currSelEquip = null;
						equipItem.itemData = null;
						this._forgingModule.strengthenPanel.clearUI();
						
						if(!GameController.player.isViewShow)// 强化和人物面板都打开时，只能人物面板发请求
						{
							GameProxy.equip.dress(null,itemData.serverData.uid);
						}
					}
				}
			}
		}
		
		/**
		 * 更新战斗力 
		 */		
		public function updateCombat():void
		{
			if(this._forgingModule && this._forgingModule.equipDisplaySpr)
			{
				this._forgingModule.equipDisplaySpr.updateComBat();	
			}
		}
		
		/**
		 * 镶嵌面板中的宝石翻页处理 
		 */		
		public function gemPageHandler(e:DataEvent):void
		{
			var currEquip:PlayerEquipItem = this._forgingModule.equipDisplaySpr.currSelEquip;
			if(currEquip && currEquip.itemData)
			{
				var equipType:int = currEquip.itemData.itemInfo.type;	
				updateGemInfo(equipType);
			}
			else
			{
				updateGemInfo(-1);
			}
		}
		
		/**
		 * 背包中增减宝石处理 
		 * @param obj
		 */		
		private function backPackGemUpdateHandler(obj:Object):void
		{
			var itemData:ItemData 		  = obj as ItemData;
			var currEquip:PlayerEquipItem = _forgingModule.equipDisplaySpr.currSelEquip;
			var equipType:int 			  = -1;
			if(itemData.itemInfo.group == EGroup._EGroupStuff && itemData.itemInfo.category == EStuff._EStuffJewel)
			{
				if(_forgingModule.currentPanel is GemEmbedPanel)
				{
					if(currEquip && currEquip.itemData)
					{
						equipType = currEquip.itemData.itemInfo.type;
					}
					updateGemInfo(equipType);
				}
			}
		}
	}
}
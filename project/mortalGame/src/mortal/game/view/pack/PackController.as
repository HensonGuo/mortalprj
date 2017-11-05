package mortal.game.view.pack
{
	import Message.DB.Tables.TRune;
	import Message.Game.SBagItem;
	import Message.Public.EPlayerItemPosType;
	import Message.Public.EProp;
	import Message.Public.EPropType;
	
	import com.gengine.debug.Log;
	
	import extend.language.Language;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import modules.interfaces.IPackModule;
	
	import mortal.component.window.WindowEvent;
	import mortal.game.cache.Cache;
	import mortal.game.cache.packCache.BackPackCache;
	import mortal.game.cache.packCache.PackPosTypeCache;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.CursorManager;
	import mortal.game.manager.GameManager;
	import mortal.game.manager.MsgManager;
	import mortal.game.mvc.EventName;
	import mortal.game.mvc.GameController;
	import mortal.game.mvc.GameProxy;
	import mortal.game.mvc.ServerCommand;
	import mortal.game.proxy.EquipProxy;
	import mortal.game.proxy.PackProxy;
	import mortal.game.resource.info.item.ItemData;
	import mortal.game.resource.tableConfig.SkillConfig;
	import mortal.game.utils.ItemsUtil;
	import mortal.game.view.common.ModuleType;
	import mortal.game.view.common.cd.CDDataType;
	import mortal.game.view.common.cd.ICDData;
	import mortal.mvc.core.Controller;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.core.NetDispatcher;
	import mortal.mvc.interfaces.IView;
	
	public class PackController extends Controller
	{
		private const pageSize:int = 49;
		private var _packModule:IPackModule;
		private var _packProxy:PackProxy;
		private var _packCache:BackPackCache;
		private var _page:int;
		
		public function PackController()
		{
			super();
			init();
		}
		
		private function init():void
		{
			_packCache = cache.pack.backPackCache;
			_packProxy = GameProxy.packProxy;
		}
		
		override protected function initView():IView
		{
			if (_packModule == null)
			{
				_packModule=new PackModule();
				_packModule.addEventListener(WindowEvent.SHOW, onPackShow);
				_packModule.addEventListener(WindowEvent.CLOSE, onPackClose);
			}
			return _packModule;
		}
		
		override protected function initServer():void
		{
			Dispatcher.addEventListener(EventName.BackPack_Destroy, destroyHandler);     //销毁物品
			Dispatcher.addEventListener(EventName.BackPack_DragInItem, dragInItemHandler);     //拖动物品
			Dispatcher.addEventListener(EventName.BackPack_Tity, tidyBagHandler);         //整理
			Dispatcher.addEventListener(EventName.BackPack_Use, onUseItemHandler);
			Dispatcher.addEventListener(EventName.BackPack_BulkUse, onBulkUseItemHandler);
			Dispatcher.addEventListener(EventName.PackSelectIndex, setSelectIndex);
		}
		
		private function onPackShow(e:Event):void
		{
			getBagInfo();
			
//			updatePackHandler();
			updateMoney();
			updateCapacity();

			_packModule.addEventListener(MouseEvent.ROLL_OVER, mouse_over);
			_packModule.addEventListener(MouseEvent.ROLL_OUT, mouse_out);
			
			NetDispatcher.addCmdListener(ServerCommand.BackpackDataChange, updatePackHandler);
			NetDispatcher.addCmdListener(ServerCommand.BackPackItemsChange, updatePackHandler);
			NetDispatcher.addCmdListener(ServerCommand.MoneyUpdate, updateMoney);
			NetDispatcher.addCmdListener(ServerCommand.UpdateCapacity,updateCapacity);
			
			Dispatcher.addEventListener(EventName.ShowUnLock, showUnLock);
			Dispatcher.addEventListener(EventName.HideUnLock, hideUnLock);
			Dispatcher.addEventListener(EventName.BackpackUpData, upDateItemsHandler);
			Dispatcher.addEventListener(EventName.BackPack_Split, splitHandler);
			Dispatcher.addEventListener(EventName.ShopSellItem, sellItemHanDler);
			Dispatcher.addEventListener(EventName.OpenGrid, openGridHandler);
			Dispatcher.addEventListener(EventName.GetTime, updateTime);
			Dispatcher.addEventListener(EventName.BackPack_Equip,equipHandler);
			Dispatcher.addEventListener(EventName.Trade_StatusChange,refreshList);
			
		}
		
		private function onPackClose(e:Event):void
		{
			hideUnLock();
			
			_packModule.removeEventListener(MouseEvent.MOUSE_OVER, mouse_over);
			_packModule.removeEventListener(MouseEvent.MOUSE_OUT, mouse_out);
			CursorManager.currentCurSorType = CursorManager.NO_CURSOR;
			
			NetDispatcher.removeCmdListener(ServerCommand.BackpackDataChange, updatePackHandler);
			NetDispatcher.removeCmdListener(ServerCommand.BackPackItemsChange, updatePackHandler);
			NetDispatcher.removeCmdListener(ServerCommand.MoneyUpdate, updateMoney);    
			NetDispatcher.removeCmdListener(ServerCommand.UpdateCapacity,updateCapacity);
			
			Dispatcher.removeEventListener(EventName.ShowUnLock, showUnLock);
			Dispatcher.removeEventListener(EventName.HideUnLock, hideUnLock);
			Dispatcher.removeEventListener(EventName.BackpackUpData, upDateItemsHandler);
			Dispatcher.removeEventListener(EventName.BackPack_Split, splitHandler);
			Dispatcher.removeEventListener(EventName.ShopSellItem, sellItemHanDler);
			Dispatcher.removeEventListener(EventName.OpenGrid, openGridHandler);
			Dispatcher.removeEventListener(EventName.GetTime, updateTime);
			Dispatcher.removeEventListener(EventName.BackPack_Equip,equipHandler);
			
		}
		
		
		/**
		 * 获取背包信息 
		 * 
		 */		
		private function getBagInfo():void
		{
			var posType:int = EPlayerItemPosType._EPlayerItemPosTypeBag;
			
			if(_packCache.capacity != _packCache.totalGride)  //格指数达到最大时,则不获取开格子时间
			{
				updatePackHandler();
				_packProxy.openTime(posType);
			}
			else
			{
				updatePackHandler();
			}

		}
		
		private function updateTime(e:DataEvent):void
		{
			var posType:int = EPlayerItemPosType._EPlayerItemPosTypeBag;
			
			if(_packCache.capacity != _packCache.totalGride)
			{
				updatePackHandler();
				_packProxy.openTime(posType);
			}
			else
			{
				updatePackHandler();
			}
		}
		
		/**
		 *更新背包数据
		 * @param obj
		 *
		 */
		private function updatePackHandler(obj:Object=null):void
		{
			//更新背包数据
			(view as IPackModule).updateAllItems();
			if (obj)
			{
				if (obj["selectIndex"] != -1)
				{
					_packModule.updataPackItemPanelSelectItem(obj["selectIndex"] - 1);
				}
				else
				{
					_packModule.updataPackItemPanelSelectItem(-1);
				}
			}
		}
		
		
		/**
		 * 整理后更新背包 
		 * @param e
		 * 
		 */
		private function upDateItemsHandler(e:DataEvent):void
		{
			(view as IPackModule).updateItems();
		}
		
		/**
		 * 使用物品 
		 * @param event
		 * 
		 */		
		private function onUseItemHandler(event:DataEvent):void
		{
			useItem(event.data as ItemData);
		}
		
		/**
		 * 使用物品 
		 * @param itemData
		 * 
		 */		
		public function useItem(itemData:ItemData):void
		{
			var uid:String=itemData.serverData.uid;
			var name:String=itemData.itemInfo.name;
			
			if(ItemsUtil.isNotCanUse(itemData))    //是否可以使用
			{
				MsgManager.showRollTipsMsg(Language.getString(30052));
			}
			else if(ItemsUtil.isEnoughLevel(itemData))
			{
				MsgManager.showRollTipsMsg(Language.getString(30053));
			}
			else if(!ItemsUtil.isFitCarrer(itemData))
			{
				MsgManager.showRollTipsMsg(Language.getString(30054));
			}
			else if(ItemsUtil.isCanUseInBag(itemData))   //是否可以在包内使用
			{
				// 冷却中
				var cd:ICDData = cache.cd.getCDData(itemData, CDDataType.itemData);
				if(cd && cd.isCoolDown)
				{
					MsgManager.showRollTipsMsg(Language.getStringByParam(20051, Language.getString(20053)));
					return;
				}
//				if (uid == null)
//				{
//					uid=cache.pack.backPackCache.getFirstItemUid(name);
//				}
//				
//				if (uid)
//				{
//					cd.startItemCd();
//					if(ItemsUtil.isAttrDrug(itemData))
//					{
//						var buffInfo:BuffInfo = cache.buff.getCanNotUseBuffInfo(itemData);
//						if(buffInfo)
//						{
//							showItemTips(buffInfo,itemData);
//							return;
//						}
//						else
//						{
//							//使用buff药品音效
//							SoundManager.instance.soundPlay(SoundTypeConst.UseBuffDrugs);
//						}
//					}
//					else if(ItemsUtil.isInstantDrug(itemData))
//					{
//						//使用瞬回的生命或法力药音效
//						SoundManager.instance.soundPlay(SoundTypeConst.UseDrugs);
//					}
				
				if(itemData.itemInfo.category == EProp._EPropProp && itemData.itemInfo.type == EPropType._EPropTypeActiveSoul) //使用精灵
				{
					Dispatcher.dispatchEvent(new DataEvent(EventName.WizardItemUse,itemData.itemCode));
				}
				else
				{
					_packProxy.useItem(uid, itemData.itemInfo.code);
				}
					
				
			}
			else  //不可在包内使用的,对应打开它的面板
			{
				if (ItemsUtil.isSkillBook(itemData))
				{
					Dispatcher.dispatchEvent(new DataEvent(EventName.UseSkillBook,itemData));
				}
				else if(ItemsUtil.isMountCulturUse(itemData))
				{
					Dispatcher.dispatchEvent(new DataEvent(EventName.MountOpenCulturWin,itemData));
				}
				else if(ItemsUtil.isPetSoul(itemData))
				{
					Dispatcher.dispatchEvent(new DataEvent(EventName.PetSkillBookOpen,itemData));
				}
				else if(ItemsUtil.isRuneStuff(itemData.itemInfo)) // 激活符文
				{
					var rune:TRune = SkillConfig.instance.getRuneByItemCode(ItemsUtil.getBindCode(itemData.itemCode));
					if(rune == null)
					{
						return;
					}
					Dispatcher.dispatchEvent(new DataEvent(EventName.Skill_SelectPos, rune.runePos));
					Dispatcher.dispatchEvent(new DataEvent(EventName.SkillShowHideModule, true));
					return;
				}
				else
				{
					MsgManager.showRollTipsMsg(Language.getString(30021));
				}
			}
			
		}
		
		/**
		 * 批量使用物品
		 * @param e
		 * 
		 */		
		private function onBulkUseItemHandler(e:DataEvent):void
		{
			var itemData:ItemData = e.data["itemData"];
			var amount:int = e.data["amount"];
			GameProxy.packProxy.useItem(itemData.serverData.uid,itemData.itemInfo.code,amount);
		}
		
		/**
		 *更新金钱
		 * @param obj
		 *
		 */
		private function updateMoney(obj:Object = null):void
		{
			(view as IPackModule).updateMoney();
		}
		
		/**
		 * 销毁物品 
		 * @param e
		 * 
		 */		
		private function destroyHandler(e:DataEvent):void
		{
			var items:Array = [];
			var sBagItem:SBagItem = new SBagItem();
			sBagItem.amount = (e.data as ItemData).serverData.itemAmount;
			sBagItem.uid = (e.data as ItemData).serverData.uid;
			items.push(sBagItem);
			_packProxy.destroy(items);
		}
		
		/**
		 * 卖给系统
		 * @param e
		 * 
		 */		
		private function sellItemHanDler(e:DataEvent):void
		{
			var itemData:ItemData = e.data as ItemData;
			
			if(ItemsUtil.isCanSell(itemData))
			{
				var items:Array = [];
				var sBagItem:SBagItem = new SBagItem();
				sBagItem.amount = itemData.serverData.itemAmount;
				sBagItem.uid = itemData.serverData.uid;
				items.push(sBagItem);
				_packProxy.sell(items);
			}
			else
			{
				MsgManager.showRollTipsMsg(Language.getString(30058));
			}
			
		}
		
		/**
		 * 开启格子 
		 * @param e
		 * 
		 */		
		private function openGridHandler(e:DataEvent):void
		{
			var obj:Object = e.data;
			_packProxy.openGrid(obj.posType, obj.amount, obj.clientNeedMoney);
		}
		
		/**
		 *打开商店之后鼠标滑进背包
		 * @param e
		 *
		 */
		private function mouse_over(e:MouseEvent):void
		{
			switch (CursorManager.currentCurSorType)
			{
				case CursorManager.SELL:
					CursorManager.showCursor(CursorManager.SELL);
					break;
				case CursorManager.FIX:
					CursorManager.showCursor(CursorManager.FIX);
					break;
				case "":
					CursorManager.showCursor(CursorManager.NO_CURSOR);
					break;
			}
		}
		
		/**
		 * 打开商店之后鼠标滑出背包
		 * @param e
		 *
		 */
		private function mouse_out(e:MouseEvent):void
		{
			CursorManager.showCursor(CursorManager.NO_CURSOR);
		}
		
		private function tidyBagHandler(e:DataEvent):void
		{
			_packProxy.tidy(EPlayerItemPosType._EPlayerItemPosTypeBag);
		}
		
		/**
		 * 拖动物品 
		 * @param e
		 * 
		 */		
		private function dragInItemHandler(e:DataEvent):void
		{
			_page = _packModule.pageTabBarSelect;  //当前页码
			var dragDropData:DragDropData=e.data as DragDropData;
			var fromIndex:int;    //开始位置
			var toIndex:int;    //目标位置
			var uidDrag:String;   
			
			var fromItemData:ItemData = dragDropData.fromItemData;;
			var toItemData:ItemData;
			var itemData:ItemData;
			var len:int;
			var toItemIsExtend:Boolean;
			
			
			switch (dragDropData.fromPosType)
			{
				//包内移动
				case EPlayerItemPosType._EPlayerItemPosTypeBag:
//					if(!ItemsUtil.isMaxOverlay(dragDropData.fromItemData) && !ItemsUtil.isMaxOverlay(dragDropData.toItemData))
//					{
//						if( ItemsUtil.isSameItemData(dragDropData.fromItemData,dragDropData.toItemData))
//						{
//							_packProxy.merge(dragDropData.fromPosType,dragDropData.toItemData.uid,dragDropData.fromItemData.uid);
//							break;
//						}
//						if(ItemsUtil.isBindSameItemData(dragDropData.fromItemData,dragDropData.toItemData))
//						{
//							Alert.show(Language.getString(40005),null,Alert.OK | Alert.CANCEL,null,onCheckOp);
//							break;
//						}
//					}
					
					var packCache:PackPosTypeCache = Cache.instance.pack.getPackChacheByPosType(dragDropData.fromPosType);
					fromIndex = packCache.getIndexByUid(dragDropData.uid);
					toIndex = pageSize * _page + dragDropData.toIndex;
					dragDropData.fromIndex = fromIndex;
					dragDropData.toIndex = toIndex;
					if (toIndex <= packCache.sbag.capacity)
					{
						if(packCache.changeItemPos(dragDropData))
						{
							updatePackHandler();
						}
					}
					break;
				case EPlayerItemPosType._EPlayerItemPosTypeRole:
					Dispatcher.dispatchEvent(new DataEvent(EventName.GetOffEquip,fromItemData));
					break;
				
			}
		}
		
		
		/**
		 *拆分物品
		 * @param e
		 *
		 */
		private function splitHandler(e:DataEvent):void
		{
			if (e.data)
			{
				_packProxy.split(e.data["uid"] as String, e.data["amount"] as int);
			}
		}
		
		/**
		 * 装备物品 
		 * @param e
		 * 
		 */		
		private function equipHandler(e:DataEvent):void
		{
			var putOnItem:ItemData = e.data as ItemData;
			var getOffItem:ItemData = Cache.instance.pack.packRolePackCache.getEquipByType(putOnItem.itemInfo.type);
			var getOffUid:String = getOffItem == null? null:getOffItem.serverData.uid;
			GameProxy.equip.dress(putOnItem.serverData.uid,getOffUid);
		}
		
		/**
		 * 更新容量 
		 * @param data
		 * 
		 */		
		private function updateCapacity(data:Object = null):void
		{
			_packModule.updateCapacity();
		}
		
		/**
		 * 显示开格子滤镜 
		 * @param e
		 * 
		 */		
		private function showUnLock(e:DataEvent):void
		{
			_packModule.showUnLockItem(e.data as Object);
		}
		
		/**
		 * 隐藏开格子滤镜 
		 * @param e
		 * 
		 */		
		private function hideUnLock(e:DataEvent = null):void
		{
			_packModule.hideUnLockItem();
		}
		
		private function setSelectIndex(e:DataEvent):void
		{
			_packCache.maxSelsecIndex = e.data as int;
		}
		
		private function refreshList(e:DataEvent):void
		{
			updatePackHandler();
		}
	}
}
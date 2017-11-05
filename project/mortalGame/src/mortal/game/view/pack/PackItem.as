package mortal.game.view.pack
{
	import Message.Public.EPlayerItemPosType;
	
	import com.gengine.debug.Log;
	import com.mui.core.GlobalClass;
	import com.mui.display.ScaleBitmap;
	import com.mui.manager.DragManager;
	
	import extend.language.Language;
	
	import fl.data.DataProvider;
	
	import flash.events.MouseEvent;
	import flash.utils.setTimeout;
	
	import mortal.component.gconst.FilterConst;
	import mortal.component.gconst.ResourceConst;
	import mortal.game.cache.Cache;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.CursorManager;
	import mortal.game.manager.MsgManager;
	import mortal.game.mvc.EventName;
	import mortal.game.mvc.GameController;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.info.item.ItemData;
	import mortal.game.utils.ItemsUtil;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.cd.CDDataType;
	import mortal.game.view.common.display.BitmapNumberText;
	import mortal.game.view.common.item.BaseItem;
	import mortal.game.view.common.menu.ItemMenuConst;
	import mortal.game.view.common.menu.ItemMenuRegister;
	import mortal.game.view.pack.data.PackItemData;
	import mortal.game.view.pack.social.ItemFeatureTips;
	import mortal.mvc.core.Dispatcher;
	
	public class PackItem extends BaseItem
	{
//		private var _bgBmp:GBitmap;
		
		private var _notMeetCareerEffect:ScaleBitmap;
		
		private var _isNotMeet:Boolean;
		
		private var _tradingIcon:ScaleBitmap;
		
		private var _isTrading:Boolean;
		
		/**
		 * 是否显示锻造数值 
		 */		
		private var _isStreng:Boolean;
		
		/** 强化等级美术字 */
		private var _txtStrenLv:BitmapNumberText;
		
		public function PackItem()
		{	
			super();
			
		}
		
		override protected function updateView():void
		{
			if(canNotUseEffect)
			{
				canNotUseEffect.width = _width - _paddingLeft*2;
				canNotUseEffect.height = _height - _paddingTop*2;
				canNotUseEffect.x = _paddingLeft;
				canNotUseEffect.y = _paddingTop;
			}
			
			if(lockedIcon)
			{
				lockedIcon.x = _paddingLeft;
				lockedIcon.y = _paddingTop;
			}
			
			if(amountLabel)
			{
				amountLabel.width = _width - _paddingLeft*2;
				amountLabel.x = _paddingLeft;
				amountLabel.y = _height - _paddingTop - amountLabel.height;
			}
			
			if(_notMeetCareerEffect)
			{
				_notMeetCareerEffect.width = _width - _paddingLeft * 2;
				_notMeetCareerEffect.height = _height - _paddingTop * 2;
				_notMeetCareerEffect.x = _paddingLeft;
				_notMeetCareerEffect.y = _paddingTop;
			}
			
			if(_tradingIcon)
			{
				_tradingIcon.width = _width - _paddingLeft * 2;
				_tradingIcon.height = _height - _paddingTop * 2;
				_tradingIcon.x = _paddingLeft;
				_tradingIcon.y = _paddingTop;
			}
		}

		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
//			_bgBmp = GlobalClass.getBitmap(ImagesConst.PackItemBg);
//			_bgBmp.y = 1;
//			this.addChildAt(_bgBmp,0);
			
			_isShowFreezingEffect = true;
			_isShowLeftTimeEffect = false;
			this.doubleClickEnabled = true;
			isShowLock = true;
			
			this.canNotUse = false;
			this.isNotMeetCarrer = false;
			this.isTrading = false;
			
			_txtStrenLv = UIFactory.bitmapNumberText(0, 22, "EquipmentTipsNumber.png", 16, 16, -5, this);
			
			setListener();
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			_txtStrenLv.dispose(isReuse);
			
			if(_notMeetCareerEffect)
			{
				_notMeetCareerEffect.dispose(isReuse);
				_notMeetCareerEffect = null;
			}
			
			if(_tradingIcon)
			{
				_tradingIcon.dispose(isReuse);
				_tradingIcon = null;
			}
			
			if(_freezingEffect)
			{
				_freezingEffect.alpha = 1;
			}
			
			_txtStrenLv = null;
		}
		
		override protected function resetEffectPlace():void
		{
			if(_freezingEffect)
			{
				_freezingEffect.x = _width/2;
				_freezingEffect.y = _height/2;
				_freezingEffect.alpha = 0.6;
				_freezingEffect.setMaskSize(_width - _paddingLeft*2, _height - _paddingTop*2);
			}
			if(_leftTimeEffect)
			{
				_leftTimeEffect.width = _width;
				_leftTimeEffect.height = 20;
				_leftTimeEffect.x = 0;
				_leftTimeEffect.y = (_height - _leftTimeEffect.height)/2;
			}
		}
		
		public function set isNotMeetCarrer(value:Boolean):void
		{
			_isNotMeet = value;
			if(_isNotMeet)
			{
				if(!_notMeetCareerEffect)
				{   
					_notMeetCareerEffect = ResourceConst.getScaleBitmap(ImagesConst.PackDisable);
					_middleLayer.addChild(_notMeetCareerEffect);
					_notMeetCareerEffect.width = _width - _paddingLeft * 2;
					_notMeetCareerEffect.height = _height - _paddingTop * 2;
					_notMeetCareerEffect.x = _paddingLeft;
					_notMeetCareerEffect.y = _paddingTop;
				}
			}
			
			if(_notMeetCareerEffect)
			{
				_notMeetCareerEffect.visible = _isNotMeet;
				if(GameController.trade.isViewShow)
				{
					_notMeetCareerEffect.visible = false;
				}
			}
			
			
		}
		
		public function set isTrading(value:Boolean):void
		{
			_isTrading = value;
			if(_isTrading)
			{
				if(!_tradingIcon)
				{
					_tradingIcon = ResourceConst.getScaleBitmap(ImagesConst.PackTrade);
					_middleLayer.addChild(_tradingIcon);
					_tradingIcon.width = _width - _paddingLeft * 2;
					_tradingIcon.height = _height - _paddingTop * 2;
					_tradingIcon.x = _paddingLeft;
					_tradingIcon.y = _paddingTop;
				}
			}
			
			if(_tradingIcon)
			{
				_tradingIcon.visible = GameController.trade.isViewShow;
				_tradingIcon.visible = _isTrading;
			}
			
		}
		
		private function setListener():void
		{
			this.configEventListener(MouseEvent.CLICK,clickHandler,false,9999);
			this.configEventListener(MouseEvent.DOUBLE_CLICK, fastOperate);
		}
		
		override public function set itemData(value:ItemData):void
		{
			var isPackItemData:Boolean = true;
			ItemMenuRegister.unRegister(this);
		
			this.isDragAble = false;
			this.isDropAble = false;
			this.isNotMeetCarrer = false;
			
			this.removeEventListener(MouseEvent.ROLL_OVER,showUnLockIcon);
			this.removeEventListener(MouseEvent.ROLL_OUT,hideUnLockIcon);
			
			updateCDEffect();
			if(value == PackItemData.lockItemData)  //锁住的(可购买)
			{
				this.source = GlobalClass.getBitmap(ImagesConst.Locked2);
				this.amount = 0;
				_itemData = value;
				isBind = false;
				this.isStreng = false;
				isPackItemData = false;
				this.buttonMode = true;
				
				this.configEventListener(MouseEvent.ROLL_OVER,showUnLockIcon);
				this.configEventListener(MouseEvent.ROLL_OUT,hideUnLockIcon);
			}
			else if(value == PackItemData.unLockItemData)   //可开启的
			{
				this.source = GlobalClass.getBitmap(ImagesConst.UnLock2);
				this.amount = 0;
				_itemData = value;
				isBind = false;
				this.isStreng = false;
				isPackItemData = false;
				this.buttonMode = true;
				
			}
			else if(value == PackItemData.unLockingItemData) //正在倒计时
			{
				this.source = GlobalClass.getBitmap(ImagesConst.UnLocking2);
				this.amount = 0;
				_itemData = value;
				isBind = false;
				this.isStreng = false;
				isPackItemData = false;
				this.buttonMode = true;
				
				_cdData = Cache.instance.cd.getCDData("lockCD",CDDataType.backPackLock);
				updateCDEffect("lockCD" , CDDataType.backPackLock);
				
				this.configEventListener(MouseEvent.ROLL_OVER,showUnLockIcon);
				this.configEventListener(MouseEvent.ROLL_OUT,hideUnLockIcon);
			}
			else if(value == PackItemData.lockingItemData)   //锁住的(不可购买)
			{
				this.source = GlobalClass.getBitmap(ImagesConst.Locked2);
				this.amount = 0;
				_itemData = value;
				this.buttonMode = false;
				isPackItemData = false;
				isBind = false;
				this.isStreng = false;
			}
			else if(value)
			{
				_itemData = value;
				this.source = value.itemInfo.url;
				this.amount = value.serverData.itemAmount;
				this.isShowToolTip = true;
				this.buttonMode = true;
				this.isDragAble = true;
				this.isDropAble = true;
				this.isNotMeetCarrer = !ItemsUtil.isFitCarrer(itemData);
				this.isBind = ItemsUtil.isBind(this.itemData);
				this.isStreng = ItemsUtil.isEquip(_itemData);
				updateCDEffect(this.itemData, CDDataType.itemData);
			}
			else
			{
				this.source =null;
				this.amount = 0;
				_itemData = null;
				isBind = false;
				this.isStreng = false;
				this.isDropAble = true;
				isPackItemData = false;
				this.buttonMode = false;
			}
			
			if(this.itemData && isPackItemData)
			{
				ItemMenuRegister.register(this,this.itemData);
			}
			
		}	
		
		private function get isStreng():Boolean
		{
			return _isStreng;
		}
		
		private function set isStreng(value:Boolean):void
		{
			_isStreng = value;
			_txtStrenLv.visible = _isStreng;
			
			if(_isStreng)
			{
				updateStrengLevel();
			}
		}
		
		/**
		 * 更新强化等级美术字 
		 */		
		private function updateStrengLevel():void
		{	
			var level:int = 0;
			if(this.itemData.extInfo)
			{
				level = this.itemData.extInfo.strengthen;
			}
			if(level != 0)
			{
				this._txtStrenLv.text  = "+" + level;
				this._txtStrenLv.x     = 40 - _txtStrenLv.width;
			}
			else
			{
				this._txtStrenLv.text  = "";
			}
		}
		
		override protected function cdFinishedHandler():void
		{
			unRegisterEffects();
			setTimeout(getTime,1000);
		}
		
		private function showUnLockIcon(e:MouseEvent):void
		{
			Dispatcher.dispatchEvent(new DataEvent(EventName.ShowUnLock, _data));
		}
		
		private function hideUnLockIcon(e:MouseEvent):void
		{
			Dispatcher.dispatchEvent(new DataEvent(EventName.HideUnLock, null));
		}
		
		private function getTime():void
		{
			Dispatcher.dispatchEvent(new DataEvent(EventName.GetTime));
		}
		
		
		private function clickHandler(e:MouseEvent):void
		{
			Log.debug("你单击了物品");
			if(_itemData == null)
			{
				e.stopImmediatePropagation();
				ItemMenuRegister.hideOpList();
			}
			else if(canNotUse || _isTrading)
			{
				MsgManager.showRollTipsMsg("物品已锁定");
				e.stopImmediatePropagation();
				ItemMenuRegister.hideOpList();
			}
			else if(_itemData == PackItemData.lockingItemData)
			{
				if(Cache.instance.pack.backPackCache.capacity == 110)
				{
					MsgManager.showRollTipsMsg("容量已满");
				}
				else
				{
					MsgManager.showRollTipsMsg(Language.getString(30082));
				}
				
				e.stopImmediatePropagation();
				ItemMenuRegister.hideOpList();
			}
			else
			{
				if (e.ctrlKey)
				{
					Dispatcher.dispatchEvent(new DataEvent(EventName.ChatShowItem, itemData));
					e.stopImmediatePropagation();
					ItemMenuRegister.hideOpList();
				}
				else if (CursorManager.currentCurSorType == CursorManager.SELL && _itemData.itemInfo)
				{
					e.stopImmediatePropagation();
					ItemMenuRegister.hideOpList();
					Dispatcher.dispatchEvent(new DataEvent(EventName.ShopSellItem, itemData));
				}
				else if (this.itemData == PackItemData.unLockItemData)
				{
					e.stopImmediatePropagation();
					var amount:int = Cache.instance.pack.backPackCache.canOpenGridNum;
					var obj:Object = {"posType":EPlayerItemPosType._EPlayerItemPosTypeBag, "amount":amount, "clientNeedMoney":0};
					Dispatcher.dispatchEvent(new DataEvent(EventName.OpenGrid, obj));
				}
				else if (this.itemData == PackItemData.unLockingItemData)
				{
					ItemFeatureTips.openGrid(this._data);
				}
				else if (this.itemData == PackItemData.lockItemData)
				{
					ItemFeatureTips.openGrid(this._data);
				}
				else if(Cache.instance.trade.isTrading)
				{
					Dispatcher.dispatchEvent(new DataEvent(EventName.TradeClickPackItem,_itemData));
					e.stopImmediatePropagation();
					ItemMenuRegister.hideOpList();
				}
				else
				{
					var dataProvider:DataProvider = ItemMenuConst.getEnabeldAttri(ItemMenuConst.getDataProvider(itemData),itemData);
//					e.stopImmediatePropagation();
//					if ((ItemsUtil.isEquip(itemData)) && GameController.player.isViewShow)  //如果人物面板打开,单击即可装备
//					{
//						ItemMenuConst.opearte(dataProvider.getItemAt(0)["label"],itemData);
//					
//						ItemMenuRegister.hideOpList();
//					}//ItemsUtil.isMount(itemData)
				}
			}
		}
		
		private function fastOperate(e:MouseEvent):void
		{
			Log.debug("你双击了物品");
			if(_itemData == null || Cache.instance.trade.isTrading)
			{
				e.stopImmediatePropagation();
				ItemMenuRegister.hideOpList();
			}
			else if(canNotUse || _isTrading)
			{
				MsgManager.showRollTipsMsg("物品已锁定");
				e.stopImmediatePropagation();
				ItemMenuRegister.hideOpList();
			}
			else if (itemData && itemData.itemInfo)
			{
				var dataProvider:DataProvider = ItemMenuConst.getEnabeldAttri(ItemMenuConst.getDataProvider(itemData),itemData);
				if((ItemsUtil.isEquip(itemData) || ItemsUtil.isMount(itemData)) && !GameController.player.isViewShow)
				{
					ItemMenuConst.opearte(dataProvider.getItemAt(0)["label"],itemData);
					e.stopImmediatePropagation();
					ItemMenuRegister.hideOpList();
				}
				else 
				{
					var itemCategory:int=itemData.itemInfo.category;
					var itemProp:int=itemData.itemInfo.type;
//					if (itemCategory == ECategory._ECategoryProp && itemProp == EProp._EPropPackage)
//					{
//						fastUsePackage(itemData);
//					}
//					else
//					{
						if(dataProvider.length > 0)
						{
							ItemMenuConst.opearte(dataProvider.getItemAt(0)["label"],itemData);
						}
//					}
				}
			}
			ItemMenuRegister.hideOpList();
		}
		
		private function fastMoveToWareHouse(item:PackItem, index:int):void
		{
			//Dispatcher.dispatchEvent(new DataEvent(EventName.Fast_Move_BackPackItem_ToWareHouse, item));
		}
		
		public function set selected(arg0:Boolean):void
		{
			if(arg0 && itemData)
			{
				this.filters = [FilterConst.itemChooseFilter];
			}
			else
			{
				this.filters = [];
			}
		}
		
		protected override function onMouseDown(e:MouseEvent):void
		{
			if(this.itemData && this.isDragAble && !_cannotUse && !_isTrading)
			{
				DragManager.instance.startDragItem(this,bitmapdata);
			}
		}
		
		private var _data:Object;//用于记录dataPrivoder的data,方便知道当前选择格子的位置
		public function set data(arg0:Object):void
		{
			_data = arg0;
			selected = arg0["selected"];
			
			if(arg0.hasOwnProperty("itemData"))
			{
				if(arg0["itemData"] is ItemData)
				{
					this.itemData = arg0["itemData"];
				}
				else if(arg0["itemData"] is int)
				{
					this.itemData = new ItemData(int(arg0["itemData"]))
				}
				
				if(arg0["locked"])
				{
					canNotUse = true;
				}
				else
				{
					canNotUse = false;
				}
				
				if(arg0["used"])  //是否正在交易
				{
					isTrading = true;
				}
				else
				{
					isTrading = false;
				}
			}
			else
			{
				this.itemData = null;
				canNotUse = false;
				updateCDEffect();
			}
			
		}
		
		override public function get toolTipData():*
		{
			if(itemData == PackItemData.lockItemData || itemData == PackItemData.unLockingItemData)
			{
				return Language.getString(30050);
			}
			else if(itemData == PackItemData.unLockItemData)
			{
				return Language.getString(30051);
			}
			else if(itemData == PackItemData.lockingItemData)
			{
				return Language.getString(30082);
			}
			else if(itemData)
			{
				return itemData;
			}
			return super.toolTipData;
		}
		
		private function changeUsingItemPos():void
		{
			
		}
		
		
		private function itemUseing(e:DataEvent):void
		{
			//playEffect( e.data as CDBackPackItem );
		}
		
		//		private function playEffect( cd:CDBackPackItem ):void
		//		{
		//			if(itemData && itemData.itemAmount > 0 )
		//			{
		//				if( freezingEffect.isCDPlaying == false && cd.isCanCd(itemData) )
		//				{
		//					freezingEffect.cdTime = cd;
		//				}
		//			}
		//			else
		//			{
		//				if( freezingEffect.isCDPlaying )
		//				{
		//					freezingEffect.clearEffect();
		//				}
		//			}
		//		}
	}
}
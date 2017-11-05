package mortal.game.view.business
{
	import Message.Public.EPlayerItemPosType;
	import Message.Public.EPrictUnit;
	import Message.Public.EUpdateType;
	import Message.Public.SBusinessInfo;
	import Message.Public.SBusinessItemUpdate;
	import Message.Public.SMiniPlayer;
	
	import com.gengine.utils.HTMLUtil;
	import com.mui.controls.Alert;
	import com.mui.controls.GButton;
	import com.mui.controls.GSprite;
	import com.mui.controls.GTextFiled;
	import com.mui.controls.GTileList;
	import com.mui.display.ScaleBitmap;
	import com.mui.events.DragEvent;
	
	import fl.data.DataProvider;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.utils.Dictionary;
	
	import mortal.common.GTextFormat;
	import mortal.common.global.GlobalStyle;
	import mortal.component.window.BaseWindow;
	import mortal.game.cache.Cache;
	import mortal.game.cache.TradeCache;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.MsgManager;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.GameDefConfig;
	import mortal.game.resource.info.item.ItemData;
	import mortal.game.utils.NameUtil;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.display.MoneyInput;
	import mortal.game.view.common.menu.PlayerMenuConst;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.interfaces.ILayer;
	
	/**
	 * 交易
	 * @author lizhaoning
	 */
	public class TradeModule extends BaseWindow
	{
		public static const listLength:int = 6;
		
		private var _lock1:Boolean = false;
		private var _lock2:Boolean = false;
		private var lockEffect1:GSprite;//玩家1锁定效果
		private var lockEffect2:GSprite;//玩家2锁定效果
		
		
		private var _topContanier:GSprite;
		private var _txtTargetInfo:GTextFiled;
		
		private var _middleContanier:GSprite;
		private var _listBg:ScaleBitmap;
		private var _listTarget:GTileList;
		private var _listSelf:GTileList;
		private var _inputCoinTarget:MoneyInput;
		private var _inputGoldTarget:MoneyInput;
		private var _inputCoinSelf:MoneyInput;
		private var _inputGoldSelf:MoneyInput;
		
		private var _bottomContanier:GSprite;
		private var _btnAddFriend:GButton;//添加好友
		private var _btnSendPrivate:GButton;//发起私聊
		private var _btnLock:GButton;//锁定按钮按钮
		private var _btnTrade:GButton;//交易按钮
		
		
		public var myItemVec:Vector.<TradeItemVo>;
		public var targetItemVec:Vector.<TradeItemVo>;
		
		public var targetSBusinessInfo:SBusinessInfo;
		
		public function TradeModule($layer:ILayer=null)
		{
			super($layer);
			setSize(332,480);
			//title = Language.getString(50001);
			titleHeight = 40;
			
			myItemVec = new Vector.<TradeItemVo>;
			targetItemVec = new Vector.<TradeItemVo>;
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			var _tfBai:GTextFormat = GlobalStyle.textFormatBai;
			_topContanier = UIFactory.getUICompoment(GSprite,20,45,this);
			_txtTargetInfo = UIFactory.textField("10级",0,0,300,20,_topContanier,_tfBai);
			
			//中间部分
			_middleContanier = UIFactory.getUICompoment(GSprite,17,70,this);
			//物品
			_listBg = UIFactory.bg(0,0,300,368,_middleContanier);
			_listTarget = UIFactory.tileList(4,4,148,312,_middleContanier);
			_listTarget.rowHeight = 51;
			_listTarget.columnWidth = 146;
			_listTarget.setStyle("cellRenderer",TradeListRenderer);
			_listTarget.rowCount = listLength;
			_listTarget.columnCount = 1;
			_listTarget.dataProvider = getMyListDp();
			
			_listSelf = UIFactory.tileList(152,4,148,312,_middleContanier);
			_listSelf.rowHeight = 51;
			_listSelf.columnWidth = 146;
			_listSelf.setStyle("cellRenderer",TradeMyItemListRenderer);
			_listSelf.rowCount = listLength;
			_listSelf.columnCount = 1;
			_listSelf.dataProvider = getTargetListDp();
			
			//锁定效果
			
			lockEffect1 = UIFactory.getUICompoment(GSprite,4,4,_middleContanier);
			lockEffect1.graphics.lineStyle(2,0xFFFF00,1);
			lockEffect1.graphics.beginFill(0xFFFFFF,0);
			lockEffect1.graphics.drawRect(0,0,148,307);
			lockEffect1.graphics.endFill();
			lockEffect1.mouseEnabled = false;
			lockEffect1.mouseChildren = false;
			lockEffect1.filters = [new BlurFilter()];
			lockEffect1.cacheAsBitmap = true;
			lockEffect1.visible = false;
			
			lockEffect2 = UIFactory.getUICompoment(GSprite,152,4,_middleContanier);
			lockEffect2.graphics.lineStyle(2,0xFFFF00,1);
			lockEffect2.graphics.beginFill(0xFFFFFF,0);
			lockEffect2.graphics.drawRect(0,0,148,307);
			lockEffect2.graphics.endFill();
			lockEffect2.filters = [new BlurFilter()];
			lockEffect2.cacheAsBitmap = true;
			lockEffect2.visible = false;
			
			//金钱
			_inputGoldTarget = UIFactory.getUICompoment(MoneyInput,26,314,_middleContanier);
			_inputGoldTarget.unit = EPrictUnit._EPriceUnitGold;
			_inputGoldTarget.value = 0;
			_inputGoldTarget.mouseChildren = _inputGoldTarget.mouseEnabled = false; 
			_inputCoinTarget = UIFactory.getUICompoment(MoneyInput,26,339,_middleContanier);
			_inputCoinTarget.unit = EPrictUnit._EPriceUnitCoin;
			_inputCoinTarget.value = 0;
			_inputCoinTarget.mouseChildren = _inputCoinTarget.mouseEnabled = false;
			
			_inputGoldSelf = UIFactory.getUICompoment(MoneyInput,170,314,_middleContanier);
			_inputGoldSelf.unit = EPrictUnit._EPriceUnitGold;
			_inputGoldSelf.defultText = "输入金额";
			_inputGoldSelf.checkSelfMoeny = true;
			_inputCoinSelf = UIFactory.getUICompoment(MoneyInput,170,339,_middleContanier);
			_inputCoinSelf.unit = EPrictUnit._EPriceUnitCoin;
			_inputCoinSelf.defultText = "输入金额";
			_inputCoinSelf.checkSelfMoeny = true;
			
			_bottomContanier = UIFactory.getUICompoment(GSprite,22,442,this);
			
			_btnAddFriend = UIFactory.gButton("加友",5,0,42,22,_bottomContanier);
			_btnSendPrivate = UIFactory.gButton("私聊",50,0,42,22,_bottomContanier);
			_btnLock = UIFactory.gButton("锁定交易",140,0,66,22,_bottomContanier);
			_btnTrade = UIFactory.gButton("确定交易",210,0,66,22,_bottomContanier);
			
			//事件监听
			_btnAddFriend.configEventListener(MouseEvent.CLICK,onClickHandler);
			_btnSendPrivate.configEventListener(MouseEvent.CLICK,onClickHandler);
			_btnLock.configEventListener(MouseEvent.CLICK,onClickHandler);
			_btnTrade.configEventListener(MouseEvent.CLICK,onClickHandler);
			_inputCoinSelf.configEventListener(Event.CHANGE,onMoneysChange);
			_inputGoldSelf.configEventListener(Event.CHANGE,onMoneysChange);
			
			this.configEventListener(DragEvent.Event_Move_In, itemMoveInHandler);
			Dispatcher.addEventListener(EventName.TradeClickItem,onItemClick);
			Dispatcher.addEventListener(EventName.TradeSelectNumOver,onSelectNunOver);
			Dispatcher.addEventListener(EventName.TradeClickPackItem,onClickBagItem);
			
			updateViewByData();
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			
			Dispatcher.removeEventListener(EventName.TradeClickItem,onItemClick);
			Dispatcher.removeEventListener(EventName.TradeSelectNumOver,onSelectNunOver);
			Dispatcher.removeEventListener(EventName.TradeClickPackItem,onClickBagItem);
			
			lockEffect1.visible = true;
			lockEffect1.mouseEnabled = true;
			lockEffect1.mouseChildren = true;
			lockEffect1.cacheAsBitmap = false;
			lockEffect1.graphics.clear();
			lockEffect1.filters = null;
			lockEffect1.dispose(true);
			
			lockEffect2.visible = true;
			lockEffect2.cacheAsBitmap = false;
			lockEffect2.graphics.clear();
			lockEffect2.filters = null;
			lockEffect2.dispose(true);
			
			
			_txtTargetInfo.dispose(isReuse);
			_topContanier.dispose(isReuse);
			
			_listBg.dispose(isReuse);
			_listTarget.dispose(isReuse);
			_listSelf.dispose(isReuse);
			_inputCoinTarget.mouseChildren = _inputCoinTarget.mouseEnabled = true;
			_inputCoinTarget.dispose(isReuse);
			_inputGoldTarget.mouseChildren = _inputGoldTarget.mouseEnabled = true; 
			_inputGoldTarget.dispose(isReuse);
			_inputCoinSelf.mouseEnabled = _inputCoinSelf.mouseChildren = true;
			_inputCoinSelf.dispose(isReuse);
			_inputGoldSelf.mouseEnabled = _inputGoldSelf.mouseChildren = true;
			_inputGoldSelf.dispose(isReuse);
			_middleContanier.dispose(isReuse);
			
			_btnAddFriend.dispose(isReuse);//添加好友
			_btnSendPrivate.dispose(isReuse);//发起私聊
			_btnLock.dispose(isReuse);//锁定按钮按钮
			_btnTrade.dispose(isReuse);//交易按钮
			_bottomContanier.dispose(isReuse);
			
			lockEffect1 = null;
			lockEffect2 = null;
			
			_txtTargetInfo = null;
			_topContanier = null;
			
			_listBg = null;
			_listTarget = null;
			_listSelf = null;
			_inputCoinTarget = null;
			_inputGoldTarget = null;
			_inputCoinSelf = null;
			_inputGoldSelf = null;
			_middleContanier = null;
			
			_btnAddFriend = null;//添加好友
			_btnSendPrivate = null;//发起私聊
			_btnLock = null;//锁定按钮按钮
			_btnTrade = null;//交易按钮
			_bottomContanier = null;
		}
		
		override protected function closeBtnClickHandler(e:MouseEvent):void
		{
			//关闭窗口取消交易
			endTrading();
			
			super.closeBtnClickHandler(e);
		}
		
		override public function hide():void
		{
			//清空视图数据
			_lock1 = false;
			_lock2 = false;
			myItemVec.splice(0,myItemVec.length);
			targetItemVec.splice(0,targetItemVec.length);
			targetSBusinessInfo = null;
			
			super.hide();
		}
		
		private function updateViewByData():void
		{
			targetSBusinessInfo = Cache.instance.trade.getTargetSBusinessInfo();
			_btnAddFriend.enabled = Cache.instance.friend.findRecordByRoleId(targetSBusinessInfo.entityId.id) == null ?true:false;
			_btnTrade.enabled = false;
			var str:String;
			if(Cache.instance.friend.findRecordByRoleId(targetSBusinessInfo.entityId.id) == null)  //陌生人
			{
				str = "与（" + HTMLUtil.addColor("陌",GlobalStyle.colorHong) + "）"; 
			}
			else
			{
				str = "与 ";
			}
			str += NameUtil.getNameByCamp(targetSBusinessInfo.camp,targetSBusinessInfo.name) +" "+
				targetSBusinessInfo.level.toString() + " 级  交易中";
			str = "<p align = 'center'>" + str + "</p>";
			_txtTargetInfo.htmlText = str;
			
		}
		
		private function onClickBagItem(e:DataEvent):void   //背包物品点击
		{
			// TODO Auto Generated method stub
			startPutInItem(e.data as ItemData);
		}		
		
		private function itemMoveInHandler(e:DragEvent):void  //背包物品拖入
		{
			// TODO Auto Generated method stub
			var dragSource:ItemData = e.dragSouce as ItemData;
			if(dragSource.serverData.posType  == EPlayerItemPosType._EPlayerItemPosTypeBag)
			{
				startPutInItem(dragSource);
			}
			else
			{
				MsgManager.showRollTipsMsg("交易物品只能来源于背包!");
				return;
			}
		}
		
		/** 正在选择数量的物品 */
		public static var _selectingNumItem:ItemData;
		/** 开始放入物品 */
		private function startPutInItem(item:ItemData):void
		{
			if(lock2) //自己已经锁定
			{
				MsgManager.showRollTipsMsg("已经锁定交易，不能更改物品");
				return;
			}
			if(myItemVec.length >= TradeModule.listLength)  //交易栏已满
			{
				MsgManager.showRollTipsMsg("交易栏已满");
				return;
			}
			
			if(item.itemAmount > 1)
			{
				_selectingNumItem = item;
				if(TradeSelectNumWin.instance.isHide)
					TradeSelectNumWin.instance.show();
				else
					TradeSelectNumWin.instance.updateViewByData();
			}
			else
			{
				putInItem(item,item.itemAmount);
			}
		}
		
		private function onSelectNunOver(e:DataEvent):void
		{
			// TODO Auto Generated method stub
			putInItem(_selectingNumItem,int(e.data));
			_selectingNumItem = null;
		}
		
		/** 正式放入物品 */
		private function putInItem(item:ItemData,count:int):void
		{
			if(myItemVec.length >= TradeModule.listLength)  //交易栏已满
			{
				MsgManager.showRollTipsMsg("交易栏已满");
				return;
			}
			
			var itemVo:TradeItemVo = new TradeItemVo(item,count);
			
			myItemVec.push(itemVo);
			
			this._listSelf.dataProvider = getMyListDp();
			Dispatcher.dispatchEvent(new DataEvent(EventName.TradeMyItemsChange,{uid:item.uid,amount:count}));
		}
		
		/** 移出物品 */
		private function putOutItem(item:ItemData):void
		{
			if(item == null)
			{
				return;
			}
			
			for (var i:int = 0; i < myItemVec.length; i++) 
			{
				if(myItemVec[i].itemData == item)
				{
					myItemVec.splice(i,1);
					break;
				}
			}
			
			this._listSelf.dataProvider = getMyListDp();
			Dispatcher.dispatchEvent(new DataEvent(EventName.TradeMyItemsChange,{uid:item.uid,amount:0}));
		}
		
		private function getMyListDp():DataProvider
		{
			return new DataProvider(getArr(myItemVec));
		}
		
		private function getTargetListDp():DataProvider
		{
			return new DataProvider(getArr(targetItemVec));
		}
		
		private function getArr(vec:Vector.<TradeItemVo>):Array
		{
			var arr:Array = [];
			for (var i:int = 0; i < listLength; i++) 
			{
				if(vec && vec.length > i)
					arr.push(vec[i]);
				else
					arr.push(new Object());
			}
			return arr;
		}
		
		private function onItemClick(e:DataEvent):void   //点击已经放入的物品
		{
			// TODO Auto Generated method stub
			if(lock2) //自己已经锁定
			{
				MsgManager.showRollTipsMsg("已经锁定交易，不能更改物品");
				return;
			}
			putOutItem(e.data as ItemData);
		}		
		
		private function onMoneysChange(e:Event):void
		{
			// TODO Auto Generated method stub
			var moneyInput:MoneyInput = e.currentTarget as MoneyInput;
			var obj:Object = {};
			obj.unit = moneyInput.unit;
			obj.amount = moneyInput.value;
			Dispatcher.dispatchEvent(new DataEvent(EventName.TradeMyMoneysChange,obj));
		}
		
		private function onClickHandler(e:MouseEvent):void
		{
			// TODO Auto Generated method stub
			if(e.currentTarget == _btnAddFriend)
			{
				addFriend();
			}
			else if(e.currentTarget == _btnSendPrivate)
			{
				sendPrivate();
			}
			else if(e.currentTarget == _btnLock)
			{
				lock();
			}
			else if(e.currentTarget == _btnTrade)
			{
				clickTrade();
			}
		}
		
		private function addFriend():void
		{
			PlayerMenuConst.Opearte(PlayerMenuConst.AddFriend,createMiniPlayer());
		}
		
		private function sendPrivate():void
		{
			PlayerMenuConst.Opearte(PlayerMenuConst.ChatPirvate,createMiniPlayer());
		}
		
		private function createMiniPlayer():SMiniPlayer
		{
			var miniPlayer:SMiniPlayer = new SMiniPlayer();
			var sb:SBusinessInfo = targetSBusinessInfo;
			miniPlayer.entityId = sb.entityId;
			miniPlayer.name = sb.name;
			return miniPlayer;
		}
		
		private function lock():void
		{
			if(_inputGoldSelf.value > TradeCache.goldRemind)
			{
				var str:String = "你正在进行大额度元宝交易,是否继续";
				Alert.show(str,null,Alert.OK|Alert.CANCEL,null,onSelect);
			}
			else
			{
				onSelect(Alert.OK);
			}
			function onSelect(tyep:int):void
			{
				if(tyep == Alert.OK)
				{
					lock2  = true;
					Dispatcher.dispatchEvent(new DataEvent(EventName.TradeClickLock));
				}
			}
		}
		
		private function clickTrade():void
		{
			_btnTrade.enabled = false;
			Dispatcher.dispatchEvent(new DataEvent(EventName.TradeClickTradeBtn));
		}
		
		//中断交易
		private function endTrading():void
		{
			Dispatcher.dispatchEvent(new DataEvent(EventName.TradeCancel));
		}
		
		public function get lock1():Boolean
		{
			return _lock1;
		}
		
		public function set lock1(value:Boolean):void
		{
			_lock1 = value;
			lockEffect1.visible = value;
			_btnTrade.enabled = _lock1 && _lock2;
		}
		
		public function get lock2():Boolean
		{
			return _lock2;
		}
		
		public function set lock2(value:Boolean):void
		{
			_lock2 = value;
			lockEffect2.visible = value;
			_inputCoinSelf.mouseEnabled = _inputCoinSelf.mouseChildren = !_lock2;
			_inputGoldSelf.mouseEnabled = _inputGoldSelf.mouseChildren = !_lock2;
			_btnLock.enabled = !_lock2;
			_btnTrade.enabled = _lock1 && _lock2;
		}
		
		public function updateTargetItem(dict:Dictionary):void
		{
			targetItemVec.splice(0,targetItemVec.length);
			
			var arr:Array = sortItemDicAsArr(dict);
			var obj:SBusinessItemUpdate;
			for (var i:int = 0; i < arr.length; i++)
			{
				obj = arr[i];
				if(obj.updateType.value() != EUpdateType._EUpdateTypeDel)
				{
					var itemData:ItemData = new ItemData(obj.playerItem);
					var itemVo:TradeItemVo = new TradeItemVo(itemData,itemData.itemAmount);
					targetItemVec.push(itemVo);
				}
			}
			_listTarget.dataProvider = getTargetListDp();
		}
		
		private function sortItemDicAsArr(dic:Dictionary):Array
		{
			var arr:Array = [];
			for each (var i:SBusinessItemUpdate in dic)
				arr.push(i);
			
			arr.sortOn("index",Array.NUMERIC);
			return arr;
		}
		
		public function updateTargetMoneys(gold:int, coin:int):void
		{
			this._inputCoinTarget.value = coin;
			this._inputGoldTarget.value = gold;
		}
	}
}
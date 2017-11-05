package mortal.game.view.pack.social
{
	import Message.Public.EPlayerItemPosType;
	
	import com.gengine.global.Global;
	import com.mui.controls.Alert;
	import com.mui.controls.GButton;
	import com.mui.controls.GTextFiled;
	import com.mui.controls.GTextInput;
	import com.mui.core.GlobalClass;
	import com.mui.display.ScaleBitmap;
	import com.mui.utils.UICompomentPool;
	
	import extend.language.Language;
	
	import fl.core.UIComponent;
	
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	
	import mortal.common.net.CallLater;
	import mortal.component.gconst.ResourceConst;
	import mortal.component.window.BaseWindow;
	import mortal.component.window.SmallWindow;
	import mortal.game.cache.Cache;
	import mortal.game.cache.packCache.BackPackCache;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.MsgManager;
	import mortal.game.manager.msgTip.MsgHistoryType;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.info.item.ItemData;
	import mortal.game.utils.ItemsUtil;
	import mortal.game.view.common.NumInput;
	import mortal.game.view.common.cd.CDData;
	import mortal.game.view.common.cd.CDDataType;
	import mortal.game.view.common.item.BaseItem;
	import mortal.game.view.pack.data.PackItemData;
	import mortal.mvc.core.Dispatcher;

	public class ItemFeatureTips
	{
		private static function get htmlContent():String
		{
			return "<font color='#ffffff'>" + Language.getString(30032) + "</font><font color='#ff3c3c'>" + Language.getString(30033) + "<font color='#ffffff'>" + Language.getString(30034) + "</font>";
		}
		
		private static function get htmlTitle():String
		{
			return "<font color='#f5ff00'>" + Language.getString(30035) + "</font>";
		}
		
		
		/**
		 * 摧毁提示
		 * */
		public static function destroyItem(itemData:ItemData):void
		{
			if(!itemData)
			{
				return;
			}
			Alert.show(htmlContent, null, Alert.OK | Alert.CANCEL, null, closeAlert);
			
			function closeAlert(index:int):void
			{
				if (index == Alert.OK)
				{
					Dispatcher.dispatchEvent(new DataEvent(EventName.BackPack_Destroy, itemData));
				}
			}
		}
		
		/**
		 * 装备提示
		 * */
		public static function equipItem(itemData:ItemData):void
		{
			if(!itemData)
			{
				return;
			}
			Alert.show( Language.getStringByParam(30081,itemData.itemInfo.name), null, Alert.OK | Alert.CANCEL, null, closeAlert);
			
			function closeAlert(index:int):void
			{
				if (index == Alert.OK)
				{
					Dispatcher.dispatchEvent(new DataEvent(EventName.BackPack_Equip,itemData));
				}
			}
		}
		
//		/**
//		 * 开启格子 
//		 * @param itemData
//		 * 
//		 */		
//		public static function openGrid(itemData:ItemData):void
//		{
//			var packCache:BackPackCache = Cache.instance.pack.backPackCache
//			var str:String;
//			var money:int; 
//			var amount:int;
//			var cdData:CDData = Cache.instance.cd.getCDData("lockCD",CDDataType.backPackLock) as CDData;
//			
//			if(itemData == PackItemData.lockItemData)
//			{
//				amount = packCache.maxCanOpenGrid() - packCache.capacity;
//				money = packCache.openGridMoney() + Math.ceil((cdData.totalTime - getTimer() + cdData.beginTime)/60/1000);
//				str = Language.getStringByParam(30038, amount - packCache.canOpenGridNum) + money;
//				Alert.show(str, null, Alert.OK | Alert.CANCEL, null, closeAlert);
//			}
//			else if(itemData == PackItemData.unLockingItemData)
//			{
////				money = Math.ceil(Cache.instance.pack.backPackCache.countdownTime/60);
//				money = Math.ceil((cdData.totalTime - getTimer() + cdData.beginTime)/60/1000);
//				str = Language.getStringByParam(30037, money);
//				amount = packCache.currentGrid - packCache.capacity;
//				Alert.show(str, null, Alert.OK | Alert.CANCEL, null, closeAlert);
//			}
//			
//			CallLater.addCallBack(showUnLock);
//			
//			function showUnLock():void
//			{
//				if(itemData == PackItemData.unLockingItemData)
//				{
//					Dispatcher.dispatchEvent(new DataEvent(EventName.ShowUnLock, 1));
//				}
//				else
//				{
//					Dispatcher.dispatchEvent(new DataEvent(EventName.ShowUnLock, 0));
//				}
//			}
//			
//			function closeAlert(index:int):void
//			{
//				if (index == Alert.OK)
//				{
//					var obj:Object = {"posType":EPlayerItemPosType._EPlayerItemPosTypeBag, "amount":amount, "clientNeedMoney":money};
//					Dispatcher.dispatchEvent(new DataEvent(EventName.OpenGrid, obj));
//					Dispatcher.dispatchEvent(new DataEvent(EventName.HideUnLock, null));
//				}
//				else if(index == Alert.CANCEL)
//				{
//					Dispatcher.dispatchEvent(new DataEvent(EventName.HideUnLock, null));
//				}
//			}
//		}
		
		/**
		 * 开启格子 (新的规则)
		 * @param itemData
		 * 
		 */		
		public static function openGrid(data:Object):void
		{
			var itemData:ItemData = data.itemData as ItemData;
			var packCache:BackPackCache = Cache.instance.pack.backPackCache
			var str:String;
			var money:int; 
			var amount:int;
			var cdData:CDData = Cache.instance.cd.getCDData("lockCD",CDDataType.backPackLock) as CDData;
			
			if(itemData == PackItemData.lockItemData)
			{
				amount = packCache.maxSelsecIndex - packCache.capacity;
				money = packCache.openGridMoney() + Math.ceil((cdData.totalTime - getTimer() + cdData.beginTime)/60/1000);
				str = Language.getStringByParam(30038, amount - packCache.canOpenGridNum) + money;
				Alert.show(str, null, Alert.OK | Alert.CANCEL, null, closeAlert);
			}
			else if(itemData == PackItemData.unLockingItemData)
			{
				//				money = Math.ceil(Cache.instance.pack.backPackCache.countdownTime/60);
				money = Math.ceil((cdData.totalTime - getTimer() + cdData.beginTime)/60/1000);
				str = Language.getStringByParam(30037, money);
				amount = packCache.currentGrid - packCache.capacity;
				Alert.show(str, null, Alert.OK | Alert.CANCEL, null, closeAlert);
			}
			
			CallLater.addCallBack(showUnLock);
			
			function showUnLock():void
			{
				if(itemData == PackItemData.unLockingItemData)
				{
					Dispatcher.dispatchEvent(new DataEvent(EventName.ShowUnLock, data));
				}
				else
				{
					Dispatcher.dispatchEvent(new DataEvent(EventName.ShowUnLock, data));
				}
			}
			
			function hideUnlock():void
			{
				Dispatcher.dispatchEvent(new DataEvent(EventName.HideUnLock, null));
			}
			
			function closeAlert(index:int):void
			{
				if (index == Alert.OK)
				{
					var obj:Object = {"posType":EPlayerItemPosType._EPlayerItemPosTypeBag, "amount":amount, "clientNeedMoney":money};
					Dispatcher.dispatchEvent(new DataEvent(EventName.OpenGrid, obj));
				}
				else if(index == Alert.CANCEL)
				{
					
				}
				
				CallLater.addCallBack(hideUnlock);
			}
		}
		
		/**
		 * 拆分提示
		 * */
		public static function splitTip(itemData:ItemData):void
		{
			if(!itemData)
			{
				MsgManager.showRollTipsMsg(Language.getString(30022));
				return;
			}
			if(itemData.serverData.itemAmount <= 1)
			{
				MsgManager.showRollTipsMsg(Language.getString(30023));
				return;
			}
			if(ItemsUtil.isTaskItem(itemData))
			{
				MsgManager.showRollTipsMsg(Language.getString(30024));
				return;
			}
			
			SplitTipWin.instance.showWin(itemData);
		}
		
		
		/**
		 * 批量使用提示 
		 * @param itemData
		 * @param callback
		 * 
		 */		
		public static function bulkUse(itemData:ItemData,callback:Function=null):void
		{
			if (!itemData)
			{
				MsgManager.showRollTipsMsg(Language.getString(30028));
				return;
			}
			if(ItemsUtil.isTaskItem(itemData))
			{
				MsgManager.showRollTipsMsg(Language.getString(30029));
				return;
			}
			
			BulkUseWin.instance.showWin(itemData,callback);
		}
	}
}
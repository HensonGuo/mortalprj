package mortal.game.proxy
{
//	import Message.Game.AMI_IBag_batchRemove;
//	import Message.Game.AMI_IBag_fastMerge;
	import Framework.Util.Exception;
	
	import Message.Game.AMI_IBag_destroy;
	import Message.Game.AMI_IBag_get;
	import Message.Game.AMI_IBag_open;
	import Message.Game.AMI_IBag_openTime;
	import Message.Game.AMI_IBag_sell;
	import Message.Game.AMI_IBag_split;
	import Message.Game.AMI_IBag_tidy;
	import Message.Game.AMI_IBag_use;
	import Message.Public.EPlayerItemPosType;
	import Message.Public.SErrorMsg;
	
	import com.gengine.debug.Log;
	import com.gengine.global.Global;
	
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import frEngine.loaders.resource.info.ABCInfo;
	
	import mortal.common.error.ErrorCode;
	import mortal.common.sound.SoundManager;
	import mortal.common.sound.SoundTypeConst;
	import mortal.game.cache.Cache;
	import mortal.game.cache.packCache.BackPackCache;
	import mortal.game.cache.packCache.PackPosTypeCache;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.MsgManager;
	import mortal.game.mvc.EventName;
	import mortal.game.mvc.GameProxy;
	import mortal.game.mvc.ServerCommand;
	import mortal.game.net.rmi.GameRMI;
	import mortal.game.resource.info.item.ItemData;
	import mortal.game.view.common.cd.CDData;
	import mortal.game.view.common.cd.CDDataType;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.core.NetDispatcher;
	import mortal.mvc.core.Proxy;

	public class PackProxy extends Proxy
	{
		private var _packCache:BackPackCache;
		
		public const posType:int = EPlayerItemPosType._EPlayerItemPosTypeBag;
		public function PackProxy()
		{
			super();
			init();
		}
		
		private function init():void
		{
			_packCache = this.cache.pack.backPackCache;
		}
		
		/**
		 * 获取背包
		 */
		public function getBag(postype:int):void
		{
			var ep:EPlayerItemPosType = EPlayerItemPosType.convert(postype);
			rmi.iBagPrx.get_async(new AMI_IBag_get(), ep);
		}
		
		/**
		 * 整理背包
		 * */
		public function tidy(posType:int):void
		{
			var ep:EPlayerItemPosType = EPlayerItemPosType.convert(posType);
			rmi.iBagPrx.tidy_async(new AMI_IBag_tidy(tidySuccess,tidyFail,null),ep);
		}
		
		private function tidySuccess(e:AMI_IBag_tidy, isSetPosit:Boolean):void
		{
			Log.debug("tidySuccess",isSetPosit);
			if(!isSetPosit)
			{
				_packCache.sortItems();
				NetDispatcher.dispatchCmd(ServerCommand.BackPackItemsChange,null);
			}
		}
		
		private function tidyFail(e:Exception):void
		{
			Log.debug("tidyFaile");
			
		}
		
		/**
		 * 使用
		 * */
		public function useItem(uid:String, code:int, amount:int = 1,values:Array = null):void
		{
			var obj:Object = {uid:uid, code:code, amount:amount, valuses:values?values:[]};
			rmi.iBagPrx.use_async(new AMI_IBag_use(useSuccesss,useFail,obj),uid,amount,values?values:new Array());
		}
		
		//使用物品成功
		private function useSuccesss(e:AMI_IBag_use):void
		{
			Log.debug("使用物品成功");
//			var obj:Object = e.userObject;
		}
		
		private function useFail(e:Exception):void
		{
			Log.debug("使用物品失败");
			Log.debug(e.code,ErrorCode.getErrorStringByCode(e.code),e.message);
			if(e.code != 36104)
			{
				MsgManager.showRollTipsMsg(ErrorCode.getErrorStringByCode(e.code));
			}
		
		}
		
		/**
		 * 拆分
		 * */
		public function split(uid:String,amount:int):void
		{
			var obj:Object = {uid:uid,amount:amount};
			rmi.iBagPrx.split_async(new AMI_IBag_split(splitSuccess,null,obj),uid,amount);
		}
		
		/**
		 * 拆分成功
		 * @param e
		 * 
		 */		
		private function splitSuccess(e:AMI_IBag_split):void
		{
			var obj:Object = e.userObject;
			//判断快捷方式中是否存在
		}
		
		/**
		 * 摧毁物品 
		 * @param items
		 * 
		 */		
		public function destroy(items:Array):void
		{
			rmi.iBagPrx.destroy_async(new AMI_IBag_destroy(destroySuccess,destroyFail),items);
		}
		
		private function destroySuccess(e:AMI_IBag_destroy):void
		{
			
		}
		
		private function destroyFail(e:Exception):void
		{
			
		}
		
		/**
		 * 出售给系统 
		 * @param items
		 * 
		 */		
		public function sell(items:Array):void
		{
			rmi.iBagPrx.sell_async(new AMI_IBag_sell(sellSuccess,sellFail),items);
		}
		
		private function sellSuccess(e:AMI_IBag_sell):void
		{
			Log.debug("出售成功");
		}
		
		private function sellFail(e:*):void
		{
			Log.debug("出售失败");
		}
		
		/**
		 * 获取当前开格子的总时间 
		 * @param posType
		 * 
		 */		
		public function openTime(posType:int = 0):void
		{
			var ep:EPlayerItemPosType = EPlayerItemPosType.convert(posType);
			rmi.iBagPrx.openTime_async(new AMI_IBag_openTime(getTimeSuccess,getTimeFail),ep);
		}
		
		private function getTimeSuccess(e:AMI_IBag_openTime, onlineTime:int, saveTime:int):void
		{
			Log.debug("获取时间成功");
			_packCache.unLockTime = onlineTime + saveTime*60;
//			Log.debug("proxy获取时间返回数据:",_packCache.unLockTime/60, onlineTime, saveTime);
			 
			var _cdData:CDData = Cache.instance.cd.registerCDData(CDDataType.backPackLock, "lockCD", _cdData) as CDData;
			_cdData.beginTime = getTimer() -  _packCache.countdownTime * 1000;
			var starTime:int = _packCache.currentGrid == 36? 0:_packCache.gridVec[_packCache.currentGrid - 37].needTime;
			_cdData.totalTime = (_packCache.gridVec[_packCache.currentGrid - 36].needTime - starTime)*1000;
//			Log.debug(_cdData.totalTime);
			_cdData.startCoolDown();
		
			
			NetDispatcher.dispatchCmd(ServerCommand.BackPackItemsChange,null);
		}
		
		private function getTimeFail(e:*):void
		{
			Log.debug("获取时间失败");
		}
		
		public function openGrid(posType:int, amount:int, clientNeedMoney:int):void
		{
			Log.debug(posType, amount, clientNeedMoney)
			var ep:EPlayerItemPosType = EPlayerItemPosType.convert(posType);
//			Log.debug("proxy开启格子提交的数据:",amount,clientNeedMoney);
			rmi.iBagPrx.open_async(new AMI_IBag_open(openSuccess, openFail, amount), ep, amount, clientNeedMoney);
		}
		
		private function openSuccess(e:AMI_IBag_open):void
		{
			Log.debug("开启格子成功");
			var obj:Object = e.userObject;
			
			_packCache.capacity += int(obj);
			NetDispatcher.dispatchCmd(ServerCommand.UpdateCapacity,null);
			openTime();
//			NetDispatcher.dispatchCmd(ServerCommand.BackPackItemsChange,null);
		}
		
		private function openFail(e:Exception):void
		{
			Log.debug("开启格子失败");
			MsgManager.showRollTipsMsg(ErrorCode.getErrorStringByCode(e.code));
//			Log.debug(e.code,ErrorCode.getErrorStringByCode(e.code),e.message);
		}
		
		
		/**
		 * 移动（不同包内）
		 * */
//		public function move(dragDropData:DragDropData,isTidy:Boolean = false,path:String=null):void
//		{
//			
//			//var fromPosIndex:int = Cache.instance.pack.getPackChacheByPosType(dragDropData.fromPosType).getIndexByUid(dragDropData.uid);
//			var uid:String = dragDropData.uid;
//			var toPosIndex:int = dragDropData.toIndex;
//            var fromPosIndex:int = dragDropData.fromIndex;
//			var toPosType:int = dragDropData.toPosType;
//			var fromPosType:int = dragDropData.fromPosType;
//			var toItemData:ItemData  = dragDropData.toItemData;
//			var fromItemData:ItemData = dragDropData.fromItemData;
//			
//			fromPosIndex = cache.pack.getPackChacheByPosType(fromPosType).getIndexByUid(uid);
//			
////			if(toPosType == EPlayerItemPosType._EPlayerItemPosTypeBagExtendBar || fromPosType == EPlayerItemPosType._EPlayerItemPosTypeBagExtendBar)
////			{
////				MsgManager.showRollTipsMsg("该功能暂时无法使用");
////				return;
////			}
//			
//			var obj:Object = {toItemData:toItemData,fromItemData:fromItemData,uid:uid,fromPosType:fromPosType,fromPosIndex:fromPosIndex,toPosType:toPosType,toPosIndex:toPosIndex,isTidy:isTidy,path:path};
//			GameRMI.instance.iBagPrxHelper.move_async(new AMI_IBag_move(moveSuccess,null,obj),uid,fromPosType,fromPosIndex,toPosType,toPosIndex);
//			
//		}
		
		//包外移动
//		private function moveSuccess(e:*):void
//		{
//			//转移物品音效
//			SoundManager.instance.soundPlay(SoundTypeConst.Transfer);
//			
//			var obj:Object = e.userObject;
//			var fromItemData:ItemData;
//			var toItemData:ItemData;
//			switch(obj.fromPosType)
//			{
//				case EPlayerItemPosType._EPlayerItemPosTypeBag:
//					if(obj.isTidy)
//					{
//						Cache.instance.pack.getPackChacheByPosType(obj.toPosType).moveBagOut(obj.toPoxIndex);
//						Cache.instance.pack.getPackChacheByPosType(obj.toPosType).moveBagIn(obj.toPosIndex,obj.fromItemData);
//						NetDispatcher.dispatchCmd(ServerCommand.BackPackExtendItemsChange,{selectIndex:obj.toPosIndex});
//						
//					}else{
//						Cache.instance.pack.getPackChacheByPosType(obj.fromPosType).moveBagOut(obj.fromPosIndex);
//						Cache.instance.pack.getPackChacheByPosType(obj.toPosType).moveBagOut(obj.toPosIndex);
//						
//						Cache.instance.pack.getPackChacheByPosType(obj.fromPosType).moveBagIn(obj.fromPosIndex,obj.toItemData);
//						Cache.instance.pack.getPackChacheByPosType(obj.toPosType).moveBagIn(obj.toPosIndex,obj.fromItemData);
//						NetDispatcher.dispatchCmd(ServerCommand.BackPackItemsChange,{selectIndex:-1});
//						NetDispatcher.dispatchCmd(ServerCommand.BackPackExtendItemsChange,{selectIndex:obj.toPosIndex});
//					}
//					break;
//				case EPlayerItemPosType._EPlayerItemPosTypeBagExtendBar:
//					if(obj.isTidy)
//					{
//						
//						Cache.instance.pack.getPackChacheByPosType(obj.fromPosType).moveBagOut(obj.fromPosIndex);
//						Cache.instance.pack.getPackChacheByPosType(obj.fromPosType).moveBagIn(obj.fromPosIndex,obj.toItemData);
//						
//						NetDispatcher.dispatchCmd(ServerCommand.BackPackExtendItemsChange,{selectIndex:obj.toPosIndex});
//					}else{
//						fromItemData = Cache.instance.pack.getPackChacheByPosType(obj.fromPosType).getItemDataByIndex(obj.fromPosIndex);
//						toItemData= Cache.instance.pack.getPackChacheByPosType(obj.toPosType).getItemDataByIndex(obj.toPosIndex);
//						
//						Cache.instance.pack.getPackChacheByPosType(obj.fromPosType).moveBagOut(obj.fromPosIndex);
//						Cache.instance.pack.getPackChacheByPosType(obj.toPosType).moveBagOut(obj.toPosIndex);
//						
//						Cache.instance.pack.getPackChacheByPosType(obj.fromPosType).moveBagIn(obj.fromPosIndex,obj.toItemData);
//						Cache.instance.pack.getPackChacheByPosType(obj.toPosType).moveBagIn(obj.toPosIndex,obj.fromItemData);
//						NetDispatcher.dispatchCmd(ServerCommand.BackPackItemsChange,{selectIndex:obj.toPosIndex});
//						NetDispatcher.dispatchCmd(ServerCommand.BackPackExtendItemsChange,{selectIndex:-1});
//					}
//					break;
//				
//				case EPlayerItemPosType._EPlayerItemPosTypeWarehouse:
//					
//					fromItemData = Cache.instance.pack.getPackChacheByPosType(obj.fromPosType).getItemDataByIndex(obj.fromPosIndex);
//					toItemData = Cache.instance.pack.getPackChacheByPosType(obj.toPosType).getItemDataByIndex(obj.toPosIndex);
//					Cache.instance.pack.getPackChacheByPosType(obj.fromPosType).moveBagOut(obj.fromPosIndex);
//					Cache.instance.pack.getPackChacheByPosType(obj.toPosType).moveBagOut(obj.toPosIndex);
//					Cache.instance.pack.getPackChacheByPosType(obj.fromPosType).moveBagIn(obj.fromPosIndex,obj.toItemData);
//					Cache.instance.pack.getPackChacheByPosType(obj.toPosType).moveBagIn(obj.toPosIndex,obj.fromItemData);
//					NetDispatcher.dispatchCmd(ServerCommand.BackPackItemsChange, {index:obj.toPosIndex,selectIndex:obj.toPosIndex});
//					NetDispatcher.dispatchCmd(ServerCommand.WareHouseItemsChange, {index:obj.fromPosIndex,selectIndex:-1});
//					break;
//				case EPlayerItemPosType._EPlayerItemPosTypeWarehouseExtendBar:
//					Cache.instance.pack.getPackChacheByPosType(obj.toPosType).moveBagOut(obj.toPosIndex);
//					Cache.instance.pack.getPackChacheByPosType(obj.fromPosType).moveBagOut(obj.fromPosIndex);
//					Cache.instance.pack.getPackChacheByPosType(obj.toPosType).moveBagIn(obj.toPosIndex,obj.fromItemData);
//					Cache.instance.pack.getPackChacheByPosType(obj.fromPosType).moveBagIn(obj.fromPosIndex,obj.toItemData);
//					//用来记录面板之间选中的索引
//					var index_0:int;
//					var index_6:int;
//					if(obj.path == BackPackWareHouseMoveType.BackPackToWareHouseExtend)
//					{
//						index_0 = -1;
//						index_6 = obj.fromPosIndex;
//					}else if(obj.path == BackPackWareHouseMoveType.WareHouseExtendToBackPack)
//					{
//						index_0 = obj.toPosIndex;
//						index_6 = -1;
//					}else{
//						
//					}
//					
//					if(obj.isTidy)
//					{
//						NetDispatcher.dispatchCmd(ServerCommand.BackPackExtendItemsChange,{selectIndex:-1});
//						NetDispatcher.dispatchCmd(ServerCommand.WareHouseExtendItemsChange,{selectIndex:index_6});
//						NetDispatcher.dispatchCmd(ServerCommand.BackPackItemsChange,{selectIndex:index_0});
//					}else{
//						NetDispatcher.dispatchCmd(ServerCommand.BackPackItemsChange,{selectIndex:index_0});
//						NetDispatcher.dispatchCmd(ServerCommand.WareHouseExtendItemsChange,{selectIndex:index_6});
//					}
//					break;
//				case EPlayerItemPosType._EPlayerItemPosTypeTreasure:
//					Cache.instance.pack.getPackChacheByPosType(obj.fromPosType).moveBagOut(obj.fromPosIndex);
//					Cache.instance.pack.getPackChacheByPosType(obj.toPosType).moveBagOut(obj.toPosIndex);
//					
//					Cache.instance.pack.getPackChacheByPosType(obj.fromPosType).moveBagIn(obj.fromPosIndex,obj.toItemData);
//					Cache.instance.pack.getPackChacheByPosType(obj.toPosType).moveBagIn(obj.toPosIndex,obj.fromItemData);
//					NetDispatcher.dispatchCmd(ServerCommand.BackPackItemsChange,{selectIndex:-1});
//					NetDispatcher.dispatchCmd(ServerCommand.BackPackTreasurePackChange,null);
//					break;
//			}
//		}
		
//		public function useLottery(uid:String, amount:int):void
//		{
//			rmi.iBagPrxHelper.useLottery_async(new AMI_IBag_useLottery(),uid,amount);
//		}
//		
//		public function moveBag(fromPosType:int, toPosType:int, itemUidMap:Dictionary = null, onSuccess:Function = null,onEx:Function = null):void
//		{
//			rmi.iBagPrxHelper.moveBag_async(new AMI_IBag_moveBag(onSuccess,onEx), fromPosType, toPosType, itemUidMap);
//		}
		
		
		
		
//		public function moveOutOfWardrobe(posType:int,uid:String):void
//		{
//			rmi.iBagPrxHelper.moveOutOfWardrobe_async(new AMI_IBag_moveOutOfWardrobe(moveOutWardrobeSuccess),posType,uid);
//			function moveOutWardrobeSuccess(e:*):void
//			{
//				var index:int = cache.pack.getPackChacheByPosType(EPlayerItemPosType._EPlayerItemPosTypeWardrobe).getIndexByUid(uid);
//				Cache.instance.pack.getPackChacheByPosType(EPlayerItemPosType._EPlayerItemPosTypeWardrobe).moveBagOut(index);
//				NetDispatcher.dispatchCmd(ServerCommand.BackPackItemsChange,{selectIndex:-1});
//			}
//		}
		
		
	}
}
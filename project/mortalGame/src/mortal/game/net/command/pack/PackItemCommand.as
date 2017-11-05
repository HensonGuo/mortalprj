package mortal.game.net.command.pack
{
	import Framework.MQ.MessageBlock;
	
	import Message.Game.SClientPlayerItemUpdate;
	import Message.Game.SSeqClientPlayerItemUpdate;
	import Message.Public.EDrug;
	import Message.Public.EGroup;
	import Message.Public.EItemUseType;
	import Message.Public.EPlayerItemPosType;
	import Message.Public.EUpdateType;
	
	import com.gengine.debug.Log;
	
	import mortal.component.gconst.UpdateCode;
	import mortal.game.cache.Cache;
	import mortal.game.cache.packCache.BackPackCache;
	import mortal.game.cache.packCache.PackPosTypeCache;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.MsgManager;
	import mortal.game.manager.msgTip.MsgHistoryType;
	import mortal.game.mvc.EventName;
	import mortal.game.mvc.GameProxy;
	import mortal.game.mvc.ServerCommand;
	import mortal.game.net.broadCast.BroadCastCall;
	import mortal.game.resource.info.item.ItemData;
	import mortal.game.utils.ItemsUtil;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.core.NetDispatcher;
	
	public class PackItemCommand extends BroadCastCall
	{
		/**
		 * 包裹格子更新
		 */
		public function PackItemCommand( type:Object )
		{
			super(type);
		}
		
		
		override public function call(mb:MessageBlock):void
		{
			Log.debug("I have receive PackItemCommand");
			var updataItems:SSeqClientPlayerItemUpdate = mb.messageBase as SSeqClientPlayerItemUpdate;
			var objChangeIndexs:Object = new Object();  //储存各类背包的更新信息
			var itemChaneNum:Object = {};  //保存物品更新的数量和信息
			for each(var splayerItemUpdate:SClientPlayerItemUpdate in updataItems.playerItemUpdates)
			{
				var packPosTypeCatch:PackPosTypeCache = Cache.instance.pack.getPackChacheByPosType(splayerItemUpdate.playerItem.posType);   //当前出现更新的背包类型
				var aryPackItems:Array = getArrayItems(splayerItemUpdate.playerItem.posType);    //储存某类背包内各个类型的物品更新(增加,删除,状态),后面再一次性更新
				var itemData:ItemData = new ItemData(splayerItemUpdate.playerItem);	
				var itemCode:int = itemData.itemCode;
				
				if(itemChaneNum[ itemData.itemCode+"-"+splayerItemUpdate.updateType ])
				{
					itemChaneNum[ itemData.itemCode+"-"+splayerItemUpdate.updateType ].updateAmount += splayerItemUpdate.updateAmount;
				}
				else
				{
					itemChaneNum[ itemData.itemCode+"-"+splayerItemUpdate.updateType ] = {updateAmount:splayerItemUpdate.updateAmount, itemData:itemData};
				}
				
				switch(splayerItemUpdate.updateType)
				{
					case EUpdateType._EUpdateTypeAdd:
					{
						if(itemData.itemInfo.group == EGroup._EGroupTask)    //任务道具比较特殊
						{
							if((packPosTypeCatch as BackPackCache).moveInTaskBag(itemData)) 
							{
								aryPackItems.push({"itemData":itemData});
								Log.debug("移入任务物品成功");
							}
						}
						else 
						{
							if(packPosTypeCatch.moveBagIn(itemData))   //增加物品成功
							{
								aryPackItems.push({"itemData":itemData});
								Log.debug("物品移入背包成功");
							}
							
							//处理背包获得物品特殊处理
							if(splayerItemUpdate.playerItem.posType == EPlayerItemPosType._EPlayerItemPosTypeBag)
							{
								processGetPackItem(itemData,updataItems.code,splayerItemUpdate);
							}
						}
						NetDispatcher.dispatchCmd(ServerCommand.BackPackItemAdd, itemData);
						break;
					}
						
					case EUpdateType._EUpdateTypeDel:
					{
						if(itemData.itemInfo.group == EGroup._EGroupTask)
						{
							if((packPosTypeCatch as BackPackCache).moveOutTaskBag(itemData.uid,splayerItemUpdate.playerItem))  
							{
								aryPackItems.push({"itemData":itemData});
								Log.debug("删除任务物品成功");
							}
						}
						else
						{
							if(packPosTypeCatch.moveBagOut(splayerItemUpdate.playerItem.uid))  //删除物品成功
							{
								aryPackItems.push({"itemData":itemData});
								Log.debug("删除背包物品成功");
							}
						}
						NetDispatcher.dispatchCmd(ServerCommand.BackPackItemDel, itemData);
						break;
					}
						
					case EUpdateType._EUpdateTypeUpdate:
					{
						if(itemData.itemInfo.group == EGroup._EGroupTask)    //任务道具比较特殊
						{
							if((packPosTypeCatch as BackPackCache).updateTastSPlayerItem(splayerItemUpdate.playerItem))   
							{
								aryPackItems.push({"itemData":itemData});
								Log.debug("更新任务物品成功");
							}
						}
						else 
						{
							if(packPosTypeCatch.updateSPlayerItem(splayerItemUpdate.playerItem))    //更新物品状态成功
							{
								aryPackItems.push({"itemData":itemData});
								Log.debug("更新背包物品成功");
							}
							//处理背包获得物品特殊处理
							if(splayerItemUpdate.updateAmount > 0 && splayerItemUpdate.playerItem.posType == EPlayerItemPosType._EPlayerItemPosTypeBag)
							{
								processGetPackItem(itemData,updataItems.code,splayerItemUpdate);
							}
						}
						
						
						if(updataItems.code == UpdateCode.EUpdateCodeBagMove)  //背包物品移动
						{
							var fromPackCache:PackPosTypeCache = Cache.instance.pack.getPackChacheByPosType(splayerItemUpdate.fromPosType);
							var aryFromPackItems:Array = getArrayItems(splayerItemUpdate.fromPosType);
							
							if(fromPackCache.moveBagOut(splayerItemUpdate.playerItem.uid))  
							{
								aryFromPackItems.push({"itemData":itemData});
							}
							
							if(packPosTypeCatch.moveBagIn(itemData))   //增加物品成功
							{
								aryPackItems.push({"itemData":itemData});
							}
						}
						
						break;
					}
				}
				
				
			}
			
			for each (var item:Object in itemChaneNum)  //根据不同的物品类型更新处理数据
			{
				var rmItemData:ItemData = item.itemData;
				if(item.updateAmount > 0)   //表示增加
				{
					if(rmItemData.itemInfo.useType == EItemUseType._EItemUseTypeGet)  //如果是自动使用的物品则自动使用
					{
						GameProxy.packProxy.useItem(rmItemData.serverData.uid,rmItemData.itemInfo.code,rmItemData.serverData.itemAmount);
					}
					
					if(updataItems.code != UpdateCode.EUpdateCodeBagMove )  //如果是包间移动,则不算是增加物品
					{
						MsgManager.addTipText("获得" + item.updateAmount + ItemsUtil.getItemName(item.itemData),MsgHistoryType.GetMsg);
					}
				}
				else if(item.updateAmount < 0)   //表示使用
				{
					if((rmItemData.itemInfo.type ==EDrug._EDrugLife || rmItemData.itemInfo.type == EDrug._EDrugMana) && updataItems.code == UpdateCode.EUpdateCodeBagUseDrug)  //使用药品 
					{
						//人物的持续药
						if(rmItemData.itemInfo.effect == 0)
						{
							NetDispatcher.dispatchCmd(ServerCommand.BackPackUseItemSuccess, rmItemData.itemInfo.code);
						}
						
						//宠物的持续药
						//							if( item.itemData.itemInfo.item.effect == 2)
						//							{
						//								var obj:Object = {uid:uid, code:code, amount:amount, valuses:values?values:[]};
						//								
						//							}
					}
					MsgManager.addTipText("消耗" + Math.abs(item.updateAmount) + ItemsUtil.getItemName(item.itemData),MsgHistoryType.LostMsg);
				}
				else if(item.updateAmount == 0)
				{
					
				}
			}
			
			
			///上面是处理数据,下面是派发事件(先处理完数据再统一派发事件)///
			
			//背包
			var aryChangeIndexBag:Array = objChangeIndexs[EPlayerItemPosType._EPlayerItemPosTypeBag];
			if(aryChangeIndexBag && aryChangeIndexBag.length > 0)
			{
				if(updataItems.code == UpdateCode.EUpdateCodeBagTidy)
				{
					(packPosTypeCatch as BackPackCache).sortItems();
				}
				NetDispatcher.dispatchCmd(ServerCommand.BackPackItemsChange,null);
				NetDispatcher.dispatchCmd(ServerCommand.UpdateCapacity,null);
			}
			//人物
			var aryChangeIndexRole:Array = objChangeIndexs[EPlayerItemPosType._EPlayerItemPosTypeRole];
			if(aryChangeIndexRole && aryChangeIndexRole.length > 0)
			{
				NetDispatcher.dispatchCmd(ServerCommand.updateEquipMent,(aryChangeIndexRole[0].itemData as ItemData).itemInfo.type);
				NetDispatcher.dispatchCmd(ServerCommand.UpdateStrengthenEquip,(aryChangeIndexRole[0].itemData as ItemData).itemInfo.type);
			}
			
			//宝石背包
			var aryChangeIndexGem:Array = objChangeIndexs[EPlayerItemPosType._EPlayerItemPosTypeEmbed];
			if(aryChangeIndexGem && aryChangeIndexGem.length > 0)
			{
				// 先更新镶嵌包避免空数据
//				NetDispatcher.dispatchCmd(ServerCommand.BackPackGemUpdate,null);
				var data:Object = Cache.instance.forging.embedCallBackData;
				NetDispatcher.dispatchCmd(ServerCommand.EmbedInfoUpdate,data);
				
			}
			
			
			
			function getArrayItems(posType:int):Array
			{
				if(!objChangeIndexs[posType])
				{
					objChangeIndexs[posType] = [];
				}
				
				return objChangeIndexs[posType];
			}
		}
		
		/**
		 * 处理背包获取物品 
		 * @param itemData
		 * @param splayerItemUpdate
		 * 
		 */
		private function processGetPackItem(itemData:ItemData,updateCode:int,splayerItemUpdate:SClientPlayerItemUpdate):void
		{
			if(updateCode == UpdateCode.EUpdateCodeBossDrop)
			{
				flyToBackpack(itemData);
			}
		}
		
		
		
		/**
		 * 发送飘物品到背包事件
		 * @param item
		 */
		private function flyToBackpack(item:ItemData):void
		{
			Dispatcher.dispatchEvent(new DataEvent(EventName.FlyItemToPack,item));
		}
	}
}
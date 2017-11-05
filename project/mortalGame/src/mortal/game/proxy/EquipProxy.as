package mortal.game.proxy
{
	import Framework.Util.Exception;
	
	import Message.Game.AMI_IEquip_equipDecompose;
	import Message.Game.AMI_IEquip_equipRefresh;
	import Message.Game.AMI_IEquip_equipRefreshReplace;
	import Message.Game.AMI_IEquip_jewelEmbed;
	import Message.Game.AMI_IEquip_jewelRemove;
	import Message.Game.AMI_IEquip_jewelUpdate;
	import Message.Game.AMI_IEquip_strengthen;
	import Message.Game.AMI_IRole_dress;
	import Message.Game.EOperType;
	import Message.Game.EPriorityType;
	import Message.Public.SPlayerItem;
	
	import com.gengine.debug.Log;
	
	import flash.utils.Dictionary;
	
	import mortal.common.error.ErrorCode;
	import mortal.game.cache.packCache.BackPackCache;
	import mortal.game.cache.packCache.PackRolePackCache;
	import mortal.game.manager.MsgManager;
	import mortal.game.mvc.ServerCommand;
	import mortal.mvc.core.NetDispatcher;
	import mortal.mvc.core.Proxy;
	
	public class EquipProxy extends Proxy
	{
		private var _packRoleCache:PackRolePackCache;
		private var _backPackCache:BackPackCache;
		
		public function EquipProxy()
		{
			super();
			_packRoleCache = this.cache.pack.packRolePackCache;
			_backPackCache = this.cache.pack.backPackCache;
		}
		
		public function dress(putonUid:String , getoffUid:String):void
		{
			var obj:Object = {putonUid:putonUid,getoffUid:getoffUid}
			rmi.iRolePrx.dress_async(new AMI_IRole_dress(dressSuccess,dressFail,obj),putonUid,getoffUid);
		}
		
		private function dressSuccess(e:AMI_IRole_dress):void
		{
			Log.debug("装备成功");
//			var obj:Object = e.userObject;
//			var type:int = -1;
//			
//			if(obj.putonUid != null)
//			{
//				var putInItem:ItemData = _backPackCache.getEquipByUid(obj.putonUid);
//				if(putInItem)
//				{
//					putInItem.serverData.posType = EPlayerItemPosType._EPlayerItemPosTypeRole;
//					type = putInItem.itemInfo.type;
//					_packRoleCache.moveBagIn(putInItem);
//					_backPackCache.moveBagOut(putInItem.serverData.uid);
//				}
//			}
//			
//			if(obj.getoffUid != null)
//			{
//				var getOffItem:ItemData = _packRoleCache.getItemDataByUid(obj.getoffUid);
//				type = getOffItem.itemInfo.type;
//				getOffItem.serverData.posType = EPlayerItemPosType._EPlayerItemPosTypeBag;
//				_backPackCache.moveBagIn(getOffItem);
//				_packRoleCache.moveBagOut(obj.getoffUid);
//			}
//			
//			NetDispatcher.dispatchCmd(ServerCommand.BackPackItemsChange,null);
//			NetDispatcher.dispatchCmd(ServerCommand.upDateEquipMent,type);
//			NetDispatcher.dispatchCmd(ServerCommand.UpdateStrengthenEquip,type);
		}
		
		private function dressFail(e:Exception):void
		{
			Log.debug("装备失败");
			MsgManager.showRollTipsMsg(ErrorCode.getErrorStringByCode(e.code));
		}
		
		/**
		 * 装备强化 
		 * @param equipUid        装备uid
		 * @param operatortype    0:普通强化，1:最高强化
		 * @param autoBuy 		      强化材料不足是否自动购买
		 * @param priorityFlag    0:优先使用绑定材料  1:只消耗非绑材料
		 * @return resultEquip    操作后的物品
		 * @return consumes		      消耗
		 */
		public function strengthen(equipUid:String,operatortype:EOperType,autoBuy:Boolean,priorityFlag:EPriorityType):int
		{
			rmi.iEquip.strengthen_async(new AMI_IEquip_strengthen(strengthenSuccess), equipUid,operatortype,autoBuy,priorityFlag);
			return 0;
		}
		
		private function strengthenSuccess(e:AMI_IEquip_strengthen, result:int, resultEquip:SPlayerItem, consumes:Array):void
		{
			var data:Object  = {};
			data.result      = result;
			data.resultEquip = resultEquip;
			data.consumes    = consumes;
			NetDispatcher.dispatchCmd(ServerCommand.StrengthenInfoUpdate,data);
		}
		
		private function strengthenFail(e:Exception):void
		{
			Log.debug("强化失败");
		}
		
		/**
		 * 宝石镶嵌 
		 * @param equipUid 装备uid
		 * @param gemUids  宝石列表uid
		 */		
		public function jewelEmbed(equipUid:String,gemUids:Array):void
		{
			rmi.iEquip.jewelEmbed_async(new AMI_IEquip_jewelEmbed(embedSuccess), equipUid,gemUids);
		}
		
		private function embedSuccess(e:AMI_IEquip_jewelEmbed, result:int, resultEquip:SPlayerItem, consumes:Array):void
		{
			var data:Object  = {};
			data.result      = result;
			data.resultEquip = resultEquip;
			data.consumes    = consumes;
			data.type        = 0;
			cache.forging.embedCallBackData = data;
			MsgManager.showRollTipsMsg("宝石镶嵌成功");
//			NetDispatcher.dispatchCmd(ServerCommand.EmbedInfoUpdate,data);
		}
		
		/**
		 * 宝石摘除 
		 * @param equipUid 装备uid
		 * @param gemUids  宝石列表uid
		 * 
		 */		
		public function jewelRemove(equipUid:String, gemUids:Array):void
		{
			rmi.iEquip.jewelRemove_async(new AMI_IEquip_jewelRemove(removeSuccess), equipUid,gemUids);
		}
		
		private function removeSuccess(e:AMI_IEquip_jewelRemove, result:int, resultEquip:SPlayerItem):void
		{
			var data:Object  = {};
			data.result      = result;
			data.resultEquip = resultEquip;
			data.type        = 1;
			cache.forging.embedCallBackData = data;
			MsgManager.showRollTipsMsg("宝石摘除成功");
//			NetDispatcher.dispatchCmd(ServerCommand.EmbedInfoUpdate,data);
		}
		
		/**
		 * 宝石升级 
		 * @param equipUid  宝石UID
		 * @param operType  升级方式(0 -- 普通升级，1 -- 一键升级)
		 * @param autoBuy   材料不足是否自动购买
		 */		
		public function jewelUpdate(equipUid:String,operType:EOperType,autoBuy:Boolean):void
		{
			rmi.iEquip.jewelUpdate_async(new AMI_IEquip_jewelUpdate(updateSuccess), equipUid,operType,autoBuy);
		}
		
		private function updateSuccess(e:AMI_IEquip_jewelUpdate, result:int, resultJewel:SPlayerItem,consumes:Array):void
		{
			var data:Object  = {};
			data.result      = result;
			data.resultJewel = resultJewel;
			data.consumes    = consumes;
			
			NetDispatcher.dispatchCmd(ServerCommand.GemUpgradeInfoUpdate,data);
		}
		
		/**
		 * 装备洗练
		 * @param  equipUid      装备uid
		 * @param  EOperType     洗练类型，普通洗练，批量洗练
		 * @param  autoBuy       是否自动购买
		 * @param  priorityFlag  优先消耗绑定材料情况
		 * @param  lockDict      锁定情况
		 * @param  expectAttr    期望洗练输出 
		 * @param  expectAttrAll 期望任意等级
		 * 
		 * @return consumes      消耗
		 * @return resultEquip   返回装备
		 */
		public function equipRefresh(equipUid:String,type:EOperType,autoBuy:Boolean,priorityFlag:EPriorityType,lockDict:Dictionary,expectAttr:Dictionary,expectAttrAll:int):void
		{
			rmi.iEquip.equipRefresh_async(new AMI_IEquip_equipRefresh(refreshSuccess),equipUid,type,autoBuy,priorityFlag,lockDict,expectAttr,expectAttrAll);
		}
		
		private function refreshSuccess(e:AMI_IEquip_equipRefresh,result:int,resultEquip:SPlayerItem,consumes:Array):void
		{
			MsgManager.showRollTipsMsg("恭喜你！装备洗练成功");
			var data:Object  = {};
			data.result      = result;
			data.resultEquip = resultEquip;
			data.consumes    = consumes;
			
			NetDispatcher.dispatchCmd(ServerCommand.RefreshInfoUpdate,data);
		}
		
		/**
		 * 洗练替换
		 * @param  equipUid     装备uid
		 * @param  replaceIndex 要替换的洗练序号
		 * 
		 * @return resultEquip  返回装备
		 */
		public function equipRefreshReplace(equipUid:String,replaceIndex:int):void
		{
			rmi.iEquip.equipRefreshReplace_async(new AMI_IEquip_equipRefreshReplace(replaceSuccess), equipUid,replaceIndex);
		}
		
		private function replaceSuccess(e:AMI_IEquip_equipRefreshReplace,resultEquip:SPlayerItem):void
		{
			// TODO
		}
		
		/**
		 * 装备分解
		 * @param equipUid 装备uid
		 * @param priority 优先级
		 * 
		 * @return consumes 消耗
		 */
		public function EquipDecompose(equipUid:String,priority:EPriorityType):void
		{
			rmi.iEquip.equipDecompose_async(new AMI_IEquip_equipDecompose(decomposeSuccess), equipUid, priority);
		}
		
		private function decomposeSuccess(e:AMI_IEquip_equipDecompose,resultEquip:SPlayerItem,consume:Array):void
		{
			// TODO
		}
	}
}
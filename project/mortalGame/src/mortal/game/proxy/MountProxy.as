package mortal.game.proxy
{
	import Framework.Util.Exception;
	
	import Message.Game.AMI_IMount_getPlayerMountInfo;
	import Message.Game.AMI_IMount_setMountState;
	import Message.Game.AMI_IMount_upgrade;
	import Message.Game.AMI_IMount_upgradeTool;
	import Message.Public.EMountState;
	
	import com.gengine.debug.Log;
	
	import flash.utils.Dictionary;
	
	import mortal.common.error.ErrorCode;
	import mortal.game.manager.MsgManager;
	import mortal.game.mvc.ServerCommand;
	import mortal.game.view.mount.MountCache;
	import mortal.game.view.mount.data.CultureData;
	import mortal.game.view.mount.data.MountData;
	import mortal.mvc.core.NetDispatcher;
	import mortal.mvc.core.Proxy;
	
	public class MountProxy extends Proxy
	{
		private var _mountCache:MountCache;
		
		public function MountProxy()
		{
			super();
			init();
		}
		 
		private function init():void
		{
			_mountCache = this.cache.mount;
		}
		
		/**
		 * 获取玩家自己的坐骑信息 
		 * 
		 */		
		public function getPlayerMountInfo():void
		{
			rmi.iMount.getPlayerMountInfo_async(new AMI_IMount_getPlayerMountInfo());
		}
		
		/**
		 * 卸下,装备,乘骑 
		 * @param uid
		 * @param state
		 * 
		 */		
		public function setMountState(uid:String , state:int):void
		{
			var eMountState:EMountState = EMountState.convert(state);
			rmi.iMount.setMountState_async(new AMI_IMount_setMountState(setStateSuceess,setStateFail,{"uid":uid,"state":state}),uid,eMountState);
		}
		
		private function setStateSuceess(e:AMI_IMount_setMountState):void
		{
			var state:int;
			switch(e.userObject.state)
			{
				case EMountState._EMountStateDress:
					cache.mount.state = EMountState._EMountStateDress;
					Log.debug("状态转化为装备");
					break;
				case EMountState._EMountStateUndress:
					cache.mount.state = EMountState._EMountStateUndress;
					Log.debug("状态转化为卸下");
					break;
				case EMountState._EMountStateChange:
					cache.mount.currentMount = cache.mount.getMountDataByUid(e.userObject.uid);
					Log.debug("幻化坐骑成功");
					break;
				case EMountState._EMountStateRide:
					if(e.userObject.uid) //如果uid为空,则表示下马
					{
						cache.mount.currentMount = cache.mount.getMountDataByUid(e.userObject.uid);
						Log.debug("乘骑坐骑成功");
					}
					break;
				default:
					return;
			}
//			cache.mount.state = state;
			NetDispatcher.dispatchCmd(ServerCommand.MountSetEquipBtn ,null);
		}
		
		private function setStateFail(e:Exception):void
		{
			MsgManager.showRollTipsMsg(ErrorCode.getErrorStringByCode(e.code));
//			MsgManager.showRollTipsMsg("坐骑改变状态失败");
		}
		
		/**
		 * 经验提升 
		 * @param uid
		 * @param type
		 * @param itemCount
		 * @param goldCount
		 * 
		 */		
		public function upgrade(value:CultureData):void
		{
			rmi.iMount.upgrade_async(new AMI_IMount_upgrade(),value.uid,value.type,value.itemCount,value.goldCount);
		}
		
		/**
		 * 宝具提升 
		 * @param uid
		 * @param type
		 * @param itemCount
		 * @param goldCount
		 * 
		 */		
		public function upgradeTool(value:CultureData):void
		{
			var num:int = Math.max(value.itemCount,value.goldCount);
			var obj:Object = {"uid":value.uid,"num":num};
			rmi.iMount.upgradeTool_async(new AMI_IMount_upgradeTool(upgradeToolSuccess,upgradeToolFail,obj),value.uid,value.type,value.itemCount,value.goldCount);
		}
		
		private function upgradeToolSuccess(e:AMI_IMount_upgradeTool, randValue:Array, toolExpMap:Dictionary):void
		{
			var num:int = e.userObject.num as int;
			var obj:Object = {"valueArr":randValue,"num":num};
			NetDispatcher.dispatchCmd(ServerCommand.Mount_777Runing ,obj);
			var uid:String = e.userObject.uid as String;
			var mountData:MountData = _mountCache.getMountDataByUid(uid);
			for(var i:int ; i < mountData.toolList.length ; i++)
			{
				mountData.toolList[i].exp =  toolExpMap[i + 1];
			}
//			trace(toolExpMap);
		}
		
		private function upgradeToolFail(e:Exception):void
		{
			MsgManager.showRollTipsMsg(ErrorCode.getErrorStringByCode(e.code));
		}
		
	}
}
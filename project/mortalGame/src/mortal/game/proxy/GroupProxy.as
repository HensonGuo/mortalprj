package mortal.game.proxy
{
	import Framework.Util.Exception;
	
	import Message.Game.AMI_IGroup_createGroup;
	import Message.Game.AMI_IGroup_disbandGroup;
	import Message.Game.AMI_IGroup_getGroupInfos;
	import Message.Game.AMI_IGroup_groupOper;
	import Message.Game.AMI_IGroup_kickOut;
	import Message.Game.AMI_IGroup_leftGroup;
	import Message.Game.AMI_IGroup_modifyCaptain;
	import Message.Game.AMI_IGroup_updateGroupSetting;
	import Message.Public.SEntityId;
	import Message.Public.SGroupOper;
	import Message.Public.SGroupSetting;
	
	import com.gengine.debug.Log;
	
	import extend.language.Language;
	
	import mortal.common.error.ErrorCode;
	import mortal.game.cache.Cache;
	import mortal.game.manager.MsgManager;
	import mortal.game.view.group.GroupCache;
	import mortal.mvc.core.Proxy;
	
	public class GroupProxy extends Proxy
	{
		private var _groupCache:GroupCache;
		
		public function GroupProxy()
		{
			super();
			init();
		}
		
		private function init():void
		{
			_groupCache = this.cache.group;
		}
		
		/**
		 * 队伍操作 
		 * 
		 */		
		public function groupOper(arr:Array):void
		{
			var sGroupOper:SGroupOper = arr[0];
			if(sGroupOper.toEntityId.id == Cache.instance.role.entityInfo.entityId.id)
			{
				MsgManager.showRollTipsMsg(Language.getString(30257));
				return;
			}
		
			rmi.iGroupPrx.groupOper_async(new AMI_IGroup_groupOper(operSuccess,operFail),arr);
		}
		
		private function operSuccess(e:AMI_IGroup_groupOper):void
		{
			Log.debug("队伍操作成功");
		}
		
		private function operFail(e:Exception):void
		{
			Log.debug("队伍操作失败");
			MsgManager.showRollTipsMsg(ErrorCode.getErrorStringByCode(e.code));
		}
		
		
		/**
		 * 离开队伍 
		 * 
		 */
		public function leftGroup():void
		{
			rmi.iGroupPrx.leftGroup_async(new AMI_IGroup_leftGroup(leftSuccess,leftFail));
		}
		
		private function leftSuccess(e:AMI_IGroup_leftGroup):void
		{
			Log.debug("离开队伍成功");
		}
		
		private function leftFail(e:Exception):void
		{
			Log.debug("离开队伍失败");
		}
		
		/**
		 * 踢出队伍 
		 * 
		 */		
		public function kickOut(entityId:SEntityId):void
		{
			rmi.iGroupPrx.kickOut_async(new AMI_IGroup_kickOut(kickSuccess,kickFail),entityId);
		}
		
		private function kickSuccess(e:AMI_IGroup_kickOut):void
		{
			Log.debug("踢出队伍成功");
		}
		
		private function kickFail(e:Exception):void
		{
			Log.debug("踢出队伍失败");
		}
		
		/**
		 * 转让 队长成功
		 * @param entityId
		 * 
		 */		
		public function modifyCaptain(entityId:SEntityId):void
		{
			rmi.iGroupPrx.modifyCaptain_async(new AMI_IGroup_modifyCaptain(modifySuccess,modifyFail),entityId);
		}
		
		private function modifySuccess(e:AMI_IGroup_modifyCaptain):void
		{
			Log.debug("转让队长成功");
		}
		
		private function modifyFail(e:Exception):void
		{
			Log.debug("转让队长失败");
		}
			
		
		/**
		 * 创建队伍 
		 * 
		 */		
		public function createGroup():void
		{
			rmi.iGroupPrx.createGroup_async(new AMI_IGroup_createGroup(createSuccess,createFail));
		}
		
		private function createSuccess(e:AMI_IGroup_createGroup):void
		{
			Log.debug("创建队伍成功");
		}
		
		private function createFail(e:Exception):void
		{
			Log.debug("创建队伍失败");
			Log.debug(e.code,ErrorCode.getErrorStringByCode(e.code),e.message);
			if(e.code != 36104)
			{
				MsgManager.showRollTipsMsg(ErrorCode.getErrorStringByCode(e.code));
			}
		}
		
		/**
		 * 解散队伍 
		 * 
		 */		
		public function disbandGroup():void
		{
			rmi.iGroupPrx.disbandGroup_async(new AMI_IGroup_disbandGroup(disbandSuccess,disbandFail));
		}
		
		private function disbandSuccess(e:AMI_IGroup_disbandGroup):void
		{
			Log.debug("解散队伍成功");
		}
		
		private function disbandFail(e:Exception):void
		{
			Log.debug("解散队伍失败");
		}
		
		
		/**
		 * 刷新附近队伍 
		 */		
		public function getGroupInfos(entityIdArr:Array):void
		{
			rmi.iGroupPrx.getGroupInfos_async(new AMI_IGroup_getGroupInfos(getInfoSucess,getInfoFail),entityIdArr);
		}
		
		private function getInfoSucess(e:AMI_IGroup_getGroupInfos):void
		{
			Log.debug("获取附近队伍成功");
		}
		
		private function getInfoFail(e:Exception):void
		{
			Log.debug("获取附近队伍失败");
		}
		
		/**
		 * 获取队伍设置 
		 * @param entityIds
		 * 
		 */		
		public function getGroupSetting(entityIds:Array):void
		{
			rmi.iGroupPrx.getGroupInfos_async(new AMI_IGroup_getGroupInfos(getSettingSuccess,getSettingFail),entityIds);
		}
		
		private function getSettingSuccess(e:AMI_IGroup_getGroupInfos):void
		{
			Log.debug("获取设置成功");
		}
		private function getSettingFail(e:Exception):void
		{
			Log.debug("获取设置失败");
		}
		
		/**
		 * 更新队伍设置 
		 */	
		public function updateGroupSetting(groupSetting:SGroupSetting):void
		{
			rmi.iGroupPrx.updateGroupSetting_async(new AMI_IGroup_updateGroupSetting(settingSuccess,settingbandFail,groupSetting),groupSetting);
		}
		
		private function settingSuccess(e:AMI_IGroup_updateGroupSetting):void
		{
			Log.debug("设置队伍成功");
			var groupSetting:SGroupSetting = e.userObject as SGroupSetting;
			_groupCache.groupName = groupSetting.name;
			_groupCache.autoEnter = groupSetting.autoEnter;
			_groupCache.memberInvite = groupSetting.memberInvite;
			MsgManager.showRollTipsMsg(Language.getString(30250));
		}
		
		private function settingbandFail(e:Exception):void
		{
			Log.debug("设置队伍失败");
			MsgManager.showRollTipsMsg(ErrorCode.getErrorStringByCode(e.code));
		}
	}
}
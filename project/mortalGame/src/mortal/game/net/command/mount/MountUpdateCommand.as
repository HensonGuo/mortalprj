package mortal.game.net.command.mount
{
	import Framework.MQ.MessageBlock;
	
	import Message.Public.EEntityAttribute;
	import Message.Public.EMountState;
	import Message.Public.SAttributeUpdate;
	import Message.Public.SPublicMount;
	import Message.Public.SSeqAttributeUpdate;
	
	import com.gengine.debug.Log;
	
	import mortal.game.manager.GameManager;
	import mortal.game.manager.MsgManager;
	import mortal.game.mvc.GameController;
	import mortal.game.mvc.ServerCommand;
	import mortal.game.net.broadCast.BroadCastCall;
	import mortal.game.resource.tableConfig.MountConfig;
	import mortal.game.view.common.ModuleType;
	import mortal.game.view.mount.data.MountData;
	import mortal.game.view.mount.data.MountToolData;
	import mortal.mvc.core.NetDispatcher;
	
	public class MountUpdateCommand extends BroadCastCall
	{
		public function MountUpdateCommand(type:Object)
		{
			super(type);
		}
		
		override public function call(mb:MessageBlock):void
		{
			Log.debug("I have receive MountUpdateCommand");
			
			var msg:SSeqAttributeUpdate = mb.messageBase as SSeqAttributeUpdate;
			var mountData:MountData ;
			
			for each(var attributeUpdate:SAttributeUpdate in msg.updates)
			{
				switch(attributeUpdate.attribute.__value)
				{
					case EEntityAttribute._EAttributeExperience:
						if(attributeUpdate.valueStr != "")
						{
							var array:Array = attributeUpdate.valueStr.split("#");
							mountData = _cache.mount.getMountDataByUid(array[0]);
							mountData.sPublicMount.experience = array[1];
							NetDispatcher.dispatchCmd(ServerCommand.MountExpUpdate,null);
						}
						break;
					case EEntityAttribute._EAttributeExperienceAdd:
						if(attributeUpdate.valueStr != "")
						{
							MsgManager.showRollTipsMsg("+" + attributeUpdate.value/MountConfig.instance.baseMultiple + "X");
						}
						break;
					case EEntityAttribute._EAttributeLevel:
						if(attributeUpdate.valueStr != "")
						{
							mountData = _cache.mount.getMountDataByUid(attributeUpdate.valueStr);
							mountData.sPublicMount.level = attributeUpdate.value;
							NetDispatcher.dispatchCmd(ServerCommand.MountLevelUpdate,null);
						}
						break;
					case EEntityAttribute._EAttributeMountTool:  //坐骑宝具更新
						if(attributeUpdate.valueStr != "")
						{
							var toolArr:Array = attributeUpdate.valueStr.split("#");
							mountData = _cache.mount.getMountDataByUid(toolArr[0]);
							toolArr = JSON.parse(toolArr[1]) as Array;
							for (var i:int ; i<mountData.toolList.length ; i++)
							{
								mountData.toolList[i].level = toolArr[i].tl;
								mountData.toolList[i].exp = toolArr[i].exp;
//								MsgManager.showRollTipsMsg(mountData.toolList[i].name + "+" + toolArr[i].exp/MountConfig.instance.baseMultiple + "X");
							}
						}
						break;
//					case EEntityAttribute._EAttributeMountState:  //坐骑状态更新
//						if(attributeUpdate.value == 0)
//						{
//							var obj:Object = {"code":"","type":"" };
//							NetDispatcher.dispatchCmd(ServerCommand.MountStateChange,obj);
//						}
//						break;
					case EEntityAttribute._EAttributeMountToolExp:  //坐骑宝具经验更新
						break;
					case EEntityAttribute._EAttributeMountExpNum:  //坐骑经验升级次数
						if(attributeUpdate.valueStr != "")
						{
							_cache.mount.currentIndex = attributeUpdate.value;
						}
						break;
					case EEntityAttribute._EAttributeMount:  //坐骑变更 
						mountData = _cache.mount.getMountDataByUid(attributeUpdate.valueStr);
						var spublicMount:SPublicMount = mountData.sPublicMount;
						spublicMount.code = attributeUpdate.value;
						mountData.sPublicMount = spublicMount;
						_cache.mount.newMountData = _cache.mount.getMountDataByUid(spublicMount.uid);
						
						if(!GameController.mount.isViewShow)
						{
							GameManager.instance.popupWindow(ModuleType.Mounts);
						}
						
						NetDispatcher.dispatchCmd(ServerCommand.MountUpdateList,null);
						break;
				}
			}
			
		}
	}
}
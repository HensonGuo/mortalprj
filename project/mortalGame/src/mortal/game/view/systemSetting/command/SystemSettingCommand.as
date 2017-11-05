/**
 * 2014-1-13
 * @author chenriji
 **/
package mortal.game.view.systemSetting.command
{
	import Framework.MQ.MessageBlock;
	
	import Message.Public.SPublicDictIntStr;
	
	import com.gengine.debug.Log;
	
	import flash.utils.Dictionary;
	
	import mortal.common.shortcutsKey.ShortcutsKey;
	import mortal.game.cache.Cache;
	import mortal.game.mvc.ServerCommand;
	import mortal.game.net.broadCast.BroadCastCall;
	import mortal.game.view.common.ClassTypesUtil;
	import mortal.game.view.systemSetting.ClientSetting;
	import mortal.game.view.systemSetting.SystemSetting;
	import mortal.game.view.systemSetting.SystemSettingType;
	import mortal.mvc.core.NetDispatcher;
	
	public class SystemSettingCommand extends BroadCastCall
	{
		public function SystemSettingCommand(type:Object)
		{
			super(type);
		}
		
		public override function call(mb:MessageBlock):void
		{
			var data:Dictionary = (mb.messageBase as SPublicDictIntStr).publicDictIntStr;
			var cData:Array = [];
			// 就算服务器没保存，那么也添加key值对应为 "" 或者 null
			cData[SystemSettingType.SystemKeyMapData] = data[SystemSettingType.SystemKeyMapData];
			cData[SystemSettingType.ShortcutBarData] = data[SystemSettingType.ShortcutBarData];
			cData[SystemSettingType.SystemSetting] = data[SystemSettingType.SystemSetting];
			cData[SystemSettingType.ClientSetting] = data[SystemSettingType.ClientSetting];
			
			for(var key:String in cData)
			{
				var type:int = int(key);
				var jstr:String = data[key] as String;
				switch(type)
				{
					case SystemSettingType.SystemKeyMapData:
						Log.system("SystemSettingType.SystemKeyMapData: " + jstr);
						ShortcutsKey.instance.setServerStr(jstr);
						break;
					case SystemSettingType.ShortcutBarData:
						Log.system("SystemSettingType.ShortcutBarData: " + jstr);
						Cache.instance.shortcut.initData(jstr);
						NetDispatcher.dispatchCmd(ServerCommand.ShortcutBarDataUpdate, null);
						break;
					case SystemSettingType.SystemSetting:
						SystemSetting.instance.initFromServerStr(jstr);
						Log.system("SystemSettingType.SystemSetting: " + jstr);
						NetDispatcher.dispatchCmd(ServerCommand.SystemSettingDataGot, null);
						break;
					case SystemSettingType.ClientSetting:
						ClientSetting.server.initFromServerStr(jstr);
						ClientSetting.local.initFromServerStr(jstr);
						ClientSetting.isInited = true;
						Log.system("SystemSettingType.ClientSetting: " + jstr);
						break;
				}
			}
		}
	}
}
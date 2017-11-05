/**
 * 2014-1-20
 * @author chenriji
 **/
package mortal.game.view.systemSetting
{
	import extend.language.Language;
	
	import mortal.game.events.DataEvent;
	import mortal.game.manager.MsgManager;
	import mortal.game.mvc.EventName;
	import mortal.mvc.core.Dispatcher;
	

	public class ClientSetting
	{
		public function ClientSetting()
		{
		}
		
		public static var server:ClientSettingInfo = new ClientSettingInfo();
		public static var local:ClientSettingInfo = new ClientSettingInfo();
		public static var defualt:ClientSettingInfo = new ClientSettingInfo();
		
		public static var isChanged:Boolean = false;
		public static var isInited:Boolean = false;
		
		public static function save():void
		{
			isChanged = false;
			server.copy(local);
			var str:String = local.getString();
			Dispatcher.dispatchEvent(new DataEvent(EventName.SystemSettingSava,
				{"type":SystemSettingType.ClientSetting, "value":str}));
//			trace("....:" + local.getIsDone(0));
			MsgManager.showRollTipsMsg(Language.getString(20104));
		}
	}
}
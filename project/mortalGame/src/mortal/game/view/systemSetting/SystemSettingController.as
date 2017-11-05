/**
 * 2014-1-13
 * @author chenriji
 **/
package mortal.game.view.systemSetting
{
	import Framework.MQ.MessageBlock;
	
	import Message.Command.EGateCommand;
	import Message.Public.EClientSetType;
	import Message.Public.SPublicDictIntStr;
	
	import com.gengine.core.call.Caller;
	
	import flash.events.TimerEvent;
	import flash.utils.Proxy;
	import flash.utils.Timer;
	
	import mortal.common.shortcutsKey.ShortcutsKey;
	import mortal.game.events.DataEvent;
	import mortal.game.manager.MsgManager;
	import mortal.game.mvc.EventName;
	import mortal.game.mvc.GameProxy;
	import mortal.game.scene3D.layer3D.utils.ThingUtil;
	import mortal.mvc.core.Controller;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.core.NetDispatcher;
	import mortal.mvc.interfaces.IView;
	
	public class SystemSettingController extends Controller
	{
		private var _timer:Timer = new Timer(2000);
		
		private var _systemsettingModule:SystemSettingModule;
		
		public function SystemSettingController()
		{
			super();
		}
		
		protected override function initServer():void
		{
			Dispatcher.addEventListener(EventName.SystemSettingSava, saveClientSettingHandler);
			
			// 每隔几秒，保存一下系统设置
			_timer.addEventListener(TimerEvent.TIMER, onSaveTimer);
			_timer.start();
		}
		
		override protected function initView():IView
		{
			if(!_systemsettingModule)
			{
				_systemsettingModule = new SystemSettingModule();
			}
			return _systemsettingModule;
		}
		
		private function onSaveTimer(evt:TimerEvent):void
		{
			if(ClientSetting.local.isDirty)
			{
				ClientSetting.local.isDirty = false;
				ClientSetting.save();
			}
		}
		
		/**
		 * 保存客户端设置 EClientSetType
		 * @param type
		 * 
		 */		
		private function saveClientSettingHandler(evt:DataEvent):void
		{			
			var type:int = int(evt.data["type"]);
			var str:String = String(evt.data["value"]);
			GameProxy.role.saveClientSetting(type, str);
			if(type == SystemSettingType.SystemKeyMapData)
			{
				MsgManager.showRollTipsMsg("快捷键保存成功");
			}
			else if(type == SystemSettingType.SystemSetting)
			{
				MsgManager.showRollTipsMsg("系统设置保存成功");
				//处理场景人物头顶显示
				ThingUtil.entityUtil.updateHeadContainer();
				ThingUtil.isMoveChange = true;
			}
			
			Dispatcher.dispatchEvent(new DataEvent(EventName.SystemSettingSaved, evt.data));
		}
	}
}
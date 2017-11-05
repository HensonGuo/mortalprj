package mortal.game.view.wizard
{
	import flash.events.Event;
	
	import mortal.component.window.WindowEvent;
	import mortal.game.cache.Cache;
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.mvc.GameProxy;
	import mortal.game.mvc.ServerCommand;
	import mortal.game.proxy.WizardProxy;
	import mortal.game.resource.info.item.ItemData;
	import mortal.game.view.wizard.data.WizardData;
	import mortal.mvc.core.Controller;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.core.NetDispatcher;
	import mortal.mvc.interfaces.IView;
	
	public class WizardController extends Controller
	{
		private var _wizardModule:WizardModule;
		
		private var _wizardProxy:WizardProxy;
		
		private var _wizardCache:WizardCache;
		
		public function WizardController()
		{
			super();
			init();
		}
		
		private function init():void
		{
			_wizardProxy = GameProxy.wizard;
			_wizardCache = Cache.instance.wizard;
		}
		
		override protected function initView():IView
		{
			if(_wizardModule == null)
			{
				_wizardModule=new WizardModule();
				_wizardModule.addEventListener(WindowEvent.SHOW, onWinShow);
				_wizardModule.addEventListener(WindowEvent.CLOSE, onWinClose);
			}
			return _wizardModule;
		}
		
		override protected function initServer():void
		{
			Dispatcher.addEventListener(EventName.WizardItemUse,wizardItemUse);
		}
		
		private function onWinShow(e:Event):void
		{
			NetDispatcher.addCmdListener(ServerCommand.WizardInfoUpde,updateWizardList);
			
			Dispatcher.addEventListener(EventName.UpgradeSoul,upgradeSoul);
		}
		
		private function onWinClose(e:Event):void
		{
			NetDispatcher.removeCmdListener(ServerCommand.WizardInfoUpde,updateWizardList);
			
			Dispatcher.removeEventListener(EventName.UpgradeSoul,upgradeSoul);
		}
		
		/**
		 * 获取精灵信息 
		 * 
		 */		
		private function getPlayerSoul():void
		{
			_wizardProxy.getPlayerSoul(0);
		}
		
		/**
		 * 更新精灵列表
		 * @param data
		 * 
		 */		
		private function updateWizardList(obj:Object):void
		{
			_wizardModule.updateWizardList();
		}
		
		/**
		 * 激活精灵 
		 * @param e
		 * 
		 */		
		private function wizardItemUse(e:DataEvent):void
		{
			_wizardProxy.activeSoul(0,e.data as int);
		}
		
		private function upgradeSoul(e:DataEvent):void
		{
			_wizardProxy.upgradeSoul(e.data as WizardData);
		}
	}
}
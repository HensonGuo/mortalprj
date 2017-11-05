package mortal.game.control
{
	import Message.Public.SPassTo;
	import Message.Public.SPoint;
	
	import flash.geom.Point;
	import flash.utils.setTimeout;
	
	import modules.MapNavBarModule;
	
	import mortal.common.net.CallLater;
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.mvc.ServerCommand;
	import mortal.game.scene3D.events.PlayerEvent;
	import mortal.game.scene3D.player.entity.RolePlayer;
	import mortal.mvc.core.Controller;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.core.NetDispatcher;
	import mortal.mvc.interfaces.IView;
	
	public class MapNavBarController extends Controller
	{
		private var _smallModule:MapNavBarModule;
		
		public function MapNavBarController()
		{
			super();
		}
		
		protected override function initServer():void
		{
			NetDispatcher.addCmdListener(ServerCommand.MapPointUpdate, pointChangeHandler);
//			RolePlayer.instance.addEventListener(PlayerEvent.ServerPoint, pointChangeHandler);
			RolePlayer.instance.addEventListener(PlayerEvent.GIRD_WALK_END, pointChangeHandler);
			Dispatcher.addEventListener(EventName.MapSwitchToNewMap, changeSceneHandler);
		}
		
		private function pointChangeHandler(evt:*=null):void
		{
			if(_smallModule == null)
			{
				return;
			}
			_smallModule.updateToCurrent();
		}
		
		private function changeSceneHandler(evt:*=null):void
		{
			Dispatcher.removeEventListener(EventName.ChangeScene, changeSceneHandler);
			setTimeout(pointChangeHandler, 1200);
		}
		
		override protected function initView():IView
		{
			if(!_smallModule)
			{
				_smallModule = new MapNavBarModule();
			}
			return _smallModule;
		}
		
		
	}
}
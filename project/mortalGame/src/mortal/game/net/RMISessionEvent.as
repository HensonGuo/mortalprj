package mortal.game.net
{
	import Engine.RMI.IRMISessionEvent;
	import Engine.RMI.Session;
	
	import com.gengine.manager.BrowerManager;
	import com.mui.controls.Alert;
	
	import extend.php.PHPSender;
	import extend.php.SenderType;
	
	import flash.display.Sprite;
	
	import mortal.common.global.ParamsConst;
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.mvc.core.Dispatcher;
	
	public class RMISessionEvent implements IRMISessionEvent
	{
		private var alert:Sprite;
		public function RMISessionEvent()
		{
			
		}
		
		public function onAbandon(session:Session):void
		{
			Dispatcher.dispatchEvent(new DataEvent(EventName.SocketClose));
			PHPSender.sendToURLByPHP(SenderType.GameSocketClose,ParamsConst.instance.username);
		}
		
		private function closeHandler( e:int ):void
		{
			if(ParamsConst.instance.actimUrl)
			{
				BrowerManager.instance.getUrl(ParamsConst.instance.actimUrl);
			}
		}
	}
}
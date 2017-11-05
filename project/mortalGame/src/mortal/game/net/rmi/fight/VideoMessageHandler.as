package mortal.game.net.rmi.fight
{
	import mortal.game.net.MessageHandler;
	import mortal.game.net.broadCast.BroadCastManager;
	
	public class VideoMessageHandler extends MessageHandler
	{
		public function VideoMessageHandler()
		{
			super();
		}
		
		override protected function registerCall():void
		{
			_broadCastManager = new BroadCastManager();
			super.registerCall();
		}
	}
}
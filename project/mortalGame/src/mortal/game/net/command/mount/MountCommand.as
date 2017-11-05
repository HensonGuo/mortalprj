package mortal.game.net.command.mount
{
	import Framework.MQ.MessageBlock;
	
	import Message.Game.SSeqMount;
	import Message.Public.SPublicMount;
	
	import com.gengine.debug.Log;
	
	import mortal.game.net.broadCast.BroadCastCall;
	import mortal.game.resource.tableConfig.MountConfig;
	
	public class MountCommand extends BroadCastCall
	{
		public function MountCommand(type:Object)
		{
			super(type);
		}
		
		override public function call(mb:MessageBlock):void
		{
			Log.debug("I have receive MountCommand");
			
			var msg:SSeqMount = mb.messageBase as SSeqMount;
			
			for each(var i:SPublicMount in msg.mounts)
			{
				_cache.mount.addMount(i);
			}
			_cache.mount.sortList();
			
			_cache.mount.currentMount = _cache.mount.getMountDataByUid(msg.rideUid);
			
			_cache.mount.state = msg.state;
		}
	}
}
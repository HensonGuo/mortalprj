package mortal.game.net.command.pack
{
	import Framework.MQ.MessageBlock;
	
	import Message.Game.SBag;
	import Message.Public.EPlayerItemPosType;
	
	import com.gengine.debug.Log;
	
	import mortal.game.cache.packCache.PackPosTypeCache;
	import mortal.game.mvc.ServerCommand;
	import mortal.game.net.broadCast.BroadCastCall;
	import mortal.mvc.core.NetDispatcher;

	public class PackInfoCommand extends BroadCastCall
	{
		/**
		 *  背包信息
		 */
		public function PackInfoCommand( type:Object )
		{
			super(type);
		}
		
		override public function call(mb:MessageBlock):void
		{
			Log.debug("I have receive PackInfoCommand");
			var msg:SBag = mb.messageBase as SBag;
			switch(msg.posType)
			{
				case EPlayerItemPosType._EPlayerItemPosTypeBag:
					_cache.pack.backPackCache.sbag = msg;
					NetDispatcher.dispatchCmd(ServerCommand.BackpackDataChange,null);
					break;
				case EPlayerItemPosType._EPlayerItemPosTypeRole:
					_cache.pack.packRolePackCache.sbag = msg;
					break;
				case EPlayerItemPosType._EPlayerItemPosTypeEmbed:
					(_cache.pack.embedPackCache as PackPosTypeCache).sbag = msg;
					break;
				default:
					break;
			}
		}
	}
}
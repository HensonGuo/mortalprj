package mortal.game.net.command
{
	import Framework.MQ.MessageBlock;
	
	import Message.Public.EEntityAttribute;
	import Message.Public.SAttributeUpdate;
	import Message.Public.SPassTo;
	import Message.Public.SPoint;
	import Message.Public.SSeqAttributeUpdate;
	
	import com.gengine.debug.Log;
	
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.ServerCommand;
	import mortal.game.net.broadCast.BroadCastCall;
	import mortal.mvc.core.Dispatcher;
	import mortal.mvc.core.NetDispatcher;

	public class PositionUpdateCommand extends BroadCastCall
	{
		public function PositionUpdateCommand( type:Object )
		{
			super(type)
		}
		
		private var _passTo:SPassTo;
		
		override public function call(mb:MessageBlock):void
		{
			Log.debug("PositionUpdateCommand");
			var updates:SSeqAttributeUpdate = mb.messageBase as SSeqAttributeUpdate;
			var attUpdate:SAttributeUpdate;
			var passTo:SPassTo = new SPassTo;
			passTo.toPoint = new SPoint();
			passTo.passToId = updates.code;  //更新码
			for each(  attUpdate in updates.updates  )
			{
				
				switch( attUpdate.attribute.__value )
				{
					case EEntityAttribute._EAttributeSpaceId:           //地图
					{
						passTo.mapId = attUpdate.value;
						break;
					}
					case EEntityAttribute._EAttributePointX:       //X
					{
						passTo.toPoint.x = attUpdate.value;
						break;
					}
					case EEntityAttribute._EAttributePointY:           //Y
					{
						passTo.toPoint.y = attUpdate.value;
						break;
					}
//					case EEntityAttribute._EAttributeProxyId:
//					{
//						passTo.proxyId = attUpdate.value;
//						break;
//					}
//					case EEntityAttribute._EAttributeServerId:
//					{
//						passTo.serverId = attUpdate.value;
//						break;
//					}
				}
			}
			Log.debug("mapPassTo:  "+passTo.toPoint.x+":"+passTo.toPoint.y);
			NetDispatcher.dispatchCmd( ServerCommand.MapPointUpdate,passTo);
		}
	}
}

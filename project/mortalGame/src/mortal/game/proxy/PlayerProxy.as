package mortal.game.proxy
{
	import Framework.Util.Exception;
	
	import Message.Game.AMI_IPlayer_findMiniPlayerById;
	import Message.Game.AMI_IPlayer_findMiniPlayerByName;
	import Message.Game.AMI_IPlayer_sendSignature;
	import Message.Public.SMiniPlayer;
	
	import com.gengine.debug.Log;
	
	import mortal.game.mvc.ServerCommand;
	import mortal.mvc.core.NetDispatcher;
	import mortal.mvc.core.Proxy;
	
	/**
	 * @date   2014-2-28 上午11:36:53
	 * @author dengwj
	 */	 
	public class PlayerProxy extends Proxy
	{
		public function PlayerProxy()
		{
			super();
		}
		
		/**
		 * 根据ID查找玩家 
		 * @param roleIds 玩家ID数组
		 * @param type    查找类型  0：好友查找   1：最近联系查找
		 */		
		public function findMiniPlayerById(roleIds:Array,type:int = 0):void
		{
			if(type == 0)
			{
				rmi.iPlayerPrx.findMiniPlayerById_async(new AMI_IPlayer_findMiniPlayerById(getPlayerSucc, getPlayerFail), roleIds);
			}
			else
			{
				rmi.iPlayerPrx.findMiniPlayerById_async(new AMI_IPlayer_findMiniPlayerById(getPlayerSucc3), roleIds);
			}
		}
		
		public function findMiniPlayerByName(roleNames:Array):void
		{
			rmi.iPlayerPrx.findMiniPlayerByName_async(new AMI_IPlayer_findMiniPlayerByName(getPlayerSucc2, getPlayerFail), roleNames);
		}
		
		private function getPlayerSucc(e:AMI_IPlayer_findMiniPlayerById, players:Array):void
		{
			NetDispatcher.dispatchCmd(ServerCommand.GetRoleList, players);
		}
		
		private function getPlayerSucc2(e:AMI_IPlayer_findMiniPlayerByName, players:Array):void
		{
			NetDispatcher.dispatchCmd(ServerCommand.GetRoleList, players);
		}
		
		private function getPlayerSucc3(e:AMI_IPlayer_findMiniPlayerById, players:Array):void
		{
			NetDispatcher.dispatchCmd(ServerCommand.AddToRecent, players);
		}
		
		private function getPlayerFail(e:Exception):void
		{
			Log.debug("获取玩家失败");
			NetDispatcher.dispatchCmd(ServerCommand.GetRoleList, null);
		}
		
		public function sendSignature(sign:String):void
		{
			rmi.iPlayerPrx.sendSignature_async(new AMI_IPlayer_sendSignature(), sign);
		}
	}
}
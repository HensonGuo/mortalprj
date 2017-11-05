/**
 * @heartspeak
 * 2014-1-21 
 */   	

package mortal.game.net.command.buff
{
	import Framework.MQ.MessageBlock;
	
	import Message.BroadCast.SEntityInfo;
	import Message.Public.EBuffUpdateType;
	import Message.Public.SBuff;
	import Message.Public.SBuffUpdate;
	
	import com.gengine.debug.Log;
	import com.gengine.global.Global;
	
	import flash.display.Stage;
	
	import mortal.game.cache.Cache;
	import mortal.game.manager.MouseRuleManager;
	import mortal.game.manager.mouse.MouseThreeClickRule;
	import mortal.game.mvc.GameProxy;
	import mortal.game.mvc.ServerCommand;
	import mortal.game.net.broadCast.BroadCastCall;
	import mortal.game.scene3D.player.entity.RolePlayer;
	import mortal.mvc.core.NetDispatcher;

	public class BuffUpdateCommand extends BroadCastCall
	{
		public function BuffUpdateCommand(type:Object)
		{
			super(type);
		}
		
		/**
		 *数据推入缓存 
		 * @param mb
		 * 
		 */		
		override public function call(mb:MessageBlock):void
		{
			Log.debug("I have receieve BuffUpdateCommand");
			super.call(mb);
			var sBufferMsg:SBuffUpdate = mb.messageBase as SBuffUpdate;
			for(var i:int = 0;i< sBufferMsg.buffs.length;i++)
			{
				Cache.instance.role.roleEntityInfo.updateBuffer((sBufferMsg.buffs[i] as SBuff).buffId,sBufferMsg.op);
//				updateRoleEntityInfoBuffer((sBufferMsg.buffs[i] as SBuff).buffId,sBufferMsg.op);
			}
			_cache.buff.updateBuff(sBufferMsg);
			
			NetDispatcher.dispatchCmd(ServerCommand.BufferUpdate,_cache.buff.showBuffArray);
			
		    if(_cache.buff.buffInfoArray.length > 0)
			{
				MouseRuleManager.addRule(Global.stage,MouseThreeClickRule,threeClickCall);
			
			}
			else
			{
				MouseRuleManager.removeRule(Global.stage,MouseThreeClickRule);
			}
			
			
		}
		
		private function threeClickCall():void
		{
			GameProxy.sceneProxy.dispelBuffSelf();
		}
		
//		/**
//		 * 场景用到的 
//		 * @param value
//		 * @param type
//		 * 
//		 */		
//		public function updateRoleEntityInfoBuffer(value:int,type:int):void
//		{
//			if(RolePlayer.instance.entityInfo.entityInfo)
//			{
//				RolePlayer.instance.updateBuffer(value,type);
//				return;
//			}
//			var i:int;
//			var entityInfo:SEntityInfo = Cache.instance.role.entityInfo;
//			if(!entityInfo.buffs)
//			{
//				entityInfo.buffs = [];
//			}
//			switch(type)
//			{
//				case EBuffUpdateType._EBuffUpdateTypeAdd:
//					entityInfo.buffs.push(value);
//					break;
//				case EBuffUpdateType._EBuffUpdateTypeRemove:
//					var length:int = entityInfo.buffs.length;
//					for(i = length - 1;i>=0;i--)
//					{
//						if(entityInfo.buffs[i] == value)
//						{
//							entityInfo.buffs.splice(i,1);
//						}
//					}
//					break;
//			}
//		}
	}
}
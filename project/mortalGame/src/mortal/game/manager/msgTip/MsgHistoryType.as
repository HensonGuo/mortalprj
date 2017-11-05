/**
 * @heartspeak
 * 2014-4-17 
 */   	

package mortal.game.manager.msgTip
{
	public class MsgHistoryType
	{
		public static const FriendMsg:MsgTypeImpl = new MsgTypeImpl("好友","#fd7bef",0);
		public static const FightMsg:MsgTypeImpl = new MsgTypeImpl("战斗","#ffdd80",0);
		public static const SkillMsg:MsgTypeImpl = new MsgTypeImpl("技能","#ff975e",0);
		public static const GetMsg:MsgTypeImpl = new MsgTypeImpl("获得","#88fa65",0);
		public static const LostMsg:MsgTypeImpl = new MsgTypeImpl("消耗","#ff5e5e",0);
		public static const TaskMsg:MsgTypeImpl = new MsgTypeImpl("任务","#5ed7ff",0);
		
		public function MsgHistoryType()
		{
		}
	}
}
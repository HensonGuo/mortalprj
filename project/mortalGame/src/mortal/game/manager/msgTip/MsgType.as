/**
 * @date	2011-3-16 下午09:50:44
 * @author  jianglang
 * 
 */	

package mortal.game.manager.msgTip
{

	public class MsgType
	{
		public static const DefaultMsg:MsgTypeImpl = new MsgTypeImpl("默认提示","#ffff00",0);
		public static const FightMsg:MsgTypeImpl = new MsgTypeImpl("战斗信息提示","#ff5b5b",0,1);
		public static const WarningMsg:MsgTypeImpl = new MsgTypeImpl("警告提示","#ff0000",3000);
		public static const RealNameMsg:MsgTypeImpl = new MsgTypeImpl("实名制提示","#ff0000",60000);
		public function MsgType()
		{
			
		}
	}
}

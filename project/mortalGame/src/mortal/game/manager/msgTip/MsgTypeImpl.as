/**
 * @date	2011-3-22 下午06:21:21
 * @author  宋立坤
 * 
 */	
package mortal.game.manager.msgTip
{
	public class MsgTypeImpl
	{
		public static const SYSTEMMSG:int = 0;
		public static const FIGHTMSG:int = 1;
		public var name:String;	//名字
		public var color:String;//颜色
		public var delay:int;	//持续时间 毫秒
		public var type:int = 0;//信息类型
		
		public function MsgTypeImpl(n:String,c:String,d:int,t:int = 0)
		{
			name = n;
			color = c;
			delay = d;
			type = t;
		}
	}
}
/**
 * 2014-3-6
 * @author chenriji
 **/
package mortal.game.proxy
{
	import Message.Game.AMI_ICopy_copyWaitingRoomOper;
	import Message.Game.AMI_ICopy_enterCopy;
	import Message.Game.AMI_ICopy_enterCopyWaitingRoom;
	import Message.Game.AMI_ICopy_getCopyWaitingRoomInfo;
	import Message.Game.AMI_ICopy_leftCopy;
	
	import mortal.game.mvc.GameProxy;
	import mortal.game.net.rmi.GameRMI;
	import mortal.mvc.core.Proxy;
	
	public class CopyProxy extends Proxy
	{
		public function CopyProxy()
		{
			super();
		}
		
		/**
		 * 进入副本 
		 * @param copyCode
		 * 
		 */		
		public function enterCopy(copyCode:int):void
		{
			GameRMI.instance.iCopy.enterCopy_async(new AMI_ICopy_enterCopy(), copyCode);
		}
		
		/**
		 * 离开当前副本 
		 * 
		 */		
		public function leaveCopy():void
		{
			GameRMI.instance.iCopy.leftCopy_async(new AMI_ICopy_leftCopy());
		}
		
		/**
		 * 获取组队信息 
		 * @param copyCode
		 * 
		 */		
		public function getGroupCopyTeamInfos(copyCode:int):void
		{
			GameRMI.instance.iCopy.getCopyWaitingRoomInfo_async(new AMI_ICopy_getCopyWaitingRoomInfo(), copyCode);
		}
		
		/**
		 *  进入，退出副本的队伍登记
		 * @param copyCode
		 * @param oper 参考ECopyWaitingOperate
		 * 
		 */		
		public function copyGroupOperate(copyCode:int, oper:int):void
		{
			GameRMI.instance.iCopy.copyWaitingRoomOper_async(new AMI_ICopy_copyWaitingRoomOper(), copyCode, oper);
		}
	}
}
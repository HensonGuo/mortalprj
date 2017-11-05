/**
 * 2014-1-11
 * @author chenriji
 **/
package mortal.game.view.common.cd.effect
{
	public class CDEffectTimerType
	{
		public function CDEffectTimerType()
		{
		}
		/**
		 * 每秒回调一次，剩下多少秒 
		 */		
		public static const Second:String = "CD_Second";
		/**
		 * 每帧回调一次， 当前第几帧
		 */		
		public static const Frame:String = "CD_Frame";
		/**
		 * 每百分之一回调一次， 完成百分之几 
		 */		
		public static const Percentage:String = "CD_Percentage";
		
		public static const FinishedCallback:String = "cd_FinishedCallback";
		public static const StartCallback:String = "cd_StartCallback";
		public static const FrameUpdateCallback:String = "cd_FrameUpdateCallback";
	}		
}
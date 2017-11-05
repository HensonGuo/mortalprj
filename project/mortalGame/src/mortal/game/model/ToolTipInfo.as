/**
 * @date 2011-3-24 上午09:53:45
 * @author  wangyang
 * 
 */  
package mortal.game.model
{
	public class ToolTipInfo
	{
		public var type:String;//tooltip类弄
		public var tooltipData:*;//tooltip数据
		public function ToolTipInfo(type:String, tooltipData:*):void
		{
			this.type = type;
			this.tooltipData = tooltipData;
		}
	}
}
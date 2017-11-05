/**
 * 2014-3-28
 * @author chenriji
 **/
package mortal.game.view.common.tooltip.tooltips.equipment
{
	import mortal.game.resource.info.item.ItemData;

	public class ToolTipStoneData
	{
		public function ToolTipStoneData()
		{
		}
		
		public var itemData:ItemData; // null代表没镶嵌石头
		public var isLocked:Boolean; // true代表未开孔
		public var openTips:String; // 完美+3开启
	}
}
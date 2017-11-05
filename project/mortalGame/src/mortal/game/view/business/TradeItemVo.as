package mortal.game.view.business
{
	import mortal.game.resource.info.item.ItemData;

	/**
	 * 交易物品vo
	 * @author lizhaoning
	 */
	public class TradeItemVo
	{
		public var itemData:ItemData;
		public var amount:int;
		
		public function TradeItemVo(_itemData:ItemData,_amount:int)
		{
			itemData = _itemData;
			amount = _amount;
		}
	}
}
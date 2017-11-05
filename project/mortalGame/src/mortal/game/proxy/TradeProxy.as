package mortal.game.proxy
{
	import Message.Game.AMI_IBusiness_doApply;
	import Message.Game.AMI_IBusiness_doOperation;
	import Message.Game.AMI_IBusiness_updateItem;
	import Message.Game.AMI_IBusiness_updateMoney;
	import Message.Public.EBusinessOperation;
	import Message.Public.EPrictUnit;
	import Message.Public.SEntityId;
	
	import mortal.mvc.core.Proxy;
	
	/**
	 * 
	 * @author lizhaoning
	 */
	public class TradeProxy extends Proxy
	{
		public function TradeProxy()
		{
			super();
		}
		
		/**
		* 执行交易申请
		* @param entityId  实体ID
		* @return 交易事件通过ECmdPublicBusinessApplySuccess返回
		* @exception --失败返回异常 使用异常代码
		*/
		public function doApply(entityId:SEntityId):void
		{
			rmi.iTrade.doApply_async(new AMI_IBusiness_doApply(),entityId);
		}
		
		/**
		* 操作交易过程
		* @param oper        操作 主要有锁定交易 确认交易 取消交易 拒绝交易
		* @param businessId  操作ID
		* @return 交易事件通过ECmdPublicBusiness返回
		* @exception --失败返回异常 使用异常代码
		*/
		public function doOperation(oper : int , businessId : String):void
		{
			rmi.iTrade.doOperation_async(new AMI_IBusiness_doOperation(),EBusinessOperation.convert(oper),businessId ); 
		}
		
		
		/**
		* 更新交易物品
		* @param businessId  交易ID
		* @param itemId  玩家物品
		* @param count   数量   非0表示添加或者更新,0表示移除
		* @return 交易事件通过ECmdPublicBusiness返回
		* @exception --失败返回异常 使用异常代码
		*/
		public function updateItem(businessId : String , itemId : String , count : int):void
		{
			rmi.iTrade.updateItem_async(new AMI_IBusiness_updateItem(),businessId,itemId,count);
		}
		
		/**
		* 更新交易金钱
		* @param businessId  交易ID
		* @param unit        玩家物品
		* @param amount      数量
		* @return 交易事件通过ECmdPublicBusiness返回
		* @exception --失败返回异常 使用异常代码
		*/
		public function updateMoney(businessId : String , unit : EPrictUnit , amount : int):void
		{
			rmi.iTrade.updateMoney_async(new AMI_IBusiness_updateMoney(),businessId,unit,amount);
		}
		
	}
}
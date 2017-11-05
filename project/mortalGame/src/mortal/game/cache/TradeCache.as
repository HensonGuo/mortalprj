package mortal.game.cache
{
	import Message.Public.SBusiness;
	import Message.Public.SBusinessInfo;
	
	import flash.utils.Dictionary;

	/**
	 * 交易缓存
	 * @author lizhaoning
	 */
	public class TradeCache
	{
		/** 交易元宝数超过这个就给予提示 */
		public static const goldRemind:int = 1000;
		
		private var _isTrading:Boolean = false;//是否交易中
		public var usedItems:Dictionary = new Dictionary();//当前选中准备进行交易的物品列表，格式useItems[物品uid] = 物品amount
		
		public var requestList:Vector.<SBusiness>;
		public var currentSbusiness:SBusiness;
		
		public function TradeCache()
		{
			requestList = new Vector.<SBusiness>;
		}

		public function get isTrading():Boolean
		{
			return _isTrading;
		}

		public function set isTrading(value:Boolean):void
		{
			_isTrading = value;
			
			if(isTrading == false)
			{
				usedItems = new Dictionary();
				currentSbusiness = null;
			}
		}
		
		public function get currentBusinessId():String
		{
			return currentSbusiness.businessId;
		}
		
		
		public function addToRequest(sb:SBusiness):void
		{
			for (var i:int = 0; i < requestList.length; i++) 
			{
				if(requestList[i].businessId == sb.businessId)
				{
					requestList.splice(i,1);
					break;
				}
			}
			requestList.push(sb);
		}
		
		
		public function getTargetSBusinessInfo(sb:SBusiness  = null):SBusinessInfo
		{
			if(sb == null)
			{
				sb = currentSbusiness;
			}
			
			if(sb.fromInfo.entityId.id == Cache.instance.role.entityInfo.entityId.id)  //我发起的交易
			{
				return sb.toInfo;
			}
			else  if(sb.toInfo.entityId.id ==Cache.instance.role.entityInfo.entityId.id) //别人给发起的交易
			{
				return sb.fromInfo;
			}
			return null;
		}
	}
}
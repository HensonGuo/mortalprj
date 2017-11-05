/**
 * 2014-2-28
 * @author chenriji
 **/
package mortal.game.view.task.view
{
	import Message.Game.STaskReward;
	import Message.Public.EReward;
	import Message.Public.SReward;
	
	import com.gengine.utils.HTMLUtil;
	import com.gengine.utils.pools.ObjectPool;
	import com.mui.controls.GSprite;
	import com.mui.controls.GTextFiled;
	
	import extend.language.Language;
	
	import flash.display.DisplayObject;
	
	import mortal.common.DisplayUtil;
	import mortal.common.global.GlobalStyle;
	import mortal.game.resource.GameDefConfig;
	import mortal.game.resource.ItemConfig;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.item.BaseItem;
	
	public class TaskReward extends GSprite
	{
		private var _txts:Array;
		private var _items:Array;
		
		public function TaskReward()
		{
			super();
		}
		
		protected override function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			_txts = [];	
			_items = [];
		}
		
		protected override function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			_txts = null;	
			_items = null;
		}
		
		/**
		 * 更新数据 
		 * @param arr [STaskReward]
		 * 
		 */		
		public function updateRewards(arr:Array):void
		{
			var txtNum:int = 0;
			var itemNum:int = 0;
			for(var i:int = 0; i < arr.length; i++)
			{
				var reward:SReward = STaskReward(arr[i]).reward;
				switch(reward.type)
				{
					case EReward._ERewardItem:
						var item:BaseItem = getItem(itemNum);
						item.itemCode = reward.code
						item.amount = reward.num;
						itemNum++;
						break;
					case EReward._ERewardExp:
						var txt:GTextFiled = getTxt(txtNum);
						txt.htmlText = HTMLUtil.addColor(Language.getString(30122)+ ":", GlobalStyle.colorHuang) 
						+ reward.num.toString();
						txtNum++;
						break;
					case EReward._ERewardMoney:
						txt = getTxt(txtNum);
						txt.htmlText = HTMLUtil.addColor(GameDefConfig.instance.getEPrictUnitName(reward.code)+ ":",
							GlobalStyle.colorHuang) + reward.num.toString();
						txtNum++;
						break;
				}
			}
			
			delNotUse(_txts, txtNum);
			delNotUse(_items, itemNum);
			
			updateLayout();
		}
		
		public function updateLayout():void
		{
			for(var i:int = 0; i < _txts.length; i++)
			{
				var txt:GTextFiled = _txts[i];
				txt.y = 0;
				txt.x = i*100;
			}
			for(i = 0; i < _items.length; i++)
			{
				var item:BaseItem = _items[i];
				item.y = 30;
				item.x = i * 40;
			}
		}
		
		private function delNotUse(arr:Array, usedNum:int):void
		{
			if(arr.length <= usedNum)
			{
				return;
			}
			var tmp:int = usedNum;
			for(var i:int = usedNum; i < arr.length; i++)
			{
				DisplayUtil.removeMe(arr[i] as DisplayObject);
			}
			if(tmp < i && arr.length >= tmp)
			{
				arr.splice(tmp);
			}
		}
		
		private function getTxt(index:int):GTextFiled
		{
			var res:GTextFiled = _txts[index];
			if(res == null)
			{
				res = UIFactory.gTextField("", 0, 0, 200, 20, this);
				_txts[index] = res;
			}
			return res;
		}
		
		private function getItem(index:int):BaseItem
		{
			var res:BaseItem = _items[index];
			if(res == null)
			{
				res = ObjectPool.getObject(BaseItem);
				res.isDragAble = false;
				res.isDropAble = false;
				res.isThrowAble = false;
				_items[index] = res;
			}
			return res;
		}
	}
}
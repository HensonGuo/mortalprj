/**
 * @date	2011-3-19 上午10:34:01
 * @author  宋立坤
 * 
 */	
package mortal.game.manager.msgTip
{
	import com.gengine.global.Global;
	import com.gengine.utils.HTMLUtil;
	import com.gengine.utils.pools.ObjectPool;
	import com.mui.containers.GBox;
	import com.mui.containers.globalVariable.GBoxDirection;
	
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import mortal.component.gconst.FilterConst;
	import mortal.game.view.msgtips.TipsItem;
	
	public class MsgTipTextImpl extends Sprite
	{
		private var _items:Array = [];
		private const maxLen:int = 3;
		
		public function MsgTipTextImpl()
		{
			super();
			mouseEnabled = false;
			mouseChildren = false;
		
			this.scrollRect = new Rectangle(0,0,width,height);
		}
		
		/**
		 * 提示消失回调函数
		 * 
		 */
		private function onItemHide(item:TipsItem):void
		{
			// do somting...
		}
		
		/**
		 * 显示一条信息 
		 * @param str
		 * @param color
		 * @param hideDelay
		 * 
		 */
		public function showInfo(str:String,color:String="#ffff00",hideDelay:int=0):void
		{
			var index:int = 0;
			var length:int = _items.length;
			var item:TipsItem;
			if(length >= maxLen)
			{
				item = _items.pop();
				item.dispose();
				ObjectPool.disposeObject(item,TipsItem);
				removeChild(item);
			}
			
			//插一条进去
			item = ObjectPool.getObject(TipsItem);
			item.updateData(str,color,hideDelay,onItemHide);
			index = 0;
			length = _items.length;
			var inserted:Boolean = false;
			var innerItem:TipsItem;
			while(index < length)
			{
				innerItem = _items[index];
				if(!innerItem.hideAble)
				{
					_items.splice(index,0,item);
					inserted = true;
					break;
				}
				index++;
			}
			
			if(inserted == false)
			{
				_items.push(item);
			}
			
			addChild(item);
			updatePy();
		}
		
		/**
		 * 更新y坐标 
		 * 
		 */
		private function updatePy():void
		{
			var index:int
			var length:int = _items.length;
			var lastHeight:int;
			var item:TipsItem;
			while(index < length)
			{
				item = _items[index];
				item.y = height - 2 - lastHeight - item.height;
				
//				if(_items[index].hideAble || (_items[index-1]!=null && _items[index-1].hideAble))
//				{
//					//不变颜色
//				}else
					
				if(index != 0 && !item.colorUpdated)//第一个永远不变颜色
				{
					item.updateColor();
				}

				item.easeIn();
				
				lastHeight += item.height;
				index++;
			}
		}
		
		/**
		 * 舞台改变大小 
		 * 
		 */
		public function stageResize():void
		{
			x = Global.stage.stageWidth - width - 60;
			y = Global.stage.stageHeight - height - 130;
		}
		
		override public function get height():Number
		{
			return 30;
		}
		
		override public function get width():Number
		{
			return 150;
		}
	}
}
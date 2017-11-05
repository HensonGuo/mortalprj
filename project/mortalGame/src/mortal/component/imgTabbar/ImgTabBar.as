/**
 * @date 2011-6-7 下午04:30:52
 * @author  宋立坤
 * 
 */  
package mortal.component.imgTabbar
{
	import com.gengine.utils.pools.ObjectPool;
	import com.mui.containers.GBox;
	import com.mui.containers.globalVariable.GBoxDirection;
	import com.mui.display.ScaleBitmap;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import mortal.component.gconst.ResourceConst;
	import mortal.game.model.GiftInfo;
	import mortal.game.resource.ImagesConst;
	
	public class ImgTabBar extends Sprite
	{
		protected var _border:ScaleBitmap;
		protected var _itemList:GBox;
		protected var _lastSelected:ImgTabBarItem;//上次选择的item
		protected var _itemRander:Class;
		
		protected var _width:int;
		protected var _height:int;
		
		public function ImgTabBar(item:Class,width:int=192,height:int=370)
		{
			super();
			_width = width;
			_height = height;
			mouseEnabled = false;
			_itemRander = item;
			initUI(width,height);
		}
		
		protected function initUI(width:int=192,height:int=370):void
		{
			_border = ResourceConst.getScaleBitmap(ImagesConst.WindowCenterB);
			_border.width = width;
			_border.height = height;
			addChild(_border);
			
			_itemList = new GBox();
			_itemList.mouseEnabled = false;
			_itemList.direction = GBoxDirection.VERTICAL;
			_itemList.verticalGap = -4;
			addChild(_itemList);
			_itemList.addEventListener(MouseEvent.CLICK,onMouesClickHandler);
		}
		
		/**
		 * 列表点击事件 
		 * @param event
		 * 
		 */
		private function onMouesClickHandler(event:MouseEvent):void
		{
			var target:ImgTabBarItem = event.target as ImgTabBarItem;
			if(target != null && target != _lastSelected)
			{
				target.selected(true);
				if(_lastSelected != null)
				{
					_lastSelected.selected(false);
				}
				_lastSelected = target;
			}
			else
			{
				event.stopImmediatePropagation();
			}
		}
		
		/**
		 * 选择某一项 
		 * @param index
		 */
		public function selectedByIndex(index:int):ImgTabBarItem
		{
			if(index >= 0 && index < _itemList.numChildren)
			{
				var target:ImgTabBarItem = _itemList.getChildAt(index) as ImgTabBarItem;
				if(target && target != _lastSelected)
				{
					target.selected(true);
					if(_lastSelected != null)
					{
						_lastSelected.selected(false);
					}
					_lastSelected = target;
				}
				return target;
			}
			return null;
		}
		
		/**
		 * 拿到某一个按钮 
		 * @param index
		 * @return 
		 * 
		 */		
		public function getByIndex(index:int):ImgTabBarItem
		{
			if(index >= 0 && index < _itemList.numChildren)
			{
				return _itemList.getChildAt(index) as ImgTabBarItem;
			}
			return null;
		}
		
		
		/**
		 * 功能列表 
		 * @param list
		 * 
		 */
		public function updateData(list:Array):void
		{
			dispose();
			
			var index:int;
			var length:int = list.length;
			var info:Object;
			var item:ImgTabBarItem;
			while(index < length)
			{
				info = list[index];
				item = ObjectPool.getObject(_itemRander);
				item.updateData(info);
				item.index = index + 1;
				_itemList.addChild(item);
				if(index == 0 && _lastSelected == null)
				{
					item.selected(true);
					_lastSelected = item;
				}
				index++;
			}
			_itemList.invalidate();
		}
		
		/**
		 * 释放 
		 * 
		 */
		public function dispose():void
		{
			var item:ImgTabBarItem;
			while(_itemList.numChildren > 0)
			{
				item = _itemList.removeChildAt(0) as ImgTabBarItem;
				item.dispose();
				ObjectPool.disposeObject(item,_itemRander);
			}
			
			if(_lastSelected != null)
			{
				_lastSelected.selected(false);
			}
			_lastSelected = null; 
		}
		
		public function get lastSelected():ImgTabBarItem
		{
			return _lastSelected;
		}
		
		override public function get width():Number
		{
			return _width;
		}
	}
}
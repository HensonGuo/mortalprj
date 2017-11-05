/**
 * @heartspeak
 * 2014-2-26 
 */   	

package com.mui.controls
{
	import com.gengine.debug.Log;
	import com.mui.containers.globalVariable.GBoxDirection;
	import com.mui.core.IFrUI;
	import com.mui.core.IFrUIContainer;
	import com.mui.events.MuiEvent;
	import com.mui.utils.UICompomentPool;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class GTabBar2 extends GSprite
	{
		public function GTabBar2()
		{
			super();
		}
		
		protected var _selectIndex:int = -1;
		protected var _direction:String;
		protected var _gap:Number = 0;
		protected var _cellWidth:Number = 0;
		protected var _cellHeight:Number = 0;
		protected var _dataProvider:Array;
		protected var vctabBar2Cell:Vector.<ITabBar2Cell> = new Vector.<ITabBar2Cell>();
		protected var _cellRenderer:Class;
		
		/**
		 * 通过数据获取cell 
		 * @param obj
		 * @return 
		 * 
		 */		
		public function itemToCell(obj:*):ITabBar2Cell
		{
			if(_dataProvider)
			{
				for(var i:int = 0;i < _dataProvider.length;i++)
				{
					if(_dataProvider[i] == obj)
					{
						return vctabBar2Cell[i];
					}
				}
			}
			return null;
		}
		
		public function get dataProvider():Array
		{
			return _dataProvider;
		}

		public function set dataProvider(value:Array):void
		{
			_dataProvider = value;
			var max:int = vctabBar2Cell.length;
			max = value.length > max?max:value.length;
			var i:int;
			//已有的直接赋值
			for(i = 0;i < max;i++)
			{
				vctabBar2Cell[i].data = value[i];
			}
			//超过的销毁
			for(i = max;i < vctabBar2Cell.length;i++)
			{
				vctabBar2Cell[i].dispose();
			}
			vctabBar2Cell.length = max;
			for(i = max;i < value.length;i++)
			{
				vctabBar2Cell[i] = UICompomentPool.getUICompoment(_cellRenderer);
				if(vctabBar2Cell[i] is IFrUIContainer)
				{
					(vctabBar2Cell[i] as IFrUIContainer).createDisposedChildren();
				}
				vctabBar2Cell[i].data = value[i];
				(vctabBar2Cell[i] as IFrUI).configEventListener(MouseEvent.CLICK,onClickTabBarCell);
				(vctabBar2Cell[i] as IFrUI).configEventListener(MouseEvent.ROLL_OVER,onRollOverTabBarCell);
				(vctabBar2Cell[i] as IFrUI).configEventListener(MouseEvent.ROLL_OUT,onRollOutTabBarCell);
				this.addChild(vctabBar2Cell[i] as DisplayObject);
			}
			
			if(value.length > 0)
			{
				selectIndex = 0;
			}
			else
			{
				selectIndex = -1;
			}
			
			updatePos();
		}
		
		protected function updatePos():void
		{
			var i:int;
			if(_direction == GBoxDirection.HORIZONTAL)
			{
				for(i = 0;i < vctabBar2Cell.length;i++)
				{
					(vctabBar2Cell[i] as Sprite).x = (_cellWidth + _gap) * i;
				}
			}
			else
			{
				for(i = 0;i < vctabBar2Cell.length;i++)
				{
					(vctabBar2Cell[i] as Sprite).y = (_cellHeight + _gap) * i;
				}
			}
		}
		
		/**
		 * 点击 
		 * @param e
		 * 
		 */		
		protected function onClickTabBarCell(e:MouseEvent):void
		{
			selectIndex = this.getChildIndex(e.currentTarget as DisplayObject);
		}
		
		/**
		 * 移上去
		 * @param e
		 * 
		 */		
		protected function onRollOverTabBarCell(e:MouseEvent):void
		{
			if(selectIndex != this.getChildIndex(e.currentTarget as DisplayObject))
			{
				(e.currentTarget as ITabBar2Cell).over();
			}
		}
		
		/**
		 * 移出 
		 * @param e
		 * 
		 */		
		protected function onRollOutTabBarCell(e:MouseEvent):void
		{
			if(selectIndex != this.getChildIndex(e.currentTarget as DisplayObject))
			{
				(e.currentTarget as ITabBar2Cell).out();
			}
		}
		
		/**
		 * 设置选择的index 
		 * @param value
		 * 
		 */		
		public function set selectIndex(value:int):void
		{
			if(value == _selectIndex)
			{
				return;
			}
			if(_selectIndex >= 0)
			{
				(this.getChildAt(_selectIndex) as ITabBar2Cell).selected = false;
			}
			_selectIndex = value;
			if(_selectIndex >= 0)
			{
				(this.getChildAt(_selectIndex) as ITabBar2Cell).selected = true;
			}
			dispatchEvent(new MuiEvent(MuiEvent.GTABBAR_SELECTED_CHANGE,_selectIndex));
		}
		
		/**
		 * 获取当前选中的序号 
		 * @return 
		 * 
		 */
		public function get selectIndex():int
		{
			return _selectIndex;
		}
		
		public function get direction():String
		{
			return _direction;
		}
		
		public function set direction(value:String):void
		{
			if (_direction == value)
				return;
			
			_direction = value;
		}
		
		public function set gap(value:Number):void
		{
			_gap = value;
		}
		
		public function set cellWidth(value:Number):void
		{
			_cellWidth = value;
		}
		
		public function set cellHeight(value:Number):void
		{
			_cellHeight = value;
		}
		
		public function set cellRenderer(value:Class):void
		{
			_cellRenderer = value;
		}
		
		override public function dispose(isReuse:Boolean=true):void
		{
			super.dispose(isReuse);
			var i:int = vctabBar2Cell.length - 1;
			for(;i >=0;i--)
			{
				vctabBar2Cell[i].dispose();
				(vctabBar2Cell[i] as Sprite).removeEventListener(MouseEvent.CLICK,onClickTabBarCell);
				(vctabBar2Cell[i] as Sprite).removeEventListener(MouseEvent.ROLL_OVER,onRollOverTabBarCell);
				(vctabBar2Cell[i] as Sprite).removeEventListener(MouseEvent.ROLL_OUT,onRollOutTabBarCell);
			}
			vctabBar2Cell.length = 0;
			_selectIndex = -1;
			_gap = 0;
			_cellWidth = 0;
			_cellHeight = 0;
			_dataProvider = null;
			_cellRenderer = null;
		}
	}
}
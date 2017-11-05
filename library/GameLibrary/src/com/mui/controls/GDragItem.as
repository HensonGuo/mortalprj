package com.mui.controls
{
	/**
	 * 可以拖动或者可以被其他拖动物品放下的物品基类
	 */
	import com.gengine.global.Global;
	import com.mui.core.IFrUI;
	import com.mui.manager.IDragDrop;
	import com.mui.manager.IToolTipItem;
	import com.mui.manager.ToolTipsManager;
	import com.mui.utils.ObjEventListerTool;
	import com.mui.utils.UICompomentPool;
	
	import fl.core.UIComponent;
	
	import flash.events.Event;
	
	public class GDragItem extends UIComponent implements IDragDrop,IToolTipItem,IFrUI
	{
		public function GDragItem()
		{
			this.addEventListener(Event.ADDED_TO_STAGE,judgeToolTip);
			this.addEventListener(Event.REMOVED_FROM_STAGE,judgeToolTip);
		}
		
		protected function judgeToolTip(e:Event = null):void
		{
			if(e && e.type == Event.ADDED_TO_STAGE && toolTipData 
				|| !e && toolTipData && Global.stage.contains(this))
			{
				ToolTipsManager.register(this);
			}
			else
			{
				ToolTipsManager.unregister(this);
			}
		}
		
		/**
		 * 判断此物品是否能拖动
		 */
		public function get isDragAble():Boolean
		{
			return true;
		}
		
		/**
		 * 判断此物品是否可以能被拖动物品放下
		 */
		public function get isDropAble():Boolean
		{
			return true;
		}
		
		/**
		 *在拖动其他物品到些物品上面时，检测是否可以放下
		 */
		public function canDrop(dragItem:IDragDrop, dropItem:IDragDrop):Boolean
		{
			return true;
		}
		
		/**
		 * 判断此物品是否可以能被丢弃
		 */
		public function get isThrowAble():Boolean
		{
			return true;
		}
		
		/**
		 * 拖动物品的数据
		 */
		public function get dragSource():Object
		{
			return {};
		}
		
		/**
		 * 拖动物品的数据
		 */
		public function set dragSource(value:Object):void
		{
			
		}
		private var _toolTipData:*;
		public function get toolTipData():*
		{
			// TODO Auto-generated method stub
			return _toolTipData;
		}

		public function set toolTipData(value:*):void
		{
			_toolTipData=value;
			judgeToolTip();
		}
		
		public function configEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			ObjEventListerTool.addObjEvent(this,type,listener,useCapture);
			addEventListener(type,listener,useCapture,priority,useWeakReference);
		}
		
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
			ObjEventListerTool.removeObjEvent(this,type,listener,useCapture);
			super.removeEventListener(type,listener,useCapture);
		}
		
		public function dispose(isReuse:Boolean=true):void
		{
			ObjEventListerTool.delObjEvent(this);
			if(this.parent)
			{
				this.parent.removeChild(this);
			}
			if(isReuse)
			{
				UICompomentPool.disposeUICompoment(this);
			}
		}
	}
}
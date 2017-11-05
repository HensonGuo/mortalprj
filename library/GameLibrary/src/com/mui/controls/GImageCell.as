/**
 * @date	Mar 9, 2011 6:30:30 PM
 * @author  huangliang
 * 
 */
package com.mui.controls
{
	import com.gengine.core.IDispose;
	import com.gengine.global.Global;
	import com.mui.core.IFrUI;
	import com.mui.manager.IToolTipItem;
	import com.mui.manager.ToolTipsManager;
	import com.mui.utils.ObjEventListerTool;
	import com.mui.utils.UICompomentPool;
	
	import fl.controls.listClasses.ImageCell;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	/**
	 * 
	 * @author huangliang
	 */
	public class GImageCell extends ImageCell implements IToolTipItem,IFrUI
	{
		/**
		 * 
		 */
		public function GImageCell()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE,judgeToolTip);
			this.addEventListener(Event.REMOVED_FROM_STAGE,judgeToolTip);
		}

		protected function judgeToolTip(e:Event = null):void
		{
			if(e && e.type == Event.ADDED_TO_STAGE && (toolTipData || _toolTipDataFunction)
				|| !e && (toolTipData || _toolTipDataFunction) && Global.stage.contains(this))
			{
				ToolTipsManager.register(this);
			}
			else
			{
				ToolTipsManager.unregister(this);
			}
		}
		
		public function get toolTipData():*
		{
			// TODO Auto-generated method stub
			return _tooltipData;
		}

		private var _tooltipData:*;
		
		public function set toolTipData(value:*):void
		{
//			// TODO Auto-generated method stub
//			if(value == null || value==""){
//				ToolTipsManager.unregister(this);
//			}else{
//				ToolTipsManager.register(this);
//			}
			_tooltipData = value;
			judgeToolTip();
		}
		
		protected var _toolTipDataFunction:Function;//可以自定义tooltip数据获取函数 
		
		public function set toolTipDataFunction(fun:Function):void
		{
//			if(fun == null){
//				ToolTipsManager.unregister(this);
//			}else{
//				ToolTipsManager.register(this);
//			}
			_toolTipDataFunction = fun;
			judgeToolTip();
		}
		
		public function get toolTipDataFunction():Function
		{
			return _toolTipDataFunction;
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
			_toolTipDataFunction = null;
			ObjEventListerTool.delObjEvent(this);
//			var childrenLength:int = this.numChildren;
//			var i:int;
//			var o:DisplayObject;
//			for(i = childrenLength - 1;i>=0;i-- )
//			{
//				o = this.getChildAt(i);
//				if(o is IDispose)
//				{
//					this.removeChild(o);
//					(o as IDispose).dispose(isReuse);
//				}
//			}
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
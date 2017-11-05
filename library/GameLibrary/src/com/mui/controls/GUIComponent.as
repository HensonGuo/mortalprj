package com.mui.controls
{
	import com.gengine.core.IDispose;
	import com.gengine.global.Global;
	import com.mui.core.IFrUI;
	import com.mui.manager.IToolTipItem;
	import com.mui.manager.ToolTipsManager;
	import com.mui.skins.SkinManager;
	import com.mui.utils.ObjEventListerTool;
	import com.mui.utils.UICompomentPool;
	
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	public class GUIComponent extends UIComponent  implements IToolTipItem,IFrUI
	{
		private var _uiDisposeVec:Vector.<IDispose> = new Vector.<IDispose>();
		
		public const CLASSNAME:String = "UIComponent";
		
		public function GUIComponent()
		{
			super();
			//_styleName = CLASSNAME;
			this.addEventListener(Event.ADDED_TO_STAGE,judgeToolTip);
			this.addEventListener(Event.REMOVED_FROM_STAGE,judgeToolTip);
		}
		
		protected function pushUIToDisposeVec(ui:IDispose):void
		{
			_uiDisposeVec.push(ui);
		}
		
		final override protected function configUI():void
		{
			//不在这里初始化background,因为要在drawBackground函数中设置
			super.configUI();
			createChildren();
		}
		
		private var _toolTipData:*;
		
		public function get toolTipData():*
		{
			return _toolTipData;
		}
		
		public function set toolTipData( value:* ):void
		{
			_toolTipData = value;
			judgeToolTip();
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
		
		private var _styleName:String;
		
		public function get styleName():String
		{
			return _styleName;
		}
		
		private var _isStyleChange:Boolean = false;
		public function set styleName( value:String ):void
		{
			if( _styleName != value )
			{
				_styleName = value;
				invalidate(InvalidationType.STYLES);
				_isStyleChange = true;
			}
		}
		
		
		final override protected function draw():void
		{
			//样式发生了改变
			if (isInvalid(InvalidationType.STYLES)) 
			{
				if( _isStyleChange )
				{
					SkinManager.setComponentStyle(this,_styleName);
					_isStyleChange = false;
				}
				updateStyle();
			}
			// 数据发生改变
			if (isInvalid(InvalidationType.DATA)) 
			{
				updateDate();
			}
			if( isInvalid(InvalidationType.SIZE) )
			{
				updateSize();
			}
			//布局发生改变
			if (isInvalid(InvalidationType.SIZE,InvalidationType.SELECTED,InvalidationType.DATA,InvalidationType.ALL)) 
			{
				updateDisplayList();
			}
			try
			{
				super.draw();
			}
			catch(e:Error){};
		}
		
		/**
		 * 创建组件的子对象 
		 * 
		 */
		protected function createChildren():void
		{
			
		}
		/**
		 * 样式发生改变时候更新 
		 * 
		 */
		protected function updateStyle():void
		{
			
		}
		
		protected function updateSize():void
		{
			
		}
		
		/** 
		 *  
		 * 
		 */
		protected function updateDate():void
		{
			
		}
		
		protected function updateDisplayList():void
		{
			
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
		
		public function disposeChild(isReuse:Boolean=true):void
		{
			var childrenLength:int = this.numChildren;
			var i:int;
			var o:DisplayObject;
			for(i = childrenLength - 1;i>=0;i-- )
			{
				o = this.getChildAt(i);
				if(o is IDispose)
				{
					this.removeChild(o);
					(o as IDispose).dispose(isReuse);
				}
			}
		}
		
		protected function disposeChildren(isReuse:Boolean=true):void
		{
			//释放UI
			for each(var obj:IDispose in _uiDisposeVec)
			{
				obj.dispose(isReuse);
			}
			_uiDisposeVec = new Vector.<IDispose>();
		}
		
		public function dispose(isReuse:Boolean=true):void
		{
			disposeChildren(isReuse);
			ObjEventListerTool.delObjEvent(this);
//			disposeChild(isReuse);
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
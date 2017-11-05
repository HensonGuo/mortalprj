package com.mui.controls
{
	import com.gengine.global.Global;
	import com.mui.core.IFrUI;
	import com.mui.manager.IToolTipItem;
	import com.mui.manager.ToolTipsManager;
	import com.mui.skins.SkinManager;
	import com.mui.utils.ObjEventListerTool;
	import com.mui.utils.UICompomentPool;
	
	import fl.controls.ComboBox;
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	
	import flash.events.Event;

	public class GComboBox extends ComboBox implements IToolTipItem,IFrUI
	{
		
		public const CLASSNAME:String = "ComboBox";
		
		public function GComboBox()
		{
			super();
			_styleName = CLASSNAME;
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
		
		final override protected function configUI():void
		{
			//不在这里初始化background,因为要在drawBackground函数中设置
			super.configUI();
			createChildren();
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
			if (isInvalid(InvalidationType.SIZE,InvalidationType.SELECTED,InvalidationType.DATA)) 
			{
				updateDisplayList(  );
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
		
		public function set textColor(color:uint):void
		{
			this.textField.textField.textColor = color;
		}
		
		public function dispose(isReuse:Boolean=true):void
		{
			this.removeAll();
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
package com.mui.controls
{
	import com.gengine.core.IDispose;
	import com.mui.controls.scrollBarResizable.ResizableScrollBar;
	import com.mui.controls.scrollBarResizable.ScrollBarResizableScrollPane;
	import com.mui.core.IFrUI;
	import com.mui.skins.SkinManager;
	import com.mui.utils.ObjEventListerTool;
	import com.mui.utils.UICompomentPool;
	
	import fl.containers.ScrollPane;
	import fl.controls.ScrollBar;
	import fl.controls.ScrollBarDirection;
	import fl.controls.ScrollPolicy;
	import fl.core.InvalidationType;
	import fl.events.ScrollEvent;
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	public class GScrollPane extends ScrollPane implements IFrUI
	{
		private var verticalScrollBarPosition:String = GScrollPane.SCROLLBARPOSITIONRIGHT;
		private var _highPerformance:Boolean;
		public static const SCROLLBARPOSITIONLEFT:String = "left";
		public static const SCROLLBARPOSITIONRIGHT:String = "right";
		public const CLASSNAME:String = "ScrollPane";
		
		public function GScrollPane()
		{
			super();
			_styleName = CLASSNAME;
			this.highPerformance = true;
		}
		
		//final override protected function configUI():void
		//{
			//不在这里初始化background,因为要在drawBackground函数中设置
		//	super.configUI();
		//	createChildren();
		//}
		
		public function get highPerformance():Boolean
		{
			return _highPerformance;
		}
		
		public function set highPerformance(ifH:Boolean):void
		{
			this.mouseEnabled = !ifH;
			this.contentClip.mouseEnabled = !ifH;
			this.useBitmapScrolling = ifH;
			
		}
		
		private var _styleName:String = "";
		
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
		
		
		override protected function draw():void
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
			
			if( isInvalid(InvalidationType.SCROLL) )
			{
//				setVerticalScrollBarPosition();
			}
			//布局发生改变
			if (isInvalid(InvalidationType.ALL)) 
			{
				updateDisplayList();
			}
			
			//horizontalScrollBar.setSize(__width,height);
			//verticalScrollBar.setSize(__width,height);
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
		
		/**
		 * 设置滚动条的宽度 
		 * @param __width
		 * 
		 */		
		
		public function setScrollBarSize(__width:Number):void
		{
			_horizontalScrollBar.setSize(__width,height);
			_verticalScrollBar.setSize(__width,height);
			//draw();
		}
		
		override protected function drawLayout():void 
		{
			super.drawLayout();
			setVerticalScrollBarPosition();
		}
		
		private var verticalScrollBarWidth:Number = 13;
		
		public function setVerticalScrollBarWidth(value:Number):void
		{
			verticalScrollBarWidth = value;
		}
		
		public function set verticalScrollBarPos(value:String):void
		{
			verticalScrollBarPosition = value!=GScrollPane.SCROLLBARPOSITIONLEFT?GScrollPane.SCROLLBARPOSITIONRIGHT:GScrollPane.SCROLLBARPOSITIONLEFT;
			invalidate(InvalidationType.SCROLL);
		}
		
		private function setVerticalScrollBarPosition():void
		{
			if( vScrollBar )
			{
				if(verticalScrollBarPosition == GScrollPane.SCROLLBARPOSITIONRIGHT)
				{
					_verticalScrollBar.x = width - verticalScrollBarWidth;
				}
				else
				{
					_verticalScrollBar.x = 0;
					contentClip.x += verticalScrollBarWidth;
				}
			}
			_verticalScrollBar.visible = vScrollBar;
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
			verticalScrollBarWidth = 15;
			verticalScrollBarPosition = GScrollPane.SCROLLBARPOSITIONRIGHT;
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
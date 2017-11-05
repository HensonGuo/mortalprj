/**
 * @date 2011-3-28 上午11:43:25
 * @author  wangyang
 *
 */
package com.mui.controls
{
	import com.gengine.core.IDispose;
	import com.mui.core.IFrUI;
	import com.mui.skins.SkinManager;
	import com.mui.utils.ObjEventListerTool;
	import com.mui.utils.UICompomentPool;

	import fl.controls.ScrollBar;
	import fl.core.InvalidationType;

	import flash.display.DisplayObject;

	public class GScrollBar extends ScrollBar implements IFrUI
	{
		public const CLASSNAME:String = "";

		public function GScrollBar()
		{
			super();
			_styleName = CLASSNAME;
		}

		private var _styleName:String = "";

		public function get styleName():String
		{
			return _styleName;
		}

		private var _isStyleChange:Boolean = false;

		public function set styleName(value:String):void
		{
			if (_styleName != value)
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
				if (_isStyleChange)
				{
					SkinManager.setComponentStyle(this , _styleName);
					_isStyleChange = false;
				}
				updateStyle();
			}
			// 数据发生改变
			if (isInvalid(InvalidationType.DATA))
			{
				updateDate();
			}
			if (isInvalid(InvalidationType.SIZE))
			{
				updateSize();
			}

			if (isInvalid(InvalidationType.SCROLL))
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
//				//代码从ScrollBar类拷贝过来，将常数换成与width有关的变量，以使得在调用setSize或者设置width的时候，可以改变宽度
//				if (isInvalid(InvalidationType.SIZE))
//				{
//					var h:Number = super.height;
//
//					//滚动条按钮按宽度进行设置，源程序写死了一个常数，导致该大小无法改变，有兴趣的朋友可以在此基础上进行修改，让按钮区域可以不呈现为正方形。
//					downArrow.setSize(_width , _width);
//					upArrow.setSize(_width , _width);
//					downArrow.move(0 , Math.max(upArrow.height , h - downArrow.height));
//
//					//轨道宽度也要进行设置
//					track.move(0 , _width);
//					track.setSize(_width , Math.max(0 , h - (downArrow.height + upArrow.height)));
//					thumb.setSize(_width , thumb.height);
//					updateThumb();
//				}
//				if (isInvalid(InvalidationType.STYLES , InvalidationType.STATE))
//				{
//					setStyles();
//				}
//				// Call drawNow on nested components to get around problems with nested render events:
//				downArrow.drawNow();
//				upArrow.drawNow();
//				track.drawNow();
//				thumb.drawNow();
//				validate();
			}
			catch (e:Error)
			{
			}
			;
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

		public function configEventListener(type:String , listener:Function , useCapture:Boolean = false , priority:int = 0 , useWeakReference:Boolean = false):void
		{
			ObjEventListerTool.addObjEvent(this , type , listener , useCapture);
			addEventListener(type , listener , useCapture , priority , useWeakReference);
		}

		override public function removeEventListener(type:String , listener:Function , useCapture:Boolean = false):void
		{
			ObjEventListerTool.removeObjEvent(this , type , listener , useCapture);
			super.removeEventListener(type , listener , useCapture);
		}

		public function dispose(isReuse:Boolean = true):void
		{
			ObjEventListerTool.delObjEvent(this);
			var childrenLength:int = this.numChildren;
			var i:int;
			var o:DisplayObject;
			for (i = childrenLength - 1 ; i >= 0 ; i--)
			{
				o = this.getChildAt(i);
				if (o is IDispose)
				{
					this.removeChild(o);
					(o as IDispose).dispose(isReuse);
				}
			}
			if (this.parent)
			{
				this.parent.removeChild(this);
			}
			if (isReuse)
			{
				UICompomentPool.disposeUICompoment(this);
			}
		}
	}

}

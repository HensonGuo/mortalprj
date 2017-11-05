package com.mui.controls
{
	import com.gengine.core.IDispose;
	import com.gengine.global.Global;
	import com.mui.core.IFrUI;
	import com.mui.display.ScaleBitmap;
	import com.mui.manager.IToolTipItem;
	import com.mui.manager.ToolTipsManager;
	import com.mui.skins.SkinManager;
	import com.mui.utils.ObjEventListerTool;
	import com.mui.utils.UICompomentPool;
	
	import fl.controls.BaseButton;
	import fl.controls.NumericStepper;
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	[Style(name="maxBtnDownSkin", type="Class")]
	[Style(name="maxBtnOverSkin", type="Class")]
	[Style(name="maxBtnUpSkin", type="Class")]
	
	[Style(name="minBtnDownSkin", type="Class")]
	[Style(name="minBtnOverSkin", type="Class")]
	[Style(name="minBtnUpSkin", type="Class")]
	
	[Style(name="bg", type="Class")]
	
	public class GNumericStepper extends NumericStepper implements IToolTipItem,IFrUI
	{
		
		public const CLASSNAME:String = "List";
		
		static public const SetMaxNum:String = "SetMaxNum";
		
		static public const SetMaxAndMinNum:String = "SetMaxAndMinNum";
		
		static public const NoMaxAndMin:String = "NoMaxAndMin";
		
		private var _maxNumBtn:BaseButton;
		
		private var _minNumBtn:BaseButton;
		
		private var _bg:ScaleBitmap;
		
		public var style:String = "SetMaxNum";
		
		public var needDispatchEvent:Boolean;//是否手动更改text文本时调度 Event.CHANGE事件
		
		protected static const MAX_BTN_STYLES:Object = {
			downSkin:"maxBtnDownSkin",
			overSkin:"maxBtnOverSkin",
			upSkin:"maxBtnDownSkin"
		};
		
		protected static const MIN_BTN_STYLES:Object = {
			downSkin:"minBtnDownSkin",
			overSkin:"minBtnOverSkin",
			upSkin:"minBtnDownSkin"
		};
		
		public function GNumericStepper()
		{
			super();
			_styleName = CLASSNAME;
			this.imeMode = null;
			this.addEventListener(Event.ADDED_TO_STAGE,judgeToolTip);
			this.addEventListener(Event.REMOVED_FROM_STAGE,judgeToolTip);
		}
		
		final override protected function configUI():void
		{
			//不在这里初始化background,因为要在drawBackground函数中设置
			super.configUI();
			createChildren();
			
			_maxNumBtn = new BaseButton();
			copyStylesToChild(_maxNumBtn, MAX_BTN_STYLES);
//			_maxNumBtn.styleName = "numMax_upSkin";
			_maxNumBtn.autoRepeat = true;
			_maxNumBtn.setSize(20, 20);
			_maxNumBtn.focusEnabled = false;
			addChild(_maxNumBtn);
			_maxNumBtn.addEventListener(MouseEvent.CLICK,setMaxNum);
			
			_minNumBtn = new BaseButton();
			copyStylesToChild(_minNumBtn, MIN_BTN_STYLES);
			_minNumBtn.autoRepeat = true;
			_minNumBtn.setSize(20, 20);
			_minNumBtn.focusEnabled = false;
			addChild(_minNumBtn);
			_minNumBtn.addEventListener(MouseEvent.CLICK,setMinNum);
			
			_bg = new ScaleBitmap();
			addChild(_bg);
			
			
		}
		
		private function setMaxNum(e:MouseEvent):void
		{
			setValue(maximum);
		}
		
		private function setMinNum(e:MouseEvent):void
		{
			setValue(minimum);
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
		
		override protected function setStyles():void {
			copyStylesToChild(downArrow, DOWN_ARROW_STYLES);
			copyStylesToChild(upArrow, UP_ARROW_STYLES);
			copyStylesToChild(inputField, TEXT_INPUT_STYLES);
			
			copyStylesToChild(_maxNumBtn, MAX_BTN_STYLES);
			copyStylesToChild(_minNumBtn, MIN_BTN_STYLES);
		}

		protected var _toolTipData:*;
		
		public function get toolTipData():*
		{
			// TODO Auto-generated method stub
			return _toolTipData;
		}

		public function set toolTipData(value:*):void
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
		
		/**
		 * 文本发生更改时 
		 * @param event
		 * 
		 */		
		override protected function onTextChange(event:Event):void 
		{
			if( needDispatchEvent )
			{
				setValue( Number( inputField.text ));
			}
			else
			{
				super.onTextChange( event );
			}
			event.stopPropagation();
			checkValue();
		}
		
		override protected function setValue(arg0:Number, arg1:Boolean=true):void
		{
			// TODO Auto Generated method stub
			super.setValue(arg0, arg1);
		}
		private function checkValue():void
		{
			var num:Number = Number( inputField.text );
			num = num > this.maximum ? maximum:num;
			num = num < this.minimum ? minimum:num;
			this.inputField.text = num.toString();
		}
		
		override protected function drawLayout():void
		{
			this.addChildAt(inputField,0);
			var w:Number = 17;
			var h:Number = 11;
			inputField.setSize(width - w - 1, height);
			upArrow.width = w;
			downArrow.width = w;
			upArrow.height = h;
			downArrow.height = h;
			
//			_minNumBtn.move(0,0);
			if(style == GNumericStepper.NoMaxAndMin)
			{
				inputField.move(0,0);
				_minNumBtn.visible = _maxNumBtn.visible = false;
			}
			else if(style == GNumericStepper.SetMaxNum)
			{
				inputField.move(0,0);
				_minNumBtn.visible = false;
			}
			else if(style == GNumericStepper.SetMaxAndMinNum)
			{
				inputField.move(_minNumBtn.x + _minNumBtn.width,0);
				_minNumBtn.visible = _maxNumBtn.visible = true;
			}
	
			downArrow.move(width - w - 1 + inputField.x, 8);
			upArrow.move(width - w - 1 + inputField.x, 0);
			_maxNumBtn.move(upArrow.x + upArrow.width,0);
			
			downArrow.drawNow();
			upArrow.drawNow();
			inputField.drawNow();
			_minNumBtn.drawNow();
			_maxNumBtn.drawNow();
		}
		
		
		public function dispose(isReuse:Boolean=true):void
		{
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
			this.value = 1;
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
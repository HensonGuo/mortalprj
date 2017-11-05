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
	
	import fl.controls.Button;
	import fl.controls.ButtonLabelPlacement;
	import fl.core.InvalidationType;
	import fl.core.UIComponent;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
 
	public class GButton extends Button implements IToolTipItem,IFrUI
	{
		
		//include "ExtComponent.as";
		
		public const CLASSNAME:String = "Button";
		
		
		public function GButton()
		{
			super();
			this.buttonMode = true;
			this.useHandCursor = true;
//			this.focusEnabled = false;
			//_styleName = CLASSNAME;
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
		
		override protected function keyDownHandler(arg0:KeyboardEvent):void
		{
			
		}
		override protected function keyUpHandler(arg0:KeyboardEvent):void
		{
			
		}
		
		protected var _toolTipData:*;
		
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
		
		protected var _styleName:String;
		
		public function get styleName():String
		{
			return _styleName;
		}
		
		protected var _isStyleChange:Boolean = false;
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
		
		private var _paddingTop:Number = 0;
		private var _textFieldHeight:Number = 0;
		
		/**
		 * 数字越大越上 
		 * @param value
		 * 
		 */		
		public function set paddingTop(value:int):void
		{
			_paddingTop = value;
			drawLayout();
		}
		
		public function set textFieldHeight(value:int):void
		{
			_textFieldHeight = value;
			drawLayout();
		}
		
		override protected function drawLayout():void 
		{
			var txtPad:Number = Number(getStyleValue("textPadding"));
			var placement:String = (icon == null && mode == "center") ? ButtonLabelPlacement.TOP : _labelPlacement;
			textField.height =  textField.textHeight+4;
			
			var txtW:Number = textField.textWidth+4;
			var txtH:Number = textField.textHeight+4;
			
			var paddedIconW:Number = (icon == null) ? 0 : icon.width+txtPad;
			var paddedIconH:Number = (icon == null) ? 0 : icon.height+txtPad;
			textField.visible = (label.length > 0);
			
			if (icon != null) {
				icon.x = Math.round((width-icon.width)/2);
				icon.y = Math.round((height-icon.height)/2);
			}
			
			var tmpWidth:Number;
			var tmpHeight:Number;
			
			if (textField.visible == false) 
			{
				textField.width = 0;
				textField.height = 0;
			} 
			else if (placement == ButtonLabelPlacement.BOTTOM || placement == ButtonLabelPlacement.TOP) 
			{
				tmpWidth = Math.max(0,Math.min(txtW,width-2*txtPad));
				if (height > txtH) {
					tmpHeight = txtH;
				} else {
					tmpHeight = height;
				}
				
				textField.width = txtW = tmpWidth;
				if(_textFieldHeight)
				{
					textField.height = txtH = _textFieldHeight;
				}
				else
				{
					textField.height = txtH = tmpHeight;
				}
				
				
				textField.x = Math.round((width-txtW)/2);
				textField.y = Math.round((height-textField.height-paddedIconH - _paddingTop)/2+((placement == ButtonLabelPlacement.BOTTOM) ? paddedIconH : 0 ));
				if (icon != null) 
				{
					icon.y = Math.round((placement == ButtonLabelPlacement.BOTTOM) ? textField.y-paddedIconH : textField.y+textField.height+txtPad);
				}
			} 
			else 
			{
				tmpWidth =  Math.max(0,Math.min(txtW,width-paddedIconW-2*txtPad));	
				textField.width = txtW = tmpWidth;	
				
				textField.x = Math.round((width-txtW-paddedIconW)/2+((placement != ButtonLabelPlacement.LEFT) ? paddedIconW : 0));
				textField.y = Math.round((height-textField.height - _paddingTop)/2);
				if (icon != null) 
				{
					icon.x = Math.round((placement != ButtonLabelPlacement.LEFT) ? textField.x-paddedIconW : textField.x+txtW+txtPad);
				}
			}
			
			if(background)
			{
				background.width = width;
				background.height = height;
			}	
		}
		
		public function dispose(isReuse:Boolean=true):void
		{
			_styleName = "";
			_isStyleChange = false;
			ObjEventListerTool.delObjEvent(this);
			textField.filters = [];
			_paddingTop = 0;
			_textFieldHeight = 0;
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
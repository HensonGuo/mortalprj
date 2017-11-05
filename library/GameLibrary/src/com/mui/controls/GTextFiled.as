package com.mui.controls
{
	import com.gengine.global.Global;
	import com.mui.core.IFrUI;
	import com.mui.manager.IToolTipItem;
	import com.mui.manager.ToolTipsManager;
	import com.mui.utils.ObjEventListerTool;
	import com.mui.utils.UICompomentPool;
	
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class GTextFiled extends TextField implements IToolTipItem,IFrUI
	{
		public function GTextFiled()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE,judgeToolTip);
			this.addEventListener(Event.REMOVED_FROM_STAGE,judgeToolTip);
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
			text = "";
			embedFonts = false;
			width = 100;
			height = 20;
			ObjEventListerTool.delObjEvent(this);
			//清除文本的一些信息
			var textformat:TextFormat = this.defaultTextFormat;
			textformat.align = TextFormatAlign.LEFT;
			textformat.bold = false;
			textformat.underline = false;
			textformat.size = 12;
			textformat.letterSpacing = 0;
			textformat.underline = false;
			this.defaultTextFormat = textformat;
			this.autoSize =  TextFieldAutoSize.NONE;
			this.mouseEnabled = true;
			this.multiline = false;
			this.wordWrap = false;
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
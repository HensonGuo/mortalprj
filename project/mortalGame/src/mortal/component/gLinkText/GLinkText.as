/**
 * 2014-2-21
 * @author chenriji
 **/
package mortal.component.gLinkText
{
	import Message.Public.SPassTo;
	import Message.Public.SPoint;
	
	import com.mui.controls.GButton;
	import com.mui.controls.GLoadedButton;
	import com.mui.controls.GSprite;
	import com.mui.controls.GTextFiled;
	
	import extend.language.Language;
	
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	
	import mortal.common.DisplayUtil;
	import mortal.common.GTextFormat;
	import mortal.common.global.GlobalStyle;
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.ImagesConst;
	import mortal.game.view.common.UIFactory;
	import mortal.mvc.core.Dispatcher;
	
	public class GLinkText extends GSprite
	{
		private var _myData:GLinkTextData;
		private var _btnFlyBoot:GLoadedButton;
		private var _txt:GTextFiled;
		private var _isShowNum:Boolean = true;
		private var _isShowFlyBoot:Boolean = true;
		private var _widthConst:int = -1;
		
		public function GLinkText()
		{
			super();
		}
		
		public override function get height():Number
		{
			if(_btnFlyBoot != null && _btnFlyBoot.parent != null)
			{
				return _btnFlyBoot.y + _btnFlyBoot.height;
			}
			return _txt.height;
		}
		
		public function get widthConst():int
		{
			return _widthConst;
		}

		public function set widthConst(value:int):void
		{
			_widthConst = value;
			_txt.width = _widthConst;
		}

		public function get isShowFlyBoot():Boolean
		{
			return _isShowFlyBoot;
		}

		public function set isShowFlyBoot(value:Boolean):void
		{
			_isShowFlyBoot = value;
		}

		public function get isShowNum():Boolean
		{
			return _isShowNum;
		}
		
		public function set isShowNum(value:Boolean):void
		{
			_isShowNum = value;
		}

		protected override function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			var tf:GTextFormat = GlobalStyle.textFormatPutong;
			tf.leading = 2;
			_txt = UIFactory.gTextField("", 0, 0, 220, 40, this, tf);
			_txt.wordWrap = true;
			_txt.multiline = true;
			_txt.mouseEnabled = true;
			_txt.addEventListener(TextEvent.LINK, linkHandler);
		}
		
		protected override function disposeImpl(isReuse:Boolean=true):void
		{
			_txt.dispose(isReuse);
			_txt.removeEventListener(TextEvent.LINK, linkHandler);
			_txt = null;
			if(_btnFlyBoot != null)
			{
				_btnFlyBoot.dispose(isReuse);
				_btnFlyBoot = null;
			}
			_myData = null;
			_isShowNum = true;
			_isShowFlyBoot = true;
		}
		
		public function setLinkText(data:GLinkTextData, extendHtmlText:String = "", preText:String = ""):void
		{
			_myData = data;
//			_txt.height = 40;
			if(_myData.htmlText != null)
			{
				_txt.height = 40;
				if(data.isShowNum && _isShowNum)
				{
					_txt.htmlText = preText + _myData.htmlText + Language.getStringByParam(20163, data.curNum, data.totalNum);
				}
				else 
				{
					_txt.htmlText = preText + _myData.htmlText;
				}
				
				var pixels:int = DisplayUtil.getStringPixes(_txt.text, int(_txt.defaultTextFormat.size));
				if(_widthConst == -1)
				{
					_txt.width = pixels + 8;
				}
				if(_txt.numLines == 1)
				{
					_txt.height = 20;
				}
//				_txt.height = (_txt.numLines - 1)*20 + 20;
			}
			
			if(_myData.needBoot && _isShowFlyBoot)
			{
				if(_btnFlyBoot == null)
				{
					_btnFlyBoot = UIFactory.gLoadedButton(ImagesConst.MapBtnFlyBoot_upSkin, 0, 0, 16, 18);
					_btnFlyBoot.configEventListener(MouseEvent.CLICK, flyBootHandler);
				}
				if(_btnFlyBoot.parent == null)
				{
					this.addChild(_btnFlyBoot);
				}
				var lastText:String = _txt.getLineText(_txt.numLines - 1);
				pixels = DisplayUtil.getStringPixes(lastText, int(_txt.defaultTextFormat.size));
				// 计算小飞鞋的位置
				if(pixels <= _txt.width - 20)
				{
					_btnFlyBoot.x = pixels + 4;
					_btnFlyBoot.y = (_txt.numLines - 1) * (int(_txt.defaultTextFormat.size) + 8);
				}
				else
				{
					_btnFlyBoot.x = 4;
					_btnFlyBoot.y = (_txt.numLines) * (int(_txt.defaultTextFormat.size) + 8)
				}
			}
			else
			{
				DisplayUtil.removeMe(_btnFlyBoot);
			}
		}
		
		public override function get width():Number
		{
			if(_btnFlyBoot != null)
			{
				return _btnFlyBoot.x + _btnFlyBoot.width;
			}
			return DisplayUtil.getStringPixes(_txt.text, int(_txt.defaultTextFormat.size));
		}
		
		private function linkHandler(evt:TextEvent):void
		{
			var str:String = evt.text;
			if(str.length <= 2) // event:0, event:1
			{
				var index:int = int(evt.text);
				Dispatcher.dispatchEvent(new DataEvent(EventName.TaskTraceTargetEvent, _myData));
			}
			else // 发事件类型
			{
				Dispatcher.dispatchEvent(new DataEvent(EventName.TaskTrackClickEvent, str));
			}
		}
		
		private function flyBootHandler(evt:MouseEvent):void
		{
			Dispatcher.dispatchEvent(new DataEvent(EventName.FlyBoot_GLinkText, _myData));
		}
	}
}
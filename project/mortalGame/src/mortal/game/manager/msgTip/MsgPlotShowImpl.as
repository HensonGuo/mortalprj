package mortal.game.manager.msgTip
{
	import com.gengine.global.Global;
	import com.gengine.utils.pools.ObjectPool;
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import mortal.common.GTextFormat;
	import mortal.common.font.FontUtil;
	import mortal.common.global.ParamsConst;
	import mortal.common.global.ProxyType;
	import mortal.component.gconst.FilterConst;
	import mortal.game.manager.EffectManager;
	import mortal.game.manager.LayerManager;

	public class MsgPlotShowImpl extends Sprite
	{
		private var _infoTxtFormat:TextFormat = new GTextFormat(FontUtil.xingkaiName,30,0xffffff,false);//0xffcc33
		private var _infoTxtFormatTW:TextFormat = new GTextFormat(FontUtil.songtiName,30,0xffffff,false);//针对港版的
		
		private var _inTween:TweenMax;
		private var _outTween:TweenMax;
		private var _timerKey:uint;
		private var _lineWidth:int = 38;
		
		private var _inTimeOut:Number = 1;		//淡入时间
		private var _outTimeOut:Number = 0.2;		//淡出时间
		private var _outTimeOut2:Number = 0.5;
		
		private var _step:int;//当前步骤 1=淡入 2=停留 3=淡出
		
		private var _msgList:Array = [];
		private var _endCallBack:Function;
		
		public function MsgPlotShowImpl()
		{
			_infoTxtFormat.leading = 1;
			_infoTxtFormat.align = TextFormatAlign.LEFT;
			
			_infoTxtFormatTW.leading = 1;
			_infoTxtFormatTW.align = TextFormatAlign.LEFT;
			
			mouseEnabled = false;
			mouseChildren = false;
		}
		
		private var _lastClickTime:Number = 0;
		
		/**
		 * 遮罩层点击回调函数 
		 * 
		 */
		private function onMaskClickHandler():void
		{
			if(_lastClickTime != 0)
			{
				var clickTime:Number = getTimer();
				if(clickTime - _lastClickTime > 400)
				{
					_lastClickTime = clickTime;
					return;
				}
				_lastClickTime = clickTime;
			}
			else
			{
				_lastClickTime = getTimer();
				return;
			}
			
			switch(_step)
			{
				case 1://淡入
					_inTimeOut = 0.1;
					break;
				case 2://停留
					clearTimeout(_timerKey);
					playHideEffect2();
					break;
				case 3://淡出
					_outTimeOut2 = 0.1;
					break;
			}
		}
		
		/**
		 * 显示诗句 
		 * @param strMsg
		 * @param endCallBack
		 * 
		 */
		public function showMsg(strMsg:String,endCallBack:Function):void
		{
			hideMsg();
			
			_inTimeOut = 1;
			_outTimeOut = 0.2;
			_outTimeOut2 = 0.5;
			
			this.alpha = 1;
			_endCallBack = endCallBack;
			
			var msgs:Array = strMsg.split("|");
			var index:int = 0;
			var length:int = msgs.length;
			var msg:String;
			var infoTxt:TextField;
			var infoPx:int = Global.stage.stageWidth/2 + msgs.length * _lineWidth;
			
			if(infoPx > Global.stage.stageWidth - 320)
			{
				infoPx = Global.stage.stageWidth - 320;
			}
			
			while(index < length)
			{
				infoTxt = ObjectPool.getObject(TextField);
				if(ParamsConst.instance.proxyType == ProxyType.TW)
				{
					infoTxt.defaultTextFormat = _infoTxtFormatTW;
				}
				else
				{
					infoTxt.defaultTextFormat = _infoTxtFormat;
				}
				infoTxt.width = _lineWidth;
				infoTxt.autoSize = TextFieldAutoSize.LEFT;
				infoTxt.multiline = true;
				infoTxt.wordWrap = true;
				infoTxt.mouseEnabled = false;
				infoTxt.filters = [FilterConst.plotShowFilter2,FilterConst.plotShowFilter,FilterConst.sceneDesFilter];
				infoTxt.x = infoPx - (index * _lineWidth);
				infoTxt.y = 0;
				infoTxt.text = msgs[index];
				_msgList.push(infoTxt);
				
				index++;
			}
		
//			EffectManager.addUIMask(null,0,0,onMaskClickHandler);
			LayerManager.highestLayer.addChild(this);
			stageReseze();
			playShowEffect();
		}
		
		/**
		 * 开始播放显示特效
		 * 
		 */
		private function playShowEffect():void
		{
			if(_msgList.length > 0)
			{
				var textField:TextField = _msgList.shift() as TextField;
				textField.alpha = 0;
				this.addChild(textField);
				_inTween = TweenMax.to(textField,_inTimeOut,{alpha:1,onComplete:playShowEffect}); 
				_step = 1;
			}
			else
			{
//				_timerKey = setTimeout(playHideEffect,3000,true);
				_timerKey = setTimeout(playHideEffect2,3000);
				_step = 2;
			}
		}
		
		/**
		 * 停留时间到 方案1
		 * 
		 */
		private function playHideEffect(beginPlay:Boolean = false):void
		{
			_step = 3;
			if(this.numChildren > 0)
			{
				var textField:TextField = this.getChildAt(0) as TextField;

				if(!beginPlay)
				{
					textField.text = "";
					textField.filters = null;
					this.removeChild(textField);
					ObjectPool.disposeObject(textField,TextField);
					
					if(this.numChildren > 0)
					{
						textField = this.getChildAt(0) as TextField;
					}
				}
				
				if(textField.parent)
				{
					_outTween = TweenMax.to(textField,_outTimeOut,{alpha:0,onComplete:playHideEffect});
				}
				else
				{
					hideEffectEnd();
				}
			}
			else
			{
				hideEffectEnd();
			}
		}
		
		/**
		 * 停留时间到 方案2
		 * 
		 */
		private function playHideEffect2():void
		{
			_step = 3;
			_outTween = TweenMax.to(this,_outTimeOut2,{alpha:0,onComplete:hideEffectEnd});
		}
		
		/**
		 * 隐藏特效播放完成 
		 * 
		 */
		private function hideEffectEnd():void
		{
			_step = 0;
			if(_endCallBack != null)
			{
				_endCallBack();
			}
			
			hideMsg();
		}
		
		/**
		 * 场景改变大小 
		 * 
		 */
		public function stageReseze():void
		{
			if(parent != null)
			{
//				this.x = (Global.stage.stageWidth - width)/2;
				this.y = (Global.stage.stageHeight - height)/2;
				
				if(y > 70)
				{
					y = 70;
				}
			}
		}
		
		/**
		 * 隐藏诗句 
		 * 
		 */
		public function hideMsg():void
		{
			_lastClickTime = 0;
			_step = 0;
			_endCallBack = null;
			EffectManager.hideUIMask();
			if(this.parent)
			{
				this.parent.removeChild(this);
			}
			
			if(_inTween && _inTween.active)
			{
				_inTween.kill();
			}
			
			if(_outTween && _outTween.active)
			{
				_outTween.kill();
			}
			
			clearTimeout(_timerKey);
			
			var textField:TextField;
			while(this.numChildren > 0)
			{
				textField = this.removeChildAt(0) as TextField;
				textField.filters = null;
				textField.text = "";
				ObjectPool.disposeObject(textField,TextField);
			}
			
			while(_msgList.length > 0)
			{
				textField = _msgList.shift() as TextField;
				textField.filters = null;
				textField.text = "";
				ObjectPool.disposeObject(textField,TextField);
			}
		}
		
		override public function get height():Number
		{
			var index:int = 1;
			var length:int = numChildren;
			var result:int;
			var txt:TextField;
			while(index < length)
			{
				txt = getChildAt(index) as TextField;
				if(txt && txt.textHeight > result)
				{
					result = txt.textHeight;
				}
				index++;
			}
			
			index = 0;
			length = _msgList.length
			while(index < length)
			{
				txt = _msgList[index] as TextField;
				if(txt && txt.textHeight > result)
				{
					result = txt.textHeight;
				}
				index++;
			}
			
			return result;
		}
		
		override public function get width():Number
		{
			return (numChildren + _msgList.length) * _lineWidth;
		}
	}
}
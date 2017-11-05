package mortal.game.manager.msgTip
{
	import com.gengine.global.Global;
	import com.gengine.utils.HTMLUtil;
	import com.greensock.TweenMax;
	import com.greensock.easing.Quint;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
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
	import mortal.game.manager.LayerManager;
	import mortal.game.model.TaskShowTargetInfo;
	import mortal.game.mvc.GameProxy;
	
	public class MsgTaskShowImpl
	{
		private var _str:String;
		private var _daily:int;
		
		private var _wordTxt:TextField;
		private var _bmp:Bitmap;
		private var _bmpd:BitmapData;
		private var _tweenIn:TweenMax;
		private var _timerKey:uint;
		private var _tweenOut:TweenMax;
		private var _matrix:Matrix;
		
		public function MsgTaskShowImpl()
		{
			_bmp = new Bitmap();
			_matrix = new Matrix(1,0,0,1,10,10);
		}
		
		//需要显示的文字记录
		private var _ary:Array = [];
		
		private var _lastShowTime:int = 0;
		private const LimitShowTime:int = 10;
		
		/**
		 * 显示字 
		 * @param str 内容
		 * @param daily 显示时间
		 * @param daily 是否强制显示
		 */
		public function showTarget(str:String,daily:int = 5,isForce:Boolean = false):void
		{
			var currentTime:int = getTimer();
			if (isForce == true || 
				(currentTime - _lastShowTime > LimitShowTime + 970 && _ary.length == 0))
			{
				_lastShowTime = currentTime;
			}
			else
			{
				_ary.push(new Msg(str,daily));
				return;
			}
			
			showMsg(str,daily);
			
			setTimeout(showNext,LimitShowTime + 1000);
		}
		
		/**
		 *  
		 * 飘下一个
		 */		
		private function showNext():void
		{
			if (_ary.length > 0)
			{
				var msg:Msg = _ary.shift();
				showTarget(msg.str,msg.daily,true);
			}
		}
		
		private function showMsg(str:String,daily:int = 5):void
		{
			dispose();
			
			_str = str;
			_daily = daily;
			
			if(!_wordTxt)
			{
				_wordTxt = new TextField();
				_wordTxt.autoSize = TextFieldAutoSize.LEFT;
				if(ParamsConst.instance.proxyType == ProxyType.TW)
				{
					_wordTxt.defaultTextFormat = new GTextFormat(FontUtil.songtiName,32,0xffffff,null,null,null,null,TextFormatAlign.LEFT);
				}
				else
				{
					_wordTxt.defaultTextFormat = new GTextFormat(FontUtil.xingkaiName,32,0xffffff,null,null,null,null,TextFormatAlign.LEFT);
				}
				_wordTxt.filters = [FilterConst.taskShowTargetFilter];
				_wordTxt.selectable = false;
				_wordTxt.mouseEnabled = false;
				//				_wordTxt.width = 1000;
				_wordTxt.height = 100;
			}
			
			_wordTxt.htmlText = HTMLUtil.addColor(_str,"#ffffff");
			_wordTxt.alpha = 1;
			
			if(_bmpd)
			{
				_bmpd.dispose();
				_bmpd = null;
			}
			_bmpd = new BitmapData(_wordTxt.textWidth + 20,100,true,0);
			_bmpd.draw(_wordTxt,_matrix);
			_bmp.bitmapData = _bmpd;
			
			if(_bmp.parent == null)
			{
				LayerManager.topLayer.addChild(_bmp);
			}
			
			_tweenIn = TweenMax.to(_bmp,0.5,{alpha:1,ease:Quint.easeIn,onComplete:onTweenInEnd});
			
			stageResize();
		}
		
		/**
		 * 淡入完成 
		 * 
		 */
		private function onTweenInEnd():void
		{
			if(_daily > 0)
			{
				_timerKey = setTimeout(onTimerEnd,_daily * 1000);
			}
		}
		
		/**
		 * 停留时间到 
		 * 
		 */
		private function onTimerEnd():void
		{
			hide();
		}
		
		public function stageResize():void
		{
			if(_bmp && _bmp.parent)
			{
				_bmp.x = (Global.stage.stageWidth - _wordTxt.textWidth) / 2;
				_bmp.y = Global.stage.stageHeight/2 + (Global.stage.stageHeight / 2 - _wordTxt.textHeight) / 2 + _wordTxt.textHeight;
			}
		}
		
		public function hide():void
		{
			if(_bmp && _bmp.parent)
			{
				if(_tweenIn && _tweenIn.active)
				{
					_tweenIn.kill();
				}
				
				clearTimeout(_timerKey);
				_tweenOut = TweenMax.to(_bmp,1,{alpha:0,ease:Quint.easeOut,onComplete:onTweenOutEnd});
			}
			else
			{
				dispose();
			}
		}
		
		private function onTweenOutEnd():void
		{
			dispose();
		}
		
		public function dispose():void
		{
			if(_tweenIn && _tweenIn.active)
			{
				_tweenIn.kill();
			}
			
			if(_tweenOut && _tweenOut.active)
			{
				_tweenOut.kill();
			}
			
			clearTimeout(_timerKey);
			
			if(_wordTxt)
			{
				_wordTxt.text = "";
			}
			if(_bmp.parent)
			{
				_bmp.parent.removeChild(_bmp);
			}
			
			_str = null;
			_daily = 0;
			
		}
	}
}

class Msg
{
	public function Msg($str:String,$daily:int)
	{
		str = $str;
		daily = $daily;
	}
	public var str:String;
	public var daily:int;
}
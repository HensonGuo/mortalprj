package mortal.game.view.common
{
	import com.gengine.core.frame.SecTimer;
	import com.gengine.core.frame.TimerType;
	import com.gengine.utils.HTMLUtil;
	import com.mui.controls.GTextFiled;
	
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import mortal.common.GTextFormat;
	import mortal.common.cd.SecTimerViewData;
	import mortal.common.font.FontUtil;
	import mortal.common.global.GlobalStyle;
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	
	/**
	 * 倒计时显示类 
	 * @author
	 * 
	 */	
	public class SecTimerView extends GTextFiled
	{
		private var _secTimerViewData:SecTimerViewData;
		private var _strParse:String = "mm:ss";
		private var _timeOutCallBack:Function;
		private var _colorChange:Array;
		
		public function SecTimerView()
		{
			super();
		}
		
		/**
		 * 设置剩余时间 
		 * @param value
		 * @param isStart
		 * 
		 */		
		public function setLeftTime(value:int,isStart:Boolean = true):void
		{
			if(value < 0)
			{
//				return;
				value = 0;
			}
			if(!_secTimerViewData)
			{
				_secTimerViewData = new SecTimerViewData();
			}
			_secTimerViewData.setLeftTime(value,isStart);
			_secTimerViewData.caller = update;
			if(_timeOutCallBack != null)
			{
				_secTimerViewData.timeOutCaller = _timeOutCallBack;
			}
			update();
		}
		
		/**
		 *获取剩余时间 
		 * @return 
		 * 
		 */		
		public function getLeftTime():int
		{
			if(_secTimerViewData)
			{
				return _secTimerViewData.leftTime;
			}
			return 0;
		}
		
		/**
		 * 停止倒计时 
		 * 
		 */
		public function stop():void
		{
			if(_secTimerViewData)
			{
				_secTimerViewData.stop();
			}
		}
		
		private var _updateCount:int;
		private var _curColorIndex:int;
		private var _curColor:String;
		
		private function update():void
		{
			_updateCount++;
			if(_colorChange && _colorChange.length > 0)
			{
				_curColorIndex = _updateCount % _colorChange.length;
				_curColor = _colorChange[_curColorIndex];
			}
			
			if(_curColor)
			{
				this.htmlText = HTMLUtil.addColor(_secTimerViewData.parse(_strParse),_curColor);
			}
			else
			{
				var text:String =  _secTimerViewData.parse(_strParse);
				this.htmlText = text;
			}
			
			this.dispatchEvent(new DataEvent(EventName.SecViewTimeChange,_secTimerViewData.leftTime));
		}
		
		/**
		 * 设置显示规则 
		 * @param str
		 * 
		 */		
		public function setParse(str:String):void
		{
			_strParse = str;
		}
		
		override public function dispose(isReuse:Boolean=true):void
		{
			if(_secTimerViewData)
			{
				_secTimerViewData.dispose();
			}
			_secTimerViewData = null;
			_colorChange = null;
			_timeOutCallBack = null;
			_updateCount = 0;
			_curColorIndex = 0;
			_curColor = null;
			defaultTextFormat = GlobalStyle.textFormatHuang;
			this.styleSheet = null;
			this.text = "";
			this.htmlText = "";
			this.setTextFormat(this.defaultTextFormat);
			super.dispose(isReuse);
		}

		public function get secTimerViewData():SecTimerViewData
		{
			return _secTimerViewData;
		}
		
		/**
		 * 时间倒计时完毕的回调函数 
		 * @param callBack
		 * 
		 */
		public function set timeOutHandler(callBack:Function):void
		{
			_timeOutCallBack = callBack;
			if(_secTimerViewData)
			{
				_secTimerViewData.timeOutCaller = _timeOutCallBack;
			}
		}
		
		/**
		 * 颜色变换 
		 * @param colors
		 * 
		 */
		public function set colorChange(colors:Array):void
		{
			_colorChange = colors;
		}
		
		public function get running():Boolean
		{
			if(_secTimerViewData)
			{
				return _secTimerViewData.running;
			}
			return false;
		}

		public function get parse():String
		{
			return _strParse;
		}

	}
}
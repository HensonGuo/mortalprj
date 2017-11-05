/**
 * @date 2013-6-4 下午03:52:00
 * @author chenriji
 */
package mortal.game.view.common
{
	import com.gengine.utils.HTMLUtil;
	import com.mui.controls.GTextFiled;
	
	import flash.utils.Dictionary;
	
	import mortal.common.cd.SecTimerViewData;
	import mortal.common.global.GlobalStyle;
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	
	/**
	 * 时间累计显示组件
	 * 
	 */	
	public class SecTimerCountView extends GTextFiled
	{
		private var _secTimerViewData:SecTimerViewData;
		private var _strParse:String = "mm:ss";
		// [5] = func, 表示显示5秒时调用func
		private var _callbacks:Dictionary = new Dictionary();
		// 进行了多少秒
		private var _updateCount:int;
		
		private var _curColorIndex:int;
		private var _curColor:String;
		// 颜色变换的数据
		private var _colorChange:Array;
		
		public function SecTimerCountView()
		{
			super();
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
		
		/**
		 * 开始计时 
		 * @param startSecond
		 * 
		 */		
		public function startCount(startSecond:int = 0):void
		{
			if(startSecond < 0)
			{
				startSecond = 0;
			}
			if(!_secTimerViewData)
			{
				_secTimerViewData = new SecTimerViewData();
			}
			_secTimerViewData.setLeftTime(int.MAX_VALUE, true);
			_secTimerViewData.caller = update;
			_updateCount = startSecond - 1;
			update();
		}
		private function update():void
		{
			_updateCount++;
			
			// 设置显示时间
			var originalLeftTime:int = _secTimerViewData.leftTime;
			_secTimerViewData.tempChangeLeftTime(_updateCount);
			
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
				this.htmlText = _secTimerViewData.parse(_strParse);
			}
			
			// 还原原本的leftTime
			_secTimerViewData.tempChangeLeftTime(originalLeftTime);
			
			checkAndCallback();
		}
		
		private function checkAndCallback():void
		{
			var func:Function = _callbacks[_updateCount] as Function;
			if(func != null)
			{
				func.call();
			}
		}
		
		/**
		 * 停止计时 
		 * 
		 */		
		public function stop():void
		{
			if(_secTimerViewData)
			{
				_secTimerViewData.stop();
			}
		}
		
		/**
		 * 添加到显示second秒时刻的回调 
		 * @param second
		 * @param callback
		 * 
		 */		
		public function addTimeOut(second:int, callback:Function):void
		{
			_callbacks[second.toString()] = callback;
		}
		
		/**
		 * 停止并销毁 
		 * 
		 */		
		public override function dispose(isReuse:Boolean=false):void
		{
			stop();
			_secTimerViewData = null;
			_colorChange = null;
			_updateCount = 0;
			_curColorIndex = 0;
			_curColor = null;
			_callbacks = new Dictionary();
			defaultTextFormat = GlobalStyle.textFormatHuang;
			super.dispose(isReuse);
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
		
		/**
		 * 是否正在计时中 
		 * @return 
		 * 
		 */		
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
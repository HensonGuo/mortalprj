package mortal.game.view.mount.panel
{
	import com.gengine.core.frame.FrameTimer;
	import com.gengine.core.frame.TimerType;
	import com.greensock.TweenMax;
	import com.greensock.easing.Quint;
	import com.mui.controls.GBitmap;
	import com.mui.controls.GSprite;
	import com.mui.controls.GTextFiled;
	import com.mui.utils.UICompomentPool;
	
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.view.common.UIFactory;
	import mortal.mvc.core.Dispatcher;
	
	public class Box_777 extends GSprite
	{
		public static const Up:String = "Up";   //文本
		public static const Down:String = "Down";  //图片
		
		private var _frameTimer:FrameTimer;
		
		private var _type:String;
		
		/**重复播放的Y坐标*/	
		private var _repeatY:Number = 0;  //重复播放的Y坐标;
		
		/**回跳的Y坐标*/	
		private var _returnY:Number = 0; 
		
		private var _startY:Number = 0;   //开始播放Y坐标
		
		/**结束的Y坐标*/	
		private var _endY:Number = 0;
		
		private var dataDic:Dictionary; //标签数据(Key为标签名称,值为Y坐标)
		
		private var dataArr:Array;
		
		private var _box:GSprite;
		
		public var verticalGap:Number;
		
		public var showNum:int = 3;  //一竖显示几个标签
		
		public function Box_777()
		{
			super();
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			dataDic = new Dictionary();
			dataArr = new Array();
			
			_box = UICompomentPool.getUICompoment(GSprite);
			this.addChild(_box);
				
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			dataDic = new Dictionary();
			
		    _aSpeed = 0.1;//加速度
			_speed = 0;  //速度
			_maxSpeed = 20;  //最大速度
			_currentNum = 0; //当前阶段时间
			_type = "";
			
			dataArr.length = 0;
			
			if(_frameTimer)
			{
				_frameTimer.dispose(isReuse);
				_frameTimer = null;
			}
			
			if(_showTween && _showTween.active)
			{
				_showTween.kill();
			}
			
			super.disposeImpl(isReuse);
			
			_box.dispose(isReuse);
			_box = null;
		}
		
		public function setData( arr:Array,type:String = "BitMap" ):void
		{
			var len:int = arr.length;
			
			if(type == Mount_777.BitMap)
			{
				var bitMap:GBitmap;
				for (var i:int = 0 ; i < len + showNum ;i++)
				{
					if(i <len)
					{
						bitMap = UIFactory.gBitmap(arr[i],0,i*(verticalGap),_box);
					}
					else 
					{
						bitMap = UIFactory.gBitmap(arr[i - len],0,i*(verticalGap),_box);
					}
					this.pushUIToDisposeVec(bitMap);
					dataDic[arr[i]] = i*verticalGap;
					dataArr.push(arr[i]);
					
				}
				dataDic[arr[0]] = (len)*verticalGap;
				
			}
			else if(type == Mount_777.Str)
			{
				var txt:GTextFiled;
				for (i = 0 ; i < len + showNum ;i++)
				{
					if(i <len)
					{
						txt = UIFactory.gTextField(arr[i],0,i*(verticalGap),30,20,_box);
					}
					else 
					{
						txt = UIFactory.gTextField(arr[i - len],0,i*(verticalGap),30,20,_box);
					}
					this.pushUIToDisposeVec(txt);
					dataDic[arr[i]] = i*verticalGap;
					dataArr.push(arr[i]);
				}
			}
			
			//随机排标签
			var k:int = int(Math.random()*dataArr.length);
			if(k >= dataArr.length - showNum )
			{
				k = 0;
			}
			_startY = -dataDic[dataArr[k]];
			_box.y = _startY;
			
		}
		
		private var _aSpeed:Number = 0.01;//加速度
		private var _speed:Number = 0;  //速度
		private var _maxSpeed:Number = 8;  //最大速度
		private var _currentNum:int = 0; //当前阶段时间
		private var _showTween:TweenMax;
		protected function onTurning(e:FrameTimer):void
		{
			_currentNum ++;
			
			if(_type == Box_777.Up)   //向上运动
			{
				if(_box.y <= _repeatY)
				{
					_box.y = _returnY;
				}
				
				//调整速度
				if(_currentNum < 100)  //加速阶段
				{
					_speed += _aSpeed;
				}
				else if(_currentNum < 140)  //匀速阶段
				{
					_speed = _maxSpeed;
				}
				else if(_currentNum > 160)  //减速阶段
				{
					_speed -= _aSpeed;
					if(_speed <= 2)
					{
						_speed = 2;
						
						if(_box.y == _endY)
						{
							_speed = 0;
							_frameTimer.stop();
							dispatchEvent(new Event("Mount_777Event"));
						}
					}
				}
				
				if(_speed > _maxSpeed)  //限制最大速度
				{
					_speed = _maxSpeed;
				}
				
				_box.y -=_speed;
			}
			else if(_type == Box_777.Down)  //向下运动
			{
				//调整速度
				if(_currentNum < 100)
				{
					_speed += _aSpeed;
				}
				else if(_currentNum < 140)
				{
					_speed = _maxSpeed;
				}
				else if(_currentNum > 160)
				{
					_speed -= _aSpeed;
					if(_speed <= 2)
					{
						_speed = 2;
						
						if(_box.y == _endY)
						{
							_speed = 0;
							_frameTimer.stop();
							dispatchEvent(new Event("Mount_777Event"));
						}
					}
				}
				
				if(_box.y >= _repeatY)
				{
					_box.y = _returnY;
				}
				
				if(_speed > _maxSpeed)  //限制最大速度
				{
					_speed = _maxSpeed;
				}
				
				_box.y += _speed;
			}
					
		}
				
		private function onShowEnd():void
		{
			dispatchEvent(new Event("Mount_777Event"));
		}
			
				
		/**
		 * 
		 * @param name 停止时的属性名
		 * @param type 向上滚动还是向下滚动
		 * 
		 */		
		public function starRuning(name:String,type:String = "Up"):void
		{
			resetInfo();
			_type = type;
			_endY = -(dataDic[name] - verticalGap*(int(showNum/2)));
			if(type == Box_777.Up)
			{
				_repeatY = -(dataArr.length - showNum) * verticalGap ;
				_returnY = 0;
			}
			else if(type == Box_777.Down)
			{
				_repeatY = 0 ;
				_returnY = -(dataArr.length - showNum) * verticalGap;
			}
		
			
			if(!_frameTimer)
			{
				_frameTimer = new FrameTimer(1, int.MAX_VALUE, true);
				_frameTimer.addListener(TimerType.ENTERFRAME,onTurning);
			}
			_frameTimer.start();
		}
		
		private function resetInfo():void
		{
			_aSpeed = 0.1;//加速度
			_speed = 0;  //速度
			_maxSpeed = 20;  //最大速度
			_currentNum = 0; //当前阶段时间
		}
		
	}
}
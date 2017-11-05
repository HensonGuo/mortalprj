package extend.flash.flower
{
	import com.gengine.global.Global;
	import com.gengine.utils.MathUitl;
	
	import flash.display.Bitmap;
	
	public class FlowerBitmap extends Bitmap
	{
		private var _runType:int = 0;
		
		//0 为花瓣  1为花朵
		private var _flowerBitmapType:int = 0;
		
		private var _baseX:int = 0;
		
		private var _acceleration:Number = 0.08; //加速度
			
		private var _speedY:Number = 0;
			
		private var _speedX:Number = 0;
		
		private var _gravity:Number = 0;//0.01
			
		private const _maxSpeedX:Number = 5;
		
		private const _maxSpeedY:Number = 3;
		
		private var _alphaHeight:Number;
		
		//震频
		private var _frequency:int = 500;
		
		//震幅
		private var _amplitude:int = 0;
		
		//旋转角度
		private var _rotationMargin:int = 0;
		
		public function FlowerBitmap()
		{
			
		}

		public function initType(runeType:int,bmpType:int = 0):void
		{
			_runType = runeType;
			flowerBitmapType = bmpType;
			init();
		}
		
		private function init():void
		{
			switch(_runType)
			{
				case FlowerRunType.NORMAL:
					_speedX = 0;
					break;
				case FlowerRunType.SPEEDADD:
					_speedX = MathUitl.random(-5,5);
					break;
				case FlowerRunType.SPEEDACCEL:
					_speedX = MathUitl.random(-5,5);
					break;
			}
			_speedY = MathUitl.random(2,3);
			_acceleration = 0.08 * MathUitl.getSign(_speedX);
			_alphaHeight =  Global.stage.stageHeight - MathUitl.random(150,350);
			this.alpha = 1;
		}
		
		public function update():void
		{
			move();
		}
		
		/**
		 * 更新坐标 
		 * 
		 */		
		public function move():void
		{
			var n:int;
			if (_speedX > _maxSpeedX)
			{
				n = MathUitl.random(0, 1);
				if (n == 1)
				{
					_acceleration *= -1;
				}
				_speedX = _maxSpeedX;
			}
			else if (_speedX < -_maxSpeedX)
			{
				n = MathUitl.random(0, 1);
				if (n == 1)
				{
					_acceleration *= -1;
				}
				_speedX = -_maxSpeedX;
			}
			
			_speedY += _gravity;
			if(_speedY > _maxSpeedY)
			{
				_speedY = _maxSpeedY;
			}
			
			if(_runType == FlowerRunType.SPEEDACCEL)
			{
				_speedX += _acceleration;
			}
			
			this.x += int(_speedX);
			this.y += int(_speedY);
			
			if(this.y > _alphaHeight)
			{
				this.alpha -= 0.02;
			}
		}
		
		public function set rotationMargin(value:int):void
		{
			_rotationMargin = value;
		}

		public function get rotationMargin():int
		{
			return _rotationMargin;
		}

		public function get flowerBitmapType():int
		{
			return _flowerBitmapType;
		}

		public function set flowerBitmapType(value:int):void
		{
			_flowerBitmapType = value;
		
			if(_flowerBitmapType == FlowerBitmapType.FlowerBloom)
			{
				_rotationMargin = 0;
			}
			if(_flowerBitmapType == FlowerBitmapType.FlowerLeaves)
			{
				_rotationMargin = Math.random() * 18;
			}
		}

		public function get baseX():int
		{
			return _baseX;
		}

		public function set baseX(value:int):void
		{
			_baseX = value;
		}

		public function get runType():int
		{
			return _runType;
		}

		public function set runType(value:int):void
		{
			_runType = value;
		}
		
		public function dispose():void
		{
			_runType = 0;
			_flowerBitmapType = 0;
			_baseX = 0;
			_acceleration = 0.08;
			_speedY = 0;
			_speedX = 0;
			_gravity = 0;
			_frequency = 500;
			_amplitude = 0;
			_rotationMargin = 0;
		}
	}
}
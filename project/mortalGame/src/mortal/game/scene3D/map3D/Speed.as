package  mortal.game.scene3D.map3D
{
	import com.gengine.global.Global;
	import com.gengine.utils.MathUitl;
	
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	
	import mortal.game.scene3D.player.entity.MovePlayer;
	import mortal.game.scene3D.util.MoveUtil;

	public class Speed
	{
		//变速齿轮测试
		public static var SpeedUp:Number = 1;
		
		private var _distance:Number; //距离
		private var _xSpeed:Number;
		private var _ySpeed:Number;
		private var _radians:Number; //弧度角度
		private var _direction:Number;
		private  var _speed:Number = 5;  //一帧多少像素
		
		private var _timeSpeed:Number = 0; // 一毫秒都是像素
		
		public var attackDistance:int = 5;
		private var _startPoint:Point;
		private var _endPoint:Point;
		
		private const _interval:Number = 1000/60;
		
		public var player:MovePlayer;

		public function get timeSpeed():Number
		{
			return _timeSpeed;
		}

		public function set timeSpeed(value:Number):void
		{
			_timeSpeed = value/1000;
			_speed = value/Global.stage.frameRate;
		}

		public function get speed():Number
		{
			return _speed;
		}

		public function get ySpeed():Number
		{
			return _ySpeed;
		}

		public function get xSpeed():Number
		{
			return _xSpeed;
		}

		public function Speed():void
		{
			_startPoint = new Point();
			_endPoint = new Point();
		}
		
		public function setPoint( x1:Number,y1:Number,x2:Number,y2:Number ):void
		{
			_startPoint.x = x1;
			_startPoint.y = y1;
			_endPoint.x = x2;
			_endPoint.y = y2;
			updateSpeed();
		}
		
		/**
		 * 是否到达 
		 * @return 
		 * 
		 */		
		public function get isArrive():Boolean
		{
			return distance < attackDistance * 1.3;
		}
		
		public function update(x:Number,y:Number):void
		{
			_startPoint.x = x;
			_startPoint.y = y;
			updateSpeed();
		}
		
		private function updateSpeed():void
		{
			_radians = MathUitl.getRadiansByPoint(_startPoint,_endPoint);
//			_direction = GameMapUtil.getDirectionByRadians(_radians);
			_direction = MathUitl.getAngle(_radians);
			
			_speed = _timeSpeed * MoveUtil.speedInterval;
			_xSpeed = _speed * Math.cos(_radians) * SpeedUp;
			_ySpeed = _speed * Math.sin(_radians) * SpeedUp;
			
//			trace(_xSpeed,_ySpeed);
			//trace("速度" ,int(_radians),_interval,[_xSpeed,_ySpeed]);
		}
		
		public function setSpeedXY(xSpeed:Number,ySpeed:Number):void
		{
			_xSpeed = xSpeed;
			_ySpeed = ySpeed;
		}

		public function get radians():Number
		{
			return _radians;
		}

		public function get distance():Number
		{
			return  Point.distance(_endPoint,_startPoint);
		}
		
		/**
		 * 八方向
		 *
		 * 2
		 * @return 
		 * 
		 */		
		public function get direction():Number
		{
			return _direction;
		}
	}
}
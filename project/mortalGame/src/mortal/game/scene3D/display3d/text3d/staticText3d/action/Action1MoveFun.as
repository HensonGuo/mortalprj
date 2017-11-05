package mortal.game.scene3D.display3d.text3d.staticText3d.action
{
	import flash.geom.Point;
	import flash.geom.Vector3D;

	public class Action1MoveFun extends ActionMoveBase
	{
		
		
		private const _V:Number=30;
		private const _A:Number=4;
		private const _lastV:Number=5;
		private const _moveTime:int=3;
		private const _midTime:int=_moveTime+_V/_A;
		private const _lastTime:int=20;
		private const _waitTime:int=_midTime+5;
		private const _totalTime:int=_waitTime+_lastTime;
		
		private var _curOffY:int=0;
		private var _curOffX:int=0;
		private var _alpha:Number=1;
		
		private var _Ax:Number;
		private var _Ay:Number;
		
		private var _Vx:Number;
		private var _Vy:Number;
		
		private var _LVx:Number;
		private var _LVy:Number;	

		public function Action1MoveFun()
		{
			
		}
		public override function set vo(value:ActionVo):void
		{
			super.vo=value;
			var angle:Number=Math.atan2(value.start2d_y-value.end2d_y,value.end2d_x-value.start2d_x);
			var cos:Number=Math.cos(angle);
			var sin:Number=Math.sin(angle);
			
			_Ax=_A*cos;
			_Ay=_A*sin;
			
			_Vx=_V*cos;
			_Vy=_V*sin;
			_LVx=_lastV*cos;
			_LVy=_lastV*sin;
			
		}
		public override function update(frame:int,$result:Vector3D):Boolean
		{
			if(frame>_totalTime)
			{
				_curOffY=0;
				_curOffX=0;
				_alpha=1;
				return false;
			}else
			{
				if(frame<=_moveTime)
				{
					//匀速上升
					_curOffX=_Vx*frame;
					_curOffY=_Vy*frame;
				}
				else if(frame<=_midTime)
				{
					//减速到0
					var time:int=frame-_moveTime;
					time*=0.5*time;
					_curOffX = _Vx*frame-_Ax*time;
					_curOffY = _Vy*frame-_Ay*time;
					
				}else if(frame<=_waitTime)
				{
					
				}else
				{
					//最后随机一个方向上升，并透明到渐变到0
					_curOffX+=_LVx;
					_curOffY+=_LVy;
					_alpha=(_totalTime-frame)/_lastTime;
				}
				$result.x=_curOffX;
				$result.y=_curOffY;
				$result.z=_alpha;
				return true;
				
			}
		}
	}
}
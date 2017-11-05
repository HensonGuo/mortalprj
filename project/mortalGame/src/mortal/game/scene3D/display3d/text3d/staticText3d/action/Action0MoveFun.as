package mortal.game.scene3D.display3d.text3d.staticText3d.action
{
	import flash.geom.Vector3D;

	public class Action0MoveFun extends ActionMoveBase
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
		private var _cos:Number;
		private var _sin:Number;
		private var _hasRandomAngle:Boolean;
		private var _flag:int=1;
		
		public function Action0MoveFun()
		{
		}
		public override function update(frame:int,$result:Vector3D):Boolean
		{
			if(frame>_totalTime)
			{
				_curOffY=0;
				_curOffX=0;
				_alpha=1;
				_hasRandomAngle=false;
				return false;
			}else
			{
				if(frame<=_moveTime)
				{
					//匀速上升
					_curOffY=_V*frame;
				}
				else if(frame<=_midTime)
				{
					//减速到0
					var time:int=frame-_moveTime;
					_curOffY = _V*frame-0.5*_A*time*time;
					
				}else if(frame<=_waitTime)
				{
					
				}else
				{
					//最后随机一个方向上升，并透明到渐变到0
					if(!_hasRandomAngle)
					{
						_hasRandomAngle=true;
						_flag*=-1;
						var angle:Number=15+Math.random()*75;
						angle=_flag*angle/180*Math.PI+Math.PI/2;
						_cos=Math.cos(angle)*_lastV;
						_sin=Math.sin(angle)*_lastV;	
					}
					_curOffX+=_cos;
					_curOffY+=_sin;
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
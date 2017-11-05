package frEngine.loaders.particleSub.multyEmmiterType
{
	import flash.geom.Vector3D;
	
	import frEngine.animateControler.particleControler.ParticleParams;
	import frEngine.math.Quaternion;
	
	public class LinearMultyEmmiter implements IMultyEmmiterType
	{
		private var _defaultStartPos:Vector3D=new Vector3D();
		private var _defaultEndPos:Vector3D=defaultStartPos;
		private var _defaultMultyPlaySpeed:int=0;
		
		public var openAngle:Number;
		private var speedVector3d:Vector3D;
		
		private static const qu:Quaternion=new Quaternion();
		
		private var _distanceBirthNum:int=1;
		
		private var strValue:String;
		private static const _temp:Vector3D=new Vector3D();
		private var params0:Number=0;
		private var params1:Number=0;
		private var params2:Number=0;
		private var params3:Number=0;
		
		public function LinearMultyEmmiter(str:String)
		{
			strValue=str;
		}
		
		public function get defaultStartPos():Vector3D
		{
			return _defaultStartPos;
		}
		public function get defaultEndPos():Vector3D
		{
			return _defaultEndPos;
		}
		public function get defaultMultyPlaySpeed():int
		{
			return _defaultMultyPlaySpeed;
		}
		
		public function initData(_particleParams:ParticleParams):void
		{
			
			var arr:Array=strValue.split(",");
			var _t:String=arr[1];
			var _ta:Array=_t.split(" ");
			_defaultStartPos=new Vector3D(_ta[0],_ta[1],_ta[2]);
			_t=arr[2];
			_ta=_t.split(" ");
			_defaultEndPos=new Vector3D(_ta[0],_ta[1],_ta[2]);
			
			openAngle=Number(arr[3]);

			_defaultMultyPlaySpeed=_particleParams.multyPlaySpeed;
			
			calculateDistanceBirthNum(_particleParams);
		}
		
		private function calculateDistanceBirthNum(_particleParams:ParticleParams):void
		{
			
			if(_particleParams.distanceBirth)
			{
				var _direction:Vector3D=defaultEndPos.subtract(_defaultStartPos);
				var maxDistance:Number=_direction.length;
				var defaultMultyPlayDringFrame:int=maxDistance/defaultMultyPlaySpeed;
				var emmiterDuringFrame:Number=_particleParams.emitterTimeEffectPeriod;
				var _multyEmmiterSpeed:Number=1/defaultMultyPlayDringFrame
				var times:Number=emmiterDuringFrame*_multyEmmiterSpeed;
				if(times>1)
				{
					_distanceBirthNum=Math.ceil(maxDistance/_particleParams.birthDistance);
				}else
				{
					var distanceValue:Number=maxDistance*times;
					_distanceBirthNum=Math.ceil(distanceValue/_particleParams.birthDistance);
				}
			}
			else
			{
				_distanceBirthNum=1;
			}
		}
		
		public function get distanceBirthNum():int
		{
			return _distanceBirthNum;
		}
		
		public function reInit($startPos:Vector3D,$endPos:Vector3D,$speed:int,_particleParams:ParticleParams,vc0_60:Vector.<Number>):void
		{
			
			if($speed<1)
			{
				$speed=_defaultMultyPlaySpeed;
			}
			if($startPos==null)
			{
				$startPos=_defaultStartPos;
			}
		
			if($endPos==null)
			{
				$endPos=_defaultEndPos;
			}
			
			
				
			var _direction:Vector3D=$endPos.subtract($startPos);
			
			var _left:Vector3D=_direction.crossProduct(Vector3D.Y_AXIS);
			var _up:Vector3D=_left.crossProduct(_direction);//_direction
			_up.normalize();
			qu.fromAxisAngle(_up,openAngle/180*Math.PI);
			qu.rotatePoint(_direction,_temp);
			$endPos=$startPos.add(_temp);
			
			speedVector3d=$endPos.subtract($startPos);
			
			var maxDistance:Number=speedVector3d.normalize();
			
			var playDringFrame:int=maxDistance/$speed;
			
			var _multyEmmiterSpeed:Number=1/playDringFrame
				
			if(_particleParams.distanceBirth)
			{
				params0=_particleParams.birthDistance/maxDistance;//两个相邻发射器的时差(0至1);
				
				var minDuringTime:Number=Math.min(_particleParams.emitterTimeEffectPeriod,playDringFrame);
				params1=minDuringTime/_distanceBirthNum;;//两个相邻发射器的帧数差;
				params2=_distanceBirthNum;//发射器个数
				
			}else if(_particleParams.tailEnabled)
			{
				params0=_multyEmmiterSpeed;//运动速度
				params1=_particleParams.tailMaxDistance/maxDistance;//一个从头到到尾需要的时间（0至1）
			}else
			{
				params0=_multyEmmiterSpeed;//运动速度
			}
			
			params3=maxDistance;
			
			vc0_60.push(params0,params1,params2,params3);
			vc0_60.push($startPos.x,$startPos.y,$startPos.z,0);
			vc0_60.push(speedVector3d.x,speedVector3d.y,speedVector3d.z,0);
		}
	}
}
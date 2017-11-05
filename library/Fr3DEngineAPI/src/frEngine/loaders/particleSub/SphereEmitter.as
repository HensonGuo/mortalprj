package frEngine.loaders.particleSub
{
	import frEngine.primitives.FrSphere;

	public class SphereEmitter extends EmitterObject
	{
		private var _R:Number=0;
		private var _rate:Number;
		private var _instance3d:FrSphere;
		private var _instance3dArr:Array;
		private var _segment:int=30;
		public function SphereEmitter(R:Number,rate:Number,emitterPosType:String,$randnomArr:Array)
		{
			_R=R;
			_rate=rate;
			super(emitterPosType,$randnomArr);
		}
		
		protected override function processVolume(index:int):void
		{
			
			

			var _rand3:Number = randnomArr[index+2];
			
			processCurve(index);
			var rand:Number = Math.sqrt(_rand3);
			_vect3d.x *= rand;
			_vect3d.y *= rand;
			_vect3d.z *= rand;
		}
		
		protected override function processAxis(index:int):void
		{
			_vect3d.y = 0;//_R * _rate - _R * Math.random() * _rate * 2;
			_vect3d.x = 0;
			_vect3d.z = 0;
		}
		
		protected override function processCurve(index:int):void
		{
			
			
			
			var _rand1:Number = randnomArr[index];
			var _rand2:Number = randnomArr[index+1];

			var angle1:Number = 2 * Math.PI * _rand1;
			
			// 确定Y轴
			_vect3d.y = _R * _rate * Math.sin(angle1);
			
			var Rxz:Number = _R * _rate * Math.cos(angle1); // x.z轴的圆的半径
			var angleXZ:Number = 2 * Math.PI * _rand2;
			// 确定x、z
			_vect3d.x = Rxz * Math.cos(angleXZ);
			_vect3d.z = Rxz * Math.sin(angleXZ);
		}
		
		protected override function processEdage(index:int):void
		{
			processCurve(index);
		}
		
		protected override function processVertex(index:int):void
		{
			processCurve(index);
		}

		public override function getObject3d():*
		{
			if(emitterPosType == EmitterPosType.TextureRGB)
			{
				if(!_instance3d)
				{
					_instance3d = new FrSphere("sphere",null, _R, 30, null);
				}
				return _instance3d;
			}
			if(!_instance3dArr)
			{
				_instance3dArr=new Array();
				createLineData0(_instance3dArr);
				createLineData1(_instance3dArr);
				createLineData2(_instance3dArr);
			}
			return _instance3dArr;
			
		}
		private function createLineData0(resultArr:Array):void
		{
			var arr:Array=new Array();
			var perAngle:Number=Math.PI*2/_segment;
			var curAngle:Number=0;
			for(var i:int=0;i<=_segment;i++)
			{
				curAngle=perAngle*i;
				var xx:Number=Math.cos(curAngle)*_R;
				var zz:Number=Math.sin(curAngle)*_R;
				arr.push(xx,0,zz);
			}
			resultArr.push(arr);
		}
		private function createLineData1(resultArr:Array):void
		{
			var arr:Array=new Array();
			var perAngle:Number=Math.PI*2/_segment;
			var curAngle:Number=0;
			for(var i:int=0;i<=_segment;i++)
			{
				curAngle=perAngle*i;
				var xx:Number=Math.cos(curAngle)*_R;
				var yy:Number=Math.sin(curAngle)*_R;
				arr.push(xx,yy,0);
			}
			resultArr.push(arr);
		}
		private function createLineData2(resultArr:Array):void
		{
			var arr:Array=new Array();
			var perAngle:Number=Math.PI*2/_segment;
			var curAngle:Number=0;
			for(var i:int=0;i<=_segment;i++)
			{
				curAngle=perAngle*i;
				var yy:Number=Math.cos(curAngle)*_R;
				var zz:Number=Math.sin(curAngle)*_R;
				arr.push(0,yy,zz);
			}
			resultArr.push(arr);
		}
	}
}
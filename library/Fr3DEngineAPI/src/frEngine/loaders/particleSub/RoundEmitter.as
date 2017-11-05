package frEngine.loaders.particleSub
{
	import frEngine.primitives.Cone;

	public class RoundEmitter extends EmitterObject
	{
		private var _R:Number = 0;
		private var _instance3d:Cone;
		private var _instance3dArr:Array;
		private var _segment:int = 30;
		private var _isRandom:Boolean=true;
		public function RoundEmitter(R:Number, emitterPosType:String,$randnomArr:Array,$isRandom:Boolean)
		{
			_R = R;
			_isRandom=$isRandom;
			super(emitterPosType,$randnomArr);
		}

		protected override function processVolume(index:int):void
		{
			
			

			var _rand2:Number = randnomArr[index+1];

			processCurve(index);
			var rand:Number = _rand2;
			_vect3d.x *= rand;
			_vect3d.z *= rand;
		}

		protected override function processAxis(index:int):void
		{
			_vect3d.y = 0; //_R * _rate - _R * Math.random() * _rate * 2;
			_vect3d.x = 0;
			_vect3d.z = 0;
		}

		protected override function processCurve(index:int):void
		{
			
			var angle1:Number
			if(_isRandom)
			{
				var _rand1:Number = randnomArr[index];
				angle1 = 2 * Math.PI * _rand1;
			}else
			{
				angle1 = 2 * Math.PI *index / (randnomArr.length-5);
			}
			
			// 确定x、z
			_vect3d.x = _R * Math.cos(angle1);
			_vect3d.z = _R * Math.sin(angle1);
			_vect3d.y = 0;
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
			if (emitterPosType == EmitterPosType.TextureRGB)
			{
				if (!_instance3d)
				{
					_instance3d = new Cone("",null, _R, _R, 0, 10);
				}
				return _instance3d;
			}
			if (!_instance3dArr)
			{
				_instance3dArr = new Array();
				createLineData0(_instance3dArr);
			}
			return _instance3dArr;

		}

		private function createLineData0(resultArr:Array):void
		{
			var arr:Array = new Array();
			var perAngle:Number = Math.PI * 2 / _segment;
			var curAngle:Number = 0;
			for (var i:int = 0; i <= _segment; i++)
			{
				curAngle = perAngle * i;
				var xx:Number = Math.cos(curAngle) * _R;
				var zz:Number = Math.sin(curAngle) * _R;
				arr.push(xx, 0, zz);
			}
			resultArr.push(arr);
		}


	}
}

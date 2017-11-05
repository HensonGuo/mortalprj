package frEngine.loaders.particleSub
{
	import baseEngine.core.Mesh3D;
	
	import frEngine.primitives.Cone;

	public class CylinderEmitter extends EmitterObject
	{
		private var _topR:Number = 0;
		private var _bottomR:Number = 0;
		private var _H:Number = 0;

		public function CylinderEmitter(topR:Number, bottomR:Number, H:Number, emitterPosType:String,$randnomArr:Array)
		{
			_topR = topR;
			_bottomR = bottomR;
			_H = H;
			super(emitterPosType,$randnomArr);
		}

		protected override function processVolume(index:int):void
		{
			
			
			
			var _rand1:Number = randnomArr[index];
			var _rand2:Number = randnomArr[index+1];
			var _rand3:Number = randnomArr[index+2];
			
			var rate:Number = _rand1;
			var _h:Number = _H * rate;
			_vect3d.y = _h;
			var angle:Number = Math.PI * 2 * _rand2;
			
			var targetR:Number;
			
			if (_topR > _bottomR)
			{
				targetR = (_topR - _bottomR) * rate + _bottomR;
			}
			else
			{
				targetR = (_bottomR - _topR) * rate + _topR;
			}
			
			var r:Number = targetR * _rand3;
			_vect3d.x = r * Math.sin(angle);
			_vect3d.z = r * Math.cos(angle);
		}
		
		protected override function processAxis(index:int):void
		{
			_vect3d.y = 0;//_H * Math.random();
			_vect3d.x = 0;
			_vect3d.z = 0;
		}
		
		protected override function processCurve(index:int):void
		{
			
			
			
			var _rand1:Number = randnomArr[index];
			var _rand2:Number = randnomArr[index+1];
			
			_vect3d.y = _H * _rand1;
			var dr:Number = Math.abs(_bottomR - _topR);
			var R:Number = _topR + (_H - _vect3d.y)/_H * dr;
			var angle:Number = Math.PI * 2 * _rand2;
			
			_vect3d.x = R * Math.sin(angle);
			_vect3d.z = R * Math.cos(angle);
		}
		
		protected override function processEdage(index:int):void
		{
			
			
			
			var _rand1:Number = randnomArr[index];
			var _rand2:Number = randnomArr[index+1];
			
			var angle:Number = Math.PI * 2 * _rand1;
			var R:Number;
			if(_rand2 < 0.5)
			{
				_vect3d.y = _H;
				R = _topR;
			}
			else
			{
				_vect3d.y = 0;
				R = _bottomR;
			}
			_vect3d.x = R * Math.sin(angle);
			_vect3d.z = R * Math.cos(angle);
		}
		
		protected override function processVertex(index:int):void
		{
			processEdage(index);
		}
		
		private var _instance3d:Mesh3D;

		public override function getObject3d():*
		{
			if (!_instance3d)
			{
				_instance3d = new Cone("",null, _bottomR, _topR, _H, 10);
			}
			return _instance3d;
		}
	}
}

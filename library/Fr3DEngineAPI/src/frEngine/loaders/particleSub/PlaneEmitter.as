package frEngine.loaders.particleSub
{
	import baseEngine.core.Mesh3D;

	public class PlaneEmitter extends EmitterObject
	{
		private var _H:Number=0;
		private var _W:Number=0;
		private var dx:Number;
		private var dz:Number;
	;
		public function PlaneEmitter(W:Number,H:Number,emitterPosType:String,$randnomArr:Array)
		{
			_W=W;
			_H=H;
			dx = _W/2;
			dz = _H/2;
			
			super(emitterPosType,$randnomArr);
		}
		protected override function processAxis(index:int):void
		{
			_vect3d.x = 0;
			_vect3d.z = 0;
		}
		
		protected override function processCurve(index:int):void
		{
			
			
			
			var _rand1:Number = randnomArr[index];
			var _rand2:Number = randnomArr[index+1];

			_vect3d.x=_W*0.5-_W*_rand1;
			_vect3d.z=_H*0.5-_H*_rand2;
		}
		
		protected override function processEdage(index:int):void
		{
			
			
			
			var _rand1:Number = randnomArr[index];
			var _rand2:Number = randnomArr[index+1];
			var _rand3:Number = randnomArr[index+2];

			if(_rand1 < 0.5) // x轴随机
			{
				_vect3d.x=_W*0.5-_W*_rand2;
				_vect3d.z = _rand3<0.5?-dz:dz;
			}
			else
			{
				_vect3d.z=_H*0.5-_H*_rand2;
				_vect3d.x = _rand3<0.5?-dx:dx;
			}
		}
		
		protected override function processVertex(index:int):void
		{
			
			
			
			var _rand1:Number = randnomArr[index];
			var _rand2:Number = randnomArr[index+1];

			_vect3d.x = _rand1<0.5?-dx:dx;
			_vect3d.z = _rand2<0.5?-dz:dz;
		}
		
		protected override function processVolume(index:int):void
		{
			processCurve(index);
		}
		
		private var _instance3d:Mesh3D;
		public override function getObject3d():*
		{
			if(!_instance3d)
			{
				_instance3d=new ParticlePlane(this._W,this._H,"+xz");
			}
			return _instance3d;
		}
	}
}


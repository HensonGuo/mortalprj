package frEngine.loaders.particleSub
{
	import baseEngine.core.Mesh3D;
	
	import frEngine.primitives.FrCube;

	public class BoxEmitter extends EmitterObject
	{
		private var _H:Number=0;
		private var _W:Number=0;
		private var _L:Number=0;

		private var dx:Number;
		private var dy:Number;
		private var dz:Number;
		
		public function BoxEmitter(W:Number,H:Number,L:Number,emitterPosType:String,$randomArr:Array)
		{
			_W=W;
			_H=H;
			_L=L;
			dx = _W*0.5;
			dy = _H*0.5;
			dz = _L*0.5;
			
			super(emitterPosType,$randomArr);
		}
		
		protected override function processVolume(index:int):void
		{

			_vect3d.x = dx - _W*randnomArr[index];
			_vect3d.y = dy - _H*randnomArr[index+1];
			_vect3d.z = dz - _L*randnomArr[index+2];
		}
		
		protected override function processAxis(index:int):void
		{
			_vect3d.x = 0;
			_vect3d.y = 0;//dy - _H*Math.random();
			_vect3d.z = 0;
		}
		
		protected override function processVertex(index:int):void
		{

			var rand1:Number = randnomArr[index];
			var rand2:Number = randnomArr[index+1];
			var rand3:Number = randnomArr[index+2];
			_vect3d.x = rand1 < 1?-dx:dx;
			_vect3d.y = rand2 < 1?-dy:dy
			_vect3d.z = rand3 < 1?-dz:dz;
		}
		
		protected override function processEdage(index:int):void
		{

			var _rand1:Number = randnomArr[index];
			var _rand2:Number = randnomArr[index+1];
			var _rand3:Number = randnomArr[index+2];
			
			var rand1:Number = _rand1 * 3;
			var rand2:Number = _rand2 * 2;
			var rand3:Number = _rand3 * 2;
			if(rand1 < 1) // 沿着X轴随机
			{
				_vect3d.x = dx - _W*_rand1;
				_vect3d.y = (rand2 < 1?-dy:dy);
				_vect3d.z = (rand3 < 1?-dz:dz);
			}
			else if(rand1 < 2) // 沿着Y轴随机
			{
				_vect3d.x = (rand2 < 1?-dx:dx);
				_vect3d.y = dy - _H*_rand1
				_vect3d.z = (rand3 < 1?-dz:dz);
			}
			else
			{
				_vect3d.x = (rand2 < 1?-dx:dx);
				_vect3d.y = (rand3 < 1?-dy:dy);
				_vect3d.z = dz - _L*_rand1;
			}
		}
		
		protected override function processCurve(index:int):void
		{
			
			
			
			var _rand1:Number = randnomArr[index];
			var _rand2:Number = randnomArr[index+1];
			var _rand3:Number = randnomArr[index+2];
			
			var rand1:Number = _rand1 * 3;
			var rand2:Number = _rand2 * 2;

			if(rand1 < 1) // X轴为+ - dx
			{
				_vect3d.x = (rand2 < 1)?-dx:dx;
				_vect3d.y = dy - _H*_rand2;
				_vect3d.z = dz - _L*_rand3;
			}
			else if(rand1 < 2) // y轴为+ - dy
			{
				_vect3d.x = dx - _W*_rand2;
				_vect3d.y = (rand2 < 1)?-dy:dy
				_vect3d.z = dz - (_L*_rand3);
			}
			else // z 轴为+ - dz
			{
				_vect3d.x = dx - _W*_rand2;
				_vect3d.y = dy - _H*_rand3;
				_vect3d.z = rand2 < 1?-dz:dz
			}
		}
		
		private var _instance3d:Mesh3D;
		public override function getObject3d():*
		{
			if(!_instance3d)
			{
				_instance3d=new FrCube("",null,_W,_H,_L);
			}
			return _instance3d;
		}
	}
}
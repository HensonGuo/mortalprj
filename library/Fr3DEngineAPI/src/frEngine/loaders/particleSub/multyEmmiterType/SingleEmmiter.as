package frEngine.loaders.particleSub.multyEmmiterType
{
	import flash.geom.Vector3D;
	
	import frEngine.animateControler.particleControler.ParticleParams;
	import frEngine.core.mesh.NormalMesh3D;
	import frEngine.shader.filters.vertexFilters.ParticleVertexFilter;
	
	public class SingleEmmiter implements IMultyEmmiterType
	{
		private var _distanceBirthNum:int;
		public function SingleEmmiter()
		{
			
		}
		public function get defaultStartPos():Vector3D
		{
			return null;
		}
		public function get defaultEndPos():Vector3D
		{
			return null;
		}
		public function get defaultMultyPlaySpeed():int
		{
			return 0;
		}
		public function get distanceBirthNum():int
		{
			return _distanceBirthNum;
		}
		
		public function reInit($startPos:Vector3D,$endPos:Vector3D,$speed:int, _particleParams:ParticleParams,vc0_60:Vector.<Number>):void
		{
			
		}
		
		public function initData(_particleParams:ParticleParams):void
		{
			if(_particleParams.distanceBirth)
			{
				_distanceBirthNum=(_particleParams.instancingObject is NormalMesh3D)?20:ParticleVertexFilter.maxConstRegistNum;
			}else
			{
				_distanceBirthNum=1;
			}
		}
	}
}
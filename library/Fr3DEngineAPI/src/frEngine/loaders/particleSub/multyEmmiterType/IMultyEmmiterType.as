package frEngine.loaders.particleSub.multyEmmiterType
{
	import flash.geom.Vector3D;
	
	import frEngine.animateControler.particleControler.ParticleParams;

	public interface IMultyEmmiterType
	{
		function get defaultStartPos():Vector3D;
		function get defaultEndPos():Vector3D;
		function get defaultMultyPlaySpeed():int;
		function get distanceBirthNum():int;
		function reInit($startPos:Vector3D,$endPos:Vector3D,$speed:int,_particleParams:ParticleParams,vc0_60:Vector.<Number>):void;
		function initData(_particleParams:ParticleParams):void;
	}
}
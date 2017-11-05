package frEngine.loaders.particleSub.multyEmmiterType
{ 
	import flash.geom.Vector3D;
	
	import frEngine.animateControler.particleControler.ParticleParams;
	
	public class PointMultyEmmiter implements IMultyEmmiterType
	{
		private var _defaultStartPos:Vector3D=new Vector3D();
		private var _defaultEndPos:Vector3D=defaultStartPos;
		private var strValue:String;
		private static const _temp:Vector3D=new Vector3D();
		public function PointMultyEmmiter(str:String)
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
			return 0;
		}
		
		public function initData(_particleParams:ParticleParams):void
		{
			
			var arr:Array=strValue.split(",");
			var _t:String=arr[1];
			var _ta:Array=_t.split(" ");
			_defaultStartPos=new Vector3D(_ta[0],_ta[1],_ta[2]);
			
		}
		public function get distanceBirthNum():int
		{
			return 1;
		}
		public function reInit($startPos:Vector3D,$endPos:Vector3D,$speed:int,_particleParams:ParticleParams,vc0_60:Vector.<Number>):void
		{

			if($startPos==null)
			{
				$startPos=_defaultStartPos;
			}
			vc0_60.push($startPos.x,$startPos.y,$startPos.z,0);
		}

	}
}
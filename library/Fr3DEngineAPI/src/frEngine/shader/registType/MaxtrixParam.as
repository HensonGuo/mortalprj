package frEngine.shader.registType
{
	import flash.display3D.Context3DProgramType;
	import flash.geom.Matrix3D;
	
	import frEngine.shader.registType.base.RegistParam;

	public class MaxtrixParam extends RegistParam
	{
		
		public var type:String;
		public function MaxtrixParam($type:String,$index:int,$paramName:String,$isGlobleVar:Boolean,$defaultValue:Matrix3D)
		{
			var _registName:String;
			type=$type;
			if($type==Context3DProgramType.VERTEX)
			{
				_registName="vc"+$index;
			}else
			{
				_registName="fc"+$index;
			}
			super(_registName,$index,$paramName,$isGlobleVar,$defaultValue);
		}
		public function clone():MaxtrixParam
		{
			return new MaxtrixParam(this.type,this.index,this.paramName,this.isGlobleVar,this.value);
		}
	}
}
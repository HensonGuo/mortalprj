package frEngine.shader.registType
{

	import frEngine.shader.registType.base.ConstParamBase;

	public class VcParam extends ConstParamBase
	{
		
		public function VcParam($index:int,$paramName:String,isGlobleVar:Boolean,$defaultValue:Vector.<Number>)
		{
			super("vc"+$index,$index,$paramName,isGlobleVar,$defaultValue);
		}
		public function clone():VcParam
		{
			return new VcParam(this.index,this.paramName,this.isGlobleVar,this.value);
		}
		
		
	}
}
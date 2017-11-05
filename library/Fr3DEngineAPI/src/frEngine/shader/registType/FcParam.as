package frEngine.shader.registType
{
	import frEngine.shader.registType.base.ConstParamBase;

	public class FcParam extends ConstParamBase
	{
		
		public function FcParam($index:int,$paramName:String,$isGlobleVar:Boolean,$defaultValue:Vector.<Number>)
		{
			super("fc"+$index,$index,$paramName,$isGlobleVar,$defaultValue);
		}
		public function clone():FcParam
		{
			return new FcParam(this.index,this.paramName,this.isGlobleVar,this.value);
		}
	}
}

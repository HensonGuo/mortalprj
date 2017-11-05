package frEngine.shader.registType.base
{
	import baseEngine.system.Device3D;

	public class RegistParam
	{
		public var index:int;
		public var registName:String;
		public var paramName:String;
		public var isGlobleVar:Boolean;
		public var value:*;
		public var hasDisposed:Boolean=false;
		public function RegistParam($registName:String,$index:int,$paramName:String,$isGlobleVar:Boolean,$defaultValue:*)
		{
			index=$index;
			registName=$registName;
			paramName=$paramName;
			isGlobleVar=$isGlobleVar;
			if(isGlobleVar)
			{
				var _paramName:String=paramName.substr(1,paramName.length-2);
				value=Device3D[_paramName]
			}else
			{
				value=$defaultValue;
				
			}
			
		}
		public function dispose():void
		{
			hasDisposed=true;
		}
	}
}
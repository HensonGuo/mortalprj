package frEngine.shader
{
	public class ToBuilderInfo
	{
		public var type:String;
		public var oldVarName:String;

		public var paramName:String;
		public var isGlobleVar:Boolean;
		public var varNum:int;
		public var defaultValue:*;
		public var isVertex:Boolean;

		public function ToBuilderInfo($oldVarName:String,$paramName:String,$isGlobleVar:Boolean,$varNum:int,$defaultValue:*=null,program:Program3dRegisterInstance=null)
		{
			oldVarName=$oldVarName;
			paramName=$paramName;
			if(paramName.indexOf("{")!=0 || paramName.indexOf("}")!=paramName.length-1)
			{
				throw new Error("名称不合法，请加上{}");
				return;
			}
			isGlobleVar=$isGlobleVar;
			varNum=$varNum;
			type=oldVarName.substr(0,2);
			if(type=="vf")
			{
				type="v";
			}
			
			defaultValue=$defaultValue;
			
			if(defaultValue is Array)
			{
				defaultValue=Vector.<Number>(defaultValue);
			}
			
			if(type=="va"||type=="vc"||type=="vm"||type=="v"||type=="vt")
			{
				isVertex=true;
			}else
			{
				isVertex=false;
			}
			
			if(program)
			{
				program.registParam(this);
			}
		}
	}
}
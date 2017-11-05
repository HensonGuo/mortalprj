package frEngine.shader.filters.fragmentFilters
{
	
	import frEngine.shader.Program3dRegisterInstance;
	import frEngine.shader.ToBuilderInfo;
	import frEngine.shader.filters.FilterBase;
	import frEngine.shader.filters.FilterName;
	import frEngine.shader.filters.FilterPriority;
	import frEngine.shader.filters.FilterType;
	import frEngine.shader.registType.FtParam;
	
	public class UvCenterScaleFilter extends FilterBase
	{
		public var params:Vector.<Number>;
		
		public function UvCenterScaleFilter()
		{
			super(FilterType.UVCenterScale,FilterPriority.UvCenterScale);
			params = Vector.<Number>([0.5,0.5,1,-1]);
		}
		public override function setRegisterParams(program:Program3dRegisterInstance):void
		{
			program.getParamByName("{scaleSize}",false).value=params;
		}
		
		public override function get programeId():String
		{
			return "UvCenterScale0";
		}
		public override function createFragmentUvCoord(frprogram:Program3dRegisterInstance):String
		{
			var code:String = "";
			var uvCoord:FtParam=frprogram.getParamByName(FilterName.F_UVPostion,false);
			if(uvCoord)
			{
				var buildinfos:Array=new Array();
				var uvcoordFlag:String=uvCoord.paramName;
				buildinfos.push(new ToBuilderInfo("fc0", "{scaleSize}", false, 1, params));
				
				code += "sub				ft0.xy				"+uvcoordFlag+".xy		fc0.xy			\n";
				
				code += "mov				ft0.z				{fcConst1}.x							\n";
				
				code += "nrm				ft1.xyz				ft0.xyz									\n"; 
				
				code += "mul				ft1.xy				ft1.xy					fc.z			\n";

				code += "add				ft0.xy				ft0.xy					ft1.xy			\n"; 
				
				code += "add				ft0.xy				ft0.xy					fc0.xy			\n"; 
				// 转移到 vf0 以供给fragmentCode使用
				code += "mov				"+uvcoordFlag+".xy				ft0.xy						\n";

				code=frprogram.toBuild(code,buildinfos);
			}
			
			return code;
		}
	}
}


/**
 * @date 2013-10-17 下午5:05:51
 * @author chenriji
 */
package frEngine.shader.filters.fragmentFilters
{

	import frEngine.shader.Program3dRegisterInstance;
	import frEngine.shader.ToBuilderInfo;
	import frEngine.shader.filters.FilterBase;
	import frEngine.shader.filters.FilterName;
	import frEngine.shader.filters.FilterPriority;
	import frEngine.shader.filters.FilterType;
	import frEngine.shader.registType.FtParam;
	
	public class UvRotateFilter extends FilterBase
	{
		public var params:Vector.<Number>;
		
		public function UvRotateFilter()
		{
			super(FilterType.UVRotateAnimation,FilterPriority.UvRotate);
			params = new Vector.<Number>(4, true); // 旋转中心点x，旋转中心点y，旋转角度
			params[0] = 0.5;
			params[1] = 0.5;
			params[2] = 0;
		}
		public override function setRegisterParams(program:Program3dRegisterInstance):void
		{
			program.getParamByName("{UVrotate}",false).value=params;
		}
		
		public override function get programeId():String
		{
			return "uvRotate0";
		}
		public override function createFragmentUvCoord(frprogram:Program3dRegisterInstance):String
		{
			var code:String = "";
			var uvCoord:FtParam=frprogram.getParamByName(FilterName.F_UVPostion,false);
			if(uvCoord)
			{
				var buildinfos:Array=new Array();
				var uvcoordFlag:String=uvCoord.paramName;
				buildinfos.push(new ToBuilderInfo("fc0", "{UVrotate}", false, 1, params));
				
				code += "sub				ft0.xy				"+uvcoordFlag+".xy				fc0.xy				\n"; 
				//计算转移
				code += "mov				ft1					fc0										\n"; 
				// cos@
				code += "cos				ft0.z				ft1.z									\n"; 
				// sin@
				code += "sin				ft0.w				ft1.z									\n";
				
				// cos@ * X
				code += "mul				ft1.xyzw			ft0.zwwz			ft0.xyxy			\n";
				// cos@ * x - sin@ * y
				code += "sub				ft2.x				ft1.x				ft1.y				\n";
				// sin@ * x - cos@ * y
				code += "add				ft2.y				ft1.z				ft1.w				\n";
				
				// 转移回ui坐标系
				code += "add				ft2.xy				ft2.xy				fc0.xy				\n";
				
				// 转移到 vf0 以供给fragmentCode使用
				code += "mov				"+uvcoordFlag+".xy				ft2.xy						\n";
				
				
				code=frprogram.toBuild(code,buildinfos);
			}
			
			return code;
		}
	}
}
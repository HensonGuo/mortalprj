package frEngine.shader.filters.fragmentFilters
{
	import frEngine.shader.Program3dRegisterInstance;
	import frEngine.shader.ToBuilderInfo;
	import frEngine.shader.filters.FilterBase;
	import frEngine.shader.filters.FilterName;
	import frEngine.shader.filters.FilterPriority;
	import frEngine.shader.filters.FilterType;
	import frEngine.shader.registType.FtParam;
	
	public class UvScaleFilter extends FilterBase
	{
		public var uvValue:Vector.<Number>=Vector.<Number>([1,1,0,0]);
		public function UvScaleFilter(uScalue:Number=1,vScalue:Number=1)
		{
			super(FilterType.MaterialUvScale,FilterPriority.UvScale);
			uvValue[0]=uScalue;
			uvValue[1]=vScalue;
		}
		public override function setRegisterParams(program:Program3dRegisterInstance):void
		{
			program.getParamByName("{UVscale}",false).value=uvValue;
		}
		
		public override function get programeId():String
		{
			return "uvScale0";
		}
		public override function getParams():XML
		{
			var xml:XML=<params/>;
			return xml;
		}
		
		public override function createFragmentUvCoord(frprogram:Program3dRegisterInstance):String
		{
			var code:String=""; 
			var uvCoord:FtParam=frprogram.getParamByName(FilterName.F_UVPostion,false);
			if(uvCoord)
			{
				var buildinfos:Array=new Array();
				var uvcoordFlag:String=uvCoord.paramName;
				buildinfos.push(new ToBuilderInfo("fc0","{UVscale}",false,1,uvValue));
				code +=	"mul           "+uvcoordFlag+".xy        "+uvcoordFlag+".xy           fc0         	\n";
				code=frprogram.toBuild(code,buildinfos);
			}

			return code;
		}
	}
}


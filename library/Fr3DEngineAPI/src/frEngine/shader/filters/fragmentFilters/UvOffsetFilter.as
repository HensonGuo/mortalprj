package frEngine.shader.filters.fragmentFilters
{
	import frEngine.shader.Program3dRegisterInstance;
	import frEngine.shader.ToBuilderInfo;
	import frEngine.shader.filters.FilterBase;
	import frEngine.shader.filters.FilterName;
	import frEngine.shader.filters.FilterPriority;
	import frEngine.shader.filters.FilterType;
	import frEngine.shader.registType.FtParam;

	public class UvOffsetFilter extends FilterBase
	{
		public var uvOffsetValue:Vector.<Number>=Vector.<Number>([0,0,0,0]);
		public function UvOffsetFilter(uOffset:Number=0,vOffset:Number=0)
		{
			super(FilterType.MaterialUvOffset,FilterPriority.UvOffset);
			uvOffsetValue[0]=uOffset;
			uvOffsetValue[1]=vOffset;
		}
		public override function setRegisterParams(program:Program3dRegisterInstance):void
		{
			program.getParamByName("{UVoffset}",false).value=uvOffsetValue;
		}
		
		public override function get programeId():String
		{
			return "uvOffset0";
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
				buildinfos.push(new ToBuilderInfo("fc0","{UVoffset}",false,1,uvOffsetValue));
				code +=	"add           "+uvcoordFlag+".xy        "+uvcoordFlag+".xy      fc0.xy    	\n";
				code=frprogram.toBuild(code,buildinfos);
			}
			return code;
		}
	}
}
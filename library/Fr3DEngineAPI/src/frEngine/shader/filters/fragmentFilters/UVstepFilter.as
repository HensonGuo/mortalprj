package frEngine.shader.filters.fragmentFilters
{

	import frEngine.shader.Program3dRegisterInstance;
	import frEngine.shader.ToBuilderInfo;
	import frEngine.shader.filters.FilterBase;
	import frEngine.shader.filters.FilterName;
	import frEngine.shader.filters.FilterPriority;
	import frEngine.shader.filters.FilterType;
	import frEngine.shader.registType.FtParam;
	
	
	public class UVstepFilter extends FilterBase
	{

		private var UVstepOffsetPoint:Vector.<Number>=new Vector.<Number>(4,true);
		public function UVstepFilter(u:Number,v:Number)
		{
			super(FilterType.NodeUVstepFilter,FilterPriority.UVstepFilter);
			UVstepOffsetPoint[0]=1/u;
			UVstepOffsetPoint[1]=1/v;
		}
		
		public override function setRegisterParams(program:Program3dRegisterInstance):void
		{
			program.getParamByName("{UVstepOffsetPoint}",false).value=UVstepOffsetPoint;
		}
		
		public override function get programeId():String
		{
			return "uvstep0";
		}
		public override function getParams():XML
		{
			var xml:XML=<params/>;
			//var param0:XML=new XML("<param paramIndex='0' classType='Number' value='"+skinNum+"'/>");
			//xml.appendChild(param0);
			return xml;
		}
		public override function clone():FilterBase
		{
			return this;
		}
		public override function createFragmentUvCoord(frprogram:Program3dRegisterInstance):String
		{
			var code:String="";
			var uvCoord:FtParam=frprogram.getParamByName(FilterName.F_UVPostion,false);
			if(uvCoord)
			{
				var toReplace:Array=[];
				var uvcoordFlag:String=uvCoord.paramName;
				toReplace.push(new ToBuilderInfo("fc0","{UVstepOffsetPoint}",false,1,UVstepOffsetPoint));
				code +=	"mul           "+uvcoordFlag+".xy        "+uvcoordFlag+".xy      fc0.xy         	\n";
				code +=	"add           "+uvcoordFlag+".xy        "+uvcoordFlag+".xy      fc0.zw    		\n";
				code=frprogram.toBuild(code,toReplace);
			}
			
			return code;
		}
	}
}


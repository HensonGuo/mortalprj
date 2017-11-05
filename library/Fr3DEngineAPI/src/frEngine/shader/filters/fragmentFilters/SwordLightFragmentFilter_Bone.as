package frEngine.shader.filters.fragmentFilters
{
	import frEngine.shader.Program3dRegisterInstance;
	import frEngine.shader.ToBuilderInfo;
	import frEngine.shader.filters.FilterBase;
	import frEngine.shader.filters.FilterName;
	import frEngine.shader.filters.FilterPriority;
	import frEngine.shader.filters.FilterType;
	import frEngine.shader.registType.FcParam;
	import frEngine.shader.registType.FtParam;
	
	public class SwordLightFragmentFilter_Bone extends FilterBase
	{

		public var uvOffset:Vector.<Number>=Vector.<Number>([0,1,0,0]);
		public function SwordLightFragmentFilter_Bone()
		{
			super(FilterType.SwordLightFilter_Bone,FilterPriority.Sword_Bone);
		}
		
		public override function setRegisterParams(program:Program3dRegisterInstance):void
		{
			var register:FcParam=program.getParamByName("{swordUVOffset}",false)
			register && (register.value=uvOffset);
		}
		
		public override function get programeId():String
		{
			return "swordUVOffset"
		}
		public override function getParams():XML
		{
			var xml:XML=<params/>;
			var param0:XML=new XML("<param paramIndex='0' classType='flare.core.Texture3D' value='texture3d'/>");
			xml.appendChild(param0);
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
				buildinfos.push(new ToBuilderInfo("fc0","{swordUVOffset}",false,1,uvOffset));
				code +=	"sub           "+uvcoordFlag+".x        "+uvcoordFlag+".x				fc0.x    		\n";
				code +=	"mul           "+uvcoordFlag+".x        "+uvcoordFlag+".x				fc0.y         	\n";
				code=frprogram.toBuild(code,buildinfos);
			}
			
			return code;
		}

		
		
	}
}

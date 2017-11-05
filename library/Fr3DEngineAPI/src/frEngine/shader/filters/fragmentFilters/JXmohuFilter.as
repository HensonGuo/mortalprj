package frEngine.shader.filters.fragmentFilters
{
	import baseEngine.core.Texture3D;
	
	import frEngine.shader.Program3dRegisterInstance;
	import frEngine.shader.ToBuilderInfo;
	import frEngine.shader.filters.FilterBase;
	import frEngine.shader.filters.FilterName;
	import frEngine.shader.filters.FilterPriority;
	import frEngine.shader.filters.FilterType;
	import frEngine.shader.registType.FsParam;
	import frEngine.shader.registType.FtParam;
	
	public class JXmohuFilter extends FilterBase
	{
		private const step:Number = 7;
		private const stepLen:Number=0.01;

		public var blurConst:Vector.<Number>=Vector.<Number>([0.04,0.5,1-stepLen,step]);
		
		public function JXmohuFilter()
		{
			super(FilterType.JXmohu,FilterPriority.JXmohuFilter);

		}
		public override function setRegisterParams(program:Program3dRegisterInstance):void
		{
			program.getParamByName("{blurConst}",false).value=blurConst;
		}
		
		public override function get programeId():String
		{
			return "JXmohuFilter0";
		}
		public override function getParams():XML
		{
			var xml:XML=<params/>;
			return xml;
		}
		
		public override function createFragmentColor(frprogram:Program3dRegisterInstance,uvRepeat:Boolean):String
		{
			var code:String=""; 
			var uvCoord:FtParam=frprogram.getParamByName(FilterName.F_UVPostion,false);
			if(uvCoord)
			{
				var buildinfos:Array=new Array();
				buildinfos.push(new ToBuilderInfo("fc0","{blurConst}",false,1,blurConst));

				var _fragmentProgram_0:String =  "sub ft0 {F_UVPostion} fc0.y\n"+
					"mul ft1.xy ft0.xy ft0.xy\n"+
					"add ft1.x ft1.x ft1.y\n"+
					"mul ft1.x ft1.x fc0.x\n"+
					"sub ft1.x {fcConst1}.z ft1.x\n";
				

				var textureRegister:FsParam=frprogram.getParamByName("{texture1}",false);
				var texture:Texture3D=textureRegister.value;
				var texureParamLine:String=getSmapleString("{texture1}",texture.format,uvRepeat,texture.mipMode);
				
				var _fragmentProgram_1:String =  "mul ft0.xy ft0.xy ft1.x\n" +
					"add ft2 ft0 fc0.y\n" +
					"tex ft2 ft2 "+texureParamLine+"\n" +
					"add {output} {output} ft2\n";
				
				var _fragmentProgram_2:String = "div {output} {output} fc0.w\n";
				
				code = _fragmentProgram_0;
				
				for (var i:int = 1; i < step; i++)
				{
					code = code + _fragmentProgram_1;
				}
				
				code = code + _fragmentProgram_2;
				
				code=frprogram.toBuild(code,buildinfos);
			}
			return code;
		}
	}
}
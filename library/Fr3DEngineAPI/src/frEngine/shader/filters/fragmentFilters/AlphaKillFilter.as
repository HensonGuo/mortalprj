package frEngine.shader.filters.fragmentFilters
{
	import frEngine.shader.Program3dRegisterInstance;
	import frEngine.shader.ToBuilderInfo;
	import frEngine.shader.filters.FilterBase;
	import frEngine.shader.filters.FilterPriority;
	import frEngine.shader.filters.FilterType;

	public class AlphaKillFilter extends FilterBase
	{
		private var _kilValues:Vector.<Number>=new Vector.<Number>(4,true);
		public function AlphaKillFilter($kilValue:Number)
		{
			super(FilterType.Fragment_AlphaKill,FilterPriority.AlphaKillFilter);
			kilValue=$kilValue;
		}
		
		public override function setRegisterParams(program:Program3dRegisterInstance):void
		{
			program.getParamByName("{alphaMinValue}",false).value=_kilValues;
		}
		
		public override function get programeId():String
		{
			return "alphaKill0";
		}
		
		public function set kilValue(value:Number):void
		{
			_kilValues[0]=_kilValues[1]=_kilValues[2]=_kilValues[3]=value;
		}
		public override function getParams():XML
		{
			var xml:XML=<params/>;
			return xml;
		}
		/*public override function createVertexCode(frprogram:FrProgram3D):String
		{
			var toReplace:Array=[];
			toReplace.push(new ToBuilderInfo("vc0","alphaMinValue",false,1,false,[kilValue,kilValue,kilValue,kilValue]));
			toReplace.push(new ToBuilderInfo("vf1",FilterParams.V_UVscale,false,1));
			
			vertexCode+="sgl           vf0      			vc0.xy  		 	 							\n";//xy位置
			vertexCode+="mov           vf1      			vc1.xy  		 	 							\n";
			vertexCode=frprogram.toBuild(vertexCode,toReplace);
			return vertexCode;
		}*/
		public override function createFragmentColor(frprogram:Program3dRegisterInstance,uvRepeat:Boolean):String
		{
			var buildinfos:Array=new Array();
			buildinfos.push(new ToBuilderInfo("fc0","{alphaMinValue}",false,1,_kilValues));
			var framentCode:String = "sub           ft0.x    		{output}.w  		fc0.x				\n";
			framentCode  += "kil           ft0.x    												\n";
			framentCode=frprogram.toBuild(framentCode,buildinfos);
			return framentCode;
		}
	}
}

package frEngine.shader.filters.fragmentFilters
{

	import frEngine.shader.Program3dRegisterInstance;
	import frEngine.shader.ToBuilderInfo;
	import frEngine.shader.filters.FilterBase;
	import frEngine.shader.filters.FilterName;
	import frEngine.shader.registType.Vparam;
	
	public class ColorFilter extends FragmentFilter
	{
		
		
		public var colorValue:Vector.<Number>=new Vector.<Number>(4,true);

		public function ColorFilter($colorR:Number,$colorG:Number,$colorB:Number,$alpha:Number=1)
		{
			
			colorValue[0]=$colorR;
			colorValue[1]=$colorG;
			colorValue[2]=$colorB;
			colorValue[3]=$alpha;
			super();
			
		}
		public override function setRegisterParams(program:Program3dRegisterInstance):void
		{
			program.getParamByName(FilterName.COLOR,false).value=colorValue;
		}
		
		public override function get programeId():String
		{
			return "color0";
		}
		public override function getParams():XML
		{
			var xml:XML=<params/>;
			var param0:XML=new XML("<param paramIndex='0' classType='Number' value='"+colorValue[0]+"'/>");
			var param1:XML=new XML("<param paramIndex='1' classType='Number' value='"+colorValue[1]+"'/>");
			var param2:XML=new XML("<param paramIndex='2' classType='Number' value='"+colorValue[2]+"'/>");
			var param3:XML=new XML("<param paramIndex='3' classType='Number' value='"+colorValue[3]+"'/>");
			xml.appendChild(param0);
			xml.appendChild(param1);
			xml.appendChild(param2);
			xml.appendChild(param3);
			return xml;
		}
		public override function clone():FilterBase
		{
			return this;
		}
		public function set colorR(value:Number):void
		{
			colorValue[0]=value;

			
		}
		public function set colorG(value:Number):void
		{
			colorValue[1]=value;

		}
		public function set colorB(value:Number):void
		{
			colorValue[2]=value;
		}
		public function set alpha(value:Number):void
		{
			colorValue[3]=value;

		}
		public override function createVertexCode(frprogram:Program3dRegisterInstance):String
		{
			return "";
		}
		
		public override function createFragmentUvCoord(frprogram:Program3dRegisterInstance):String
		{
			var code:String="";
			var v_globle:Vparam=frprogram.getParamByName(FilterName.V_GloblePos,true);
			if(v_globle)
			{
				code	+= "sub			ft0.x	   {V_GloblePos}.y	{fcConst1}.x	\n";
				code	+= "kil			ft0.x	   										\n";
			}
			return code;
		}
		
		public override function createFragmentColor(frprogram:Program3dRegisterInstance,uvRepeat:Boolean):String
		{

			var buildinfos:Array=new Array();
			buildinfos.push(new ToBuilderInfo("fc0",FilterName.COLOR,false,1,colorValue));
			
			var framentCode:String="";
			
			var V_ColorOffset:Vparam=frprogram.getParamByName(FilterName.V_ColorOffset,false);

			if(V_ColorOffset)
			{
				framentCode =	"add           {output}        fc0      "+V_ColorOffset.paramName+"    	\n";
			}else
			{
				framentCode	  = "mov           {output}        fc0									\n"; 
			}
			
			framentCode=frprogram.toBuild(framentCode,buildinfos);

			return framentCode;
			
		}
	}
}


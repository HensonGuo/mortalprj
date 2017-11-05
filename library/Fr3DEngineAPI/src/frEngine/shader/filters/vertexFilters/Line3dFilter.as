package frEngine.shader.filters.vertexFilters
{
	import frEngine.shader.Program3dRegisterInstance;
	import frEngine.shader.ToBuilderInfo;
	import frEngine.shader.filters.FilterName;
	import frEngine.shader.filters.FilterType;
	import frEngine.shader.filters.vertexFilters.def.ECalculateOpType;

	
	public class Line3dFilter extends VertexFilter
	{
		private var near:Vector.<Number>=Vector.<Number>([1,1,1,1]);
		private var size:Vector.<Number>=Vector.<Number>([0.001,0.001,0.001,0.001]);
		public function Line3dFilter()
		{
			super(FilterType.Transform);
		}
		public override function setRegisterParams(program:Program3dRegisterInstance):void
		{
			program.getParamByName("{near}",true).value=near;
			program.getParamByName("{size}",true).value=size;
		}
		public override function getParams():XML
		{
			var xml:XML=<params/>;
			/*var param0:XML=new XML("<param paramIndex='0' classType='Number' value='"+skinNum+"'/>");
			xml.appendChild(param0);*/
			return xml;
		}
		public override function get programeId():String
		{
			return "Line3d0"
		}
		public override function createVertexCode(frprogram:Program3dRegisterInstance):String
		{
			var toReplace:Array=[];
			toReplace.push(new ToBuilderInfo("vm1",FilterName.worldView,true,4));
			toReplace.push(new ToBuilderInfo("vm2",FilterName.proj,true,4));
			toReplace.push(new ToBuilderInfo("vc5","{near}",false,1,near));
			toReplace.push(new ToBuilderInfo("vc6","{size}",false,1,size));

			toReplace.push(new ToBuilderInfo("va0",FilterName.POSITION,false,3));
			toReplace.push(new ToBuilderInfo("va1",FilterName.PARAM0,false,3));//linePosition2
			toReplace.push(new ToBuilderInfo("va2",FilterName.PARAM1,false,1));//lineThickness
			//toReplace.push(new ToBuilderInfo("va3",FilterName.PARAM2,false,4));//lineColorOffset
			//toReplace.push(new ToBuilderInfo("vf0",FilterName.V_ColorOffset,false,1));
			
			var vertexCode:String="";
			vertexCode+="m44           vt0           va0           vm1		\n";           
			vertexCode+="m44           vt1           va1           vm1		\n";           
			vertexCode+="sub           vt2           vt1           vt0		\n";           
			vertexCode+="slt           vt3           vt0.z         vc5.x		\n";         
			vertexCode+="sub           vt3.y         {vcConst1}.z  vt3.x		\n";         
			vertexCode+="sub           vt3.z         vt0.xxz       vc5.x		\n";         
			vertexCode+="sub           vt3.w         vt0.xxxz      vt1.xxxz	\n";      
			vertexCode+="div           vt4           vt3.z         vt3.w		\n";         
			vertexCode+="mul           vt5           vt2           vt4.x		\n";         
			vertexCode+="add           vt4           vt0           vt5		\n";           
			vertexCode+="mul           vt5           vt3.x         vt4		\n";           
			vertexCode+="mul           vt4           vt0           vt3.y		\n";         
			vertexCode+="add           vt0           vt5           vt4		\n";           
			vertexCode+="crs           vt3.xyz       vt2           vt1		\n";           
			vertexCode+="nrm           vt1.xyz       vt3						\n";           
			vertexCode+="mul           vt2.xyz       vt1           va2.x		\n";         
			vertexCode+="mul           vt1.x         vt0.z         vc6.x		\n";         
			vertexCode+="mul           vt3.xyz       vt2           vt1.x		\n";         
			vertexCode+="add           {output}  	vt0           vt3		\n";           
			vertexCode+="mov           {output}.w         {vcConst1}.z		\n";          
			//vertexCode+="mov           vf0      		 va3           		\n"; 
			
			vertexCode=frprogram.toBuild(vertexCode,toReplace);
			frprogram.OpType=ECalculateOpType.Proj
			return vertexCode;
		}
	}
}
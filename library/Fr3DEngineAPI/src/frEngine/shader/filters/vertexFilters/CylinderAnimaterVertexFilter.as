package frEngine.shader.filters.vertexFilters
{

	import frEngine.shader.Program3dRegisterInstance;
	import frEngine.shader.ToBuilderInfo;
	import frEngine.shader.filters.FilterName;
	import frEngine.shader.filters.FilterType;
	import frEngine.shader.filters.vertexFilters.def.ECalculateOpType;
	import frEngine.shader.registType.Vparam;
	
	public class CylinderAnimaterVertexFilter extends VertexFilter
	{
		public var params:Vector.<Number>;
		public function CylinderAnimaterVertexFilter($topR:Number,$bottomR:Number,$h:Number)
		{
			params=Vector.<Number>([$topR,$h,$bottomR,0]);
			super(FilterType.CylinderVertexFilter);
		}
		public override function setRegisterParams(program:Program3dRegisterInstance):void
		{
			program.getParamByName("{params}",true).value=params;
		}
		public override function get programeId():String
		{
			return "cylinderAnim0"
		}
		public override function getParams():XML
		{
			var xml:XML=<params/>;
			/*var param0:XML=new XML("<param paramIndex='0' classType='Number' value='"+skinNum+"'/>");
			xml.appendChild(param0);*/
			return xml;
		}
		
		public override function createVertexCode(frprogram:Program3dRegisterInstance):String
		{
			var toReplace:Array=[];
			toReplace.push(new ToBuilderInfo("vc0","{params}",false,1,params));
			toReplace.push(new ToBuilderInfo("va0",FilterName.POSITION,false,4));//c

			var vertexCode:String="";
			vertexCode+="mul         	 vt0     		 	 vc0					va0							\n";
			vertexCode+="add           vt1.w      	 	 vt0.x					vt0.z           			\n";
			vertexCode+="cos           vt0.x     		 va0.w			    	       						\n";  
			vertexCode+="sin           vt0.z      	 	 va0.w					           				\n";
			vertexCode+="mul           vt0.xz     		 vt0.xz			    	vt1.ww       				\n"; 
			vertexCode+="mov           vt0.w      	 	 {vcConst1}.z				           			\n";
			vertexCode+="mov           {output}      	 vt0				           					\n";
			vertexCode=frprogram.toBuild(vertexCode,toReplace);
			frprogram.OpType=ECalculateOpType.World_And_ViewProj;
			return vertexCode;
		}
		/*public override function completeCode(frprogram:Program3dRegisterInstance):String
		{
			var toReplace:Array=[ ]
			toReplace.push(new ToBuilderInfo("vm1",FilterName.global,true,4));
			var vertexCode:String ="";
			vertexCode +="m44         	 {output}      		{output}           vm1			\n";
			
			var v_globle:Vparam=frprogram.getParamByName(FilterName.V_GloblePos,true);
			if(v_globle)
			{
				vertexCode +="mov         {V_GloblePos}  {output}         					\n";
			}
			
			vertexCode +="m44         	 op      				{output}           {viewProj}	\n";
			vertexCode=frprogram.toBuild(vertexCode,toReplace);
			return vertexCode;
		}*/
	}
}


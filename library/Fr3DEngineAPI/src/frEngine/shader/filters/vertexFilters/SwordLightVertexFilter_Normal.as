package frEngine.shader.filters.vertexFilters
{
	import frEngine.shader.Program3dRegisterInstance;
	import frEngine.shader.ToBuilderInfo;
	import frEngine.shader.filters.FilterName;
	import frEngine.shader.filters.FilterType;
	import frEngine.shader.filters.vertexFilters.def.ECalculateOpType;
	import frEngine.shader.registType.Vparam;

	public class SwordLightVertexFilter_Normal extends VertexFilter
	{
		
		public var keyLineNum:int;

		public function SwordLightVertexFilter_Normal($lineNum:int)
		{
			keyLineNum=$lineNum;
			super(FilterType.SwordLightFilter_Normal);
			if(keyLineNum<=0)
			{
				throw new Error("分段数不能小于等于0");
			}
			
		}
		public override function setRegisterParams(program:Program3dRegisterInstance):void
		{
			
		}
		public override function get programeId():String
		{
			return "SwordLight"+keyLineNum;
		}
		
		public function reInit($lineNum:int):Boolean
		{
			if(keyLineNum==$lineNum)
			{
				return false;
			}
			keyLineNum=$lineNum;
			return true;
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
			
			toReplace.push(new ToBuilderInfo("vc1","{keyLinePos}",false,keyLineNum));
			toReplace.push(new ToBuilderInfo("vc2","{keyLineRot}",false,keyLineNum));
			toReplace.push(new ToBuilderInfo("vc7","{const}",false,1,[2.65,-1,2,-1]));
			
			toReplace.push(new ToBuilderInfo("va0",FilterName.SKIN_INDICES,false,4));//cIndex
			toReplace.push(new ToBuilderInfo("va2",FilterName.PARAM0,false,4));//time
			
			toReplace.push(new ToBuilderInfo("va1",FilterName.POSITION,false,4));
			
			var vertexCode:String="";

			vertexCode+="mov         	 vt0     		 	 vc[va0.x]										\n";
			vertexCode+="mov           vt3      	 		 vc[va0.z]				           			\n";
			vertexCode+="sub           vt4      		 	 vt3			    vt0       					\n"; 
			vertexCode+="mov           vt1      	 		 vt4				           				\n";
			vertexCode+="dp3         	 vt1.x     		 vt4				vt1							\n";
			vertexCode+="sqt           vt5.w      		 vt1.x						       				\n";
			vertexCode+="div           vt5.w      		 vt5.w			    vc7.x       				\n"; 
			
			vertexCode+="nrm           vt4.xyz      		 vt4					       					\n";
			
			//计算第一个控制点
			vertexCode+="sub           vt1      		 	 vt0			    	vc[va0.y]       		\n";
			vertexCode+="nrm           vt1.xyz      		 vt1					       					\n";
			vertexCode+="add           vt1      		 	 vt1			    	vt4       				\n";
			vertexCode+="nrm           vt1.xyz      		 vt1					       					\n";
			vertexCode+="mul           vt1      			 vt1					vt5.w       			\n";
			vertexCode+="add           vt1      		 	 vt0			    	vt1       				\n"; 
			
			//计算第二个控制点
			vertexCode+="sub           vt2      		 	 vt3			   	 	vc[va0.w]       		\n";
			vertexCode+="nrm           vt2.xyz      		 vt2					       					\n";
			vertexCode+="sub           vt2      		 	 vt2			    	vt4       				\n";
			vertexCode+="nrm           vt2.xyz      		 vt2					       					\n";
			vertexCode+="mul           vt2      			 vt2					vt5.w       			\n";
			vertexCode+="add           vt2      		 	 vt3			    	vt2       				\n"; 
			
			//三次贝塞尔差值
			vertexCode+="mul           vt0      			 vt0					va2.x       			\n";
			vertexCode+="mul           vt1      			 vt1					va2.y       			\n";
			vertexCode+="mul           vt2      			 vt2					va2.z       			\n";
			vertexCode+="mul           vt3      			 vt3					va2.w       			\n";
			vertexCode+="add           vt0      			 vt0					vt1       				\n";
			vertexCode+="add           vt0      			 vt0					vt2       				\n";
			vertexCode+="add           vt0      			 vt0					vt3       				\n";

			//四元数进行插值
			vertexCode+="mov         	 vt1     		 	 vc[va0.x+"+keyLineNum+"]						\n";
			vertexCode+="mov           vt2      	 		 vc[va0.z+"+keyLineNum+"]				       \n";
			
			vertexCode+="dp4 			 vt3.x 				vt1						vt2						\n";
			vertexCode+="sge 			 vt3.x 				vt3.x					{vcConst1}.x			\n";
			vertexCode+="mul           vt3.x      		vt3.x					vc7.z       			\n";
			vertexCode+="sub           vt3.x      		vt3.x					{vcConst1}.z       	\n";
			vertexCode+="mul           vt2      			 vt2					vt3.x       			\n";
			
			
			vertexCode+="sub           vt3      		 	 vt2			    	vt1       				\n";
			vertexCode+="mul           vt3      			 vt3					va1.w       			\n";
			vertexCode+="add           vt3      			 vt3					vt1       				\n";
			
			//四元数单位化
			vertexCode += "dp4 			vt4.x 				vt3						vt3						\n";
			vertexCode += "rsq 			vt4.x 				vt4.x											\n";
			vertexCode += "mul 			vt4					vt4.x					vt3						\n";
			
			//四元数旋转一个点,va1
			vertexCode+="crs           vt1.xyz      		 vt4					va1       				\n";
			vertexCode+="crs           vt3.xyz      		 vt4					vt1       				\n";
			vertexCode+="mul           vt1      		 	 vt1					vc7.z       			\n";
			vertexCode+="mul           vt1      		 	 vt1					vt4.w       			\n";
			vertexCode+="mul           vt3      		 	 vt3					vc7.z       			\n";
			vertexCode+="add           vt2      		 	 va1					vt1       				\n";
			vertexCode+="add           vt2      		 	 vt2					vt3       				\n";
			

			vertexCode+="add           vt0      			 vt0					vt2       				\n";
			vertexCode+="mov           vt0.w      	 	 {vcConst1}.z				           		\n";
			vertexCode+="mov           {output}      	 vt0				           				\n";
			
			
			vertexCode=frprogram.toBuild(vertexCode,toReplace);
			
			frprogram.OpType=ECalculateOpType.ViewProj;
			return vertexCode;
		}
		/*public override function completeCode(frprogram:Program3dRegisterInstance):String
		{
			
			var vertexCode:String="";
			var v_globle:Vparam=frprogram.getParamByName(FilterName.V_GloblePos,true);
			if(v_globle)
			{
				vertexCode +="mov         {V_GloblePos}  {output}         					\n";
			}
			
			vertexCode +="m44         	 op      		{output}           {viewProj}		\n";
			return vertexCode;
		}*/
	}
}
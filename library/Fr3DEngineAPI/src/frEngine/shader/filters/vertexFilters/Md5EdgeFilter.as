package frEngine.shader.filters.vertexFilters
{
	import frEngine.shader.Program3dRegisterInstance;
	import frEngine.shader.ToBuilderInfo;
	import frEngine.shader.filters.FilterBase;
	import frEngine.shader.filters.FilterName;
	import frEngine.shader.filters.FilterPriority;
	import frEngine.shader.filters.FilterType;
	
	
	public class Md5EdgeFilter extends FilterBase
	{
		
		protected var skinNum:int;
		private var edgeSize:Vector.<Number>=Vector.<Number>([3,0.1,0,1]);
		public function Md5EdgeFilter($skinNum:int=0)
		{
			super(FilterType.EdgeFilter,FilterPriority.Md5EdgeFilter);
			skinNum=$skinNum;
			if($skinNum>4 || $skinNum<0)
			{
				
				throw new Error("curMaxBoneNum:"+$skinNum+",but max bones is 4 ,min is 0 !<TransformFilter.as>");
				
			}
		}
		public override function setRegisterParams(program:Program3dRegisterInstance):void
		{
			program.getParamByName("{edgeSize}",true).value=edgeSize;
		}
		public override function get programeId():String
		{
			return "eEdgeFilter"+skinNum;
		}
		public override function getParams():XML
		{
			var xml:XML=<params/>;
			var param0:XML=new XML("<param paramIndex='0' classType='Number' value='"+skinNum+"'/>");
			xml.appendChild(param0);
			return xml;
		}
		public override function clone():FilterBase
		{
			return this;
		}
		public override function createVertexCode(frprogram:Program3dRegisterInstance):String
		{
			var vertexCode:String="";
			if(skinNum>0)
			{
				vertexCode=createSkinTransform(frprogram);
			}else
			{
				vertexCode=createNoSkinTransform(frprogram);
			}
			
			var toReplace:Array=new Array();
			toReplace.push(new ToBuilderInfo("va0",FilterName.NORMAL,false,3));
			//toReplace.push(new ToBuilderInfo("vm0",FilterName.worldView,true,4));
			toReplace.push(new ToBuilderInfo("vf0","{alphaNum}",true,1));
			toReplace.push(new ToBuilderInfo("vc0","{edgeSize}",false,4,edgeSize));
			vertexCode=frprogram.toBuild(vertexCode,toReplace);
			return vertexCode;
		}
		private function createNoSkinTransform(frprogram:Program3dRegisterInstance):String
		{
			
			var vertexCode:String= 	""+
									"mov           vt0           	va0 									\n"+
									//"m33           vt0.xyz       		va0           	vm0        				\n"+
									//"nrm           vt0.xyz       	vt0           							\n"+
									"mul           vt0.xyz       	vt0           vc0.x					\n"+
									"add           {output}.xyz     vt0.xyz       {output}.xyz			\n";
			return vertexCode;

		}
		
		private function createSkinTransform(frprogram:Program3dRegisterInstance):String
		{
			
			var vertexCode:String				="mov           vt0           vc0 									\n";
			switch(skinNum)
			{
				case 1:	vertexCode+=""+
					"m33           vt0.xyz       va0           vc[{SKIN_SKIN_INDICES}.x]		\n"+   
					"mul           vt1       	vt0           {SKIN_WEIGHTS}.x   				\n";
					break;
				
				case 2:	vertexCode+=""+
					"m33           vt0.xyz       va0           vc[{SKIN_INDICES}.x]			\n"+   
					"mul           vt1           vt0           {SKIN_WEIGHTS}.x   			\n"+      
					"m33           vt0.xyz       va0           vc[{SKIN_INDICES}.y]  		\n"+
					"mul           vt2           vt0           {SKIN_WEIGHTS}.y         	\n"+
					"add           vt1.xyz       vt1           vt2           				\n";
					break;
				
				case 3:	vertexCode+=""+
					"m33           vt0.xyz       va0           vc[{SKIN_INDICES}.x]			\n"+   
					"mul           vt1           vt0           {SKIN_WEIGHTS}.x   			\n"+      
					"m33           vt0.xyz       va0           vc[{SKIN_INDICES}.y]  		\n"+
					"mul           vt2           vt0           {SKIN_WEIGHTS}.y         	\n"+
					"m33           vt0.xyz       va0           vc[{SKIN_INDICES}.z]  		\n"+
					"mul           vt3           vt0           {SKIN_WEIGHTS}.z         	\n"+
					"add           vt1.xyz       vt1           vt2           				\n"+
					"add           vt1.xyz       vt1           vt3           				\n";
					break;
				case 4:	vertexCode+=""+
					"m33           vt0.xyz       va0           vc[{SKIN_INDICES}.x]			\n"+   
					"mul           vt1           vt0           {SKIN_WEIGHTS}.x   			\n"+      
					"m33           vt0.xyz       va0           vc[{SKIN_INDICES}.y]  		\n"+
					"mul           vt2           vt0           {SKIN_WEIGHTS}.y         	\n"+
					"m33           vt0.xyz       va0           vc[{SKIN_INDICES}.z]  		\n"+
					"mul           vt3           vt0           {SKIN_WEIGHTS}.z         	\n"+
					"m33           vt0.xyz       va0           vc[{SKIN_INDICES}.w]  		\n"+
					"mul           vt4           vt0           {SKIN_WEIGHTS}.w         	\n"+
					"add           vt1.xyz       vt1           vt2           				\n"+
					"add           vt1.xyz       vt1           vt3           				\n"+
					"add           vt1.xyz       vt1           vt4           				\n";
					break;
			}
			//vertexCode+="m33           vt0.xyz       vt1          vm0  							\n";
			vertexCode+="nrm           vt0.xyz       vt1           								\n";
			
			vertexCode+="mul           vt0       	 vt0.xyz		vc0.x           				\n";
			vertexCode+="add           {output}.xyz  vt0.xyz      {output}.xyz    				\n";
			return vertexCode;
			
		}
		/*public override function createFragmentColor(frprogram:FrProgram3D,uvRepeat:Boolean):String
		{
			var framentCode:String="mov	{output}.xyz		{alphaNum}.xyz 		\n";
			return framentCode;
		}*/
	}
}

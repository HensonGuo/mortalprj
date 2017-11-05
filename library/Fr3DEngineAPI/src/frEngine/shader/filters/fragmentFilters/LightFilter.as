package frEngine.shader.filters.fragmentFilters
{
	import frEngine.shader.Program3dRegisterInstance;
	import frEngine.shader.ToBuilderInfo;
	import frEngine.shader.filters.FilterBase;
	import frEngine.shader.filters.FilterName;
	import frEngine.shader.filters.FilterPriority;
	import frEngine.shader.filters.FilterType;
	
	
	public class LightFilter extends FilterBase
	{
		
		protected var skinNum:int;
		public function LightFilter($skinNum:int)
		{
			super(FilterType.LightFilter,FilterPriority.LightFilter);
			skinNum=$skinNum;
			if($skinNum>4 || $skinNum<0)
			{
				
				throw new Error("{curMaxBoneNum}:"+$skinNum+",but max bones is 4 ,min is 0 !<TransformFilter.as>");
				
			}
		}
		
		public override function setRegisterParams(program:Program3dRegisterInstance):void
		{
			
		}
		
		public override function get programeId():String
		{
			return "light0";
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
			var code:String="";
			if(skinNum>0)
			{
				code=createSkinTransform(frprogram);
			}else
			{
				code=createNoSkinTransform(frprogram);
			}
			return code;
		}
		private function createNoSkinTransform(frprogram:Program3dRegisterInstance):String
		{
			var toReplace:Array=[ 	new ToBuilderInfo("vf0","{vnormal}",false,1),
									new ToBuilderInfo("vm0",FilterName.global,true,4),
									new ToBuilderInfo("va0",FilterName.NORMAL,false,3)];
			var vertexCode:String= ""+
						"mov          		vt0           	vm0 									\n"+
						"m33           		vt0.xyz       	va0           			vm0        \n"+
						"nrm          	 		vt0.xyz       	vt0           						\n"+
						"mov           		vf0    		 	vt0           						\n";
			vertexCode=frprogram.toBuild(vertexCode,toReplace);
			return vertexCode;
		}
		
		private function createSkinTransform(frprogram:Program3dRegisterInstance):String
		{
			var toReplace:Array=new Array();
			toReplace.push(new ToBuilderInfo("va0",FilterName.NORMAL,false,3));
			toReplace.push(new ToBuilderInfo("vf0","{vnormal}",false,1));
			toReplace.push(new ToBuilderInfo("vm0",FilterName.global,true,4));
			
			var vertexCode:String				="mov           vt0           vc0 									\n";
			switch(skinNum)
			{
				case 1:	vertexCode+="m33           vt0.xyz       va0           vc[{SKIN_INDICES}.x]			\n"+   
									"mul           vt1.xyz       vt0           {SKIN_WEIGHTS}.x   			\n";break;
				
				case 2:	vertexCode+="m33           vt0.xyz       va0           vc[{SKIN_INDICES}.x]			\n"+   
									"mul           vt1           vt0           {SKIN_WEIGHTS}.x   			\n"+      
									"m33           vt0.xyz       va0           vc[{SKIN_INDICES}.y]  		\n"+
									"mul           vt2           vt0           {SKIN_WEIGHTS}.y         	\n"+
									"add           vt1.xyz       vt1           vt2           				\n";break;
				
				case 3:	vertexCode+="m33           vt0.xyz       va0           vc[{SKIN_INDICES}.x]			\n"+   
									"mul           vt1           vt0           {SKIN_WEIGHTS}.x   			\n"+      
									"m33           vt0.xyz       va0           vc[{SKIN_INDICES}.y]  		\n"+
									"mul           vt2           vt0           {SKIN_WEIGHTS}.y         	\n"+
									"m33           vt0.xyz       va0           vc[{SKIN_INDICES}.z]  		\n"+
									"mul           vt3           vt0           {SKIN_WEIGHTS}.z         	\n"+
									"add           vt1.xyz       vt1           vt2           				\n"+
									"add           vt1.xyz       vt1           vt3           				\n";break;
				case 4:	vertexCode+="m33           vt0.xyz       va0           vc[{SKIN_INDICES}.x]			\n"+   
									"mul           vt1           vt0           {SKIN_WEIGHTS}.x   			\n"+      
									"m33           vt0.xyz       va0           vc[{SKIN_INDICES}.y]  		\n"+
									"mul           vt2           vt0           {SKIN_WEIGHTS}.y         	\n"+
									"m33           vt0.xyz       va0           vc[{SKIN_INDICES}.z]  		\n"+
									"mul           vt3           vt0           {SKIN_WEIGHTS}.z         	\n"+
									"m33           vt0.xyz       va0           vc[{SKIN_INDICES}.w]  		\n"+
									"mul           vt4           vt0           {SKIN_WEIGHTS}.w         	\n"+
									"add           vt1.xyz       vt1           vt2           				\n"+
									"add           vt1.xyz       vt1           vt3           				\n"+
									"add           vt1.xyz       vt1           vt4           				\n";break;
			}
			vertexCode+=			"m33           vt0.xyz       vt1           vm0  							\n"+
									"nrm           vt1.xyz       vt0           								\n"+
									"mov           vf0    		 vt1         									\n";
			
			vertexCode=frprogram.toBuild(vertexCode,toReplace);
			return vertexCode;
			
		}
		public override function createFragmentColor(frprogram:Program3dRegisterInstance,uvRepeat:Boolean):String
		{

			//{fcConst1}.x == 0
			var framentCode:String="mov           ft1           {vnormal}								\n"+                   
						"dp3           ft1.w         ft1           {dirLight}							\n"+           
						"max           ft1.x         ft1.w         {fcConst1}.x						\n"+         
						"mul           ft2           ft1.x         {dirColor}							\n"+           
						"add           ft2           ft2           {ambientColor}					\n"+           
						"mul           {output}      ft2           {output}							\n";
						//"max           ft1                ft1			fc0.x						\n"+  
						//"mov           {output}.xyz      ft1.xyz										\n";
			var buildinfos:Array=new Array();
			framentCode=frprogram.toBuild(framentCode,buildinfos);
			return framentCode;
		}
	}
}


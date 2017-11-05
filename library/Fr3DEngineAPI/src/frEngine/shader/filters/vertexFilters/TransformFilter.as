package frEngine.shader.filters.vertexFilters
{
	import baseEngine.system.Device3D;
	
	import frEngine.shader.Program3dRegisterInstance;
	import frEngine.shader.ToBuilderInfo;
	import frEngine.shader.filters.FilterBase;
	import frEngine.shader.filters.FilterName;
	import frEngine.shader.filters.FilterType;
	import frEngine.shader.filters.vertexFilters.def.ECalculateOpType;

	public class TransformFilter extends VertexFilter
	{
		
		private var _skinNum:int;
		public var OpType:int;
		public function TransformFilter($skinNum:int=0,$useAlpha:Boolean=false,$OpType:int=ECalculateOpType.World_And_ViewProj)
		{
			super(FilterType.Transform);
			skinNum=$skinNum;
			useAlpha=$useAlpha;
			OpType=$OpType;
			if($skinNum>4 || $skinNum<0)
			{
				throw new Error("curMaxBoneNum:"+$skinNum+",but max bones is 4 ,min is 0 !<TransformFilter.as>");
			}
		}
		public override function setRegisterParams(frprogram:Program3dRegisterInstance):void
		{
			
		}
		public override function get programeId():String
		{
			return "transform"+_skinNum+",optype"+OpType+",useAlpha:"+useAlpha;
		}
		
		public override function createFragmentColor(frprogram:Program3dRegisterInstance,uvRepeat:Boolean):String
		{
			var framentCode:String ="";
			if(useAlpha)
			{
				framentCode+="mul           {output}       	  		{output}  		  		{v_vertexAlpha}.x			\n";
			}
			return framentCode;
		}
		
		public override function clone():FilterBase
		{
			return new TransformFilter(this._skinNum);
		}
		public function set skinNum(value:int):void
		{
			if(value<0)
			{
				throw new Error("curMaxBoneNum can not lower than 0 !");
			}
			_skinNum=value;
		}
		public function get skinNum():int
		{
			return _skinNum;
		}
		public override function getParams():XML
		{
			var xml:XML=<params/>;
			var param0:XML=new XML("<param paramIndex='0' classType='Number' value='"+skinNum+"'/>");
			xml.appendChild(param0);
			return xml;
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
			frprogram.OpType=this.OpType;
			return vertexCode;
		}

		private function createNoSkinTransform(frprogram:Program3dRegisterInstance):String
		{
			var vertexCode:String= ""
			var toReplace:Array=new Array();
			if(useAlpha)
			{
				toReplace.push(new ToBuilderInfo("va1",FilterName.POSITION,false,4));
				toReplace.push(new ToBuilderInfo("vf0","{v_vertexAlpha}",false,1));
				
				vertexCode+= "mov           {output}    			va1           		 \n";
				vertexCode+= "mov           vf0    				va1.w          	 \n";
				vertexCode+= "mov           {output}.w    		{vcConst1}.z       \n";
			}else
			{
				toReplace.push(new ToBuilderInfo("va1",FilterName.POSITION,false,3));
				vertexCode+= "mov           {output}    			va1           		 \n";
				vertexCode+= "mov           {output}.w    		{vcConst1}.z       \n";
			}
			
			vertexCode=frprogram.toBuild(vertexCode,toReplace);
			return vertexCode;
		}
		
		private function createSkinTransform(frprogram:Program3dRegisterInstance):String
		{
			var vertexCode:String				="mov           vt0           vc0 					\n";
			switch(skinNum)
			{
				case 1:vertexCode+=	"m34           vt0.xyz       va3         	 vc[va1.x]   		\n"+
									"mul           vt0       	vt0           va2.x         		\n";
									break;

				case 2:vertexCode+=	"m34           vt0.xyz       va3         	 vc[va1.x]   		\n"+
									"mul           vt2       	 vt0           va2.x         	\n"+
									"m34           vt0.xyz       va3         	 vc[va1.y]   		\n"+
									"mul           vt3           vt0           va2.y         	\n"+
									"add           vt0.xyz       vt2           vt3           	\n";
									break;
								
				case 3:vertexCode+=	"m34           vt0.xyz       va3         	 vc[va1.x]   		\n"+
									"mul           vt2       	 vt0           va2.x         	\n"+
									"m34           vt0.xyz       va3         	 vc[va1.y]   		\n"+
									"mul           vt3           vt0           va2.y         	\n"+
									"m34           vt0.xyz       va3         	 vc[va1.z]   		\n"+
									"mul           vt4           vt0           va2.z         	\n"+
									"add           vt0.xyz       vt2           vt3           	\n"+
									"add           vt0.xyz       vt4           vt0           	\n";
									break;
				case 4:vertexCode+=	"m34           vt0.xyz       va3         	 vc[va1.x]   		\n"+
									"mul           vt2       	 vt0           va2.x         	\n"+
									"m34           vt0.xyz       va3         	 vc[va1.y]   		\n"+
									"mul           vt3           vt0           va2.y         	\n"+
									"m34           vt0.xyz       va3         	 vc[va1.z]   		\n"+
									"mul           vt4           vt0           va2.z         	\n"+
									"m34           vt0.xyz       va3         	 vc[va1.w]   		\n"+
									"mul           vt5           vt0           va2.w         	\n"+
									"add           vt0.xyz       vt2           vt3           	\n"+
									"add           vt0.xyz       vt4           vt0           	\n"+
									"add           vt0.xyz       vt5           vt0           	\n";
									break;
			}
			vertexCode+=	"mov           vt0.w         {vcConst1}.z         					\n"+
							"mov         	 {output}      vt0           							\n";
			var toReplace:Array=[	
									new ToBuilderInfo("vc1-105","{bones}",false,Device3D.maxBonesPerSurface*3+1,[]),
									new ToBuilderInfo("va1",FilterName.SKIN_INDICES,false,skinNum),
									new ToBuilderInfo("va2",FilterName.SKIN_WEIGHTS,false,skinNum),
									new ToBuilderInfo("va3",FilterName.POSITION,false,3)
								]
			vertexCode=frprogram.toBuild(vertexCode,toReplace);
			return vertexCode;
			
		}
		
	}
}
package frEngine.shader.filters.vertexFilters
{
	
	import frEngine.shader.Program3dRegisterInstance;
	import frEngine.shader.ToBuilderInfo;
	import frEngine.shader.filters.FilterName;
	import frEngine.shader.filters.FilterType;
	import frEngine.shader.registType.Vparam;

	public class BatchPlaneVertexFilter extends VertexFilter
	{
		private var const120:Vector.<Number>=new Vector.<Number>(120*4,true);
		
		public function BatchPlaneVertexFilter()
		{
			super(FilterType.batchPlane);
		}
		public override function setRegisterParams(program:Program3dRegisterInstance):void
		{
			program.getParamByName("{const120}",true).value=const120;
		}
		public override function getParams():XML
		{
			var xml:XML=<params/>;
			return xml;
		}
		public override function get programeId():String
		{
			return "btPlane0"
		}
		public override function createVertexCode(frprogram:Program3dRegisterInstance):String
		{
			// vt0 = vt0 + (vt1 - vt0) * smooth;
			var buildinfos:Array=new Array();
			var vertexCode:String="";
			
			buildinfos.push(new ToBuilderInfo("vc0","{const120}",false,120,const120));
			//buildinfos.push(new ToBuilderInfo("vm0","m44List0",false,4,false));
			//buildinfos.push(new ToBuilderInfo("vc0","vertexWH",false,1,false,[1,1,1,0]));
			//buildinfos.push(new ToBuilderInfo("vc1","uvPostion",false,1,false,[1,1,0,0]));

			buildinfos.push(new ToBuilderInfo("vc4","{const4}",false,1,[1,6,2,1]));
			buildinfos.push(new ToBuilderInfo("va0",FilterName.POSITION,false,3));
			buildinfos.push(new ToBuilderInfo("va4",FilterName.PARAM0,false,1));

			//buildinfos.push(new ToBuilderInfo("vf0",FilterParams.V_UVscale,false,1));
			//buildinfos.push(new ToBuilderInfo("vf1",FilterParams.V_UVoffset,false,1));
			buildinfos.push(new ToBuilderInfo("vf2","{v_alpha}",false,1));
			
			vertexCode+=	"mul           vt2       	 vc4.y         va4.x       		\n";
			vertexCode+=	"mul           vt0       	 va0       	 vc[vt2.x+4]	    \n";
			vertexCode+=	"mov			 vt0.w			 vc4.x								\n";
			vertexCode+=	"m44           {output}      vt0           vc[vt2.x]			\n"; 
			
			var v_globle:Vparam=frprogram.getParamByName(FilterName.V_GloblePos,true);
			if(v_globle)
			{
				vertexCode +="mov         {V_GloblePos}  {output}         					\n";
			}
			vertexCode+=	"m44           {output}      {output}       {viewProj}		\n"; 
			
			/*vertexCode+=	"mov			 vf0			 vc[vt2.x+5].xy					\n";
			vertexCode+=	"mov			 vf1			 vc[vt2.x+5].zw					\n";*/
			vertexCode+=	"mov			 vf2			 vc[vt2.x+4].w			 		\n";

			vertexCode=frprogram.toBuild(vertexCode,buildinfos);

			return vertexCode;
		}

		public override function createFragmentColor(frprogram:Program3dRegisterInstance,uvRepeat:Boolean):String
		{
			var framentCode:String="mul {output} {output} {v_alpha}\n";
			
			return framentCode;
			
		}
	}
}


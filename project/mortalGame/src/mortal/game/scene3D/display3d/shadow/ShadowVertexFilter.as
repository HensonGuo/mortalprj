package mortal.game.scene3D.display3d.shadow
{
	import frEngine.shader.Program3dRegisterInstance;
	import frEngine.shader.ToBuilderInfo;
	import frEngine.shader.filters.FilterName;
	import frEngine.shader.filters.vertexFilters.VertexFilter;
	import frEngine.shader.filters.vertexFilters.def.ECalculateOpType;
	
	public class ShadowVertexFilter extends VertexFilter
	{
		public function ShadowVertexFilter()
		{
			super(-1, null);
		}
		public override function get programeId():String
		{
			return "ShadowVertexFilter0";
		}
		public override function createVertexCode(frprogram:Program3dRegisterInstance):String
		{
			var toReplace:Array=[];
			toReplace.push(new ToBuilderInfo("vc0-100","{shadowPosList}",false,100,[]));
			toReplace.push(new ToBuilderInfo("va0",FilterName.POSITION,false,3));
			toReplace.push(new ToBuilderInfo("va1",FilterName.SKIN_INDICES,false,1));
			toReplace.push(new ToBuilderInfo("vf0","{v_shadowRate}",false,1));
			var vertexCode:String="";
			vertexCode +="mov           vt0    				vc[va1.x]  						\n";
			vertexCode +="add           {output}    			vt0         		va0  			\n";
			vertexCode +="sge           vt0.x    			vt0.w  			{vcConst1}.x		\n";
			vertexCode +="mul           {output}    			{output}        	vt0.x  			\n";
			vertexCode +="mov           {output}.w    		{vcConst1}.z  						\n";

			vertexCode +="mov           vf0    				vt0  								\n";
			
			vertexCode =frprogram.toBuild(vertexCode,toReplace);
			frprogram.OpType=ECalculateOpType.ViewProj;
			return vertexCode;
		}

	}
}
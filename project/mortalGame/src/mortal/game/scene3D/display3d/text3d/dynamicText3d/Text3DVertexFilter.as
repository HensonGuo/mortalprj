package mortal.game.scene3D.display3d.text3d.dynamicText3d
{

	import frEngine.shader.Program3dRegisterInstance;
	import frEngine.shader.ToBuilderInfo;
	import frEngine.shader.filters.FilterName;
	import frEngine.shader.filters.vertexFilters.VertexFilter;
	import frEngine.shader.filters.vertexFilters.def.ECalculateOpType;
	
	import mortal.game.scene3D.layer3D.utils.Scene3DUtil;
	
	public class Text3DVertexFilter extends VertexFilter
	{
		public function Text3DVertexFilter()
		{
			super(-1, null);
		}
		public override function get programeId():String
		{
			return "textVertexFilter0";
		}
		public override function createVertexCode(frprogram:Program3dRegisterInstance):String
		{
			var toReplace:Array=[];
			toReplace.push(new ToBuilderInfo("vc0-100","{textPosList}",false,100,[]));
			toReplace.push(new ToBuilderInfo("vc1","{textConst}",false,1,[-1,256,-1,128]));
			toReplace.push(new ToBuilderInfo("va0",FilterName.POSITION,false,3));
			toReplace.push(new ToBuilderInfo("va1",FilterName.SKIN_INDICES,false,1));
			toReplace.push(new ToBuilderInfo("vf0","{v_textRate}",false,1));
			

			var vertexCode:String="";
			vertexCode +="mov           vt0    				vc[va1.x]  					\n";//vt0.w为texture高,vt0.z为textureOffsetY	

			vertexCode +="mul           vt2.y    			va0.y  			vt0.w			\n";
			vertexCode +="mul           vt2.x    			va0.x  			vc1.w			\n";
			
			vertexCode +="add           {output}.x    		vt0.x         		vt2.x  	\n";
			vertexCode +="sub           {output}.y    		vt0.y         		vt2.y  	\n";
			
			vertexCode +="sub         	 {output}.x      		{output}.x			{viewPortRect}.z		\n";
			vertexCode +="sub         	 {output}.y      		{viewPortRect}.w	{output}.y				\n";

			vertexCode +="div         	 {output}.xy      	{output}.xy	   {viewPortRect}.xy		\n";
			vertexCode +="mul         	 {output}.xy      	{output}.xy	   {vcConst1}.w			\n";

			vertexCode +="mov         	 {output}.zw      	{vcConst1}.xxxz	   					\n";
			
			vertexCode +="sge           vt1.z    			vt0.w  			{vcConst1}.x			\n";
			vertexCode +="mul           {output}.xy    		{output}.xy    vt1.z  				\n";
			vertexCode +="div           vt1.xy				vt0.wz      		vc1.y				\n";
			vertexCode +="mov           vf0    				vt1.xyzz  								\n";
			

			vertexCode =frprogram.toBuild(vertexCode,toReplace);
			
			frprogram.OpType=ECalculateOpType.None;
			
			return vertexCode;
		}
	}
}
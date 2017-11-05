package mortal.game.scene3D.display3d.text3d.staticText3d
{
	import frEngine.shader.Program3dRegisterInstance;
	import frEngine.shader.ToBuilderInfo;
	import frEngine.shader.filters.FilterName;
	import frEngine.shader.filters.vertexFilters.VertexFilter;
	import frEngine.shader.filters.vertexFilters.def.ECalculateOpType;
	
	import mortal.game.scene3D.layer3D.utils.Scene3DUtil;
	
	public class SText3DVertexFilter extends VertexFilter
	{
		public static const maxDuringFrame:uint=30;
		public function SText3DVertexFilter()
		{
			super(-1, null);
		}
		public override function get programeId():String
		{
			return "SText3DVertexFilter0";
		}
		public override function createVertexCode(frprogram:Program3dRegisterInstance):String
		{
			
			var toReplace:Array=[];
			toReplace.push(new ToBuilderInfo("vc0-100","{textPosList}",false,SText3DRender.instance.maxNum,[]));
			toReplace.push(new ToBuilderInfo("vc1","{textConst1}",false,1,[-1,1000,-500,-1]));
			toReplace.push(new ToBuilderInfo("vc2","{textConst2}",false,1,[Scene3DUtil.cameraAngleCos,Scene3DUtil.cameraAngleSin,TextVo.sw,TextVo.sh]));

			
			toReplace.push(new ToBuilderInfo("va0",FilterName.POSITION,false,3));
			toReplace.push(new ToBuilderInfo("va1",FilterName.SKIN_INDICES,false,1));
			toReplace.push(new ToBuilderInfo("vf0","{v_textRate}",false,1));
			toReplace.push(new ToBuilderInfo("vf1","{v_textAlpha}",false,1));
			var vertexCode:String="";
			vertexCode +="mov           vt1    				vc[va1.x]  					\n";
			vertexCode +="div           vt0    				vt1  			vc1.y			\n";
			vertexCode +="frc           vt3    				vt0  							\n";
			vertexCode +="sub           vt3.xy    			vt0.zw  		vt3.zw			\n";//vt3.xy,boxPlaceid,offsetX
			vertexCode +="mul           vt1.zw    			vt3.xxzw  		vc1.y			\n";//vt1.zw,textwidth,textheight
			
			vertexCode +="mul           vt2    				va0  			vt1.zw			\n";
			vertexCode +="mul           vt2    				vt2  			vc2.zw			\n";
			
			vertexCode +="mul           vt2.yz    			vc2.xxy  		vt2.y			\n";
			

			vertexCode +="mov           vt0    				vc[vt3.x]  					\n";
			vertexCode +="add           vt0.x    			vt0.x  			vt3.y			\n";
			
			vertexCode +="add           {output}    			vt0         	vt2  			\n";
			
			vertexCode +="sge           vt2.w    			vt0.w  			vc1.z			\n";
			vertexCode +="sge           vt2.z    			vt3.y  			{vcConst1}.x	\n";
			vertexCode +="min           vt2.w    			vt2.w      	vt2.z  			\n";
			vertexCode +="mul           {output}    			{output}      vt2.w  			\n";
			
			vertexCode +="mov           {output}.w    		{vcConst1}.z  					\n";
			vertexCode +="mov           vf0    				vt1  							\n";
			vertexCode +="mov           vf1    				vt0.w  							\n";
			
			vertexCode =frprogram.toBuild(vertexCode,toReplace);
			frprogram.OpType=ECalculateOpType.ViewProj;
			return vertexCode;
		}
	}
}
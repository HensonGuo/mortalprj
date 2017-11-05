package mortal.game.scene3D.display3d.shadow
{
	import baseEngine.core.Texture3D;
	
	import frEngine.shader.Program3dRegisterInstance;
	import frEngine.shader.ToBuilderInfo;
	import frEngine.shader.filters.FilterName;
	import frEngine.shader.filters.fragmentFilters.FragmentFilter;
	
	public class ShadowFragmentFilter extends FragmentFilter
	{
		private var _shadowBg0:Texture3D;
		public function ShadowFragmentFilter(shadowBg0:Texture3D)
		{
			super([shadowBg0]);
			_shadowBg0=shadowBg0;
		}
		public override function setRegisterParams(program:Program3dRegisterInstance):void
		{
			program.getParamByName("{shadowBg0}",false).value=_shadowBg0;
		}
		
		public override function get programeId():String
		{
			return "shadowFragmentFilter0";
		}

		public override function createVertexCode(frprogram:Program3dRegisterInstance):String
		{
			var buildinfos:Array=new Array();
			buildinfos.push(new ToBuilderInfo("va0",FilterName.UV,false,2));
			buildinfos.push(new ToBuilderInfo("vf0",FilterName.V_UvOriginalPos,false,1));
			
			var vertexCode:String ="mov           vf0         	 va0        				\n";
			
			vertexCode=frprogram.toBuild(vertexCode,buildinfos);
			return vertexCode;
		}
		public override function createFragmentUvCoord(frprogram:Program3dRegisterInstance):String
		{
			var buildinfos:Array=new Array();
			var code:String="";
			
			buildinfos.push(new ToBuilderInfo("ft0",FilterName.F_UVPostion,false,1));
			
			var v_uvPos:String=FilterName.V_UvOriginalPos;
			
			code +="mov           ft0         	 "+v_uvPos+"        				\n";
			
			code=frprogram.toBuild(code,buildinfos);
			return code;
		}
		public override function createFragmentColor(frprogram:Program3dRegisterInstance,uvRepeat:Boolean):String
		{
			var buildinfos:Array=new Array();
			buildinfos.push(new ToBuilderInfo("fs0","{shadowBg0}",false,1,_shadowBg0));//黑色底图
			
			var V_UVPostion:String=FilterName.F_UVPostion;
			
			var framentCode:String  = "";
			framentCode	+= "kil			{v_shadowRate}.x		\n";
			framentCode	+= "tex			{output}   	"+V_UVPostion+".xy    "+getSmapleString("fs0",_shadowBg0.format,uvRepeat,_shadowBg0.mipMode)+"	\n";
			
			
			framentCode=frprogram.toBuild(framentCode,buildinfos);
			
			return framentCode;
		}
	}
}
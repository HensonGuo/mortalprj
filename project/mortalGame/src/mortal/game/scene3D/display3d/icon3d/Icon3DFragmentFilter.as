package mortal.game.scene3D.display3d.icon3d
{
	import baseEngine.core.Texture3D;
	
	import frEngine.shader.Program3dRegisterInstance;
	import frEngine.shader.ToBuilderInfo;
	import frEngine.shader.filters.FilterName;
	import frEngine.shader.filters.fragmentFilters.FragmentFilter;
	
	public class Icon3DFragmentFilter extends FragmentFilter
	{
		private var _iconBg0:Texture3D;
		public function Icon3DFragmentFilter(iconBg0:Texture3D)
		{
			super([iconBg0]);
			_iconBg0=iconBg0;
		}
		public override function setRegisterParams(program:Program3dRegisterInstance):void
		{
			program.getParamByName("{iconBg0}",false).value=_iconBg0;
		}
		
		public override function get programeId():String
		{
			return "iconFragmentFilter0";
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
			buildinfos.push(new ToBuilderInfo("fc0","{imgConst}",false,1,[8,-1,-1,-1]));
			var v_uvPos:String=FilterName.V_UvOriginalPos;
			
			code +="mov           ft0         	 "+v_uvPos+"        					\n";
			code +="div           ft1         	 {v_iconRate}.w      fc0.x			\n";
			code +="frc           ft1.x         	 ft1.x									\n";	
			code +="sub           ft1.y         	 ft1.y					ft1.x			\n";
			code +="div           ft1.y         	 ft1.y      			fc0.x			\n";
			code +="add           ft0.xy         ft1.xy      			ft0.xy			\n";
			
			code=frprogram.toBuild(code,buildinfos);
			return code;
		}
		public override function createFragmentColor(frprogram:Program3dRegisterInstance,uvRepeat:Boolean):String
		{
			var buildinfos:Array=new Array();
			buildinfos.push(new ToBuilderInfo("fs0","{iconBg0}",false,1,_iconBg0));//黑色底图
			
			var V_UVPostion:String=FilterName.F_UVPostion;
			
			var framentCode:String  = "";
			framentCode	+= "kil			{v_iconRate}.x		\n";
			framentCode	+= "tex			{output}   	"+V_UVPostion+".xy    "+getSmapleString("fs0",_iconBg0.format,uvRepeat,_iconBg0.mipMode)+"	\n";
			
			
			framentCode=frprogram.toBuild(framentCode,buildinfos);
			
			return framentCode;
		}
	}
}
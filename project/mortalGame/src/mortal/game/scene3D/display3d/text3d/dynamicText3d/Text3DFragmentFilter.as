package mortal.game.scene3D.display3d.text3d.dynamicText3d
{
	import baseEngine.core.Texture3D;
	
	import frEngine.shader.Program3dRegisterInstance;
	import frEngine.shader.ToBuilderInfo;
	import frEngine.shader.filters.FilterName;
	import frEngine.shader.filters.fragmentFilters.FragmentFilter;
	
	public class Text3DFragmentFilter extends FragmentFilter
	{
		private var _textBg0:Texture3D;
		public function Text3DFragmentFilter(textBg0:Texture3D)
		{
			super([textBg0]);
			_textBg0=textBg0;
		}
		public override function setRegisterParams(program:Program3dRegisterInstance):void
		{
			program.getParamByName("{textBg0}",false).value=_textBg0;
		}
		
		public override function get programeId():String
		{
			return "textFragmentFilter0";
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
			
			code +="mov           ft0         	 "+v_uvPos+"        							\n";
			
			code +="mul           ft0.y			ft0.y      			{v_textRate}.x			\n";
			
			code +="add           ft0.y			{v_textRate}.y      	ft0.y					\n";
			
			code=frprogram.toBuild(code,buildinfos);
			return code;
		}
		public override function createFragmentColor(frprogram:Program3dRegisterInstance,uvRepeat:Boolean):String
		{
			var buildinfos:Array=new Array();
			buildinfos.push(new ToBuilderInfo("fs0","{textBg0}",false,1,_textBg0));//黑色底图
			
			var V_UVPostion:String=FilterName.F_UVPostion;
			
			var framentCode:String  = "";
			framentCode	+= "kil			{v_textRate}.z		\n";
			
			
			framentCode	+= "tex			{output}   	"+V_UVPostion+".xy    "+getSmapleString("fs0",_textBg0.format,uvRepeat,Texture3D.MIP_NONE)+"	\n";
			framentCode	+= "sub			ft0.x	   {output}.w				{fcConst1}.y	\n";
			framentCode	+= "kil			ft0.x	   											\n";
			
			framentCode=frprogram.toBuild(framentCode,buildinfos);
			
			return framentCode;
		}
	}
}
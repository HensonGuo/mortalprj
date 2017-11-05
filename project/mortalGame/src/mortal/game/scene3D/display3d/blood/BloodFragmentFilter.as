package mortal.game.scene3D.display3d.blood
{
	import baseEngine.core.Texture3D;
	
	import frEngine.shader.Program3dRegisterInstance;
	import frEngine.shader.ToBuilderInfo;
	import frEngine.shader.filters.FilterName;
	import frEngine.shader.filters.fragmentFilters.FragmentFilter;
	
	public class BloodFragmentFilter extends FragmentFilter
	{
		private var _bloodBg0:Texture3D;
		private var _bloodBg1:Texture3D;
		public function BloodFragmentFilter(bloodBg0:Texture3D,bloodBg1:Texture3D)
		{
			super([bloodBg0,bloodBg1]);
			_bloodBg0=bloodBg0;
			_bloodBg1=bloodBg1;
		}
		public override function setRegisterParams(program:Program3dRegisterInstance):void
		{
			program.getParamByName("{bloodBg0}",false).value=_bloodBg0;
			program.getParamByName("{bloodBg1}",false).value=_bloodBg1;
		}
		
		public override function get programeId():String
		{
			return "bloodFragmentFilter0";
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
			buildinfos.push(new ToBuilderInfo("fs0","{bloodBg0}",false,1,_bloodBg0));//黑色底图
			buildinfos.push(new ToBuilderInfo("fs1","{bloodBg1}",false,1,_bloodBg1));//上面红色血条
			
			var V_UVPostion:String=FilterName.F_UVPostion;
			
			var framentCode:String  = "";
			framentCode	+= "kil			{v_bloodRate}.x		\n";
			framentCode	+= "tex			ft0   	"+V_UVPostion+".xy    "+getSmapleString("fs0",_bloodBg0.format,uvRepeat,_bloodBg0.mipMode)+"	\n";
			framentCode	+= "tex			ft1   	"+V_UVPostion+".xy    "+getSmapleString("fs1",_bloodBg0.format,uvRepeat,_bloodBg0.mipMode)+"	\n";
			
			framentCode	+= "sge			ft2.x	"+V_UVPostion+".x	  "+"{v_bloodRate}.w	\n";
			framentCode	+= "mul			ft1		ft1		ft2.x			\n";
			
			//进行颜色混合
			framentCode  += "sub           ft2.y				{fcConst1}.z	ft1.w    		\n";
			framentCode  += "mul           ft0.xyz       	ft0    			ft2.y			\n";
			framentCode  += "add           {output}     		ft1				ft0				\n";

			framentCode=frprogram.toBuild(framentCode,buildinfos);
			
			return framentCode;
		}
	}
}
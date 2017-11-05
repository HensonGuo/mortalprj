package mortal.game.scene3D.map3D.mapShader
{
	import baseEngine.core.Texture3D;
	
	import frEngine.loaders.resource.Resource3dManager;
	import frEngine.shader.Program3dRegisterInstance;
	import frEngine.shader.ToBuilderInfo;
	import frEngine.shader.filters.FilterBase;
	import frEngine.shader.filters.FilterName;
	import frEngine.shader.filters.fragmentFilters.FragmentFilter;
	
	public class MapFragmentFilter extends FragmentFilter
	{
		public var bottomTexture:Texture3D;
		
		public function MapFragmentFilter($bottomTexture:Texture3D)
		{
			super([$bottomTexture]);
			
			bottomTexture=$bottomTexture;
		}
		public override function setRegisterParams(program:Program3dRegisterInstance):void
		{
			program.getParamByName("{F_const}",false).value=Vector.<Number>([0,0,256/2000,256/2000,1,0.01,0,0]);
			program.getParamByName("{texture1}",false).value=bottomTexture;
			program.getParamByName("{texture2}",false).value=bottomTexture;
		}
		public override function get programeId():String
		{
			return "mapTextureFilter:"+FilterBase.ATLFormat[bottomTexture.format];
		}
		public override function getParams():XML
		{
			var xml:XML=<params/>;
			var param0:XML=new XML("<param paramIndex='0' classType='flare.core.Texture3D' value='texture3d'/>");
			xml.appendChild(param0);
			return xml;
		}
		public override function clone():FilterBase
		{ 	
			var newtexture:Texture3D=Resource3dManager.instance.getTexture3d(bottomTexture.request,bottomTexture.mipMode);
			var newTextureFilter:MapFragmentFilter=new MapFragmentFilter(newtexture);
			return newTextureFilter;
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
			buildinfos.push(new ToBuilderInfo("ft0",FilterName.F_UVPostion,false,1));
			
			var v_uvPos:String=FilterName.V_UvOriginalPos;
			
			var code:String ="mov           ft0         	 "+v_uvPos+"        				\n";
			
			code=frprogram.toBuild(code,buildinfos);
			return code;
		}
		public override function createFragmentColor(frprogram:Program3dRegisterInstance,uvRepeat:Boolean):String
		{
			var buildinfos:Array=new Array();
			buildinfos.push(new ToBuilderInfo("fc0","{F_const}",false,2,[0,0,256/2000,256/2000]));
			buildinfos.push(new ToBuilderInfo("fs0","{texture1}",false,1,bottomTexture));//地图
			buildinfos.push(new ToBuilderInfo("fs1","{texture2}",false,1,bottomTexture));//背景地图
			

			var V_UVPostion:String=FilterName.F_UVPostion;
			var framentCode:String  ="";
			framentCode  += "tex           {output}  "+V_UVPostion+".xy    "+getSmapleString("fs0",bottomTexture.format,uvRepeat,bottomTexture.mipMode)+"	\n";
			framentCode  += "mul           ft0       fc0.zw    "+V_UVPostion+".xy		\n";
			framentCode  += "add           ft0.xy    fc0.xy    ft0.xy					\n";
			framentCode  += "frc           ft0.xy    ft0.xy    							\n";
			
			framentCode  += "tex           ft0       ft0.xy    "+getSmapleString("fs1",bottomTexture.format,uvRepeat,bottomTexture.mipMode)+"	\n";
			framentCode  += "sub           ft0.w				{fcConst1}.z	{output}.w    		\n";
			framentCode  += "mul           ft0.xyz       	ft0    			ft0.w				\n";
			framentCode  += "add           {output}     		{output}    	ft0					\n";
			
			framentCode=frprogram.toBuild(framentCode,buildinfos);
			
			return framentCode;
		}
		
		
	}
}


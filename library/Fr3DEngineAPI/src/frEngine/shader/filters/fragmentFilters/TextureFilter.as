package frEngine.shader.filters.fragmentFilters
{
	import baseEngine.core.Texture3D;
	
	import frEngine.loaders.resource.Resource3dManager;
	import frEngine.shader.Program3dRegisterInstance;
	import frEngine.shader.ToBuilderInfo;
	import frEngine.shader.filters.FilterBase;
	import frEngine.shader.filters.FilterName;
	import frEngine.shader.registType.Vparam;

	public class TextureFilter extends FragmentFilter
	{
		public var texture:Texture3D;
		
		public function TextureFilter($texture:Texture3D)
		{
			super([$texture]);
			texture=$texture;
		}
		
		public override function setRegisterParams(program:Program3dRegisterInstance):void
		{
			program.getParamByName("{texture1}",false).value=texture;
		}
		
		public override function get programeId():String
		{
			return "textureFilter:"+FilterBase.ATLFormat[texture.format]+",mip:"+texture.mipMode;
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
			var newtexture:Texture3D=Resource3dManager.instance.getTexture3d(texture.request,texture.mipMode);
			var newTextureFilter:TextureFilter=new TextureFilter(newtexture);
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
			var code:String="";
			var v_globle:Vparam=frprogram.getParamByName(FilterName.V_GloblePos,true);
			if(v_globle)
			{
				code	+= "sub			ft0.x	   {V_GloblePos}.y	{fcConst1}.x	\n";
				code	+= "kil			ft0.x	   										\n";
			}
			
			buildinfos.push(new ToBuilderInfo("ft0",FilterName.F_UVPostion,false,1));
			
			var v_uvPos:String=FilterName.V_UvOriginalPos;
			
			code +="mov           ft0         	 "+v_uvPos+"        				\n";

			code=frprogram.toBuild(code,buildinfos);
			return code;
		}
		public override function createFragmentColor(frprogram:Program3dRegisterInstance,uvRepeat:Boolean):String
		{
			var buildinfos:Array=new Array();
			buildinfos.push(new ToBuilderInfo("fs0","{texture1}",false,1,texture));
			var framentCode:String  ="";
			if(!uvRepeat)
			{
				framentCode	+= "sge			ft0.xy	   			{F_UVPostion}.xy			{fcConst1}.x			\n";
				framentCode	+= "sge			ft1.xy	   			{fcConst1}.z				{F_UVPostion}.xy		\n";
				framentCode	+= "mul			ft0.xy	   			ft0.xy						ft1.xy					\n";
				framentCode	+= "min			ft0.x	   			ft0.x						ft0.y					\n";
				framentCode	+= "sub			ft0.x	   			ft0.x						{fcConst1}.z			\n";
				framentCode	+= "kil			ft0.x	   																\n";
			}
			framentCode += "tex           {output}           {F_UVPostion}.xy    "+getSmapleString("fs0",texture.format,uvRepeat,texture.mipMode)+"	\n";
			//framentCode	+= "sub			ft0.x	   {output}.w				{fcConst1}.y	\n";
			//framentCode	+= "kil			ft0.x	   											\n";
			
			
			framentCode=frprogram.toBuild(framentCode,buildinfos);
			
			return framentCode;
		}
		
		
	}
}
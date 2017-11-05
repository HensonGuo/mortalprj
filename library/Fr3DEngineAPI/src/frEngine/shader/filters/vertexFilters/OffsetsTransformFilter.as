package frEngine.shader.filters.vertexFilters
{
	import flash.geom.Point;
	
	import frEngine.shader.Program3dRegisterInstance;
	import frEngine.shader.ToBuilderInfo;
	import frEngine.shader.filters.FilterBase;
	import frEngine.shader.filters.FilterName;
	import frEngine.shader.filters.FilterPriority;
	import frEngine.shader.filters.FilterType;
	import frEngine.shader.filters.vertexFilters.def.ECalculateOpType;

	public class OffsetsTransformFilter extends FilterBase
	{
		private var _centeOffsetsVector:Vector.<Number>=Vector.<Number>([0,0,0,0]);
		private var _boundVector:Vector.<Number>=Vector.<Number>([0,0,1,1])
		private var _oldOpType:int;
		public function OffsetsTransformFilter()
		{
			super(FilterType.OffsetTransform,FilterPriority.offsetTransformFilter);
			
		}
		public override function setRegisterParams(program:Program3dRegisterInstance):void
		{
			program.getParamByName("{centerOffsets}",true).value=_centeOffsetsVector;
			program.getParamByName("{killBound}",false).value=_boundVector;
		}
		
		public override function get programeId():String
		{
			return "offsetsTransform"+_oldOpType;
		}
		public function changeCenteOffsets(offsetx:Number,offsety:Number):void
		{
			_centeOffsetsVector[0]=offsetx;
			_centeOffsetsVector[1]=offsety;
		}
		
		public function changeBounds(offsetx:Number,offsety:Number,w:Number,h:Number):void
		{
			_boundVector[0]=offsetx;
			_boundVector[1]=offsety;
			_boundVector[2]=w;
			_boundVector[3]=h;
		}
		
		public override function createVertexCode(frprogram:Program3dRegisterInstance):String
		{
			var toReplace:Array=[ ]
			_oldOpType=frprogram.OpType;
			var vertexCode:String="";
			toReplace.push(new ToBuilderInfo("vc0","{centerOffsets}",false,1,_centeOffsetsVector));
			
			if(_oldOpType==ECalculateOpType.None)
			{
				toReplace.push(new ToBuilderInfo("vm1",FilterName.worldViewProj,true,4));
				vertexCode +="m44         	 {output}      		{output}           vm1			\n";
				vertexCode +="mul         	 vt0      				 vc0           	 {output}.w	\n";
				vertexCode +="add         	 {output}      		{output}           vt0			\n";
			}
			if(_oldOpType==ECalculateOpType.Proj)
			{
				toReplace.push(new ToBuilderInfo("vm1",FilterName.proj,true,4));
				vertexCode +="m44         	 {output}      		{output}           vm1			\n";
				vertexCode +="mul         	 vt0      				 vc0           	 {output}.w	\n";
				vertexCode +="add         	 {output}      		{output}           vt0			\n";
			}
			
			if(_oldOpType==ECalculateOpType.ViewProj)
			{
				vertexCode +="m44         	 {output}      		{output}         {viewProj}			\n";
				vertexCode +="mul         	 vt0      				 vc0           	 {output}.w	\n";
				vertexCode +="add         	 {output}      		{output}           vt0			\n";
			}
			
			if(_oldOpType==ECalculateOpType.WorldViewProj)
			{
				toReplace.push(new ToBuilderInfo("vm1",FilterName.worldViewProj,true,4));
				vertexCode +="m44         	 {output}      		{output}           vm1			\n";
				vertexCode +="mul         	 vt0      				 vc0           	 {output}.w	\n";
				vertexCode +="add         	 {output}      		{output}           vt0			\n";
			}
			
			if(_oldOpType==ECalculateOpType.World_And_ViewProj)
			{
				toReplace.push(new ToBuilderInfo("vm0",FilterName.global,true,4));
				vertexCode +="m44         	 {output}      		{output}           vm0			\n";
				vertexCode +="m44         	 {output}      		{output}           {viewProj}	\n";
				vertexCode +="mul         	 vt0      				 vc0           	 {output}.w	\n";
				vertexCode +="add         	 {output}      		{output}           vt0			\n";
			}
			
			toReplace.push(new ToBuilderInfo("vf0","{v_kil}",true,1));
			vertexCode +="div         	 vf0      		{output}     {output}.w   		\n";
			
			vertexCode=frprogram.toBuild(vertexCode,toReplace);
			
			frprogram.OpType=ECalculateOpType.None;
			return vertexCode;
		}
		public override function createFragmentColor(frprogram:Program3dRegisterInstance,uvRepeat:Boolean):String
		{
			var buildinfos:Array=new Array();
			buildinfos.push(new ToBuilderInfo("fc0","{killBound}",false,1,_boundVector));
			var framentCode:String = "";
			framentCode  += "sub           ft0.xy    	{v_kil}.xy  		fc0.xy				\n";
			framentCode  += "abs           ft0.xy    	ft0.xy									\n";
			framentCode	 += "sub           ft0.xy    	fc0.zw				ft0.xy				\n";
			framentCode  += "kil           ft0.x    												\n";
			framentCode  += "kil           ft0.y    												\n";
			
			framentCode=frprogram.toBuild(framentCode,buildinfos);
			return framentCode;
		}
		
	}
}
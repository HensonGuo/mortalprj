package mortal.game.scene3D.map3D.mapShader
{
	import frEngine.shader.Program3dRegisterInstance;
	import frEngine.shader.ToBuilderInfo;
	import frEngine.shader.filters.FilterName;
	import frEngine.shader.filters.FilterType;
	import frEngine.shader.filters.vertexFilters.VertexFilter;
	import frEngine.shader.filters.vertexFilters.def.ECalculateOpType;
	import frEngine.shader.registType.Vparam;
	
	
	public class MapVertexFilter extends VertexFilter
	{

		public function MapVertexFilter()
		{
			super(FilterType.Transform);
			
		}
		public override function setRegisterParams(program:Program3dRegisterInstance):void
		{
			
		}
		public override function get programeId():String
		{
			return "MapVertexFilter0";
		}


		public override function getParams():XML
		{
			var xml:XML=<params/>;
			var param0:XML=new XML("<param paramIndex='0' classType='Number' value=0'/>");
			xml.appendChild(param0);
			return xml;
		}
		public override function createVertexCode(frprogram:Program3dRegisterInstance):String
		{
			var toReplace:Array=[new ToBuilderInfo("va1",FilterName.POSITION,false,3)];
			toReplace.push(new ToBuilderInfo("vm0","{transform}",false,1,null));
			var vertexCode:String= ""
			vertexCode+= "mov           {output}    			va1           		 	\n";
			vertexCode+= "mov           {output}.w    		{vcConst1}.z       	\n";
			vertexCode+= "m44           {output}    			{output}    	vm0   	\n";
			vertexCode=frprogram.toBuild(vertexCode,toReplace);
			frprogram.OpType=ECalculateOpType.None;
			
			/*
			var toReplace:Array=[new ToBuilderInfo("va1",FilterName.POSITION,false,3)];
			toReplace.push(new ToBuilderInfo("vc0","{xywh}",false,1,[0,0,256,256]));
			var vertexCode:String= "mov           {output}    			va1           		 	\n";
			vertexCode +="mov         	 vt0      		vc0           							\n";
			vertexCode +="div         	 vt0.xyzw     vt0.xyzw         {viewPortRect}.xyxy  	\n";
			
			vertexCode +="sub         	 vt1.x      	vt0.z			{vcConst1}.z	    \n";
			vertexCode +="sub         	 vt1.y      	{vcConst1}.z	vt0.w     	  		\n";
			
			vertexCode +="mul         	 {output}.xy  {output}.xy  vt0.zw				\n";
			vertexCode +="add         	 {output}.xy  {output}.xy  vt0.xy				\n";
			vertexCode +="add         	 {output}.xy  {output}.xy  vt1.xy				\n";
			vertexCode +="mov         	 {output}.w   {vcConst1}.z           			\n";
			vertexCode=frprogram.toBuild(vertexCode,toReplace);
			frprogram.OpType=ECalculateOpType.None;
			*/
			
			return vertexCode;
		}
	}
}


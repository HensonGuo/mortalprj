package frEngine.shader.filters.fragmentFilters
{
	import frEngine.shader.Program3dRegisterInstance;
	import frEngine.shader.ToBuilderInfo;
	import frEngine.shader.filters.FilterBase;
	import frEngine.shader.filters.FilterPriority;
	import frEngine.shader.filters.FilterType;
	
	public class ColorTransformFilter extends FilterBase
	{
		public var colorOffsetValue:Vector.<Number>=Vector.<Number>([1,1,1,1]);
		public function ColorTransformFilter()
		{
			super(FilterType.Fragment_ColorTransform,FilterPriority.ColorTransformFilter);
		}
		public override function get programeId():String
		{
			return "colorTransform0";
		}
		public override function setRegisterParams(program:Program3dRegisterInstance):void
		{
			program.getParamByName("{ColorOffset}",false).value=colorOffsetValue;
		}
		
		public function changeColor($colorOffsetValue:Vector.<Number>):void
		{
			colorOffsetValue[0]=$colorOffsetValue[0];
			colorOffsetValue[1]=$colorOffsetValue[1];
			colorOffsetValue[2]=$colorOffsetValue[2];
			colorOffsetValue[3]=$colorOffsetValue[3];
		}
		public override function createFragmentColor(frprogram:Program3dRegisterInstance,uvRepeat:Boolean):String
		{
			var buildinfos:Array=new Array();
			buildinfos.push(new ToBuilderInfo("fc1","{ColorOffset}",false,1,colorOffsetValue));
			var framentCode:String ="";
			framentCode+="mul           {output}.xyz       	  	{output}.xyz  		  		fc1.w						\n";
			framentCode+="mul           {output}       	  		{output}  		  			fc1							\n";
			framentCode=frprogram.toBuild(framentCode,buildinfos);
			return framentCode;
		}
	}
}
/*package frEngine.shader.filters.fragmentFilters
{
	import frEngine.shader.Program3dRegisterInstance;
	import frEngine.shader.ToBuilderInfo;
	import frEngine.shader.filters.FilterBase;
	import frEngine.shader.filters.FilterPriority;
	import frEngine.shader.filters.FilterType;
	
	public class ColorTransformFilter extends FilterBase
	{
		public var colorMultiplyValue:Vector.<Number>=Vector.<Number>([1,1,1,1]);
		public var colorOffsetValue:Vector.<Number>=Vector.<Number>([0,0,0,0]);
		public function ColorTransformFilter()
		{
			super(FilterType.Fragment_ColorTransform,FilterPriority.ColorTransformFilter);
		}
		public override function get programeId():String
		{
			return "colorTransform0";
		}
		public override function setRegisterParams(program:Program3dRegisterInstance):void
		{
			program.getParamByName("{ColorMultiply}",false).value=colorMultiplyValue;
			program.getParamByName("{ColorOffset}",false).value=colorOffsetValue;
		}
		
		public function changeColor($colorMultiplyValue:Vector.<Number>,$colorOffsetValue:Vector.<Number>):void
		{
			colorMultiplyValue[0]=$colorMultiplyValue[0];
			colorMultiplyValue[1]=$colorMultiplyValue[1];
			colorMultiplyValue[2]=$colorMultiplyValue[2];
			colorMultiplyValue[3]=$colorMultiplyValue[3];
			
			colorOffsetValue[0]=$colorOffsetValue[0];
			colorOffsetValue[1]=$colorOffsetValue[1];
			colorOffsetValue[2]=$colorOffsetValue[2];
			colorOffsetValue[3]=$colorOffsetValue[3];
		}
		public override function createFragmentColor(frprogram:Program3dRegisterInstance,uvRepeat:Boolean):String
		{
			var buildinfos:Array=new Array();
			buildinfos.push(new ToBuilderInfo("fc0","{ColorMultiply}",false,1,colorMultiplyValue));
			buildinfos.push(new ToBuilderInfo("fc1","{ColorOffset}",false,1,colorOffsetValue));
			var framentCode:String ="mul           {output}.xyz       	  	{output}.xyz  		  		fc0.w						\n";
			framentCode+="mul           {output}       	  		{output}  		  				fc0							    	\n";
			framentCode+="add           {output}       	  		{output}  		  				fc1							    	\n";
			framentCode=frprogram.toBuild(framentCode,buildinfos);
			return framentCode;
		}
	}
}*/




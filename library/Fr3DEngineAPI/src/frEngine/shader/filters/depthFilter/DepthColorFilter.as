package frEngine.shader.filters.depthFilter
{

	import frEngine.shader.Program3dRegisterInstance;
	import frEngine.shader.filters.fragmentFilters.FragmentFilter;

	public class DepthColorFilter extends FragmentFilter
	{
		public function DepthColorFilter()
		{
			super(null);
		}
		public override function getParams():XML
		{
			var xml:XML=<params/>;
			return xml;
		}
	
		public override function get programeId():String
		{
			return "depthColor0";
		}
		public override function createFragmentColor(frprogram:Program3dRegisterInstance,uvRepeat:Boolean):String
		{
			var buildinfos:Array=new Array();
			var framentCode:String 	="mov           {output}     {v_const0}.w \n";
			framentCode=frprogram.toBuild(framentCode,buildinfos);
			return framentCode;
		}
	}
}


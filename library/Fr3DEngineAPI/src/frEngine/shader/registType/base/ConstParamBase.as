package frEngine.shader.registType.base
{
	public class ConstParamBase extends RegistParam 
	{

		public var hasSeting:Boolean=false;
		
		public function ConstParamBase($registName:String,$index:int,$paramName:String,$isGlobleVar:Boolean,$defaultValue:*)
		{
			
			super($registName,$index,$paramName,$isGlobleVar,$defaultValue);
			
		}
		
		
		public function changeValue1(index:int,$value:Number):void
		{
			value[index]=$value;
			hasSeting=false;
		}
		public function changeValue2($valuex:Number,$valuey:Number):void
		{
			value[0]=$valuex;
			value[1]=$valuey;
			hasSeting=false;
		}
		
		public function changeValue3($valuex:Number,$valuey:Number,$valuez:Number):void
		{
			value[0]=$valuex;
			value[1]=$valuey;
			value[2]=$valuez;
			hasSeting=false;
		}
		public function changeValue4($valuex:Number,$valuey:Number,$valuez:Number,$valuew:Number):void
		{
			value[0]=$valuex;
			value[1]=$valuey;
			value[2]=$valuez;
			value[3]=$valuew;
			hasSeting=false;
		}
	}
}


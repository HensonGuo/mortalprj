package frEngine.primitives
{
	import baseEngine.basic.RenderList;
	
	import frEngine.primitives.base.LineBase;


	public class FrLine3D extends LineBase
	{
		
		public function FrLine3D($name:String,$renderList:RenderList)
		{
			super($name,false,$renderList);
			
		}
		public function clear():void
		{
			drawInstance.clear();
		}
		public function moveTo($x:Number,$y:Number,$z:Number,surfaceIndex:int=0):void
		{
			drawInstance.moveTo($x,$y,$z,surfaceIndex);
		}
		public function lineTo($x:Number,$y:Number,$z:Number,surfaceIndex:int=0):void
		{
			drawInstance.lineTo($x,$y,$z,surfaceIndex);
		}
		public function lineStyle($thickness:Number=1, $color:uint=0xFFFFFF, $alpha:Number=1,surfaceIndex:int=0):void
		{
			drawInstance.lineStyle($thickness,$color,$alpha,surfaceIndex);
		}
		
	}
}
package mortal.game.scene3D.display3d.text3d.staticText3d
{
	import flash.geom.Point;
	import flash.utils.Dictionary;

	public class StaticTextMap
	{
		public var textMapDic:Dictionary=new Dictionary(false);
		public var numberMapDic:Dictionary=new Dictionary(false);
		public function StaticTextMap()
		{
			inittextMapDic();
		}
		private function inittextMapDic():void
		{
			textMapDic["暴"]=new Point(8,0);
			textMapDic["击"]=new Point(8,1);
			textMapDic["反"]=new Point(8,2);
			textMapDic["弹"]=new Point(8,3);
			textMapDic["格"]=new Point(8,4);
			textMapDic["档"]=new Point(8,5);
			textMapDic["免"]=new Point(8,6);
			textMapDic["疫"]=new Point(8,7);
			textMapDic["闪"]=new Point(8,8);
			textMapDic["避"]=new Point(8,9);
			textMapDic["吸"]=new Point(8,10);
			textMapDic["收"]=new Point(8,11);
			textMapDic["("]=new Point(9,0);
			textMapDic[")"]=new Point(9,1);
			
			numberMapDic["0"]=0
			numberMapDic["1"]=1
			numberMapDic["2"]=2
			numberMapDic["3"]=3
			numberMapDic["4"]=4
			numberMapDic["5"]=5
			numberMapDic["6"]=6
			numberMapDic["7"]=7
			numberMapDic["8"]=8
			numberMapDic["9"]=9
			numberMapDic["+"]=10
			numberMapDic["-"]=11
		}
	}
}
package mortal.game.scene3D.display3d.text3d.staticText3d
{
	import baseEngine.core.Mesh3D;
	import baseEngine.system.Device3D;

	public class SText3DMesh extends Mesh3D
	{
		public var vcListMap:Vector.<VcList>=new Vector.<VcList>();
		private static var vcListPool:Vector.<VcList>=new Vector.<VcList>();
		public function SText3DMesh(useColorAnimate:Boolean)
		{
			super("", useColorAnimate, Device3D.scene.renderLayerList);
		}
		public override function dispose(isReuse:Boolean=true):void
		{
			super.dispose(isReuse);
			vcListMap=null;
		}

		
		
		public function clearAll():void
		{
			for each(var p:VcList in vcListMap)
			{
				vcListPool.push(p);
				p.dispose()
			}
			vcListMap.length=0;
			VcList.totalUseNum=0;
		}
		
		public function createNewVcList():VcList
		{
			var list:VcList;
			if(vcListPool.length>0)
			{
				list=vcListPool.shift();
			}else
			{
				list=new VcList();
			}
			vcListMap.push(list);
			
			return list;
			
			
		}
	}
}
package mortal.game.scene3D.display3d.icon3d
{
	import baseEngine.basic.RenderList;
	import baseEngine.core.Mesh3D;
	import baseEngine.core.Texture3D;
	import baseEngine.system.Device3D;
	
	public class Icon3DMesh extends Mesh3D
	{
		private var _curList:Vector.<Number>;
		public var iconBg0:Texture3D;
		public var listArr:Array=new Array();
		public function Icon3DMesh($url:String, useColorAnimate:Boolean)
		{
			super($url, useColorAnimate, Device3D.scene.renderLayerList);
			iconBg0=new Texture3D($url,0);
		}
		public override function dispose(isReuse:Boolean=true):void
		{
			super.dispose(isReuse);
			_curList=null;
			listArr=null;
			iconBg0.disposeImp();
			iconBg0=null;
		}
		public function get vectorList():Vector.<Number>
		{
			if(!_curList || _curList.length>=400 )
			{
				_curList=new Vector.<Number>();
				listArr.push(_curList);
			}
			
			return _curList;
			
		}
	}
}
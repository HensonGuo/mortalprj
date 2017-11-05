package mortal.game.scene3D.display3d.icon3d
{

	import flash.utils.getTimer;
	
	import frEngine.render.layer.Layer3DManager;
	
	import mortal.game.scene3D.GameScene3D;

	public class Icon3DBigImg
	{
		private var _pool:Array=new Array();
		private var _iconMesh3d:Icon3DMesh
		public var url:String;
		private var _lastDisposeTime:Number=0;
		private var _disposeTime:Number=1000*60*5;
		private var _hasCreateMaxNum:int=0;
		public function Icon3DBigImg($url:String)
		{
			url=$url;
			_iconMesh3d=new Icon3DMesh(url,false);
			_iconMesh3d.setLayer(Layer3DManager.IconLayer,false);
			_iconMesh3d.render=Icon3DRender.instance;
		}
		
		public function canDispose(curTime:Number):Boolean
		{
			if(curTime-_lastDisposeTime>_disposeTime && _pool.length==_hasCreateMaxNum)
			{
				return true;
			}else
			{
				return false;
			}
		}
		public function init(scene:GameScene3D):void
		{
			scene.addChild(_iconMesh3d);
			_iconMesh3d.iconBg0.upload(scene,false);
			
		}
		public function createIcon3D(xid:uint,yid:uint):Icon3D
		{
			var _icon:Icon3D;
			if(_pool.length>0)
			{
				_icon=_pool.pop();
				_icon.show();
			}else
			{
				_icon=new Icon3D(url);
				_icon.reInit(_iconMesh3d.vectorList);
				_hasCreateMaxNum++;
			}
			_icon.setImgPos(xid,yid);
			
			return _icon;
		}
		public function disposeIcon3D(icon:Icon3D):void
		{
			if(_pool.indexOf(icon)==-1)
			{
				_pool.push(icon);
			}
			icon.hide();
			_lastDisposeTime=getTimer();
		}
		public function disposeAll():void
		{
			_iconMesh3d.dispose(false);
			_pool=null;
		}
	}
}
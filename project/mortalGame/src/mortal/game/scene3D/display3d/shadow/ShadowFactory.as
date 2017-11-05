package mortal.game.scene3D.display3d.shadow
{
	import baseEngine.core.Mesh3D;
	
	import frEngine.render.layer.Layer3DManager;
	
	import mortal.game.scene3D.GameScene3D;

	public class ShadowFactory
	{
		private static var _shadowMesh3d:Mesh3D;
		private static var _pool:Array=new Array();
		
		public function ShadowFactory()
		{
			
		}
		public static function init(scene:GameScene3D):void
		{
			_shadowMesh3d=new Mesh3D("shadows",false,true);
			_shadowMesh3d.setLayer(Layer3DManager.ShadowLayer,false);
			_shadowMesh3d.render=Shadow3DRender.instance;
			scene.addChild(_shadowMesh3d);
			Shadow3DRender.instance.init(scene);
			
		}
		public static function createshadow3D():Shadow3D
		{
			var _shadow:Shadow3D;
			if(_pool.length>0)
			{
				_shadow=_pool.pop();
				_shadow.show();
			}else
			{
				_shadow=new Shadow3D();
				var shadowRender:Shadow3DRender=Shadow3DRender.instance;
				var target:Vector.<Number>=shadowRender.list1Values.length>=400?shadowRender.list2Values:shadowRender.list1Values;
				_shadow.reInit(target);
			}
			return _shadow;
		}
		public static function disposeshadow3D(shadow:Shadow3D):void
		{
			if(shadow.parent)
			{
				shadow.parent=null;
			}
			
			shadow.hide();
			
			if(_pool.indexOf(shadow)==-1)
			{
				_pool.push(shadow);
			}
		}
		
	}
}
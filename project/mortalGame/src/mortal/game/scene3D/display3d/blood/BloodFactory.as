package mortal.game.scene3D.display3d.blood
{
	import baseEngine.core.Mesh3D;
	import baseEngine.system.Device3D;
	
	import frEngine.render.layer.Layer3DManager;
	
	import mortal.game.scene3D.GameScene3D;

	public class BloodFactory
	{
		private static var _bloodMesh3d:Mesh3D;
		private static var _pool:Array=new Array();
		
		public function BloodFactory()
		{
			
		}
		public static function init(scene:GameScene3D):void
		{
			_bloodMesh3d=new Mesh3D("bloods",false,scene.renderLayerList);
			_bloodMesh3d.setLayer(Layer3DManager.modelLayer1,false);
			_bloodMesh3d.render=Blood3DRender.instance;
			scene.addChild(_bloodMesh3d);
			Blood3DRender.instance.init(scene);
			
		}
		public static function createBlood3D():Blood3D
		{
			var _blood:Blood3D;
			if(_pool.length>0)
			{
				_blood=_pool.pop();
				_blood.show();
			}else
			{
				_blood=new Blood3D();
				var bloodRender:Blood3DRender=Blood3DRender.instance;
				var target:Vector.<Number>=bloodRender.list1Values.length>=400?bloodRender.list2Values:bloodRender.list1Values;
				_blood.reInit(target);
			}
			return _blood;
		}
		public static function disposeBlood3D(blood:Blood3D):void
		{
			if(blood.parent)
			{
				blood.parent=null;
			}
			
			blood.hide();
			
			if(_pool.indexOf(blood)==-1)
			{
				_pool.push(blood);
			}
		}
		
	}
}
package mortal.game.scene3D.layer3D.utils
{
	import com.gengine.utils.MathUitl;
	
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	
	import baseEngine.core.Mesh3D;
	import baseEngine.system.Device3D;
	
	import frEngine.core.OrthographicCamera3D;
	import frEngine.math.Quaternion;
	
	import mortal.game.Game;
	import mortal.game.scene3D.GameCamera;

	public class Scene3DUtil
	{
		public static const sceneObjectsList:Dictionary=new Dictionary(false);
		public static const cameraAngle:Number=40;
		public static const anglePI:Number=cameraAngle/180*Math.PI;
		public static const cameraAngleCos:Number=Math.cos(anglePI);
		public static const cameraAngleSin:Number=Math.sin(anglePI);
		private static var _gameCameraCopy:OrthographicCamera3D;
		
		private static var _cameraQuaternion:Quaternion;
		
		private static const to3D:Number=1/cameraAngleSin;
		private static var _tempPoint:Point=new Point();

		public static function getSceneMousePostion(stageX:Number,stageY:Number,isGloble:Boolean):Point
		{
			var scaleScene:Number=Game.scene.sceneScale;
			var w2:Number=Device3D.viewPortW*0.5;
			var h2:Number=Device3D.viewPortH*0.5;
			_tempPoint.x = (stageX-w2)/scaleScene+w2;
			_tempPoint.y = (stageY-h2)/scaleScene+h2;
			
			if(isGloble)
			{
				var camerax:Number=GameCamera(Game.scene.camera).x2d;
				var cameray:Number=GameCamera(Game.scene.camera).y2d;
				_tempPoint.x += camerax;
				_tempPoint.y += cameray;
			}
			
			return _tempPoint;
		}
		public static function get gameCameraCopy():OrthographicCamera3D
		{
			if(!_gameCameraCopy)
			{
				_gameCameraCopy = new OrthographicCamera3D("gameCameraCopy");
				_gameCameraCopy.parent = Device3D.scene;
				
				_gameCameraCopy.x = 0
				_gameCameraCopy.y = 0;
				_gameCameraCopy.z = -1000;
				
				_gameCameraCopy.zoom=1;
				_gameCameraCopy.updateProjectionMatrix();

			}
			return _gameCameraCopy;
		}
		public static function get cameraQuaternion():Quaternion
		{
			if(!_cameraQuaternion)
			{
				_cameraQuaternion=new Quaternion();
				_cameraQuaternion.fromAxisAngle(Vector3D.X_AXIS,cameraAngle/180*Math.PI);
			}
			return _cameraQuaternion;
		}
		
		
		/**
		 * 将3d地平面坐标转成平行相机xy平面的2d坐标 
		 * @param point3d
		 * @return 
		 * 
		 */		
		public static function change3Dto2D(point3d:Vector3D):Point
		{
			_tempPoint.x=point3d.x;
			_tempPoint.y=-point3d.z*cameraAngleSin-point3d.y*cameraAngleCos;
			return _tempPoint;
		}
		
		/**
		 * 将平行相机xy平面的2d坐标转成3d地平面的x,z坐标
		 * @param valueX2D
		 * @return 
		 * 
		 */		
		public static function change2Dto3DY(valueY2D:Number):Number
		{
			
			return (-valueY2D) * to3D;
		}
		public static function change2Dto3DX(valueX2D:Number):Number
		{
			return valueX2D;
		}

		
		
		public static function change2Dto3DRotation(rotation2D:Number):Number
		{
			var radians2D:Number = MathUitl.getRadians(rotation2D);
			var tempX2D:Number = Math.cos(radians2D);
			var tempY2D:Number = Math.sin(radians2D);
			var tempZ3D:Number = change2Dto3DY(tempY2D);
			var radians3D:Number = MathUitl.getRadiansByXY(0,0,tempZ3D,tempX2D);
			var angle3D:Number = MathUitl.getAngle(radians3D)-180;
			return angle3D
		}
		public static function addMesh(_mesh:Mesh3D):void
		{
			sceneObjectsList[_mesh]=_mesh;
		}
		public static function removeMesh(_mesh:Mesh3D):void
		{
			delete sceneObjectsList[_mesh];
		}
	}
}
package frEngine.util
{
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	
	import baseEngine.basic.Scene3D;
	import baseEngine.core.Boundings3D;
	import baseEngine.core.Mesh3D;
	import baseEngine.system.Device3D;
	import baseEngine.utils.Matrix3DUtils;
	
	import frEngine.primitives.DepthQuad;

	public class DepthRenderUtil
	{
		private var _targetObjectList:Array=new Array();
		
		private var _tempVect:Vector3D=new Vector3D();


		private var bmpCenterValue:int;
		private var _depthQuad:DepthQuad;
		private var bmp:BitmapData;
		
		public function DepthRenderUtil(rootSprite:DisplayObjectContainer)
		{
			
			_depthQuad=new DepthQuad(1,null);
			
			bmp=new BitmapData(_depthQuad.bmpSize,_depthQuad.bmpSize,false,0xffffff);
			bmpCenterValue=bmp.width/2;
			
			/*var b:Bitmap=new Bitmap(bmp);
			b.x=200;
			b.y=200;
			rootSprite.addChild(b);*/
			
		}

		public function getObjectsInArea(_movingObjectsList:Dictionary,mousex:Number,mousey:Number):int
		{
			_targetObjectList.length=0;
			for each(var mesh:Mesh3D in _movingObjectsList)
			{
				if(!mesh || !mesh.visible || mesh.isHide)
				{
					continue;
				}

				var bound:Boundings3D=mesh.bounds;
				if(!bound)
				{
					continue;
				}
				var center:Vector3D=mesh.world.transformVector(bound.center);
				var dis:Number=Device3D.camera.getScreenMouseDistance(mousex,mousey,center);
				var r:Number=bound.radius;

				Matrix3DUtils.getScale(mesh.world,_tempVect);
				r=r*Math.max(_tempVect.x,_tempVect.y,_tempVect.z);
				

				if(Math.abs(dis)<r)
				{
					_targetObjectList.push(mesh);
					if(_targetObjectList.length==9)
					{
						break;
					}
				}
			}
			var len:int=_targetObjectList.length;
			if(len>0)
			{
				_targetObjectList.sortOn("z");
			}
			
			return len;
		}
		public function getCurSelecteObject(_scene3d:Scene3D,offx:Number,offy:Number):Mesh3D
		{
			var curSelectObject:Mesh3D;
			var mesh:Mesh3D;

			_scene3d.context.setRenderToTexture(_depthQuad.depthTexture.texture, true);
			_scene3d.context.clear(1,0,0,0,1);
			
			var len:int=_targetObjectList.length;
			for(var i:int=0;i<len;i++)
			{
				mesh=_targetObjectList[i];
				mesh.render.drawDepth(mesh,0.1*i);
			}
			
			_scene3d.context.setRenderToBackBuffer();
			_scene3d.context.clear(1,0,0,1);

			_depthQuad.drawDepth(offx,offy);
			
			_scene3d.context.drawToBitmapData( bmp );
			
			var color:uint=bmp.getPixel(bmpCenterValue,bmpCenterValue);
			var rr:uint=color>>16;
			rr=Math.round(rr/255*10);
			if(rr<10)
			{
				curSelectObject=_targetObjectList[rr];
			}
			
			_scene3d.endFrame();
			_scene3d.context.setRenderToBackBuffer();

			return curSelectObject;
		}
	}
} 
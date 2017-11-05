package mortal.game.scene3D.display3d.icon3d
{
	import com.gengine.debug.Log;
	
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import frEngine.Engine3dEventName;
	import frEngine.loaders.resource.Resource3dManager;
	
	import mortal.game.scene3D.GameScene3D;

	public class Icon3DFactory
	{
		private  var _scene:GameScene3D;
		public static  const instance:Icon3DFactory=new Icon3DFactory();
		private  var _bigImgList:Dictionary=new Dictionary(false);

		public function Icon3DFactory()
		{
			Resource3dManager.instance.addEventListener(Engine3dEventName.CHECK_TO_DISPOSE,checkToDispose);
		}
		
		private function checkToDispose(e:Event):void
		{
			var curTime:Number=getTimer();
			var arr:Array=new Array();
			for each(var p:Icon3DBigImg in _bigImgList)
			{
				if(p.canDispose(curTime))
				{
					arr.push(p);
				}
			}
			var len:int=arr.length;
			for(var i:int=0;i<len;i++)
			{
				p=arr[i];
				p.disposeAll();
				delete _bigImgList[p.url];
			}
		}
		public  function init(scene:GameScene3D):void
		{
			_scene=scene;
			Icon3DRender.instance.init(scene);
			for each(var p:Icon3DBigImg in _bigImgList)
			{
				p.init(_scene);
			}
		}
		
		
		
		public  function createicon3D(bigImgUrl:String,xid:uint,yid:uint):Icon3D
		{
			var iconBigImg:Icon3DBigImg=_bigImgList[bigImgUrl]
			if(iconBigImg==null)
			{
				_bigImgList[bigImgUrl]=iconBigImg=new Icon3DBigImg(bigImgUrl);
				if(_scene)
				{
					iconBigImg.init(_scene);
				}
				
			}
			return iconBigImg.createIcon3D(xid,yid);
			
		}
		public  function disposeIcon3D(icon:Icon3D):void
		{
//			Log.debug("disposeIcon",icon.bigImgUrl);
			if(icon.parent)
			{
				icon.parent=null;
			}
			var iconBigImg:Icon3DBigImg=_bigImgList[icon.bigImgUrl];
			if(iconBigImg)
			{
				iconBigImg.disposeIcon3D(icon);
			}
		}
		
	}
}
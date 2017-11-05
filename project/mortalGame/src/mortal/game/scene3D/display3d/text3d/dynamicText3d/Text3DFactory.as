package mortal.game.scene3D.display3d.text3d.dynamicText3d
{
	import flash.events.Event;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	
	import frEngine.Engine3dEventName;
	import frEngine.loaders.resource.Resource3dManager;
	
	import mortal.game.scene3D.GameScene3D;

	public class Text3DFactory
	{
		private  var _scene:GameScene3D;
		private var _dicMap:Dictionary;
		public static  const instance:Text3DFactory=new Text3DFactory();
		public function Text3DFactory()
		{
			Resource3dManager.instance.addEventListener(Engine3dEventName.CHECK_TO_DISPOSE,checkToDispose);
			
			_dicMap=new Dictionary(false);
			_dicMap[32]=new WidthType(32);
			_dicMap[64]=new WidthType(64);
			_dicMap[128]=new WidthType(128);
			_dicMap[256]=new WidthType(256);
			_dicMap[512]=new WidthType(512);
			
		}
		
		private function checkToDispose(e:Event):void
		{
			for each(var p:WidthType in _dicMap)
			{
				var hasdispose:Boolean=p.checkAndDispose();
			}
			
		}
		
		public function checkToUploadTexture():void
		{
			if(!_scene)
			{
				return;
			}
			for each(var p:WidthType in _dicMap)
			{
				if(p.checkAndUpload(_scene))
				{
					return;
				}
			}
			
		}
		public  function init(scene:GameScene3D):void
		{
			_scene=scene;
			Text3DRender.instance.init(scene);
			for each(var p:WidthType in _dicMap)
			{
				p.init(_scene);
			}
		}
		
		public function createtext3D(textField:TextField):Text3D
		{
			var _wideType:WidthType=getWidthType(textField.textWidth+4);
			return _wideType.createText3D(textField);
		}
		
		public  function updateText3D(text3d:Text3D,textField:TextField):void
		{
			var _wideType:WidthType=getWidthType(textField.textWidth+4);
			_wideType.updateText3D(text3d,textField);
		}
		private function getWidthType(value:int):WidthType
		{
			var _level:int;
			if(value<32)
			{
				_level=32;
			}
			else if(value>512)
			{
				_level=512;
			}
			else
			{
				_level=1;
				while ((_level << 1) <= value)
				{
					_level=(_level << 1);
				}
				if(value>_level)
				{
					_level*=2;
				}
			}
			
			return _dicMap[_level];
		}
		public  function disposeText3D(text3d:Text3D):void
		{
			if(text3d.parent)
			{
				text3d.parent=null;
			}
			text3d.bigImg.disposeText3D(text3d);
			
		}
		
	}
}
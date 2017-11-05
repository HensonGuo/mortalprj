package mortal.game.scene3D.display3d.text3d.dynamicText3d
{
	import flash.display.BitmapData;
	
	import baseEngine.core.Mesh3D;
	import baseEngine.core.Texture3D;
	import baseEngine.system.Device3D;
	
	import mortal.game.scene3D.display3d.text3d.Text3DPlace;
	
	public class Text3DMesh extends Mesh3D
	{
		private var _curList:Vector.<Number>;
		public var maxId:uint=0;
		public var textBg0:Texture3D;
		public var listArr:Array=new Array();
		public var text3dWidth:uint;
		/*private static var _id:int=0;
		public static var map:Dictionary=new Dictionary(false);
		public var id:int=0;*/
		public function Text3DMesh($bmpdata:BitmapData, useColorAnimate:Boolean)
		{
			super("", useColorAnimate, Device3D.scene.renderLayerList);
			textBg0=new Texture3D($bmpdata,0);
			//textBg0.addEventListener(Engine3dEventName.TEXTURE_CREATE,createHander);
			text3dWidth=$bmpdata.width;
			//id=_id++;
		}
		/*private function createHander(e:Event):void
		{
			if(map[textBg0.texture]!=null)
			{
				trace("error");
			}
			map[textBg0.texture]=id;
			trace(id,text3dWidth);
		}*/
		public override function dispose(isReuse:Boolean=true):void
		{
			super.dispose(isReuse);
			_curList=null;
			listArr=null;
			textBg0.disposeImp();
			textBg0=null;
		}
		

		public function createNewPlace():Text3DPlace
		{
			if(!_curList || _curList.length>=400)
			{
				_curList=new Vector.<Number>();
				listArr.push(_curList);
			}
			maxId++
			var place:Text3DPlace=new Text3DPlace(_curList,_curList.length/4,maxId);
			return place;
		}
	}
}
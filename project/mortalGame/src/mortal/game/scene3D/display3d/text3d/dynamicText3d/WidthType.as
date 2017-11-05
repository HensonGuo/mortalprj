package mortal.game.scene3D.display3d.text3d.dynamicText3d
{
	import flash.text.TextField;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import mortal.game.scene3D.GameScene3D;

	public class WidthType
	{
		private var heightMap:Dictionary = new Dictionary(false);
		private var curText3dBig:Text3DBigImg;
		private var listArr:Array=new Array();
		private var _width:int=0;
		private var _scene:GameScene3D;
		public function WidthType($width:int)
		{
			_width=$width;
			
		}
		
		public function init($scene:GameScene3D):void
		{
			_scene=$scene;
			for each(var p:Text3DBigImg in listArr)
			{
				p.init(_scene);
			}
		}

		public function checkAndDispose():Boolean
		{
			var curTime:Number=getTimer();
			var arr:Array=new Array();
			for each(var p:Text3DBigImg in listArr)
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
				p.disposeAll(heightMap);
				var _index:int=listArr.indexOf(p)
				listArr.splice(_index,1);
				
			}
			var curText3dBigIsInPool:int=arr.indexOf(curText3dBig);
			if(curText3dBigIsInPool!=-1)
			{
				curText3dBig=listArr.length==0?null:listArr[listArr.length-1];
			}
			return len>0
		}
		public function checkAndUpload(scene:GameScene3D):Boolean
		{
			var len:int=listArr.length;
			for(var i:int=0;i<len;i++)
			{
				var _bigImg:Text3DBigImg=listArr[i];
				if(_bigImg.needUpload)
				{
					_bigImg.uploadTexture(scene);
					return true;
				}
			}
			return false;
		}
		private function getPosInfo(textField:TextField):Text3DInfo
		{
			var htmlFlag:String=textField.htmlText
			var posInfo:Text3DInfo = heightMap[htmlFlag];
			if (!posInfo)
			{
				if(!curText3dBig || curText3dBig.isFull(textField.height))
				{
					curText3dBig=new Text3DBigImg(_width);
					if(_scene)
					{
						curText3dBig.init(_scene);
					}
					listArr.push(curText3dBig);
				}
				
				
				heightMap[textField.htmlText]=posInfo=curText3dBig.createPos(textField,htmlFlag);
				
			}
			return posInfo;
		}
		public function createText3D(textField:TextField):Text3D
		{
			var pos:Text3DInfo=getPosInfo(textField);
			return pos.targetBigImg.createText3D(textField,pos);
		}
		
		public function updateText3D(text3d:Text3D,textField:TextField):void
		{
			var pos:Text3DInfo=getPosInfo(textField);
			pos.targetBigImg.createText3D(textField,pos,text3d);
		}
	}
}
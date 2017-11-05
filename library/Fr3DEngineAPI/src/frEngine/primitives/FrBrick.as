package frEngine.primitives
{
	import com.gengine.resource.LoaderManager;
	import com.gengine.resource.info.ImageInfo;
	
	import flash.display.BitmapData;
	
	import baseEngine.basic.RenderList;
	
	import frEngine.loaders.resource.info.ABCInfo;

	public class FrBrick extends FrQuad
	{
		public function FrBrick(_name:String="quad", _x:Number=0, _y:Number=0, _material:*=null, $renderList:RenderList=null)
		{
			super(_name, _x, _y, 100, 100, false, _material, $renderList);
		}
		public override function setMaterial(_arg1:*, mipType:int,materilaName:String):void
		{
			if(_arg1 is String)
			{
				LoaderManager.instance.load(_arg1,onLoadedImg);
			}else if(_arg1 is BitmapData)
			{
				this.width=_arg1.width;
				this.height=_arg1.height;
				this.x=(sceneRect.width-this.width)/2;
				this.y=(sceneRect.height-this.height)/2
			}
			
			super.setMaterial(_arg1,mipType,materilaName);
			
		}
		private function onLoadedImg(info:ImageInfo):void
		{
			if(info is ABCInfo)
			{
				this.width=ABCInfo(info).bmpWidth;
				this.height=ABCInfo(info).bmpHeight;
			}else
			{
				this.width=info.bitmapData.width;
				this.height=info.bitmapData.height;
			}
			this.x=(sceneRect.width-this.width)/2;
			this.y=(sceneRect.height-this.height)/2
		}
	}
}
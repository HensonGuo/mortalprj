package mortal.game.view.common.display
{
	import com.gengine.debug.Log;
	import com.gengine.resource.LoaderManager;
	import com.gengine.resource.ResourceManager;
	import com.gengine.resource.info.ImageInfo;
	import com.mui.controls.GBitmap;
	import com.mui.controls.GSprite;
	import com.mui.core.GlobalClass;
	
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import mortal.common.display.LoaderHelp;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.ResFileConst;
	import mortal.game.view.common.UIFactory;
	
	/**
	 * 图片文字
	 * @date   2014-3-17 下午9:08:33
	 * @author dengwj
	 */	 
	public class BitmapText extends GSprite
	{
		private var _bmp:GBitmap;
		
		/** 字体类型(暂时7种颜色类型字体) */
		private var _type:int;
		private var _numStr:String;
		private var _space:int;
		
		/** 是否加载完成 */
		private var _isLoadCompl:Boolean;
			
		public function BitmapText()
		{
			super();
		}
		
		override protected function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			this._bmp = UIFactory.gBitmap("",0,0,this);
			
			LoaderManager.instance.load("fightNumbers.png",onLoadOk);
		}
		
		private function onLoadOk(info:ImageInfo = null):void
		{
			this._isLoadCompl = true;
			updateText();
		}
		
		override protected function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			
			this._bmp.dispose(isReuse);
			
			this._bmp = null;
			
			_type = 0;
			_numStr = "";
			_space = 0;
		}
		
		/**
		 * 设置要显示的战斗力数字 
		 * @param type   战斗数字类型
		 * @param numStr 战斗数字文本
		 * @param space  每个字间的间距
		 * @return 
		 */
		public function setFightNum(type:int,numStr:String,space:int):void
		{
			_type = type;
			_numStr = numStr;
			_space = space;
			updateText();
		}
		
		private function updateText():void
		{
			if(_isLoadCompl && _numStr)
			{
				var len:uint = (21 + _space) * _numStr.length; 
				this._bmp.bitmapData = new BitmapData(len,25,true,0x00ffffff);
				for(var i:int = 0; i < _numStr.length; i++)
				{
					var bmpData:BitmapData = NumberManager.getBitmapData(_type,_numStr.substr(i,1));
					var tx:int = (_space + 9) * i;
					this._bmp.bitmapData.draw(bmpData,new Matrix(1,0,0,1,tx));
				}
			}
		}
	}
}
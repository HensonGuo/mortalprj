package mortal.game.scene3D.display3d.text3d.dynamicText3d
{

	import flash.display.BitmapData;
	import flash.display3D.textures.Texture;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import frEngine.render.layer.Layer3DManager;
	
	import mortal.game.scene3D.GameScene3D;
	import mortal.game.scene3D.display3d.text3d.Text3DPlace;

	public class Text3DBigImg
	{
		private var htmlMap:Array=[];
		private var _pool:Array = new Array();
		public var textMesh3d:Text3DMesh;
		private var _lastDisposeTime:Number = 0;
		private var _disposeTime:Number = 1000 * 60 * 2;
		private var _hasCreateMaxNum:int = 0;
		private var placeList:Array=[];
		public var curY:int = 0;
		private var _bmpdata:BitmapData;
		public var needUpload:Boolean=false;
		private static const _m:Matrix = new Matrix();
		
		public function Text3DBigImg($width:int)
		{
			_bmpdata = new BitmapData($width, 256, true, 0x0);
			textMesh3d = new Text3DMesh(_bmpdata, false);
			textMesh3d.setLayer(Layer3DManager.text3DLayer, false);
			textMesh3d.render = Text3DRender.instance;
			
			/*var bmp:Bitmap=new Bitmap(_bmpdata);
			bmp.x=bmp.y=400*Math.random();
			var sp:Sprite=new Sprite();
			sp.addChild(bmp);
			Device3D.scene.stage.addChild(sp);
			var fun:Function=function(e:Event):void
			{
				sp.startDrag(false);
			}
			var fun2:Function=function(e:Event):void
			{
				sp.stopDrag();
			}
			sp.addEventListener(MouseEvent.MOUSE_DOWN,fun);
			sp.addEventListener(MouseEvent.MOUSE_UP,fun2);*/
		}

		public function canDispose(curTime:Number):Boolean
		{
			if (curTime - _lastDisposeTime > _disposeTime && placeList.length == _hasCreateMaxNum && curY>200)
			{
				return true;
			}
			else
			{
				return false;
			}
		}

		public function isFull(nextHeight:int):Boolean
		{
			return curY + nextHeight+4 > 256;
		}

		public function init(scene:GameScene3D):void
		{
			
			scene.addChild(textMesh3d);
		}

		public function uploadTexture(scene:GameScene3D):void
		{
			
			if(textMesh3d.textBg0.texture)
			{
				Texture(textMesh3d.textBg0.texture).uploadFromBitmapData(_bmpdata, 0);
			}else
			{
				textMesh3d.textBg0.upload(scene,false);
			}
			
			needUpload=false;
		}
		
		
		public function createPos(textField:TextField,htmlFlag:String):Text3DInfo
		{
			htmlMap.push(htmlFlag);
			var _y:uint = curY;
			var _w:uint = int(textField.textWidth+4);
			var _h:uint = int(textField.textHeight+4);
			var posInfo:Text3DInfo = new Text3DInfo(_y,_w, _h,this);
			_m.identity();
			_m.translate(0, _y);
			
			/*if(!textField.parent)
			{
				Global.stage.addChild(textField);
				textField.x=Math.random()*1000;
			}*/
			/*var _textField:TextField=new TextField();
			_textField.width=300;
			_textField.height=50;
			_textField.textColor=0x00ff00;
			_textField.text=textField.text;
			_bmpdata.draw(_textField, _m);*/
			
			_bmpdata.draw(textField, _m);
			needUpload=true;
			curY += _h;
			return posInfo;
		}

		

		private function releasePlace(text3d:Text3D):void
		{
			text3d.hide();
			placeList.push(text3d.place);
		}
		
		
		private function getPlace():Text3DPlace
		{
			if(placeList.length>0)
			{
				return placeList.shift();
			}else
			{
				this._hasCreateMaxNum++;
				return textMesh3d.createNewPlace();
			}
		}
		public function createText3D(textField:TextField,posInfo:Text3DInfo,text3d:Text3D=null):Text3D
		{
			var _text:Text3D=text3d;
			if(_text)
			{
				if(_text.bigImg!=this)
				{
					_text.bigImg.releasePlace(_text);
					_text.reInit(this,getPlace());
				}
				
			}else
			{
				if (_pool.length > 0)
				{
					_text = _pool.pop();
				}
				else
				{
					_text = new Text3D();
				}
				_text.reInit(this,getPlace());
			}
			
			
			
			_text.setImgPos(posInfo.offsetY,posInfo.width, posInfo.height,textField.text);
			return _text;
		}

		public function disposeText3D(text:Text3D):void
		{
			if (_pool && _pool.indexOf(text) == -1)
			{
				_pool.push(text);
			}
			text.hide();
			placeList.push(text.place);
			_lastDisposeTime = getTimer();
		}

		public function disposeAll(heightMap:Dictionary):void
		{
			textMesh3d.dispose(false);
			var len:int=_pool.length;
			for(var i:int=0;i<len;i++)
			{
				var text3d:Text3D=_pool[i];
				text3d.clear();
			}
			textMesh3d=null;
			_pool = null;
			_bmpdata.dispose();
			_bmpdata=null;
			for each(var flag:String in htmlMap)
			{
				delete heightMap[flag];
			}
		}
	}
}

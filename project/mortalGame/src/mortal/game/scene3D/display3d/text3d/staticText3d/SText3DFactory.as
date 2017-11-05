package mortal.game.scene3D.display3d.text3d.staticText3d
{
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import baseEngine.core.Pivot3D;
	
	import frEngine.TimeControler;
	import frEngine.render.layer.Layer3DManager;
	
	import mortal.game.scene3D.GameScene3D;
	import mortal.game.scene3D.display3d.text3d.Stext3DPlace;
	import mortal.game.scene3D.display3d.text3d.staticText3d.action.ActionVo;

	public class SText3DFactory
	{
		private var _scene:GameScene3D;

		public var textMesh3d:SText3DMesh;

		private var _sText3DPool:Array = new Array();

		private var _boxPool:Array = new Array();
		
		private var _curUseBoxList:Array = new Array();
		
		private const reg:RegExp = /击|反|挡|压|避|收|疫/g;
		
		public static const instance:SText3DFactory = new SText3DFactory();

		public const duringFrame:Number = 33; //文字飘动时间周期

		public var textMapDic:Dictionary = new Dictionary(false);

		public var numberMapDic:Dictionary = new Dictionary(false);

		public var kuohaoMapDic:Dictionary = new Dictionary(false);

		public function SText3DFactory()
		{
			textMesh3d = new SText3DMesh(false);
			textMesh3d.setLayer(Layer3DManager.text3DLayer, false);
			textMesh3d.render = SText3DRender.instance;
			textMapDic["暴"] = new TextVo(15, 0, 0, 3, 2); //暴击

			textMapDic["射"] = new TextVo(18, 0, -8, 3, 2); //反射

			textMapDic["格"] = new TextVo(21, 0, -8, 3, 2); //格挡

			textMapDic["碾"] = new TextVo(12, 2, -8, 3, 2); //碾压

			textMapDic["闪"] = new TextVo(15, 2, -8, 3, 2); //闪避

			textMapDic["吸"] = new TextVo(18, 2, -8, 3, 2); //吸收

			textMapDic["免"] = new TextVo(21, 2, -8, 3, 2); //免疫
			
			textMapDic["弹"] = new TextVo(12, 4, -8, 3, 2); //反弹

			var _s:Number=TextVo.su;
			numberMapDic["0"] = 0*_s;
			numberMapDic["1"] = 1*_s;
			numberMapDic["2"] = 2*_s
			numberMapDic["3"] = 3*_s
			numberMapDic["4"] = 4*_s
			numberMapDic["5"] = 5*_s
			numberMapDic["6"] = 6*_s
			numberMapDic["7"] = 7*_s
			numberMapDic["8"] = 8*_s
			numberMapDic["9"] = 9*_s
			numberMapDic["-"] = 10*_s
			numberMapDic["+"] = 11*_s;

			kuohaoMapDic["("] = new TextVo(12, 0, 0, 1, 1);
			kuohaoMapDic[")"] = new TextVo(13, 0, 0, 1, 1);

			var _timer:Timer = new Timer(20 * 1000);
			_timer.addEventListener(TimerEvent.TIMER, checkToDispose);
			_timer.start();
		}

		private function checkToDispose(timer:Object):void
		{
			var maxNum:int=SText3DRender.instance.maxNum;
			if(VcList.totalUseNum < maxNum  && textMesh3d.vcListMap.length>1 )
			{
				
				textMesh3d.clearAll();
				
				var len:int = _curUseBoxList.length;
				
				for (var i:int = 0; i < len; i++)
				{
					var box:Stext3DBox = _curUseBoxList[i];
					var _list:Vector.<SText3D> = box.list;
					var _txtLen:int=_list.length
					var _placeList:Vector.<Stext3DPlace>=getPlaces(_txtLen+1);
					var boxPlace:Stext3DPlace=_placeList[0];
					for (var k:int=0;k<_txtLen;k++)
					{
						var _tex:SText3D=_list[k];
						_tex.reInitPlace(_placeList[k+1],boxPlace);
					}
					box.place=boxPlace;
				}
				
			}
		}

		public function init(scene:GameScene3D):void
		{
			_scene = scene;

			scene.addChild(textMesh3d);

			textMesh3d.upload(scene)

			SText3DRender.instance.init(scene);
		}

		private var tempVect:Vector.<Stext3DPlace>=new Vector.<Stext3DPlace>();
		
		
		private function getPlaces(num:int):Vector.<Stext3DPlace>
		{
			if(tempVect.length<num)
			{
				tempVect.length=num;
			}
			
			var map:Vector.<VcList>=textMesh3d.vcListMap;

			for each (var vclist:VcList in map)
			{
				if( vclist.getPlaces(num,tempVect))
				{
					return tempVect
				}
			}
			
			vclist=textMesh3d.createNewVcList();
			vclist.getPlaces(num,tempVect)
			return tempVect;	
		}

		public function createtext3D(str:String, numberColor:Number,$parent:Pivot3D,$actionVo:ActionVo):Stext3DBox
		{
			str = str.replace(reg, "");
			var charList:Array = str.split("");
			var len:int = charList.length;
			if(len==0)
			{
				return null;
			}
			
			var _textBox:Stext3DBox;
			if (_boxPool.length > 0)
			{
				_textBox = _boxPool.pop();
			}
			else
			{
				_textBox = new Stext3DBox("");
			}

			var _text:SText3D;
			var vectorlist:Vector.<SText3D> = new Vector.<SText3D>();

			
			var targetColorIndex:Number = numberColor;
			var uvOffsetY:Number; 
			var uvOffsetX:Number; 
			var point:TextVo;
			var curOffsetX:int = 1;
			var targetWidth:uint = 0;
			var targetHeight:uint = 0;
			var preIsNumber:Boolean = false;
			var _offsetX:int = 0;
			var sw:Number =TextVo.sw;
			var curFrame:uint = TimeControler.stageFrame;
			var list:Vector.<Stext3DPlace>=getPlaces(len+1);
			var boxPlace:Stext3DPlace=list[0];
			for (var i:int = 0; i < len; i++)
			{

				var char:String = charList[i];
				
				if (char == "(")
				{
					targetColorIndex = ENumberTextColor.green0;

				}

				var curIsNumber:Boolean;
				
				if ((point = textMapDic[char]))
				{
					uvOffsetX = point.u;
					uvOffsetY = point.v;
					targetWidth = point.width;
					targetHeight = point.height;
					_offsetX = (i==0?0:point.offsetX);
					curIsNumber = false;
				}
				else
				{

					if ((point = kuohaoMapDic[char]))
					{
						uvOffsetX = point.u;
						uvOffsetY = point.v;

					}
					else
					{
						uvOffsetX = numberMapDic[char];
						uvOffsetY = targetColorIndex;
					}
					_offsetX = 0
					targetWidth = 1;
					targetHeight = 1;
					curIsNumber = true;
				}

				if( preIsNumber && curIsNumber)
				{
					_offsetX += -8;
				}
				
				
				if (_sText3DPool.length > 0)
				{
					_text = _sText3DPool.pop();
				}
				else
				{
					_text = new SText3D(str);

				}

				_text.reInitPlace(list[i+1],boxPlace);

				preIsNumber=curIsNumber
				curOffsetX += _offsetX;
				_text.setImgInfo(targetWidth, targetHeight, curOffsetX, uvOffsetX, uvOffsetY);
				if(curIsNumber)
				{
					curOffsetX += targetWidth*sw;
				}else
				{
					curOffsetX += targetWidth*sw+point.offsetX;
				}
				

				vectorlist.push(_text);
			}
			
			_textBox.reInit(curFrame,vectorlist,boxPlace,curOffsetX,$parent,$actionVo);
			_curUseBoxList.push(_textBox);
			
			return _textBox;
		}

		public function disposeText3D(textbox:Stext3DBox):void
		{
			if (textbox.parent)
			{
				textbox.parent = null;
			}

			_boxPool.push(textbox);
			
			textbox.clear(true);
			
			var _list:Vector.<SText3D> = textbox.list;

			for each (var p:SText3D in _list)
			{
				if (_sText3DPool.indexOf(p) == -1)
				{
					_sText3DPool.push(p);
					p.clear();
					
				}
			}

			var index:int=_curUseBoxList.indexOf(textbox);
			_curUseBoxList.splice(index,1);
			
			//checkDisposeMesh && checkToDisposeMesh();

		}

	}
}

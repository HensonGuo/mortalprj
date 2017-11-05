// Decompiled by AS3 Sorcerer 1.56
// http://www.as3sorcerer.com/

//se7en.world.shot.Ground

package word.objects
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Loader;
    import flash.display.LoaderInfo;
    import flash.display3D.Context3D;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.TimerEvent;
    import flash.geom.Rectangle;
    import flash.net.URLRequest;
    import flash.utils.Dictionary;
    import flash.utils.Timer;
    
    import __AS3__.vec.Vector;
    
    import de.nulldesign.nd2d.display.Camera2D;
    import de.nulldesign.nd2d.display.Node2D;
    import de.nulldesign.nd2d.materials.BlendModePresets;
    import de.nulldesign.nd2d.materials.Sprite2DMaterial;
    import de.nulldesign.nd2d.materials.texture.Texture2D;
    
    import word.cache.Word2dCachePool;
    import word.dict.GridSizeDict;
    import word.filePath.FilePathUtils;
    import word.loader.HashLoader;
    import word.log.MyLog;
    

    public class Ground extends Node2D {

        public static const TILE_WIDTH:int = 256;
        public static const TILE_HEIGHT:int = 256;
        public static const SCALE:int = 20;
        public static const DRAW_RECT:Rectangle = new Rectangle(0, 0, 6, 5);

		private static var _COL:int;
		private static var _ROW:int;

        private var getUrlByIndex:Function;
        private var pitchOption:int;
        private var preLoader:Loader;
        public var _needMiniMap:Boolean = true;
        private var brickList:Dictionary;
        public var loadImmediate:Boolean = true;
        private var loadTimer:Timer;
        private var tileLoaderList:Vector.<HashLoader>;
        private var prevX:Number;
        private var prevY:Number;
        private var _brickMat:Sprite2DMaterial;
        private var _tempRect:Rectangle;
        private var _canDraw:Boolean = true;

        public function Ground(){
            this.brickList = new Dictionary();
            this.loadTimer = new Timer(10, int.MAX_VALUE);
            this._tempRect = new Rectangle();
            super();
            this.loadTimer.addEventListener(TimerEvent.TIMER, this.onLoadTileTimer);
            this.tileLoaderList = new Vector.<HashLoader>();
            addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStage);
        }

		public static function set COL(value:int):void
		{
			_COL=value;
		}
		public static function set ROW(value:int):void
		{
			_ROW=value;
		}
		public static function get COL():int
		{
			return _COL;
		}
		public static function get ROW():int
		{
			return _ROW;
		}

        private function onRemovedFromStage(_arg1:Event):void{
            this._brickMat = null;
        }

        public function clearAll():void{
            this.removeAllBricks();
            this._brickMat = null;
            this.tileLoaderList =  null;
			this.visible=false;
        }

        public function resizeStage(_sw:Number, _sh:Number):void{
            DRAW_RECT.width = (((_sw / TILE_WIDTH) + 1) >> 0);
            DRAW_RECT.height = (((_sh / TILE_HEIGHT) + 1) >> 0);
			this.x=-int(_sw/2);
			this.y=-int(_sh/2);
        }

        public function reset(gridx:int, gridy:int, getUrlFunctioin:Function):void{
            this.getUrlByIndex = getUrlFunctioin;
            COL = Math.ceil(((gridx * GridSizeDict.GRID_WIDTH) / TILE_WIDTH));
            ROW = Math.ceil(((gridy * GridSizeDict.GRID_HEIGHT) / TILE_HEIGHT));
            this.pitchOption = 0;
            this.clearAll();
            if (this.tileLoaderList == null)
            {
                this.tileLoaderList = new Vector.<HashLoader>();
            };
            this.prevX = -1000000;
            this.prevY = -1000000;
            this._brickMat = Word2dCachePool.instance.sprite2dMat;
			this.visible=true;
            trace("ground reset");
        }


        override protected function draw(_arg1:Context3D, _arg2:Camera2D):void{
           
            var _local3:int;
            var _local11:int;
            var _local12:String;
            var _local13:int;
            var _local14:int;

            if (!this._canDraw)
            {
                return;
            };
            var _local4:Number = this.parent.x;
            var _local5:Number = this.parent.y;
            DRAW_RECT.x = ((Math.abs(_local4) / TILE_WIDTH) >> 0);
            DRAW_RECT.y = ((Math.abs(_local5) / TILE_HEIGHT) >> 0);
            var _local6:int;
            var _local7:int = DRAW_RECT.x;
            while (_local7 <= (DRAW_RECT.x + DRAW_RECT.width))
            {
                _local11 = DRAW_RECT.y;
                while (_local11 <= (DRAW_RECT.y + DRAW_RECT.height))
                {
                    if (!(((_local7 >=COL)) || ((_local11 >= ROW))))
                    {
                        _local3 = (_local7 + (_local11 * COL));
						var brick:Brick=this.brickList[_local3]
                        if (brick == null)
                        {
							_local12 = "x" + _local7 + "y" + _local11;
                            this.brickList[_local3] =brick= new Brick(_local7,_local11,_local3, _local12);
                            this.loadTile(brick);
                        }else if(!brick.visible)
						{
							brick.visible=true;
						}
                    };
                    _local11++;
                };
                _local7++;
            };
            if ((((DRAW_RECT.x == this.prevX)) && ((DRAW_RECT.y == this.prevY))))
            {
                return;
            };
			checkToDistroy();
            
        }

		private function checkToDistroy():void
		{
			var _local9:Brick;
			var len:int=0;
			this.prevX = DRAW_RECT.x;
			this.prevY = DRAW_RECT.y;
			this._tempRect.x = DRAW_RECT.x;
			this._tempRect.y = DRAW_RECT.y;
			this._tempRect.width = (DRAW_RECT.width + 0.01);
			this._tempRect.height = (DRAW_RECT.height + 0.01);
			
			for each (_local9 in this.brickList)
			{
				len++;
			}
			if(len<60)
			{
				for each (_local9 in this.brickList)
				{
					if (!this._tempRect.contains(_local9.posx, _local9.posy))
					{
						_local9.visible=false;
					};
				};
				return;	
			}
			
			var _local8:Array = [];
			
			var _local10:int;
			var _local15:int;
			for each (_local9 in this.brickList)
			{
				if (!this._tempRect.contains(_local9.posx, _local9.posy))
				{
					_local8.push(_local9.pos);
					this.removeABrick(_local9.pos);
				};
			};
			this.pitchOption++;
			_local10 = 0;
			while (_local10 < _local8.length)
			{
				_local15 = _local8[_local10];
				if (this.brickList[_local15] != null)
				{
					delete this.brickList[_local15];
				};
				_local10++;
			};
			_local8 = [];
		}
        private function removeAllBricks():void{
            var _local2:Brick;
            var _local3:int;
            var _local1:Array = [];
            for each (_local2 in this.brickList)
            {
                _local2.destroy();
                this.removeChild(_local2);
                _local1.push(_local2.pos);
            };
            _local3 = 0;
            while (_local3 < _local1.length)
            {
                delete this.brickList[_local1[_local3]];
                _local3++;
            };
            _local1 = [];
        }

        

        public function removeABrick(_arg1:int):void{
            this.brickList[_arg1].destroy();
            this.removeChild(this.brickList[_arg1]);
        }

        private function loadTile(_arg1:Brick):void{
            var _local2:int = _arg1.pos;
            var _local3:HashLoader = _arg1.loader;
            this.brickList[_local2].status = Brick.LOADING;
            _local3.name = _arg1.name;
            _local3.id = _local2;
            this.tileLoaderList.push(_local3);
            if (this.loadImmediate)
            {
                this.onLoadTileTimer(null);
            } else
            {
                if (!this.loadTimer.running)
                {
                    this.loadTimer.start();
                };
            };
        }

        private function onLoadTileTimer(_arg1:TimerEvent):void{
            var _local3:Object;
            if (this.tileLoaderList.length == 0)
            {
                this.loadTimer.stop();
                return;
            };
            var _local2:HashLoader = this.tileLoaderList.pop();
			if (this.getUrlByIndex != null)
			{
				_local3 = this.getUrlByIndex(_local2.name);
				
				if(_local3 is BitmapData)
				{
					var brickId:int = _local2.id;
					setingBrick(brickId , BitmapData(_local3) );
				}else if( _local3 is String)
				{
					_local2.contentLoaderInfo.addEventListener(Event.COMPLETE, this.loadTileCmp);
					_local2.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, this.onLoadErr);
					var url:URLRequest=FilePathUtils.getUrl(new URLRequest( String(_local3) ) );
					_local2.load(url);
				}
				
			};
        }

        private function onLoadErr(_arg1:Event):void{
            var _local2:HashLoader = ((_arg1.target as LoaderInfo).loader as HashLoader);
			_local2.contentLoaderInfo.removeEventListener(Event.COMPLETE, this.loadTileCmp);
			_local2.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, this.onLoadErr);
			
            var _local3:int = _local2.id;
            MyLog.logE(("地板加载错误 " + (_arg1.target as LoaderInfo).loader.name));
            if (!this.brickList[_local3])
            {
				MyLog.logE(("地板状态错误 " + _local3));
                return;
            };
            this.brickList[_local3].status = Brick.ERROR;
            if (this.brickList[_local3].errCount < 3)
            {
                this.loadTile(this.brickList[_local3]);
            };
            this.brickList[_local3].errCount++;
        }

		private function loadTileCmp(_arg1:Event):void{
			var _local2:HashLoader = ((_arg1.target as LoaderInfo).loader as HashLoader);
			_local2.contentLoaderInfo.removeEventListener(Event.COMPLETE, this.loadTileCmp);
			_local2.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, this.onLoadErr);
			var _local5:BitmapData = (_local2.content as Bitmap).bitmapData;
			var _local3:int = _local2.id;
			if ((((this.brickList[_local3] == null)) || (!((this.brickList[_local3].status == Brick.LOADING)))))
			{
				return;
			};
			
			setingBrick(_local3,_local5);
			
		}
		private function setingBrick(_local3:int,bmpdata:BitmapData):void
		{
			var brick:Brick = this.brickList[_local3];
			brick.setMaterial(this._brickMat);
			brick.status = Brick.COMPLETE;
			brick.setTexture(Texture2D.textureFromBitmapData(bmpdata));
			brick.setBlendMode(BlendModePresets.OPACITY);
			
			addChild(brick);
			
			brick.x = (brick.posx+0.5) * TILE_WIDTH;
			brick.y = (brick.posy+0.5) * TILE_HEIGHT;

		}
        public function set canDraw(_arg1:Boolean):void{
            this._canDraw = _arg1;
        }

        public function tryLoadSimpleBrick(_arg1:int, _arg2:int):Loader{
            var _local4:String;
            var _local5:Loader;
            var _local3:String = ((("x" + (_arg1 + 1)) + "y") + (_arg2 + 1));
            if (this.getUrlByIndex != null)
            {
                _local4 = this.getUrlByIndex(_local3);
                _local5 = new Loader();
                _local5.load( FilePathUtils.getUrl(new URLRequest(_local4)));
                return (_local5);
            };
            return (null);
        }

        public function tryLoadBrick(_arg1:int, _arg2:int):Vector.<Loader>{
            var _local6:Loader;
            var _local8:int;
            var _local3:Number = (_arg1 - (DRAW_RECT.width / 2));
            var _local4:Number = (_arg2 - (DRAW_RECT.height / 2));
            if (_local3 < 0)
            {
                _local3 = 0;
            };
            if (_local4 < 0)
            {
                _local4 = 0;
            };
            var _local5:Vector.<Loader> = new Vector.<Loader>();
            var _local7:int = _local3;
            while (_local7 <= (_local3 + DRAW_RECT.width))
            {
                _local8 = _local4;
                while (_local8 <= (_local4 + DRAW_RECT.height))
                {
                    if (!(((_local7 >= COL)) || ((_local8 >= ROW))))
                    {
                        _local6 = this.tryLoadSimpleBrick(_local7, _local8);
                        _local5.push(_local6);
                    };
                    _local8++;
                };
                _local7++;
            };
            return (_local5);
        }


    }
}//package se7en.world.shot


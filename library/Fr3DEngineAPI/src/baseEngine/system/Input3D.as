


//flare.system.Input3D

package baseEngine.system
{
    import flash.display.Stage;
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;

    public class Input3D 
    {

        public static const A:uint = 65;
        public static const B:uint = 66;
        public static const C:uint = 67;
        public static const D:uint = 68;
        public static const E:uint = 69;
        public static const F:uint = 70;
        public static const G:uint = 71;
        public static const H:uint = 72;
        public static const I:uint = 73;
        public static const J:uint = 74;
        public static const K:uint = 75;
        public static const L:uint = 76;
        public static const M:uint = 77;
        public static const N:uint = 78;
        public static const O:uint = 79;
        public static const P:uint = 80;
        public static const Q:uint = 81;
        public static const R:uint = 82;
        public static const S:uint = 83;
        public static const T:uint = 84;
        public static const U:uint = 85;
        public static const V:uint = 86;
        public static const W:uint = 87;
        public static const X:uint = 88;
        public static const Y:uint = 89;
        public static const Z:uint = 90;
        public static const ALTERNATE:uint = 18;
        public static const BACKQUOTE:uint = 192;
        public static const BACKSLASH:uint = 220;
        public static const BACKSPACE:uint = 8;
        public static const CAPS_LOCK:uint = 20;
        public static const COMMA:uint = 188;
        public static const COMMAND:uint = 19;
        public static const CONTROL:uint = 17;
        public static const DELETE:uint = 46;
        public static const DOWN:uint = 40;
        public static const END:uint = 35;
        public static const ENTER:uint = 13;
        public static const EQUAL:uint = 187;
        public static const ESCAPE:uint = 27;
        public static const F1:uint = 112;
        public static const F10:uint = 121;
        public static const F11:uint = 122;
        public static const F12:uint = 123;
        public static const F13:uint = 124;
        public static const F14:uint = 125;
        public static const F15:uint = 126;
        public static const F2:uint = 113;
        public static const F3:uint = 114;
        public static const F4:uint = 115;
        public static const F5:uint = 116;
        public static const F6:uint = 117;
        public static const F7:uint = 118;
        public static const F8:uint = 119;
        public static const F9:uint = 120;
        public static const HOME:uint = 36;
        public static const INSERT:uint = 45;
        public static const LEFT:uint = 37;
        public static const LEFTBRACKET:uint = 219;
        public static const MINUS:uint = 189;
        public static const NUMBER_0:uint = 48;
        public static const NUMBER_1:uint = 49;
        public static const NUMBER_2:uint = 50;
        public static const NUMBER_3:uint = 51;
        public static const NUMBER_4:uint = 52;
        public static const NUMBER_5:uint = 53;
        public static const NUMBER_6:uint = 54;
        public static const NUMBER_7:uint = 55;
        public static const NUMBER_8:uint = 56;
        public static const NUMBER_9:uint = 57;
        public static const NUMPAD:uint = 21;
        public static const NUMPAD_0:uint = 96;
        public static const NUMPAD_1:uint = 97;
        public static const NUMPAD_2:uint = 98;
        public static const NUMPAD_3:uint = 99;
        public static const NUMPAD_4:uint = 100;
        public static const NUMPAD_5:uint = 101;
        public static const NUMPAD_6:uint = 102;
        public static const NUMPAD_7:uint = 103;
        public static const NUMPAD_8:uint = 104;
        public static const NUMPAD_9:uint = 105;
        public static const NUMPAD_ADD:uint = 107;
        public static const NUMPAD_DECIMAL:uint = 110;
        public static const NUMPAD_DIVIDE:uint = 111;
        public static const NUMPAD_ENTER:uint = 108;
        public static const NUMPAD_MULTIPLY:uint = 106;
        public static const NUMPAD_SUBTRACT:uint = 109;
        public static const PAGE_DOWN:uint = 34;
        public static const PAGE_UP:uint = 33;
        public static const PERIOD:uint = 190;
        public static const QUOTE:uint = 222;
        public static const RIGHT:uint = 39;
        public static const RIGHTBRACKET:uint = 221;
        public static const SEMICOLON:uint = 186;
        public static const SHIFT:uint = 16;
        public static const SLASH:uint = 191;
        public static const SPACE:uint = 32;
        public static const TAB:uint = 9;
        public static const UP:uint = 38;

        private static var _ups:Array;
        private static var _downs:Array;
        private static var _hits:Array;
        private static var _keyCode:int = 0;
        private static var _delta:int = 0;
        private static var _deltaMove:int = 0;
        private static var _mouseUp:int = 0;
        private static var _mouseHit:int = 0;
        private static var _mouseDown:int;
        private static var _rightMouseUp:int = 0;
        private static var _rightMouseHit:int = 0;
        private static var _rightMouseDown:int;
        private static var _middleMouseUp:int = 0;
        private static var _middleMouseHit:int = 0;
        private static var _middleMouseDown:int;
        private static var _mouseDobleClick:int = 0;
        private static var _mouseX:Number = 0;
        private static var _mouseY:Number = 0;
        private static var _mouseXSpeed:Number = 0;
        private static var _mouseYSpeed:Number = 0;
        private static var _mouseUpdated:Boolean = true;
        private static var _stage:Stage;
        private static var _doubleClickEnabled:Boolean;
        private static var _rightClickEnabled:Boolean;
        private static var _stageX:Number = 0;
        private static var _stageY:Number = 0;
        public static var eventPhase:uint;
        public static var enableEventPhase:Boolean = true;
        private static var _currFrame:int=0;

        public static function initialize(_arg1:Stage):void
        {
            if (_arg1 == null)
            {
                throw ("The 'stage' parameter is null");
            };
           
            _downs = ((_downs) || (new Array()));
            _hits = ((_hits) || (new Array()));
            _ups = ((_ups) || (new Array()));
			
            
        }
		public static function set stage(value:Stage):void
		{
			if(_stage)
			{
				dispose(_stage);
			}
			_stage = value;
			doubleClickEnabled = _doubleClickEnabled;
			rightClickEnabled = _rightClickEnabled;
			_mouseX = _stage.mouseX;
			_mouseY = _stage.mouseY;
			var maxLevel:int=int.MAX_VALUE;
			_stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownEvent, false, maxLevel, true);
			_stage.addEventListener(KeyboardEvent.KEY_UP, keyUpEvent, false, maxLevel, true);
			_stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseUpdate, false, maxLevel, true);
			_stage.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelEvent, false, maxLevel, true);
			_stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownEvent, false, maxLevel, true);
			_stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpEvent, false, maxLevel, true);
			_stage.addEventListener("middleMouseDown", middleMouseDownEvent, false, maxLevel, true);
			_stage.addEventListener("middleMouseUp", middleMouseUpEvent, false, maxLevel, true);
			_stage.addEventListener(Event.DEACTIVATE, deactivateEvent, false, maxLevel, true);
		}

        private static function deactivateEvent(_arg1:Event):void
        {
            reset();
        }
        public static function dispose($stage:Stage):void
        {
			$stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownEvent);
			$stage.removeEventListener(KeyboardEvent.KEY_UP, keyUpEvent);
			$stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseUpdate);
			$stage.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownEvent);
			$stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpEvent);
			$stage.removeEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelEvent);
			$stage.removeEventListener(MouseEvent.DOUBLE_CLICK, mouseDobleClickEvent);
			$stage.removeEventListener(Event.DEACTIVATE, deactivateEvent);
			$stage.removeEventListener("middleMouseDown", middleMouseDownEvent);
			$stage.removeEventListener("middleMouseUp", middleMouseUpEvent);
        }
        private static function mouseUpdate(_arg1:MouseEvent):void
        {
            _mouseUpdated = true;
            _stageX = _arg1.stageX;
            _stageY = _arg1.stageY;
			if(_stageX<5 || _stageX>_stage.stageWidth-5 || _stageY<5 || _stageY>_stage.stageHeight-5)
			{
				mouseUpEvent(_arg1);
				middleMouseUpEvent(_arg1);
			}
        }
        public static function update():void
        {
            _currFrame++;
            if (_mouseUpdated)
            {
                _mouseXSpeed = (_stageX - _mouseX);
                _mouseYSpeed = (_stageY - _mouseY);
                _mouseUpdated = false;
            }
            else
            {
                _mouseXSpeed = 0;
                _mouseYSpeed = 0;
            };
            _mouseX = _stageX;
            _mouseY = _stageY;
        }
        public static function reset():void
        {
            var _local1:int;
			if(_downs)
			{
				while (_local1 < 0xFF)
				{
					
					_downs[_local1] = 0;
					_hits[_local1] = 0;
					_ups[_local1] = 0;
					_local1++;
				};
			}
            
            _mouseXSpeed = 0;
            _mouseYSpeed = 0;
            _mouseUp = 0;
            _mouseDown = 0;
            _mouseHit = 0;
            _rightMouseUp = 0;
            _rightMouseDown = 0;
            _rightMouseHit = 0;
            _middleMouseUp = 0;
            _middleMouseDown = 0;
            _middleMouseHit = 0;
            _mouseDobleClick = 0;
        }
        private static function keyDownEvent(_arg1:KeyboardEvent):void
        {
            if (!_downs[_arg1.keyCode])
            {
                _hits[_arg1.keyCode] = (_currFrame + 1);
            };
            _downs[_arg1.keyCode] = 1;
            _keyCode = _arg1.keyCode;
        }
        private static function keyUpEvent(_arg1:KeyboardEvent):void
        {
            if (!_stage)
            {
                return;
            };
            _downs[_arg1.keyCode] = 0;
            _hits[_arg1.keyCode] = 0;
            _ups[_arg1.keyCode] = (_currFrame + 1);
            _keyCode = 0;
        }
        private static function mouseDownEvent(_arg1:MouseEvent):void
        {
			
            if (enableEventPhase)
            {
                eventPhase = _arg1.eventPhase;
            }
            else
            {
                eventPhase = 0;
            };
            _mouseDown = 1;
            _mouseUp = 0;
            _mouseHit = (_currFrame + 1);
        }
        private static function mouseWheelEvent(_arg1:MouseEvent):void
        {
            if (enableEventPhase)
            {
                eventPhase = _arg1.eventPhase;
            }
            else
            {
                eventPhase = 0;
            };
            _delta = _arg1.delta;
            _deltaMove = (_currFrame + 1);
        }
        private static function mouseUpEvent(_arg1:MouseEvent):void
        {
            if (enableEventPhase)
            {
                eventPhase = _arg1.eventPhase;
            }
            else
            {
                eventPhase = 0;
            };
            _mouseDown = 0;
            _mouseUp = (_currFrame + 1);
            _mouseHit = 0;
        }
        private static function rightMouseDownEvent(_arg1:Event):void
        {
            _rightMouseDown = 1;
            _rightMouseUp = 0;
            _rightMouseHit = (_currFrame + 1);
        }
        private static function rightMouseUpEvent(_arg1:Event):void
        {
            _rightMouseDown = 0;
            _rightMouseUp = (_currFrame + 1);
            _rightMouseHit = 0;
        }
        private static function middleMouseDownEvent(_arg1:Event):void
        {
            _middleMouseDown = 1;
            _middleMouseUp = 0;
            _middleMouseHit = (_currFrame + 1);
        }
        private static function middleMouseUpEvent(_arg1:Event):void
        {
            _middleMouseDown = 0;
            _middleMouseUp = (_currFrame + 1);
            _middleMouseHit = 0;
        }
        private static function mouseDobleClickEvent(_arg1:MouseEvent):void
        {
            _mouseDobleClick = (_currFrame + 1);
        }
        public static function get keyCode():int
        {
            return (_keyCode);
        }
        public static function keyDown(_arg1:int):Boolean
        {
            return (_downs[_arg1]);
        }
        public static function keyHit(_arg1:int):Boolean
        {
            return ((((_hits[_arg1] == _currFrame)) ? true : false));
        }
        public static function keyUp(_arg1:int):Boolean
        {
            return ((((_ups[_arg1] == _currFrame)) ? true : false));
        }
        public static function get mouseDobleClick():int
        {
            return ((((_mouseDobleClick == _currFrame)) ? 1 : 0));
        }
        public static function get delta():int
        {
            return ((((_deltaMove == _currFrame)) ? _delta : 0));
        }
        public static function set delta(_arg1:int):void
        {
            _delta = _arg1;
        }
        public static function get mouseYSpeed():Number
        {
            return (_mouseYSpeed);
        }
        public static function get mouseHit():int
        {
            return ((((_mouseHit == _currFrame)) ? 1 : 0));
        }
        public static function get mouseUp():int
        {
            return _mouseDown-1//((((_mouseUp == _currFrame)) ? 1 : 0));
        }
        public static function get mouseDown():int
        {
            return (_mouseDown);
        }
        public static function get rightMouseHit():int
        {
            return ((((_rightMouseHit == _currFrame)) ? 1 : 0));
        }
        public static function get rightMouseUp():int
        {
            return _rightMouseDown-1//((((_rightMouseUp == _currFrame)) ? 1 : 0));
        }
        public static function get rightMouseDown():int
        {
            return (_rightMouseDown);
        }
        public static function get middleMouseHit():int
        {
            return ((((_middleMouseHit == _currFrame)) ? 1 : 0));
        }
        public static function get middleMouseUp():int
        {
            return _middleMouseDown-1//((((_middleMouseUp == _currFrame)) ? 1 : 0));
        }
        public static function get middleMouseDown():int
        {
            return (_middleMouseDown);
        }
        public static function get mouseXSpeed():Number
        {
            return (_mouseXSpeed);
        }
        public static function get mouseY():Number
        {
            return (_mouseY);
        }
        public static function set mouseY(_arg1:Number):void
        {
            _mouseY = _arg1;
        }
        public static function get mouseX():Number
        {
            return (_mouseX);
        }
        public static function set mouseX(_arg1:Number):void
        {
            _mouseX = _arg1;
        }
        public static function get mouseMoved():Number
        {
            return (Math.abs((_mouseXSpeed + _mouseYSpeed)));
        }
        public static function get doubleClickEnabled():Boolean
        {
            return (_doubleClickEnabled);
        }
        public static function set doubleClickEnabled(_arg1:Boolean):void
        {
            _doubleClickEnabled = _arg1;
            _stage.doubleClickEnabled = _arg1;
            if (_arg1)
            {
                _stage.addEventListener(MouseEvent.DOUBLE_CLICK, mouseDobleClickEvent, false, 0, true);
            }
            else
            {
                _stage.removeEventListener(MouseEvent.DOUBLE_CLICK, mouseDobleClickEvent);
            };
        }
        public static function get rightClickEnabled():Boolean
        {
            return (_doubleClickEnabled);
        }
        public static function set rightClickEnabled(_arg1:Boolean):void
        {
            _rightClickEnabled = _arg1;
            if (_arg1)
            {
                _stage.addEventListener("rightMouseDown", rightMouseDownEvent, false, 0, true);
                _stage.addEventListener("rightMouseUp", rightMouseUpEvent, false, 0, true);
            }
            else
            {
                _stage.removeEventListener("rightMouseDown", rightMouseDownEvent);
                _stage.removeEventListener("rightMouseUp", rightMouseUpEvent);
            };
        }
        public static function get downs():Array
        {
            return (_downs);
        }
        public static function get hits():Array
        {
            return (_hits);
        }

    }
}//package flare.system


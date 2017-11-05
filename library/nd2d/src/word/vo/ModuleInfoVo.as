// Decompiled by AS3 Sorcerer 1.56
// http://www.as3sorcerer.com/

//game.managers.vo.ModuleInfoVo

package word.vo{
    public class ModuleInfoVo {

        private var _id:int;
        private var _url:String;
        public var type:uint;
        private var _layout:uint;
        private var _destroy:Boolean = false;
        private var _onlyone:Boolean = false;
        private var _showBottom:Boolean = false;
        private var _showEffect:Boolean = true;
        public var _playOpenCloseSound:Boolean = false;
        public var param:Object = null;
        private var _offsetX:int = 0;
        private var _offsetY:int = 0;
        public var retry:uint = 2;
        public var loadShow:Boolean = true;

        public function ModuleInfoVo(_arg1:XML){
            this._id = _arg1.@id;
            this._url = _arg1.@url;
            this.type = _arg1.@type;
            this._layout = _arg1.@layout;
            this._offsetX = int(_arg1.@offsetX);
            this._offsetY = int(_arg1.@offsetY);
            this._onlyone = (_arg1.@onlyone == "true");
            this._destroy = (_arg1.@destroy == "true");
            this._showBottom = (_arg1.@showBottom == "true");
            this._showEffect = !((_arg1.@playShowEffect == "false"));
            this._playOpenCloseSound = (_arg1.@playOpenCloseSound == "true");
        }

        public function get showBottom():Boolean{
            return (this._showBottom);
        }

        public function playShowHideEffect():Boolean{
            return (((this._showEffect) && (!((this.type == 0)))));
        }

        public function get id():int{
            return (this._id);
        }

        public function get url():String{
            return (this._url);
        }

        public function get layout():uint{
            return (this._layout);
        }

        public function get destroy():Boolean{
            return (this._destroy);
        }

        public function get onlyone():Boolean{
            return (this._onlyone);
        }

        public function get offsetX():int{
            return (this._offsetX);
        }

        public function get offsetY():int{
            return (this._offsetY);
        }


    }
}//package game.managers.vo





//flare.materials.Material3D

package baseEngine.materials
{
    import flash.display3D.Context3DBlendFactor;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    
    import baseEngine.basic.Scene3D;
    import baseEngine.core.Pivot3D;
    import baseEngine.core.Surface3D;
    import baseEngine.system.Device3D;

    public class Material3D extends EventDispatcher 
    {

        public static const BLEND_NONE:int = 0;
        public static const BLEND_ADDITIVE:int = 1;
       
		
        public static const BLEND_COLOR:int = 2;
        public static const BLEND_SCREEN:int = 3;
		
		public static const BLEND_ALPHA0:int = 4;
		public static const BLEND_ALPHA1:int = 5;
		public static const BLEND_ALPHA2:int = 6;
		public static const BLEND_LIGHT:int = 7;
		public static const BLEND_OVERLAYER:int=8;
		public static const BLEND_FOG:int=9;
		public static const BLEND_CUSTOM:int=10;
        private var _name:String;
		protected var _scene:Scene3D;
		public static const factorList:Array=[Context3DBlendFactor.ONE,//0
												Context3DBlendFactor.ZERO,//1
												Context3DBlendFactor.SOURCE_COLOR,//2
												Context3DBlendFactor.SOURCE_ALPHA,//3
												Context3DBlendFactor.DESTINATION_COLOR,//4
												Context3DBlendFactor.DESTINATION_ALPHA,//5
												Context3DBlendFactor.ONE_MINUS_SOURCE_COLOR,//6
												Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA,//7
												Context3DBlendFactor.ONE_MINUS_DESTINATION_COLOR,//8
												Context3DBlendFactor.ONE_MINUS_DESTINATION_ALPHA];//9
        public function Material3D(_arg1:String="")
        {
            
            super();
            this.name = _arg1;
        }
		
		public function get name():String
		{
			return _name;
		}
		public function set name(value:String):void
		{
			if(value==null || value.length==0)
			{
				trace("please Name Material");
			}
			_name=value;
		}
        public function dispose():void
        {
        }
        public function download():void
        {
            scene=null;
        }
        public function upload(_arg1:Scene3D):void
        {
            if (!_arg1)
            {
                throw (new Error("Parameter scene can not be null."));
            };
            if (this.scene)
            {
                return;
            };
            this.scene = _arg1;
            if (_arg1.context)
            {
                this.context3DEvent();
            };
        }
        protected function context3DEvent(_arg1:Event=null):void
        {
        }
        public function get scene():Scene3D
        {
            return (this._scene);
        }
		public function set scene(value:Scene3D):void
		{
			if(_scene)
			{
				_scene.removeEventListener(Event.CONTEXT3D_CREATE, context3DEvent);
				_scene.materials.splice(_scene.materials.indexOf(this), 1);
			}
			_scene=value;
			if(_scene)
			{
				_scene.addEventListener(Event.CONTEXT3D_CREATE, context3DEvent);
				_scene.materials.push(this);
				
			}
			
		}
        public function validate(_arg1:Surface3D):Boolean
        {
            return (true);
        }
        public function clone():Material3D
        {
            var _local1:Material3D = new Material3D(this.name);
            _local1.name = this.name;
           // _local1.transparent = this.transparent;
            
            return (_local1);
        }
        public function draw(_arg1:Pivot3D, _arg2:Surface3D,depthCompare:String ,cullFace:String,depthWrite:Boolean,sourceFactor:String,destFactor:String, _arg3:int=0, _arg4:int=-1):void
        {
            if (!this._scene)
            {
                this.upload(_arg1.scene);
            };
            if (!_arg2.scene)
            {
                _arg2.upload(this._scene);
            };
            Device3D.drawCalls3d++;
            Device3D.trianglesDrawn = (Device3D.trianglesDrawn + _arg4);
        }
		/*
        public function get transparent():Boolean
        {
            return ((((this.sourceFactor == Context3DBlendFactor.SOURCE_ALPHA)) && ((this.destFactor == Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA))));
        }
        public function set transparent(_arg1:Boolean):void
        {
            if (_arg1)
            {
                this.sourceFactor = Context3DBlendFactor.SOURCE_ALPHA;
                this.destFactor = Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA;
            }
            else
            {
                this.sourceFactor = Context3DBlendFactor.ONE;
                this.destFactor = Context3DBlendFactor.ZERO;
            };
        }*/
        
        override public function toString():String
        {
            return ((("[object Material3D name:" + this.name) + "]"));
        }

    }
}//package flare.materials


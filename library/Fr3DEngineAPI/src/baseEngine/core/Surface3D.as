


//flare.core.Surface3D

package baseEngine.core
{
    import flash.display3D.IndexBuffer3D;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.utils.Dictionary;
    
    import baseEngine.basic.Scene3D;
    
    import frEngine.loaders.resource.Resource3dManager;

    public class Surface3D extends EventDispatcher 
    {

        public var bounds:Boundings3D;
        public var indexBuffer:IndexBuffer3D;
        public var numTriangles:int = -1;
        public var firstIndex:int = 0;
        public var sizePerVertex:int = 0;
        /*public var offset:Array
        public var format:Array;*/
		public var bufferVoMap:Dictionary=new Dictionary(false);
        public var name:String;
        protected var _scene:Scene3D;

        private var _polys:Vector.<Poly3D>;
        public var visible:Boolean = true;
		
        public function Surface3D(_arg1:String)
        {
			this.name = _arg1;
			clear();
			super();
        }
		public function clear():void
		{
			/*this.offset = new Array(16);
			this.format = new Array(16);*/
			
			var _local2:int;
			/*while (_local2 < this.offset.length)
			{
				this.offset[_local2] = -1;
				this.format[_local2] = null;
				_local2++;
			}*/
			this.bounds = null;
		}
		public function get scene():Scene3D
		{
			return _scene;
		}


        public function dispose():void
        {
			Resource3dManager.instance.unLoad(this.name);
        }
		public function disposeImp():void
		{
			this.download();
			this.bounds = null;
		}
        public function download():void
        {
           
            if (this.indexBuffer)
            {
                this.indexBuffer.dispose();
            };

			this._scene = null;
            this.indexBuffer = null;
            dispatchEvent(new Event("download"));
        }
		public function get hasUpload():Boolean
		{
			return this.scene!=null;
		}
        public function upload(_arg1:Scene3D):void
        {
           
            if (this._scene)
            {
                return;
            };
            this._scene = _arg1;
            if (this._scene.context)
            {
                var sucess:Boolean=this.contextEvent();
				if(!sucess)
				{
					this._scene=null;
				}
            }
        }
        protected function contextEvent(_arg1:Event=null):Boolean
        {
            throw new Error("请覆盖contextEvent方法，from Surface3D.as");
			return false;
        }
        override public function toString():String
        {
            return ((((("[object Surface3D name:" + this.name) + " triangles:") + this.numTriangles) + "]"));
        }
        public function clone():Surface3D
        {
            var _local1:Surface3D = new Surface3D(this.name);
            
            _local1.numTriangles = this.numTriangles;
            _local1.firstIndex = this.firstIndex;
			//_local1.material =this.material; 

            return (_local1);
        }
        public function updateBoundings():Boundings3D
        {
            return null;
        }
       
       
        
    
   
        public function get polys():Vector.<Poly3D>
        {
            return (this._polys);
        }
        public function set polys(_arg1:Vector.<Poly3D>):void
        {
           
               this._polys = _arg1;
            
        }
    }
}//package flare.core


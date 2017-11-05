// Decompiled by AS3 Sorcerer 1.56
// http://www.as3sorcerer.com/

//se7en.world.shot.Brick

package word.objects{
	import de.nulldesign.nd2d.display.Sprite2D;
	import de.nulldesign.nd2d.materials.texture.Texture2D;
	
	import word.interfaces.IDestroy;
	import word.loader.HashLoader;

    public class Brick extends Sprite2D implements IDestroy {

        public static const WAIT:int = 0;
        public static const LOADING:int = 1;
        public static const COMPLETE:int = 2;
        public static const ERROR:int = 3;

        public var status:int = 0;
        public var posx:int;
		public var posy:int;
        public var cellTexture:Texture2D;
        public var errCount:int = 0;
        public var name:String;
        public var loader:HashLoader;
        public var debugVisible:Boolean = false;
		public var pos:int;
        public function Brick(px:int,py:int,$pos:int, _arg2:String){
            super();
            this.posx = px;
			this.posy = py;
			this.pos=$pos;
            this.name = _arg2;
            this.loader = new HashLoader();
        }
		
        public function destroy():void{
            this.status = WAIT;
            this.errCount = 0;
            try
            {
                this.loader.unload();
                this.loader.close();
            } catch(e:Error)
            {
            };
            this.loader = null;
            if (this.cellTexture != null)
            {
                this.cellTexture.dispose();
            };
            super.dispose();
        }

        override public function setTexture(_arg1:Texture2D):void{
            this.cellTexture = _arg1;
            super.setTexture(_arg1);
        }


    }
}//package se7en.world.shot


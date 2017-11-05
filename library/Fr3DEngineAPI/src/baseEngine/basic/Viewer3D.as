


//flare.basic.Viewer3D

package baseEngine.basic
{
    import flash.display.DisplayObjectContainer;
    import flash.events.Event;
    import flash.events.EventPhase;
    import flash.geom.Vector3D;
    
    import baseEngine.system.Input3D;
    import baseEngine.utils.Vector3DUtils;
    
    import frEngine.Engine3dEventName;

    public class Viewer3D extends Scene3D 
    {

        private var _out:Vector3D;
        private var _drag:Boolean;
        private var _spinX:Number = 0;
        private var _spinY:Number = 0;
        private var _spinZ:Number = 0;
        public var smooth:Number;
        public var speedFactor:Number;
		public var checkEventPhase:Boolean=true;
        public function Viewer3D(container:DisplayObjectContainer,  smooth:Number=1, speedFactor:Number=0.5)
        {
            this._out = new Vector3D();
            super(container);
            if (smooth > 1)
            {
                throw (new Error("Smooth value should be between 0 and 1."));
            };
            this.smooth = smooth;
            this.speedFactor = speedFactor;
            addEventListener(Engine3dEventName.PIVOT3D_UPDATE, this.updateEvent, false, 0, true);
        }
        protected function updateEvent(e:Event):void
        {
			if(!this.mouseEnabled)
			{
				return;
			}
            if (checkEventPhase && Input3D.eventPhase > EventPhase.AT_TARGET)
            {
                return;
            }
            if (Input3D.middleMouseUp)
            {
                this._drag = false;
            }
            if (this._drag)
            {
                if (Input3D.keyDown(Input3D.ALTERNATE) || Input3D.keyDown(Input3D.SPACE))
                {
                    
					this._spinX = (this._spinX + ((Input3D.mouseXSpeed * this.smooth) * this.speedFactor));
					this._spinY = (this._spinY + ((Input3D.mouseYSpeed * this.smooth) * this.speedFactor));
                }else
				{
					var len:Number=camera.getPosition().length/100;
					len=Math.pow(len,1.3)/50;
					camera.translateX(-Input3D.mouseXSpeed * len);
                    camera.translateY(Input3D.mouseYSpeed * len);
				}
            }
			
			if (Input3D.delta != 0 && viewPort.contains(Input3D.mouseX, Input3D.mouseY))// && this._selectIsEmpty
			{
				this._spinZ = ((((camera.getPosition(false, this._out).length + 0.1) * this.speedFactor) * Input3D.delta) / 20);
			}
			
			this._spinZ!=0 && camera.translateZ(this._spinZ);

			this._spinX!=0 && camera.rotateY(this._spinX, false, Vector3DUtils.ZERO);
			this._spinY!=0 && camera.rotateX(this._spinY, true, Vector3DUtils.ZERO);
			
            this._spinX = (this._spinX * (1 - this.smooth));
            this._spinY = (this._spinY * (1 - this.smooth));
            this._spinZ = (this._spinZ * (1 - this.smooth));
            if (((Input3D.middleMouseHit) && (viewPort.contains(Input3D.mouseX, Input3D.mouseY))))
            {
                this._drag = true;
            }
        }
		public function set spinZ(value:Number):void
		{
			this._spinZ=value;
		}

    }
}//package flare.basic


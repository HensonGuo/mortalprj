package frEngine.core
{
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.InterpolationMethod;
	import flash.display.Shape;
	import flash.display.SpreadMethod;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Vector3D;
	
	import baseEngine.core.Pivot3D;
	import baseEngine.system.Device3D;
	import baseEngine.utils.Matrix3DUtils;
	
	public class FrLight3D extends Pivot3D 
	{
		
		private static const _position:Vector3D = new Vector3D();
		public static const DIRECTIONAL:int = 0;
		public static const POINT:int = 1;
		public var ambientColor:Vector.<Number>
		public var type:int;
		public var color:Vector.<Number>;
		public var radius:Number = 0;
		public var attenuation:Number = 100;
		public var infinite:Boolean = true;
		public var multipler:Number = 1;
		public var sample:BitmapData;
		
		public function FrLight3D(name:String="", type:int=1)
		{
			this.sample = new BitmapData(100, 100, false, 0);
			this.ambientColor = Vector.<Number>([0.6,0.6,0.6,0]);
			this.color = Vector.<Number>([1,1,1,0]);
			this.type = type;
			this.setParams(0xFFFFFF, 100, 1, 1, true);
			super(name);
		}
		override public function dispose(isReuse:Boolean=true):void
		{
			super.dispose(isReuse);
			this.sample.dispose();
			this.sample = null;
		}
		override public function clone():Pivot3D
		{
			var c:Pivot3D;
			var l:FrLight3D = new FrLight3D(name, this.type);
			l.setParams(((((this.color[0] * 0xFF) << 16) ^ ((this.color[1] * 0xFF) << 8)) ^ (this.color[2] * 0xFF)), this.radius, this.attenuation, this.multipler, this.infinite);
			transform.copyToMatrix3D(l.transform);
			l.visible = visible;
			l.layer = layer;
			for each (c in children)
			{
				l.addChild(c.clone());
			};
			return (l);
		}
		override public function get inView():Boolean
		{
			if (!(visible))
			{
				return (false);
			};
			if (this.infinite)
			{
				return (true);
			};
			world.copyColumnTo(3, _position);
			Matrix3DUtils.transformVector(Device3D.view, _position, _position);
			priority = ((((this.infinite) || ((this.type == DIRECTIONAL)))) ? -10000000 : ((_position.z / Device3D.camera.far) * 100000));
			var zoom:Number = ((1 / Device3D.camera.zoom) / _position.z);
			var ratio:Number = (Device3D.scene.viewPort.width / Device3D.scene.viewPort.height);
			if (_position.length > this.radius)
			{
				if (((_position.x + this.radius) * zoom) < -0.5)
				{
					return (false);
				};
				if (((_position.x - this.radius) * zoom) > 0.5)
				{
					return (false);
				};
				if ((((_position.y + this.radius) * zoom) * ratio) < -0.5)
				{
					return (false);
				};
				if ((((_position.y - this.radius) * zoom) * ratio) > 0.5)
				{
					return (false);
				};
				if ((_position.z - this.radius) > Device3D.camera.far)
				{
					return (false);
				};
				if ((_position.z + this.radius) < Device3D.camera.near)
				{
					return (false);
				};
			};
			return (true);
		}
		/*override public function draw(includeChildren:Boolean=true, material:Material3D=null):void
		{
			var child:Pivot3D;
			if ((_eventFlags & ENTER_DRAW_FLAG))
			{
				dispatchEvent(_enterDrawEvent);
			};
			if (includeChildren)
			{
				for each (child in children)
				{
					child.draw(true, material);
				};
			};
			if ((_eventFlags & EXIT_DRAW_FLAG))
			{
				dispatchEvent(_exitDrawEvent);
			};
		}*/
		public function setParams(color:int=0xFFFFFF, radius:Number=0, attenuation:Number=1, multipler:Number=1, infinite:Boolean=false):void
		{
			if (this.type == DIRECTIONAL)
			{
				infinite = true;
			};
			this.radius = radius;
			this.attenuation = attenuation;
			var colorSclae:Number=1 / 0xFF
			this.color[0] = ((color & 0xFF0000) >> 16)*colorSclae ;
			this.color[1] = ((color & 0xFF00) >> 8)*colorSclae;
			this.color[2] = (color & 0xFF)*colorSclae;

			this.infinite = infinite;
			this.multipler = multipler;
			var colors:Array = [color, color, color, 0];
			var ratios:Array = [];
			var r:Number = (radius * radius);
			ratios.push(0, 0);
			if (infinite)
			{
				ratios.push(0xFF, 0xFF);
			}
			else
			{
				ratios.push(((((((1 - attenuation) * (1 - attenuation)) * radius) * radius) / r) * 253));
				ratios.push((((radius * radius) / r) * 253));
				if (ratios[2] >= ratios[3])
				{
					ratios[2] = (ratios[3] - 1);
				};
			};
			this.setColors(this.sample, colors, null, ratios);
			var m:Number = (multipler / 5);
			this.sample.colorTransform(this.sample.rect, new ColorTransform(m, m, m));
		}
		private function setColors(bmp:BitmapData, colors:Array, alphas:Array=null, ratios:Array=null):void
		{
			var shape:Shape = new Shape();
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(bmp.width, bmp.height);
			shape.graphics.beginGradientFill(GradientType.LINEAR, colors, alphas, ratios, matrix, SpreadMethod.PAD, InterpolationMethod.RGB);
			shape.graphics.drawRect(0, 0, bmp.width, bmp.height);
			bmp.draw(shape);
		}
		
	}
}


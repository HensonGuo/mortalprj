package frEngine.primitives
{

	import flash.geom.Vector3D;
	
	import baseEngine.basic.RenderList;
	import baseEngine.core.Boundings3D;
	import baseEngine.core.Mesh3D;
	import baseEngine.core.Texture3D;
	import baseEngine.materials.Material3D;
	import baseEngine.modifiers.Modifier;
	
	import frEngine.animateControler.cylinderControler.CylinderDownRadiusControler;
	import frEngine.animateControler.cylinderControler.CylinderHControler;
	import frEngine.animateControler.cylinderControler.CylinderUpRadiusControler;
	import frEngine.animateControler.keyframe.AnimateControlerType;
	import frEngine.core.FrSurface3D;
	import frEngine.render.CylinderRender;
	import frEngine.render.layer.Layer3DManager;
	import frEngine.shader.ShaderBase;
	import frEngine.shader.filters.FilterName_ID;
	import frEngine.shader.filters.fragmentFilters.ColorFilter;
	import frEngine.shader.filters.vertexFilters.CylinderAnimaterVertexFilter;

	public class FrAnimCylinder extends Mesh3D
	{
		private var _topR:Number;
		private var _bottomR:Number;
		private var _segments:int;
		private var _h:Number;

		public function FrAnimCylinder(_arg1:String ,$renderList:RenderList, $topR:Number = 10 , $bottomR:Number = 10 , $h:Number = 10 , $segments:int = 4 , $material:Material3D = null ,$isSphereTexture:Boolean=false)
		{

			super(_arg1 , true , $renderList);

			var _surface:FrSurface3D
			if (!$material)
			{
				$material = new ShaderBase("FrAnimCylinder"  , null , new ColorFilter(0.3 , 0.3 , 0.3 , 1),this.materialPrams);
			}
			this.setMateiralBlendMode(Material3D.BLEND_LIGHT);
			this.materialPrams.depthWrite = false;
			this.materialPrams.twoSided = true;
			this.setLayer(Layer3DManager.AlphaLayer0);

			this._segments = $segments;
			this._topR = $topR;
			this._bottomR = $bottomR;
			this._h = $h;
			_surface = new FrSurface3D("cylinder");
			this.setSurface(0 , _surface);
			_surface.addVertexData(FilterName_ID.POSITION_ID , 4 , false , null);//postion
			_surface.addVertexData(FilterName_ID.UV_ID , 2 , false , null);
			_surface.getVertexBufferByNameId(FilterName_ID.POSITION_ID).vertexVector = getVertexVector($isSphereTexture);
			_surface.indexVector = getIndexVector();

			this.bounds = new Boundings3D();
			var r1:Number = Math.max(_topR , _bottomR);
			var angle2:Number = Math.PI / this._segments;
			r1 = Math.cos(angle2) * r1
			this.bounds.min.setTo(-r1 , 0 , -r1);
			this.bounds.max.setTo(r1 , _h , r1);
			this.bounds.length.x = (this.bounds.max.x - this.bounds.min.x);
			this.bounds.length.y = _h;
			this.bounds.length.z = (this.bounds.max.z - this.bounds.min.z);
			this.bounds.center.x = ((this.bounds.length.x * 0.5) + this.bounds.min.x);
			this.bounds.center.y = ((this.bounds.length.y * 0.5) + this.bounds.min.y);
			this.bounds.center.z = ((this.bounds.length.z * 0.5) + this.bounds.min.z);
			this.bounds.radius = Vector3D.distance(this.bounds.center , this.bounds.max);

			setMaterial($material,Texture3D.MIP_NONE,$material.name);

			this.render = CylinderRender.instance;
		}

		public override function getAnimateControlerInstance(animateControlerType:int , instane:Modifier = null):Modifier
		{
			var modifier:Modifier = super.getAnimateControlerInstance(animateControlerType , instane);
			if (modifier == null)
			{
				switch (animateControlerType)
				{
					case AnimateControlerType.CylinderUpRadiusControler:
						modifier = instane ? instane : new CylinderUpRadiusControler();
						break;
					case AnimateControlerType.CylinderDownRadiusControler:
						modifier = instane ? instane : new CylinderDownRadiusControler();
						break;
					case AnimateControlerType.CylinderHControler:
						modifier = instane ? instane : new CylinderHControler();
						break;
				}
				if (modifier)
				{
					_animateControlerList[animateControlerType] = modifier;
					modifier.targetObject3d = this;
				}
			}
			return modifier;
		}

		protected override function setShaderBase(materaial:ShaderBase):void
		{
			if (materaial)
			{
				materaial.setVertexFilter(new CylinderAnimaterVertexFilter(_topR , _bottomR , _h));
			}
			super.setShaderBase(materaial);
		}

		private function getVertexVector($isSphereTexture:Boolean):Vector.<Number>
		{
			var vector:Vector.<Number> = new Vector.<Number>();
			var disAngle:Number = Math.PI * 2 / this._segments;
			var disU:Number = 1 / this._segments;
			var i:int,angle:Number;
			if($isSphereTexture)
			{
				for (i = 0 ; i <= this._segments ; i++)
				{
					angle = disAngle * i;
					var cos:Number=Math.cos(angle)*0.5+0.5;
					var sin:Number=Math.sin(angle)*0.5+0.5;
					vector.push(1 , 1 , 0 , angle , cos , sin);
					
					cos=Math.cos(angle)*0.01+0.5;
					sin=Math.sin(angle)*0.01+0.5;
					vector.push(0 , 0 , 1 , angle , cos , sin);
				}
			}else
			{
				for (i = 0 ; i <= this._segments ; i++)
				{
					angle = disAngle * i;
					var u:Number = disU * i;
					vector.push(1 , 1 , 0 , angle , u , 0);
					vector.push(0 , 0 , 1 , angle , u , 1);
				}
			}
			

			return vector;
		}

		private function getIndexVector():Vector.<uint>
		{
			var vector:Vector.<uint> = new Vector.<uint>();
			for (var i:int = 0 ; i < _segments ; i++)
			{
				var n:int = i * 2;
				vector.push(n , n + 3 , n + 1);
				vector.push(n + 3 , n , n + 2);

			}
			return vector;
		}

		public function get segments():int
		{
			return (this._segments);
		}

		public function get topR():Number
		{
			return (this._topR);
		}

		public function get bottomR():Number
		{
			return this._bottomR;
		}

		public function get height():Number
		{
			return this._h;
		}

	}
}

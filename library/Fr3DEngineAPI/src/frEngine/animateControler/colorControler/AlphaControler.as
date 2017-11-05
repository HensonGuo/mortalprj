package frEngine.animateControler.colorControler
{
	import flash.events.Event;
	
	import baseEngine.core.Mesh3D;
	import baseEngine.core.Pivot3D;
	
	import frEngine.Engine3dEventName;
	import frEngine.animateControler.MeshAnimateBase;
	import frEngine.animateControler.keyframe.AnimateControlerType;
	import frEngine.shader.MaterialParams;

	public class AlphaControler extends MeshAnimateBase
	{
		private var _targetMaterialPrams:MaterialParams;
		public function AlphaControler()
		{
			super();
		}
		public override function get type():int
		{
			return AnimateControlerType.alphaAnimateControler;
		}
		protected override function setMaterialHander(e:Event):void
		{
			_targetMaterialPrams.alphaAnimUse=true;
			super.setMaterialHander(e);
		}
		public override function  dispose():void
		{
			_targetMaterialPrams.alphaAnimUse=false;
			super.dispose();
		}
		protected override function setTargetProperty(value:*):void
		{
			_targetMaterialPrams.colorOffset[3]=Number(value);
		}

		protected override function getBaseValue(obj:Pivot3D):Object
		{
			return Mesh3D(obj).materialPrams.alphaBase
		}

		public override function set targetObject3d(value:Pivot3D):void
		{
			
			if(value)
			{
				_targetMaterialPrams=Mesh3D(value).materialPrams;
				_targetMaterialPrams.addEventListener(Engine3dEventName.ALPHA_CHANGE,alphaChangeHander);
			}
			super.targetObject3d=value;
			
			if(!value)
			{
				_targetMaterialPrams.removeEventListener(Engine3dEventName.ALPHA_CHANGE,alphaChangeHander);
				_targetMaterialPrams=null;
			}
		}
		private function alphaChangeHander(e:Event):void
		{
			changeBaseValue(null,_targetMaterialPrams.alphaBase);
			this.toUpdateAnimate(true);
		}
	}
}
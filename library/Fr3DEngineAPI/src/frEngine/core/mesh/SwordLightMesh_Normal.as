package frEngine.core.mesh
{
	import baseEngine.basic.RenderList;
	import baseEngine.core.Boundings3D;
	import baseEngine.core.Mesh3D;
	import baseEngine.materials.Material3D;
	import baseEngine.modifiers.Modifier;
	
	import frEngine.animateControler.keyframe.AnimateControlerType;
	import frEngine.animateControler.skilEffect.SwordLightControler_Normal;
	import frEngine.render.IRender;
	import frEngine.render.layer.Layer3DManager;

	public class SwordLightMesh_Normal extends Mesh3D
	{
		public function SwordLightMesh_Normal($name:String,$renderList:RenderList)
		{
			super($name,false,$renderList);
			this.setMateiralBlendMode(Material3D.BLEND_LIGHT);
			this.materialPrams.depthWrite=false;
			this.materialPrams.twoSided=true;
			setLayer(Layer3DManager.swordLayer,false);
		}

		public override function get bounds():Boundings3D
		{
			return null;
		}

		public override function getAnimateControlerInstance(animateControlerType:int,instane:Modifier=null):Modifier
		{
			var  modifier:Modifier=super.getAnimateControlerInstance(animateControlerType,instane);
			if(modifier==null)
			{ 
				switch(animateControlerType)
				{ 
					case AnimateControlerType.swordLight_Normal:		modifier=instane ? instane : new SwordLightControler_Normal();			break;
				}
				if(modifier)
				{
					_animateControlerList[animateControlerType]=modifier;
					modifier.targetObject3d=this;
					if(modifier is IRender)
					{
						this.render=IRender(modifier);
					}
				}
				
			}
			
			return modifier;
		}
	}
}
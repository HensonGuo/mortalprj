package frEngine.core.mesh
{
	import flash.events.Event;
	import flash.geom.Matrix3D;
	
	import baseEngine.basic.RenderList;
	import baseEngine.core.Boundings3D;
	import baseEngine.core.Mesh3D;
	import baseEngine.materials.Material3D;
	import baseEngine.modifiers.Modifier;
	
	import frEngine.Engine3dEventName;
	import frEngine.animateControler.Md5SkinAnimateControler;
	import frEngine.animateControler.keyframe.AnimateControlerType;
	import frEngine.animateControler.skilEffect.SwordLightControler_Bone;
	import frEngine.core.SwordLightSurface;
	import frEngine.render.IRender;
	import frEngine.render.layer.Layer3DManager;
	import frEngine.shader.ShaderBase;

	public class SwordLightMesh_Bone extends Mesh3D
	{
		public var toUpdate:Boolean=false;
		public function SwordLightMesh_Bone($name:String,$renderList:RenderList)
		{
			super($name,false,$renderList);
			this.setMateiralBlendMode(Material3D.BLEND_LIGHT);
			this.materialPrams.depthWrite=false;
			this.materialPrams.twoSided=true;
			setLayer(Layer3DManager.swordLayer,false);
		}
		public override function set offsetTransform(value:Matrix3D):void
		{
			//super.offsetTransform=value;
			toUpdate=true;
			
		}
		public override function get bounds():Boundings3D
		{
			return null;
		}
		public override function updateChildrenTransform():void
		{
			super.updateChildrenTransform();
			toUpdate=true;
		}
		
		public override function set curHangControler(value:Md5SkinAnimateControler):void
		{
			if(this.curHangControler)
			{
				this.curHangControler.removeEventListener(Engine3dEventName.InitComplete,reInitPlaySwordLight);
			}
			super.curHangControler=value;
			if(value)
			{
				if(curHangControler.skeletoAnimator==null)
				{
					curHangControler.addEventListener(Engine3dEventName.InitComplete,reInitPlaySwordLight);
				}else
				{
					reInitPlaySwordLight();
				}
			}
			
			
			
		}
		public function reInitPlaySwordLight(e:Event=null):void
		{
			var  _controler:SwordLightControler_Bone=getAnimateControlerInstance(AnimateControlerType.swordLight_Bone) as SwordLightControler_Bone
			if(curHangControler==null ||curHangControler.skeletoAnimator==null || _controler.length1==0)
			{
				return;
			}
			curHangControler.removeEventListener(Engine3dEventName.InitComplete,reInitPlaySwordLight);
			var boneName:String=curHangControler.getMeshHangBoneName(this);
			var surface:SwordLightSurface=curHangControler.skeletoAnimator.getSwordLightSurface(boneName,_controler.length1,_controler.offsetY,_controler.splitNum);
			this.clearSurface();
			if(surface)
			{
				this.addSurface(surface);
			}
			
			
		}
		public override function draw(_drawChildren:Boolean=true, _material:ShaderBase=null):void
		{
			super.draw(_drawChildren,_material);
		}
		public override function getAnimateControlerInstance(animateControlerType:int,instane:Modifier=null):Modifier
		{
			var  modifier:Modifier=super.getAnimateControlerInstance(animateControlerType,instane);
			if(modifier==null)
			{ 
				switch(animateControlerType)
				{ 
					case AnimateControlerType.swordLight_Bone:		modifier=instane ? instane : new SwordLightControler_Bone();			break;
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
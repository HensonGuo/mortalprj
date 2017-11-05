/**
 * 2014-4-18
 * @author chenriji
 **/
package mortal.game.view.common.tooltip.tooltips
{
	import Message.DB.Tables.TModel;
	import Message.DB.Tables.TPetConfig;
	
	import com.gengine.utils.pools.ObjectPool;
	
	import flash.geom.Vector3D;
	
	import frEngine.Engine3dEventName;
	
	import mortal.game.resource.tableConfig.ModelConfig;
	import mortal.game.resource.tableConfig.PetConfig;
	import mortal.game.scene3D.model.data.ActionName;
	import mortal.game.scene3D.model.player.ActionPlayer;

	public class ToolTipPetEgg extends ToolTipBaseItem3D
	{
		private var _petInfo:TPetConfig;
		public function ToolTipPetEgg()
		{
			super();
		}
		
		public override function set data(value:*):void
		{
			super.data = value;
			var petCode:int = _data.itemInfo.effect;
			_petInfo = PetConfig.instance.getInfoByCode(petCode);
			if(_petInfo != null)
			{
				add3DModel();
			}
		}
		
		protected override function set3dModel():void
		{
			var model:TModel = ModelConfig.instance.getInfoByCode(_petInfo.model);
			var meshUrl:String=model.mesh1 + ".md5mesh";
			var boneUrl:String=model.bone1 + ".skeleton";
			if(_3dObj)
			{
				_rect3D.removeObj3d(_3dObj);
			}
			_3dObj = ObjectPool.getObject(ActionPlayer);
			var mount:ActionPlayer = _3dObj as ActionPlayer;
			mount.addEventListener(Engine3dEventName.PARSEFINISH, modleLoadedHandler);
			mount.changeAction(ActionName.MountStand);
			mount.hangBoneName = "guazai001";
			mount.selectEnabled = true;
			mount.play();
			mount.setRotation(0, 0, 0);
			mount.scaleX = mount.scaleY = mount.scaleZ = 1;
			mount.load(meshUrl, boneUrl, model.texture1, _rect3D.renderList);
			mount.rotationY = 50;
		}
		
		protected override function modleLoadedHandler(evt:*=null):void
		{
			(_3dObj as ActionPlayer).addEventListener(Engine3dEventName.PARSEFINISH, modleLoadedHandler);
			var len:Vector3D = (_3dObj as ActionPlayer).bounds.length;
			var scale:Number = 1.0;
			if(len.y > _3dRectHeight - 30)
			{
				scale = (_3dRectHeight - 30)/len.y;
			}
			_3dObj.scaleX = _3dObj.scaleY = _3dObj.scaleZ = scale;
			
			var ry:int = 50;
			if(len.x * scale> _3dRectWidth * Math.cos(ry/180*Math.PI) * 0.9)
			{
				ry = Math.acos(_3dRectWidth*0.9/len.x * scale) * 180 / Math.PI;
			}
			if(ry != 50)
			{
				(_3dObj as ActionPlayer).rotationY = ry;
			}
		}
	}
}
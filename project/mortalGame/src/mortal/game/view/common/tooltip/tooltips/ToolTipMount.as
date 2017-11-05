/**
 * 2014-4-18
 * @author chenriji
 **/
package mortal.game.view.common.tooltip.tooltips
{
	import Message.DB.Tables.TModel;
	
	import com.gengine.utils.pools.ObjectPool;
	import com.mui.controls.GTextFiled;
	import com.mui.display.ScaleBitmap;
	
	import extend.language.Language;
	
	import flash.geom.Vector3D;
	
	import frEngine.Engine3dEventName;
	
	import mortal.common.global.GlobalStyle;
	import mortal.common.text.AutoLayoutTextContainer;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.info.item.AttributeData;
	import mortal.game.resource.info.item.ItemData;
	import mortal.game.resource.info.item.ItemMountInfo;
	import mortal.game.resource.tableConfig.ModelConfig;
	import mortal.game.scene3D.model.data.ActionName;
	import mortal.game.scene3D.model.player.ActionPlayer;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.util.AttributeUtil;

	public class ToolTipMount extends ToolTipBaseItem3D
	{
		private var _txtAddPlayerSpeed:GTextFiled;
		private var _txtSelfSpeed:GTextFiled;
		private var _attrLeft:AutoLayoutTextContainer;
		private var _attrRgiht:AutoLayoutTextContainer;
		private var _line:ScaleBitmap;
		private var _info:ItemMountInfo;
		
		public function ToolTipMount()
		{
			super();
		}
		
		protected override function createChildren():void
		{
			super.createChildren();
			
			// 移动属性
			var txt:GTextFiled;
			txt = UIFactory.gTextField(Language.getString(20250), 0, 290 + 85, 120, 20, contentContainer2D);
			txt.textColor = GlobalStyle.colorChenUint;
			_txtAddPlayerSpeed = UIFactory.gTextField("", 0, 310 + 85, 160, 20, contentContainer2D);
			_txtSelfSpeed = UIFactory.gTextField("", 134, 310 + 85, 160, 20, contentContainer2D);
			UIFactory.bg(0, 333 + 85, 288, 2, contentContainer2D, ImagesConst.SplitLine);
			
			// 基础属性
			txt = UIFactory.gTextField(Language.getString(20253), 0, 338 + 85, 120, 20, contentContainer2D);
			txt.textColor = GlobalStyle.colorChenUint;
			_attrLeft = new AutoLayoutTextContainer();
			_attrLeft.verticalGap = -7;
			_attrLeft.y = 363 + 85;
			contentContainer2D.addChild(_attrLeft);
			
			_attrRgiht = new AutoLayoutTextContainer();
			_attrRgiht.verticalGap = -7;
			_attrRgiht.x = 134;
			_attrRgiht.y = 363 + 85;
			contentContainer2D.addChild(_attrRgiht);
			_line = UIFactory.bg(0, 464 + 85, 282, 2, contentContainer2D, ImagesConst.SplitLine);
		}
		
		public override function set data(value:*):void
		{
			super.data = value;
			_info = _data.itemInfo as ItemMountInfo;
			add3DModel();
			
			_txtAddPlayerSpeed.text = Language.getString(20251) + _info.addSpeed.toString();
			_txtSelfSpeed.text = Language.getString(20252) + _info.speed.toString();
			
			var attrs:Vector.<AttributeData> = AttributeUtil.getEquipmentBasicAttrs(_info);
			var left:int = Math.ceil(attrs.length/2);
			var right:int = attrs.length - left;
			_attrLeft.split(left);
			
			for(var i:int = 0; i < left; i++)
			{
				if(_attrLeft.getTextByIndex(i) == null)
				{
					_attrLeft.addNewText(220, "", 12, GlobalStyle.colorLanUint);
				}
				var attr:AttributeData = attrs[i];
				_attrLeft.setText(i, attr.name + "：" + attr.value, false);
			}
			_attrRgiht.split(right);
			for(i = 0; i < right; i++)
			{
				if(_attrRgiht.getTextByIndex(i) == null)
				{
					_attrRgiht.addNewText(220, "", 12, GlobalStyle.colorLanUint);
				}
				attr = attrs[i + right];
				_attrRgiht.setText(i, attr.name + "：" + attr.value, false);
			}
			
			updateLayout();
		}
		
		public function updateLayout():void
		{
			_line.y = _attrLeft.y + _attrLeft.height;
			_txtDesc.y = _line.y + 9;
			_txtTips.y = _txtDesc.y + _txtDesc.height;
			updateBg();
		}
		
		protected override function set3dModel():void
		{
			var model:TModel = ModelConfig.instance.getInfoByCode(_info.model);
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
/**
 * 2014-4-17
 * @author chenriji
 **/
package mortal.game.view.common.tooltip.tooltips
{
	import baseEngine.core.Pivot3D;
	
	import com.gengine.utils.pools.ObjectPool;
	import com.mui.controls.GTextFiled;
	import com.mui.display.ScaleBitmap;
	
	import extend.language.Language;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	
	import mortal.component.window.Window;
	import mortal.component.window.WindowEvent;
	import mortal.game.cache.Cache;
	import mortal.game.manager.window3d.IWindow3D;
	import mortal.game.manager.window3d.Rect3DManager;
	import mortal.game.manager.window3d.Rect3DObject;
	import mortal.game.resource.ImagesConst;
	import mortal.game.scene3D.object2d.Img2D;
	import mortal.game.scene3D.player.entity.RoleModelPlayer;
	import mortal.game.utils.ItemsUtil;
	import mortal.game.view.common.UIFactory;

	public class ToolTipBaseItem3D extends ToolTipBaseItem implements IWindow3D
	{
		protected var _txtBind:GTextFiled;
		protected var _line3D1:ScaleBitmap;
		protected var _3dBg:Bitmap;
		protected var _line3D2:ScaleBitmap;
		protected var _3dObj:Pivot3D;
		protected var _rect3D:Rect3DObject;
		protected var _img2d:Img2D;
		protected var _3dRectWidth:int = 200;
		protected var _3dRectHeight:int = 200;
		
		public function ToolTipBaseItem3D()
		{
			super();
			
		}
		
		protected override function createChildren():void
		{
			super.createChildren();
			_txtLv.y = 28;
			_txtBind = UIFactory.gTextField("", 80, 80, 120, 20, contentContainer2D);
			
//			_line3D1 = UIFactory.bg(0, 100, 293, 2, contentContainer2D, ImagesConst.SplitLine);
			_3dBg = UIFactory.bitmap(ImagesConst.ToolTip3DBg2, -5, 102);
			contentContainer2D.addChildAt(_3dBg, 0);
//			_line3D2 = UIFactory.bg(0, _3dBg.y + _3dBg.height, 293, 2, contentContainer2D, ImagesConst.SplitLine);
			
			_txtDesc.y = 284 + 85;
			
			this.addEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
			this.addEventListener(Event.REMOVED_FROM_STAGE, removeFromeStageHandler);
		}
		
		public function get contentContainer():Sprite
		{
			return this;
		}
		
		protected function addToStageHandler(evt:Event):void
		{
//			if(_3dObj != null)
//			{
//				_rect3D.removeObj3d(_3dObj);
//				_3dObj=null;
//			}
			this.dispatchEvent(new WindowEvent(WindowEvent.SHOW));
		}
		
		protected function removeFromeStageHandler(evt:Event):void
		{
			this.dispatchEvent(new WindowEvent(WindowEvent.CLOSE));
		}
		
		public function updatePosition():void
		{
			this.dispatchEvent(new WindowEvent(WindowEvent.POSITIONCHANGE));
		}
		
		protected var _contentTopOf3DSprite:Sprite = new Sprite();
		public function get contentTopOf3DSprite():Sprite
		{
			return _contentTopOf3DSprite;
		}
		
		public override function set data(value:*):void
		{
			super.data = value;
			// 天然绑定
			var bind1:Boolean = _data.itemInfo.bind == 1;
			var bind2:Boolean = ItemsUtil.isBind(_data);
			if(bind1) // 原本就绑定 "20205":"未绑定", "20206":"已绑定", 
			{
				_txtBind.textColor = 0xff0000;
				_txtBind.text = "[" + Language.getString(20206) + "]";
			}
			else if(bind2) // 装备后绑定
			{
				_txtBind.textColor = 0xff0000;
				_txtBind.text = "[" + Language.getString(20249) + "]";
			}
			else // 非绑定
			{
				_txtBind.textColor = 0x00ff00;
				_txtBind.text = "[" + Language.getString(20205) + "]";
			}
		}
		
		protected function add3DModel():void
		{
			
			_rect3D = Rect3DManager.instance.registerWindow(new Rectangle(_3dBg.x + paddingLeft + 38, _3dBg.y + paddingTop + 36, _3dRectWidth, _3dRectHeight), this,true);
			
			Rect3DManager.instance.windowShowHander(null, this);
			if (_3dBg.bitmapData)
			{
				_rect3D.removeImg(_img2d);
				_img2d=new Img2D(null,_3dBg.bitmapData,new Rectangle(38, 36, _3dRectWidth, _3dRectHeight));
				_rect3D.addImg(_img2d);
			}
			set3dModel();
			update3dModelToStage();
		}
		
		protected function update3dModelToStage():void
		{
			_rect3D.addObject3d(_3dObj, _3dRectWidth/2, _3dRectHeight - 20);
			this.dispatchEvent(new WindowEvent(WindowEvent.SHOW));
			updatePosition();
		}
		
		protected function set3dModel():void
		{
			_3dObj = ObjectPool.getObject(RoleModelPlayer);
			(_3dObj as RoleModelPlayer).entityInfo = Cache.instance.role.roleEntityInfo;
			(_3dObj as RoleModelPlayer).scaleAll = 1.4;
			(_3dObj as RoleModelPlayer).setRenderList(_rect3D.renderList);
		}
		
		protected function modleLoadedHandler(evt:*=null):void
		{
		}
	}
}
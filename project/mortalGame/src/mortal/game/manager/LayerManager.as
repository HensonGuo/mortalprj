package mortal.game.manager
{
	import com.gengine.global.Global;
	
	import flash.display.DisplayObject;
	
	import mortal.game.scene3D.layer3D.EntityTalkLayer;

	public class LayerManager 
	{
		
		public static var sceneLayer:UILayer;
		public static var uiLayer:MainUILayer;
		public static var entityTalkLayer:EntityTalkLayer;
		public static var smallIconLayer:SmallIconLayer;
		public static var windowLayer:WindowLayer;
		public static var windowLayer3D:WindowLayer;
		public static var topLayer:UILayer;
		public static var popupLayer:UILayer;
		
		public static var guideLayer:UILayer;//新手引导层
		public static var alertLayer:UILayer;
		public static var dragLayer:UILayer;
		public static var toolTipLayer:UILayer;
		public static var msgTipLayer:UILayer;//提示消息层;
		public static var flowersLayer:UILayer;//飘花层
		public static var highestLayer:UILayer;//最高层
		
		public function LayerManager()
		{
			
		}
		
		public static function init():void
		{
			sceneLayer = new UILayer();
			sceneLayer.tabChildren = false;
			Global.application.addChild(sceneLayer);
			
			uiLayer = new MainUILayer();
//			uiLayer.addEventListener(MouseEvent.CLICK,onClickHandler);
			uiLayer.tabChildren = false;
			uiLayer.mouseEnabled = false;
			Global.application.addChild(uiLayer);
//			MonsterDebugger.initialize(uiLayer);
			
			entityTalkLayer = new EntityTalkLayer();
			uiLayer.tabChildren = false;
			uiLayer.mouseEnabled = false;
			uiLayer.addChild(entityTalkLayer);
			
			smallIconLayer = new SmallIconLayer();
			smallIconLayer.tabChildren = false;
			smallIconLayer.mouseEnabled = false;
			Global.application.addChild(smallIconLayer);
			
			windowLayer = new WindowLayer();
			windowLayer.tabChildren = false;
			Global.application.addChild(windowLayer);
			
			windowLayer3D = new WindowLayer();
			windowLayer3D.tabChildren = false;
			Global.application.addChild(windowLayer3D);
			_topWindowLayer = windowLayer3D;
			
			topLayer = new UILayer();
			topLayer.tabChildren = false;
			Global.application.addChild(topLayer);
			
			popupLayer = new UILayer();
			popupLayer.tabChildren = false;
			Global.application.addChild(popupLayer);
			
			guideLayer = new UILayer();
			guideLayer.tabChildren = false;
			Global.application.addChild(guideLayer);
			
			alertLayer = new UILayer();
			alertLayer.tabChildren = false;
			Global.application.addChild(alertLayer);
			
			dragLayer = new UILayer();
			dragLayer.tabChildren = false;
			Global.application.addChild(dragLayer);
			
			CursorManager.init(Global.stage);
			MsgManager.addBroadStage(windowLayer);
			
			msgTipLayer = new UILayer();
			msgTipLayer.tabChildren = false;
			Global.application.addChild(msgTipLayer);
			
			toolTipLayer = new UILayer();
			toolTipLayer.tabChildren = false;
			Global.application.addChild(toolTipLayer);
			
			flowersLayer = new UILayer();
			Global.application.addChild(flowersLayer);
			
			highestLayer = new UILayer();
			Global.application.addChild(highestLayer);
			
		}
		
		private static var _topWindowLayer:WindowLayer;
		private static var _uiMask:DisplayObject;
		
		private static var _windowMask:DisplayObject;
		
		public static function get topWindowLayer():WindowLayer
		{
			return _topWindowLayer;
		}
		
		public static function setWindowLayerTop(layer:WindowLayer):void
		{
			if (layer == windowLayer3D || layer == windowLayer)
			{
				if (layer != _topWindowLayer)
				{
					Global.application.swapChildren(windowLayer , windowLayer3D);
					_topWindowLayer = layer;
					updateMask();
				}
			}
		}
		
		public static function setWindowSpriteMask($uiMask:DisplayObject = null , $windowMask:DisplayObject = null):void
		{
			if(_uiMask==$uiMask && _windowMask==$windowMask)
			{
				return;
			}
			_uiMask = $uiMask;
			_windowMask = $windowMask;
			updateMask();
		}
		
		private static function updateMask():void
		{
			if (_uiMask)
			{
				uiLayer.mask = _uiMask;
				_uiMask.visible=true;
			}
			else
			{
				if(uiLayer.mask)
				{
					uiLayer.mask.visible=false;
				}
				if(_uiMask)
				{
					_uiMask.visible=false;
				}
				uiLayer.mask = null;
				
			}
			
			if (_windowMask && _topWindowLayer == windowLayer3D )
			{
				windowLayer.mask = _windowMask;
				_windowMask.visible=true;
			}
			else
			{
				if(windowLayer.mask)
				{
					windowLayer.mask.visible=false;
				}
				if(_windowMask)
				{
					_windowMask.visible=false;
				}
				windowLayer.mask = null;
				
			}
		}
	}
}
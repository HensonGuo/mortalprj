/**
 * 2014-1-22
 * @author chenriji
 **/
package mortal.game.view.mainUI.smallMap.view
{
	import Message.Public.SPoint;
	
	import com.gengine.game.core.GameSprite;
	import com.gengine.utils.pools.ObjectPool;
	import com.mui.controls.GBitmap;
	import com.mui.controls.GButton;
	import com.mui.controls.GLoadedButton;
	import com.mui.controls.GSprite;
	import com.mui.controls.GTextFiled;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextFormatAlign;
	
	import mortal.common.DisplayUtil;
	import mortal.common.GTextFormat;
	import mortal.common.global.GlobalStyle;
	import mortal.game.events.DataEvent;
	import mortal.game.mvc.EventName;
	import mortal.game.resource.ImagesConst;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.mainUI.smallMap.view.data.SmallMapTypeIconData;
	import mortal.game.view.mainUI.smallMap.view.render.SmallMapTypeIconItem;
	import mortal.game.view.msgbroad.IssmNoticItem;
	import mortal.mvc.core.Dispatcher;
	
	public class SmallMapTypeShower extends GSprite
	{
		private var _typeItems:Array = [];
		private var _nameTexts:Array = [];
		private var _iconContainer:GSprite;
		private var _nameContainer:GSprite;
		private var _targetBootContainer:GSprite;
		protected var _btnFlyBoot:GLoadedButton;
//		protected var _bmpTarget:GBitmap;
		
		public function SmallMapTypeShower()
		{
			super();
		}
		
		protected override function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			
			_iconContainer = new GSprite();
			this.addChild(_iconContainer);
			
			_nameContainer = new GSprite();
			_nameContainer.mouseChildren = false;
			_nameContainer.mouseEnabled = false;
			this.addChild(_nameContainer);
			
			_targetBootContainer = new GSprite();
			this.addChild(_targetBootContainer);
		}
		
		protected override function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			_nameContainer.dispose(isReuse);
			_nameContainer = null;
			
			_iconContainer.dispose(isReuse);
			_iconContainer = null;
			
			_targetBootContainer.dispose(isReuse);
			_targetBootContainer = null;
			
			if(_btnFlyBoot != null)
			{
				_btnFlyBoot.dispose(isReuse);
				_btnFlyBoot = null;
			}
			
//			if(_bmpTarget != null)
//			{
//				_bmpTarget.dispose(isReuse);
//				_bmpTarget = null;
//			}
		}
		
		public function showFlyBoot(isShow:Boolean=false, x:int=0, y:int=0):void
		{
			if(!isShow)
			{
				DisplayUtil.removeMe(_btnFlyBoot);
			}
			else
			{
				if(_btnFlyBoot == null)
				{
					_btnFlyBoot = UIFactory.gLoadedButton(ImagesConst.MapBtnFlyBoot_upSkin, 0, 0, 16, 18, this);
					_btnFlyBoot.configEventListener(MouseEvent.CLICK, flyHandler);
				}
				_btnFlyBoot.x = x - _btnFlyBoot.width/2;
				_btnFlyBoot.y = y - _btnFlyBoot.height - 4;
				_targetBootContainer.addChild(_btnFlyBoot);
			}
		}
		
		public function showTargetPoint(isShow:Boolean=false, x:int=0, y:int=0):void
		{
//			if(!isShow)
//			{
//				DisplayUtil.removeMe(_bmpTarget);
//			}
//			else
//			{
//				if(_bmpTarget == null)
//				{
//					_bmpTarget = UIFactory.gBitmap(ImagesConst.MapPoint_Target, 0, 0, this);//UIFactory.gLoadedButton(ImagesConst.MapPoint_Target, 0, 0, 29, 35, this);
//				}
//				_bmpTarget.x = x - _bmpTarget.width/2;
//				_bmpTarget.y = y - _bmpTarget.height;
//				_targetBootContainer.addChild(_bmpTarget);
//			}
		}
		
		private function flyHandler(evt:MouseEvent):void
		{
			if(_btnFlyBoot == null)
			{
				return;
			}
			var p:SPoint = new SPoint();
			p.x = _btnFlyBoot.x + _btnFlyBoot.width/2 - 18;
			p.y = _btnFlyBoot.y + _btnFlyBoot.height + 4;
			Dispatcher.dispatchEvent(new DataEvent(EventName.SmallMapFlybootReq, p));
		}
		
		public function updateTypeShow(type:int, scale:Number, datas:Array):void
		{
			if(datas == null)
			{
				return;
			}
			var items:Array = _typeItems[type];
			var texts:Array = _nameTexts[type];
			if(items == null)
			{
				items = [];
				texts = [];
				_typeItems[type] = items;
				_nameTexts[type] = texts;
			}
			
			
			// 调整位置
			for(var i:int = 0; i < datas.length; i++)
			{
				var data:SmallMapTypeIconData = datas[i];
				var item:SmallMapTypeIconItem = items[i];
				var text:GTextFiled = texts[i];
				if(item == null)
				{
					item = ObjectPool.getObject(SmallMapTypeIconItem);//UIFactory.gBitmap(obj["icon"] as String, p.x, p.y, this);
					items.push(item);
					_iconContainer.addChild(item);
				}
				if(text == null)
				{
					var tf:GTextFormat = GlobalStyle.textFormatPutong;
					tf.align = TextFormatAlign.CENTER;
					tf.size = 12;
					text = UIFactory.gTextField("", 0, 0, 100, 20, _nameContainer, tf);
					texts.push(text);
				}
				data.scale = scale;
				item.updateData(data);
				
				text.text = data.name;
				text.x = item.x - 42;
				text.y = item.y - 16;
			}
			
			var tmp:int = i;
			// 删除不显示的
			for(; i < items.length; i++)
			{
				item = items[i];
				item.dispose(true);
				text = texts[i];
				text.dispose(true);
			}
			if(tmp != i)
			{
				items.splice(tmp);
				texts.splice(tmp);
			}
			
//			this.setChildIndex(_nameContainer, this.numChildren - 1);
		}
	}
}
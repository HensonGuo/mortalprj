package com.mui.manager
{
	
	
	import flash.accessibility.AccessibilityProperties;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;
	import flash.text.*;
	import flash.utils.Timer;

	/**
	 * 热区提示
	 */	
	public class ToolTipsManager extends Sprite
	{
		private static var toolClassMap:Object = { };//用于存放各个对象的tooltip类
		private static var classId:int = 0;//根据注册的先后，给不同对象一个唯一id，以获取相对应的tooltip类
		private static var _instance:ToolTipsManager = null;		
		private static var _defaultRenderClass:Class;
		private var area:DisplayObject;
		//private var toolTipBg:DisplayObject;
		private var toolTipContent:IToolTip;
		private var toolTipLayer:DisplayObjectContainer;
		private var delayTimer:Timer;
		
		private var _this:ToolTipsManager;
		public function ToolTipsManager(base:DisplayObjectContainer) 
		{
			visible = false;
			mouseEnabled = mouseChildren = false;
			toolTipLayer = base;
			_this = this;
			//因为tooltip需要在最上层，所以要把它加在场景的最上层
			//var base:DisplayObjectContainer = LayerManager.toolTipLayer;
			base.addChild(this);
			
			
		}
		
		public static function get defaultRenderClass():Class
		{
			return _defaultRenderClass;
		}

		public static function set defaultRenderClass(value:Class):void
		{
			_defaultRenderClass = value;
		}

		public static function init(base:DisplayObjectContainer):void
		{
			if(_instance == null)
			{
				_instance = new ToolTipsManager(base);
			}
		}
		
		/**
		 * 注册tooltip
		 * @param	area 需要显示tooltip的对象
		 * @param	toolTipData tooltip的数据
		 * @param	renderClass tooltip的renderer
		 */
		public static function register(area:*, renderClass:Class = null, toolTipData:Object = null):void
		{
			if(_instance == null)
			{
				throw new Error("ToolTipsManager 未初始化");
			}
			
			var vId:String;
			var prop:AccessibilityProperties = area["accessibilityProperties"] ;
			if( prop == null)
			{
				prop = area["accessibilityProperties"] = new AccessibilityProperties();
				classId++;
				vId = "Item" + classId;
				prop.description = vId;
			}
			else
			{
				vId = prop.description;
			}
			
			var vTargetArea:EventDispatcher = (area as EventDispatcher);
			vTargetArea.addEventListener(MouseEvent.MOUSE_OVER,_instance.targetMouseHandler);
			
			if(renderClass != null)
			{
				toolClassMap[vId] = {toolTipClass:renderClass, areaItem:area, toolTipData:toolTipData};
			}
			else if( _defaultRenderClass != null )
			{
				toolClassMap[vId] = {toolTipClass:_defaultRenderClass, areaItem:area, toolTipData:toolTipData};
			}
			else
			{
				throw new Error("ToolTipManger的dfaultRenderClass未定义");
			}
		}
		
		public function targetMouseHandler(event:MouseEvent):void
		{
			switch(event.type) 
			{
				case MouseEvent.MOUSE_OUT:
				case MouseEvent.MOUSE_DOWN:
				case MouseEvent.MOUSE_UP:
					_instance.hide();
					break;
				case MouseEvent.MOUSE_MOVE:
					_instance.move(new Point(event.stageX, event.stageY));					
					break;
				case MouseEvent.MOUSE_OVER:
					var vTarget:DisplayObject = event.currentTarget as DisplayObject;
					if( _instance.area != vTarget )
					{
						_instance.hide();
					}
					if (vTarget.alpha == 1)
					{
						_instance.area = event.currentTarget as DisplayObject;
						startDelayCount();
					}
					break;
			}
		}
		
		/**
		 * 取消tooltip
		 * @param	area 需要取消tooltip的对象
		 */
		public static function unregister(area:EventDispatcher):void
		{
			if (_instance != null && area)
			{
				var vId:String;
				var prop:AccessibilityProperties = area["accessibilityProperties"] ;
				if( prop)
				{
					vId = prop.description;
				}
				toolClassMap[vId] = null;
				delete toolClassMap[vId];
				area.removeEventListener(MouseEvent.MOUSE_OVER, _instance.targetMouseHandler);
			}
		}
		
		public function show(area:DisplayObject):void 
		{
			//hide();
			this.area.addEventListener(MouseEvent.MOUSE_MOVE, this.targetMouseHandler);
			
			if (area.accessibilityProperties)
			{
				clearConetnt();
				var vData:Object = toolClassMap[area.accessibilityProperties.description];
				if(!vData)
				{
					return;
				}
				var vToolTipData:Object;//= (vData.areaItem as IToolTipItem).toolTipData;
				if(vData.areaItem is IToolTipItem)
				{
					vToolTipData = (vData.areaItem as IToolTipItem).toolTipData;
				}
				else
				{
					vToolTipData = vData.toolTipData;
				}
				if(vToolTipData != null	)
				{
					//toolTipContent = new (vData.toolTipClass as Class)();
					toolTipContent = ToolTipPool.getObject(vData.toolTipClass as Class);
					(toolTipContent as DisplayObject).visible = true;
					toolTipContent.data = vToolTipData;
					var toolTipObject:DisplayObjectContainer = toolTipContent as DisplayObjectContainer;
					toolTipObject.mouseChildren = false;
					toolTipObject.mouseEnabled = false;
					addChild(toolTipObject);
				}
			}		
		}
		
				
		public function hide():void	
		{
			clearDelayCount();
			clearConetnt();
			if(this.area)
			{
				this.area.removeEventListener(MouseEvent.MOUSE_DOWN, this.targetMouseHandler);
				this.area.removeEventListener(MouseEvent.MOUSE_OUT, this.targetMouseHandler);
				this.area.removeEventListener(MouseEvent.MOUSE_MOVE, this.targetMouseHandler);
				this.area = null;
			}
			visible = false;
		}
		
		private function clearConetnt():void			
		{
			if(toolTipContent)
			{
				ToolTipPool.disposeObject(toolTipContent);
				var vToolTipObject:DisplayObject = toolTipContent as DisplayObject;
				vToolTipObject.visible = false;
				
				if(vToolTipObject.hasOwnProperty("dispose"))
				{
					vToolTipObject["dispose"]();
				}
				if(this.contains(vToolTipObject))
				{
					this.removeChild(vToolTipObject);
				}
				toolTipContent = null;
			}
		}
		
		public function move(point:Point):void 
		{	
			var lp:Point = this.parent.globalToLocal(point);

			this.x = lp.x + 15
			if(this.x > (toolTipLayer.stage.stageWidth - this.width - 6))
			{
				this.x = lp.x  - this.width-6;	
			}
			
			
			var vYDir:int = 1;

			this.y = lp.y + 6;	
			var content:DisplayObject = toolTipContent as DisplayObject;
			if(content )
			{
				if( content.height > toolTipLayer.stage.stageHeight)
				{
					this.y = 0;
				}
				else if( this.y + content.height > toolTipLayer.stage.stageHeight )
				{
					this.y = toolTipLayer.stage.stageHeight - content.height;
				}
			}

			
			if(!visible)
			{
				visible = true;
			}
			
			if(content is ItoolTip3D)
			{
				(content as ItoolTip3D).positionChanged();
			}
		}
		
//		private function handler(event:MouseEvent):void
//		{
//			switch(event.type) 
//			{
//				case MouseEvent.MOUSE_OUT:
//				case MouseEvent.MOUSE_DOWN:
//				case MouseEvent.MOUSE_UP:
//					this.hide();
//					break;
//				case MouseEvent.MOUSE_MOVE:
//					this.move(new Point(event.stageX, event.stageY));					
//					break;
//				case MouseEvent.MOUSE_OVER:
//					hide();
//					var vTarget:DisplayObject = event.currentTarget as DisplayObject;
//					if (vTarget.alpha == 1)
//					{
//						this.area = event.currentTarget as DisplayObject;
//						startDelayCount();
//						//this.show(event.currentTarget as DisplayObject);
//						//this.move(new Point(event.stageX, event.stageY))
//					}
//					break;
//			}
//		}
		/**
		 * 延时显示 
		 * 
		 */		
		private function startDelayCount():void
		{
			if(!delayTimer)
			{
				delayTimer = new Timer(500, 1);
				delayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, showAfterDelay);
			}
			delayTimer.reset();
			delayTimer.start();
			this.area.addEventListener(MouseEvent.MOUSE_DOWN, this.targetMouseHandler);
			this.area.addEventListener(MouseEvent.MOUSE_OUT, this.targetMouseHandler);
			this.area.addEventListener(MouseEvent.MOUSE_UP, this.targetMouseHandler);
		}
		/**
		 * 清理延时 
		 * 
		 */		
		private function clearDelayCount():void
		{
			if(delayTimer)
			{
				delayTimer.stop();
			}
		}
		/**
		 * 延时完成 执行代码 
		 * @param e
		 * 
		 */		
		private function showAfterDelay(e:TimerEvent):void			
		{
			if( this.area )
			{
				this.show(this.area);
				var point:Point = new Point(area.mouseX,area.mouseY);
				point = area.localToGlobal(point);
				this.move(point);
			}
			
		}
		
		override public function get width():Number
		{
			if(this.toolTipContent && this.toolTipContent is DisplayObject)
			{
				return (this.toolTipContent as DisplayObject).width;
			}
			return super.width;
		}
		
	}
}
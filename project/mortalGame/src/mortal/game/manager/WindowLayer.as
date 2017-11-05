package mortal.game.manager
{
	import com.gengine.global.Global;
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import mortal.component.window.Window;
	import mortal.component.window.WindowEvent;
	import mortal.game.manager.window3d.IWindow3D;
	import mortal.mvc.interfaces.IView;

	public class WindowLayer extends UILayer
	{
		public static var topLayerChangeHander:Function;
		
		public function WindowLayer()
		{
			
		}
		
		override public function setTop(displayObject:DisplayObject):void
		{
			super.setTop(displayObject);
			if (topLayerChangeHander != null)
			{
				topLayerChangeHander.call(this , this);
			}
		}
		
		override protected function layerChange():void
		{
			this.dispatchEvent(new WindowEvent(WindowEvent.WINDOWLEVELCHANGE));
		}
		
		private var dcPopingWindow:Dictionary = new Dictionary(true);
		
		override public function addPopUp( displayObject:DisplayObject , modal:Boolean = false ):void
		{
			if( displayObject && (this.contains(displayObject) == false || isPoping(displayObject)) )
			{
				if(displayObject.localToGlobal(new Point()).x + 100 > Global.stage.stageWidth)
				{
					centerPopup(displayObject);
				}
				
				this.addChild(displayObject);
				setTop(displayObject);
				layerChange();
				
				if(displayObject is IView)
				{
					displayObject.alpha = 0;
					var tl:TweenLite = new TweenLite(displayObject, 0.5, {alpha:1, ease:Cubic.easeOut,onComplete:function():void
					{
						removePoping(displayObject);
					}});
					addPoping(displayObject,tl);
				}
			}
		}
		
		override public function removePopup( displayObject:DisplayObject,tweenable:Boolean=true):void
		{
			if( this.contains(displayObject) )
			{
				if (tweenable) 
				{
					displayObject.alpha = 1;
					
					setObjMouseEnable(displayObject,false);
					
					var tl:TweenLite = new TweenLite(displayObject, 0.5, {alpha:0, ease:Cubic.easeOut,onComplete:function():void
					{
						removePoping(displayObject);
						removeChild(displayObject);
						layerChange();
						setObjMouseEnable(displayObject,true);
					}});
					addPoping(displayObject,tl);
				}
				else
				{
					removePoping(displayObject);
					removeChild(displayObject);
					layerChange();
					setObjMouseEnable(displayObject,true);
				}
			}
		}
		
		private function addPoping(obj:Object,tl:TweenLite):void
		{
			removePoping(obj);
			dcPopingWindow[obj] = tl;
			tl.play();
		}
		
		private function isPoping(obj:Object):Boolean
		{
			var value:Object = dcPopingWindow[obj];
			return value != null;
		}
		
		private function removePoping(obj:Object):void
		{
			if(isPoping(obj))
			{
				var tlOld:TweenLite = dcPopingWindow[obj];
				tlOld.pause();
//				tlOld.killVars({onComplete:true});
				tlOld.kill();
				tlOld = null;
				setObjMouseEnable(obj,true);
				delete dcPopingWindow[obj];
			}
		}
		
		/**
		 * 设置显示对象的是否支持鼠标 
		 * @param displayerObj
		 * @param value
		 * 
		 */		
		private function setObjMouseEnable(obj:Object,value:Boolean):void
		{
			if(obj is InteractiveObject)
			{
				(obj as InteractiveObject).mouseEnabled = value;
			}
			if(obj is DisplayObjectContainer)
			{
				(obj as DisplayObjectContainer).mouseChildren = value;
			}
		}
		
		override public function centerPopup( displayObject:DisplayObject ):void
		{
			displayObject.x = (Global.stage.stageWidth - displayObject.width)/2;
			displayObject.y = (Global.stage.stageHeight - displayObject.height)/2;
			//放在在线奖励上面
			if(Global.stage.stageHeight - displayObject.height - 100 < displayObject.y)
			{
				displayObject.y = Global.stage.stageHeight - displayObject.height - 100;
			}
			//不能挡住任务追踪面板 和 右下角提示信息
			if(Global.stage.stageWidth - displayObject.width - displayObject.x - 280 < 0)
			{
				displayObject.x = Global.stage.stageWidth - displayObject.width - 280;
			}
			if(displayObject.x < 0)
			{
				displayObject.x = 0;
			}
			if(displayObject.y < 0)
			{
				displayObject.y = 0;
			}
		}
		
		/**
		 * 将窗口左移动到与聊天对齐 
		 * @param displayObject
		 * 
		 */		
		public function leftToChat(displayObject:DisplayObject):void
		{
			if(!this.contains(displayObject) || !(displayObject is IView))
			{
				return;
			}
			//不遮挡聊天
//			if(displayObject.x < 280)
//			{
				displayObject.x = 280;
//			}
		}
		
		/**
		 * 将窗口左移动到与任务对齐 
		 * @param displayObject
		 * 
		 */		
		public function rightToTask(displayObject:DisplayObject):void
		{
			if(!this.contains(displayObject))
			{
				return;
			}
			//不遮挡聊天
//			if(Global.stage.stageWidth - displayObject.width - displayObject.x - 210 < 0)
//			{
				displayObject.x = Global.stage.stageWidth - displayObject.width - 280;
//			}
		}
		
		/**
		 * 将一些窗口居中对齐 
		 * @param rest
		 * 
		 */
		public function centerWindows(...rest):void
		{
			var totleWidth:Number = 0;
			var vcWindows:Vector.<Window> = new Vector.<Window>();
			var minY:int = 10000;
			var grap:Number = 5;
			for(var i:int = 0;i<rest.length;i++)
			{
				if(!(rest[i] is Window))
				{
					if(rest[i] is Number)
					{
						grap = rest[i];
					}
					continue;
				}
				vcWindows.push(rest[i] as Window);
				totleWidth += (rest[i] as Window).width;
				centerPopup(rest[i] as Window);
				minY = Math.min(minY,(rest[i] as Window).y);
			}
			totleWidth += (vcWindows.length - 1) * grap;
			var currentX:int = (Global.stage.stageWidth - totleWidth)/2;
			for(var j:int = 0;j<vcWindows.length;j++)
			{
				if(vcWindows[j].isHide)
				{
					vcWindows[j].show();
				}
				this.setTop(vcWindows[j]);
				vcWindows[j].x = currentX;
				vcWindows[j].y = minY;
				currentX += vcWindows[j].width + grap;
			}
		}
		
		/**
		 * 缓动居中一些窗口
		 * @param rest
		 * 
		 */		
		public function tweenCenterWindow(...rest):void
		{
			var totleWidth:Number = 0;
			var vcWindows:Vector.<Window> = new Vector.<Window>();
			var minY:int = 10000;
			var grap:Number = 5;
			for(var i:int = 0;i<rest.length;i++)
			{
				if(!(rest[i] is Window))
				{
					if(rest[i] is Number)
					{
						grap = rest[i];
					}
					continue;
				}
				vcWindows.push(rest[i] as Window);
				totleWidth += (rest[i] as Window).width;
				centerPopup(rest[i] as Window);
				minY = Math.min(minY,(rest[i] as Window).y);
			}
			totleWidth += (vcWindows.length - 1) * grap;
			var currentX:int = (Global.stage.stageWidth - totleWidth)/2;
			for(var j:int = 0;j<vcWindows.length;j++)
			{
				if(vcWindows[j].isHide)
				{
					vcWindows[j].show();
				}
				this.setTop(vcWindows[j]);
				var startX:Number = (Global.stage.stageWidth - vcWindows[j].width)/2 >= currentX?currentX + vcWindows[j].width/3:currentX - vcWindows[j].width/3;
				tweenWindow(vcWindows[j],startX,minY,currentX,minY,0.3);
//				vcWindows[j].show();
//				vcWindows[j].x = currentX;
				currentX += vcWindows[j].width + grap;
			}
		}
		
		/**
		 * 缓动一个窗口 
		 * @param window 窗口
		 * @param startX 开始X位置
		 * @param startY 开始Y位置
		 * @param toX  结束X位置
		 * @param toY  结束Y位置
		 * @param time 缓动时间
		 * 
		 */		
		public function tweenWindow(window:Window,startX:Number,startY:Number,toX:Number,toY:Number,time:Number = 0.7):void
		{
			window.x = startX;
			window.y = startY;
			TweenLite.to(window,time,{x:toX,y:toY});
		}
	}
}
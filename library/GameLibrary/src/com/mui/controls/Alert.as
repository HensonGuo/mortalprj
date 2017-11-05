package com.mui.controls
{
	
	import com.greensock.TimelineLite;
	import com.greensock.TimelineMax;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	//  
	
	public class Alert
	{
		public static const YES:int = 1;		
		public static const NO:int = 2;
		public static const OK:int = 4;
		public static const CANCEL:int = 8;
		public static const CLOSE:int = 16;
		
		public static const Mode_Blur:String = "blur";
		public static const Mode_None:String = "none";
		public static const Mode_NoneNotModal:String = "nonenotmodal";
		public static const Mode_Simple:String = "simple";
		
		public static var text:String = "";//要在此警告对话框中显示的文本
		public static var title:*;//要在此警告对话框中显示的标题,可以是文字，也可以是图片
		public static var buttonFlags:uint = 0;//需要显示的按钮
		public static var parent:DisplayObjectContainer;//要让alert显示的容器

		public static var okLabel:String = "确定";
		public static var calcelLabel:String = "取消";
		public static var yesLabel:String = "是";
		public static var noLabel:String = "否";
		public static var checkBoxLabel:String = "今日不再提示！";
		
		public static var okLabelDefault:String = "确定";
		public static var calcelLabelDefault:String = "取消";
		public static var yesLabelDefault:String = "是";
		public static var noLabelDefault:String = "否";
		public static var checkBoxLabelDefault:String = "今日不再提示！";

		public static var closeHandler:Function;//关闭时调用的接口
		public static var iconClass:Class;//图标类
		public static var defaultButtonFlag:uint = 4;//默认需要显示的按钮
		public static var buttonWidth:int = 49;//每个 Alert 按钮的宽度（以像素为单位）。
		public static var buttonHeight:int = 25;//每个 Alert 按钮的高度（以像素为单位）。
		public static var showCloseBtn:Boolean;//是否显示关闭按钮
		public static var isWiggle:Boolean;//是否在显示的同时抖动

		
		public static var textColor:uint = 0xFFFFFF;
		public static var titleColor:uint = 0xFFFFFF;
		public static var buttonColor:uint = 0x4E7DB1;
		public static var buttonTextColor:uint = 0xFFFFFF;
		public static var backgroundColor:uint = 0x4E7DB1;
		public static var backgroundAlpha:Number = 0;
		
		public static var buttonStyleName:String;//按钮的样式
		
		public static var titleTextFormat:TextFormat;
		public static var messageTextFormat:TextFormat;
		
		public static var mode:String = "simple";
		//背景类型 		
		// "none" - 背景不可见 		
		// "nonenotmodal" -  背景不可见，并且alert窗口是非modal模式  		
		//"simple -  普通的背景模式		
		//"blur" -  背景模糊 
		//默认是“simple模式”
		
		
		public static var alertWinRenderer:Class = null;//预留接口，可让使用者自己定义alertwin
		public static var timerOut:int = 0;//倒计时时间
		public static var timerNO:Boolean = false;//给取消按钮加倒计时
		public static var extendObj:Object;//额外的参数
		
		private static var _defaultAlertWinRenderer:Class = null;
		
		
		
		private static  var stage:*=null;
		private static var _instance:Alert;

		public static function get defaultAlertWinRenderer():Class
		{
			
			return _defaultAlertWinRenderer;
		}
		
		public static function set defaultAlertWinRenderer(value:Class):void
		{
			alertWinRenderer = value; 
			_defaultAlertWinRenderer = value;
		}

		
		public function Alert(base:DisplayObjectContainer)
		{
			if( _instance != null )
			{
				throw new Error(" AlertManager 单例 ");
			}
			stage = base;
		}
		
		
		public static function init(base:DisplayObjectContainer):void
		{
			if(_instance == null)
			{
				_instance = new Alert(base);
			}
		}

		/**
		 * 
		 * @param	text 在 Alert 控件中显示的文本字符串。此文本将在警告对话框中居中显示。
		 * @param	title 标题栏中显示的文本字符串。此文本左对齐。
		 * @param	flags Alert 控件中放置的按钮。有效值为 Alert.OK、Alert.CANCEL、Alert.YES 和 Alert.NO。默认值为 Alert.OK。使用按位 OR 运算符可显示多个按钮。
		 * 例如，传递 (Alert.YES | Alert.NO) 显示“是”和“否”按钮。
		 * 无论按怎样的顺序指定按钮，它们始终按照以下顺序从左到右显示：“确定”、“是”、“否”、“取消”。 
		 * @param	parent Alert 控件在其上居中的对象。
		 * @param	closeHandler 按下 Alert 控件上的任意按钮时将调用的事件处理函数。传递给此处理函数的事件对象是 CloseEvent 的一个实例；
		 * 此对象的 detail 属性包含 Alert.OK、Alert.CANCEL、Alert.YES 或 Alert.NO 值。 
		 * @param	iconClass 位于 Alert 控件中文本左侧的图标的类。
		 * @param	defaultButtonFlag 指定默认按钮的位标志。您可以指定一个值，并且只能是 Alert.OK、Alert.CANCEL、Alert.YES 或 Alert.NO 中的一个值。默认值为 Alert.OK。
		 * 按 Enter 键触发默认按钮，与单击此按钮的效果相同。按 Esc 键触发“取消”或“否”按钮，与选择相应按钮的效果相同。 
		 * @return 
		 */
		public static function show(text:String = "", title:* = null, flags:uint = 0x4, parent:Sprite = null, closeHandler:Function = null, iconClass:Class = null, defaultButtonFlag:uint = 0x4):Sprite
		{
			Alert.text = text;
			Alert.title = title;
			Alert.buttonFlags = flags;
			if(parent)
			{
				Alert.parent = parent;
			}
			
			Alert.closeHandler = closeHandler;

			if(iconClass)
			{
				Alert.iconClass = iconClass;
			}
			Alert.defaultButtonFlag = defaultButtonFlag;
			
			var myAlert:Sprite
			var container:DisplayObjectContainer;
			var containerWidth:Number;
			var containerHeight:Number;
			if(!stage && !parent)
			{
				throw new Error("AlertManager尚未初始化!必需指定Alert窗口显示的容器");
				return;
			}
			else if(parent)
			{
				containerWidth = parent.width;
				containerHeight = parent.height;
				container = parent;
			}
			else
			{
				if(stage is Stage)
				{
					containerWidth = stage.stageWidth;
					containerHeight = stage.stageHeight;
				}
				else if(stage is DisplayObjectContainer)
				{
					containerWidth = stage.stage.stageWidth;
					containerHeight = stage.stage.stageHeight;
				}
				container = stage;
				//未定义容器，那么默认在stage显现
			}
			
			if(alertWinRenderer)
			{
				myAlert = new alertWinRenderer(containerWidth,containerHeight);
			}
			else
			{
				myAlert = new GAlertWin(stage.stageWidth,stage.stageHeight);
			}
			
			container.addChild(myAlert);
			if(myAlert is GAlertWin)
			{
				myAlert.addEventListener(MouseEvent.CLICK,clickHandler);
				myAlert.addEventListener(Event.REMOVED_FROM_STAGE,removeHandler);
			}
			
			if(isWiggle)
			{
				wiggle(myAlert);
			}
			
			resetToDefault();
			return myAlert;
			
			function clickHandler(e:MouseEvent):void
			{
				var object:DisplayObject = e.target as DisplayObject;
				var alertWin:GAlertWin = e.currentTarget as GAlertWin;
				if(!alertWin.window.contains(object))
				{
					if(alertWin.promptBackground)
					{
						flick(alertWin.promptBackground);
					}
				}
			}
			
			function removeHandler(e:Event):void
			{
				myAlert.removeEventListener(Event.REMOVED_FROM_STAGE,removeHandler);
				myAlert.removeEventListener(MouseEvent.CLICK,clickHandler);
			}
		}	
		
		public static function flick(obj:DisplayObject):void
		{
			var x:Number = obj.x;
			var y:Number = obj.y;
			var timeLite:TimelineMax = new TimelineMax();
			timeLite.append( new TweenMax(obj,0.05,{frameInterval:1,glowFilter:{color:0xdddddd, alpha:0.5, blurX:100, blurY:100,inner:true}}));
			timeLite.append( new TweenMax(obj,0.05,{frameInterval:1,glowFilter:{color:0xdddddd, alpha:1, blurX:1, blurY:1,inner:true}}));
			timeLite.append( new TweenMax(obj,0.05,{frameInterval:1,glowFilter:{color:0xdddddd, alpha:0.5, blurX:100, blurY:100,inner:true}}));
			timeLite.append( new TweenMax(obj,0.05,{frameInterval:1,glowFilter:{color:0xdddddd, alpha:1, blurX:1, blurY:1,inner:true}}));
			timeLite.append( new TweenMax(obj,0.05,{frameInterval:1,glowFilter:{color:0xdddddd, alpha:0.5, blurX:100, blurY:100,inner:true}}));
			timeLite.append( new TweenMax(obj,0.05,{frameInterval:1,glowFilter:{color:0xdddddd, alpha:1, blurX:1, blurY:1,inner:true},onComplete:function():void
			{
				timeLite.stop();
				timeLite.kill();
				timeLite = null;
			}}));
			timeLite.play();
		}
		
		public static function wiggle(obj:DisplayObject):void
		{
			var x:Number = obj.x;
			var y:Number = obj.y;
			var timeLite:TimelineLite = new TimelineLite();
			timeLite.append( new TweenLite(obj,0.02,{x:x-7,y:y}));
			timeLite.append( new TweenLite(obj,0.02,{x:x,y:y+5}));
			timeLite.append( new TweenLite(obj,0.02,{x:x+7,y:y}));
			timeLite.append( new TweenLite(obj,0.02,{x:x,y:y-5}));
			timeLite.append( new TweenLite(obj,0.02,{x:x-7,y:y}));
			timeLite.append( new TweenLite(obj,0.02,{x:x,y:y+5}));
			timeLite.append( new TweenLite(obj,0.02,{x:x+7,y:y}));
			timeLite.append( new TweenLite(obj,0.02,{x:x,y:y-5}));
			timeLite.append( new TweenLite(obj,0.02,{x:x-7,y:y}));
			timeLite.append( new TweenLite(obj,0.02,{x:x,y:y+5}));
			timeLite.append( new TweenLite(obj,0.02,{x:x+7,y:y}));
			timeLite.append( new TweenLite(obj,0.02,{x:x,y:y-5}));
			timeLite.append( new TweenLite(obj,0.02,{x:x,y:y,onComplete:function():void
			{
				timeLite.stop();
				timeLite.kill();
				timeLite = null;
			}}));
			timeLite.play();
		}
		
		public static function resetToDefault():void
		{
			okLabel = okLabelDefault;
			calcelLabel = calcelLabelDefault;
			yesLabel = yesLabelDefault;
			noLabel = noLabelDefault;
			
			text = "";//要在此警告对话框中显示的文本
			title = null;//要在此警告对话框中显示的标题
			buttonFlags = 0;//需要显示的按钮
			parent = null;//要让alert显示的容器
			closeHandler = null;//关闭时调用的接口
			iconClass = null;//图标类
			defaultButtonFlag = 4;
			buttonWidth = 49;//每个 Alert 按钮的宽度（以像素为单位）。
			buttonHeight = 25;//每个 Alert 按钮的高度（以像素为单位）。		
			
			textColor = 0xFFFFFF;
			titleColor = 0xFFFFFF;
			buttonColor = 0x4E7DB1;
			buttonTextColor = 0xFFFFFF;
			backgroundColor = 0x4E7DB1;
			backgroundAlpha = 0;			
			titleTextFormat = null;
			messageTextFormat = null;
			alertWinRenderer = defaultAlertWinRenderer;
			mode = "simple";		
			timerOut = 0;
			buttonStyleName = null;
			showCloseBtn = false;
			isWiggle = false;
			timerNO = false;
			extendObj = null;
			checkBoxLabel = checkBoxLabelDefault;
			//alertWinRenderer = null;//预留接口，可让使用者自己定义alertwin
		}
	}
}	
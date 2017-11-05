package com.mui.controls
{
	/**
	 * ...
	 * @author wyang
	 */
	import fl.controls.Button;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.GradientType;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class GAlertWin extends Sprite
	{
		protected var title:DisplayObject;
		protected var message:TextField;
		protected var background:DisplayObject;
		protected var prompt:DisplayObjectContainer;
		protected var allButtons:Vector.<GButton> =new Vector.<GButton>;
		protected var boarder:DisplayObject;
		protected var icon:DisplayObject;
		
		protected var boarderWidth:int = 15;
		protected var minWidth:int = 150;
		protected var minHeight:int = 150;
		//public var stage:Stage=null;
		
		protected var stageWidth:Number;
		protected var stageHeight:Number;
		
		protected var closeHandler:Function;
		protected var closeBtn:GButton;
		protected var extendObj:Object;//额外的参数
		
		public function GAlertWin(stageWidth:Number, stageHeight:Number):void
		{
			this.stageWidth = stageWidth;
			this.stageHeight = stageHeight;
			extendObj = Alert.extendObj;
			createChildren();
			childrenCreated();
			addDragHandleer();
			closeHandler = Alert.closeHandler;
			this.addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE,onRemoveFromStage);
		}
		
		private function onAddToStage(e:Event):void
		{
			this.stage.addEventListener(Event.RESIZE, onResize);
		}
		
		private function onRemoveFromStage(e:Event):void
		{
			this.stage.removeEventListener(Event.RESIZE, onResize);
		}
		
		/**
		 * 关闭按钮点击事件 
		 * @param event
		 * 
		 */
		protected function onCloseBtnClickHandler(event:MouseEvent):void
		{
			for (var i:int; i < allButtons.length; i++)
			{
				allButtons[i].removeEventListener(MouseEvent.CLICK, buttonClickHandler);
			}
			
			if(closeBtn != null)
			{
				closeBtn.removeEventListener(MouseEvent.CLICK,onCloseBtnClickHandler);
			}
			
			if (closeHandler != null)
			{
				if(extendObj != null)
				{
					closeHandler(Alert.CLOSE,extendObj);
				}
				else
				{
					closeHandler(Alert.CLOSE);
				}
			}
			
			removeDragHandleer();
			this.parent.removeChild(this);
		}
		
		/**
		 *创建元素
		 */
		protected function createChildren():void
		{
			if(Alert.title is DisplayObject)
			{
				title = Alert.title;
			}
			else 
			{
				title = createTextField();
				if(Alert.titleTextFormat)
				{
					(title as TextField).defaultTextFormat = Alert.titleTextFormat;
				}
			}
			message = createTextField();
			if(Alert.messageTextFormat)
			{
				//message.defaultTextFormat = Alert.messageTextFormat;
			}
			background = createBackground();
			boarder = createPromptBoarder();
			allButtons = createButtons();
			if (Alert.iconClass)
			{
				icon = new com.mui.controls.Alert.iconClass();
			}
			
			showCloseBtn();
		}
		
		/**
		 * 显示关闭按钮 
		 * 
		 */
		protected function showCloseBtn():void
		{
			if(Alert.showCloseBtn)
			{
				closeBtn = new GButton();
				closeBtn.styleName = "CloseButton";
				closeBtn.setSize(19,19);
				closeBtn.label = "";
				closeBtn.configEventListener(MouseEvent.CLICK,onCloseBtnClickHandler);
				_promptBackground.addChild(closeBtn);
			}
		}
		
		/**
		 * 子元素创建完成，进行位置排列
		 */
		protected function childrenCreated():void
		{
			var titleItem:TextField = title as TextField;
			titleItem.text = Alert.title;
			message.text = Alert.text;
			
			var buttonContainer:Sprite = new Sprite();
			for (var i:int = 0; i < allButtons.length; i++)
			{
				var vButton:DisplayObject = allButtons[i];
				vButton.addEventListener(MouseEvent.CLICK,buttonClickHandler);
				buttonContainer.addChild(vButton);
				vButton.x = i * (Alert.buttonWidth + 15);
			}
			
			var iconAndMessage:Sprite = new Sprite();
			iconAndMessage.addChild(message);
			if (icon)
			{
				iconAndMessage.addChild(icon);
				message.x = icon.width + 15;
			}
			
			
			var vTotalBoderWidth:int = boarderWidth * 2;
			var myWidth:Number = Math.max(title.width + vTotalBoderWidth, message.width + vTotalBoderWidth, buttonContainer.width + vTotalBoderWidth, minWidth);
			
			var myHeight:Number = Math.max(title.height + 5, 15) + message.height + Alert.buttonHeight + 45;
			
			titleItem.autoSize = flash.text.TextFieldAutoSize.NONE;
			titleItem.width = myWidth - 10;
						
			titleItem.x = 5;
			titleItem.y = 5;
			
			//message.x = 15;
			message.x = myWidth / 2 - message.width / 2;
			message.y = Math.max(title.height + 15, 15);
			buttonContainer.x = (myWidth - (Alert.buttonWidth + 15)* allButtons.length + 15) / 2;
			buttonContainer.y = message.y + message.height + 15;
			boarder.width = myWidth;
			boarder.height = myHeight;
			
			prompt = new Sprite();
			addChild(background);
			prompt.addChild(boarder);
			prompt.addChild(title);
			prompt.addChild(message);
			if (icon)
			{
				addChild(icon);
			}
			prompt.addChild(buttonContainer);
			addChild(prompt);
			
			prompt.x = (stageWidth - prompt.width) / 2;
			prompt.y = (stageHeight - prompt.height) / 2;
			
			if(Alert.showCloseBtn)
			{
				closeBtn.x = myWidth - closeBtn.width - 8;
				closeBtn.y = 7;
			}
		}
		
		protected function addDragHandleer():void
		{
			prompt.addEventListener(MouseEvent.MOUSE_DOWN,doStartDrag);
			prompt.addEventListener(MouseEvent.MOUSE_UP,doStopDrag);
		}
		
		protected function removeDragHandleer():void
		{
			prompt.removeEventListener(MouseEvent.MOUSE_DOWN,doStartDrag);
			prompt.removeEventListener(MouseEvent.MOUSE_UP,doStopDrag);
		}
		
		protected var _promptBackground:Sprite;
		/**
		 *创建提未框的边框
		 */
		protected function createPromptBoarder():DisplayObject
		{
			_promptBackground=new Sprite();
			
			//  创建提示窗口的背景
			var ellipseSize:int=10;
			_promptBackground.graphics.lineStyle(1);
			_promptBackground.graphics.beginFill(Alert.backgroundColor);
			_promptBackground.graphics.drawRoundRect(0, 0, 100, 100, ellipseSize, ellipseSize);
			_promptBackground.graphics.endFill();
			_promptBackground.scale9Grid = new Rectangle(20, 20, 60, 60);
			
			_promptBackground.filters=[getGlowFilter(),getDropShadowFilter()];
			_promptBackground.alpha = Alert.backgroundAlpha;
			return _promptBackground;
		}
		
		
		/**
		 * 创建提示窗的按钮
		 * @return 包含按的数组
		 */
		protected function createButtons():Vector.<GButton>
		{
			var allButtons:Vector.<GButton> = new Vector.<GButton>;
			var flagsList:Array = getButtonFlagsList();
			
			
			if (flagsList[0] == 1)
			{
				var yesBtn:GButton = new GButton();
				yesBtn.label = Alert.yesLabel;
				yesBtn.name = "btn_" + Alert.YES;
				yesBtn.setSize(Alert.buttonWidth,Alert.buttonHeight);
				if(Alert.buttonStyleName)
				{
					yesBtn.styleName = Alert.buttonStyleName;

				}
				allButtons.push(yesBtn);
			}
			
			if (flagsList[1] == 1)
			{
				var noBtn:GButton = new GButton();
				noBtn.label = Alert.noLabel;
				noBtn.name = "btn_" + Alert.NO;
				noBtn.setSize(Alert.buttonWidth,Alert.buttonHeight);
				if(Alert.buttonStyleName)
				{
					noBtn.styleName = Alert.buttonStyleName;
					
				}
				allButtons.push(noBtn);
			}
			
			if (flagsList[2] == 1)
			{
				var okBtn:GButton = new GButton();
				okBtn.label = Alert.okLabel;
				okBtn.name = "btn_" + Alert.OK;
				okBtn.setSize(Alert.buttonWidth,Alert.buttonHeight);
				if(Alert.buttonStyleName)
				{
					okBtn.styleName = Alert.buttonStyleName;
					
				}
				allButtons.push(okBtn);
			}
			
			if (flagsList[3] == 1)
			{
				var cancelBtn:GButton = new GButton();
				cancelBtn.label = Alert.calcelLabel;
				cancelBtn.name = "btn_" + Alert.CANCEL;
				cancelBtn.setSize(Alert.buttonWidth,Alert.buttonHeight);
				if(Alert.buttonStyleName)
				{
					cancelBtn.styleName = Alert.buttonStyleName;
					
				}
				allButtons.push(cancelBtn);
			}
			return allButtons;
		}
		
		/**
		 * 获取一个为四个元素的数组，每一位显示一个按钮是否显示，1代表显示，0代表不显示
		 * 0-3四位分别表示YES,NO,OK,CANCEL四个按钮是否显示;		
		 */
		protected function getButtonFlagsList():Array
		{
			var flagsList:Array;
			if (Alert.buttonFlags != 0)
			{
				flagsList = ByteToArray(Alert.buttonFlags);
			}
			else
			{
				flagsList = ByteToArray(Alert.defaultButtonFlag);
			}
			return flagsList;
		}
		
		/**
		 * 创建提示文本的textfiled
		 * @return
		 */
		protected  function createTextField():TextField
		{
			var myTextField:TextField=new TextField  ;
			myTextField.textColor= Alert.textColor;
			myTextField.multiline=true;
			myTextField.selectable = false;
			myTextField.mouseEnabled = false;
			myTextField.autoSize=TextFieldAutoSize.LEFT;
			return myTextField;
		}
		
		//创建alert窗口的背景 
		protected function createBackground():DisplayObject
		{
			var myBackground:Sprite=new Sprite();
			var colour:int=Alert.backgroundColor;
			switch (Alert.mode)
			{
				case Alert.Mode_Blur :
					var BackgroundBD:BitmapData=new BitmapData(stageWidth,stageHeight,true,0xFF000000 + colour);
					var stageBackground:BitmapData=new BitmapData(stageWidth,stageHeight);
					stageBackground.draw(stage);
					var rect:Rectangle=new Rectangle(0,0,stageWidth,stageHeight);
					var point:Point=new Point(0,0);
					var multiplier:uint=120;
					BackgroundBD.merge(stageBackground,rect,point,multiplier,multiplier,multiplier,multiplier);
					BackgroundBD.applyFilter(BackgroundBD,rect,point,new BlurFilter(5,5));
					var bitmap:Bitmap=new Bitmap(BackgroundBD);
					myBackground.addChild(bitmap);
					myBackground.mouseEnabled = true;
					break;
				
				case Alert.Mode_None :
					myBackground.graphics.beginFill(colour,0);//背景还是存在的，只是设为透明了 
					myBackground.graphics.drawRect(0,0,stageWidth,stageHeight);
					myBackground.graphics.endFill();
					myBackground.mouseEnabled = true;					
					break;
				
				case Alert.Mode_NoneNotModal :
					//这种模式不需要draw背景
					myBackground.graphics.beginFill(colour,0);//背景还是存在的，只是设为透明了 
					myBackground.graphics.drawRect(0,0,stageWidth,stageHeight);
					myBackground.graphics.endFill();
					myBackground.mouseEnabled = false;
					break;
				
				case Alert.Mode_Simple :
					myBackground.graphics.beginFill(colour,Alert.backgroundAlpha);
					myBackground.graphics.drawRect(0,0,stageWidth,stageHeight);
					myBackground.graphics.endFill();
					myBackground.mouseEnabled = true;
					break;
				
			}
			return myBackground;
		}
		
		protected static  function doStartDrag(event:MouseEvent):void
		{
			if (event.target is Sprite && !(event.target is Button))
			{
				event.currentTarget.startDrag();
			}
		}
		
		protected  function doStopDrag(event:MouseEvent):void
		{
			if (event.target is Sprite)
			{
				event.currentTarget.stopDrag();
			}
		}
		
		/**
		 * 创建模糊滤镜
		 * @return
		 */
		protected  function getBlurFilter():BitmapFilter
		{
			var blurX:Number=100;
			var blurY:Number=100;
			return new BlurFilter(blurX,blurY,BitmapFilterQuality.HIGH);
		}
		
		/**
		 * 创建阴影滤镜
		 * @return
		 */
		protected  function getDropShadowFilter():DropShadowFilter
		{
			var color:Number=0x000000;
			var angle:Number=90;
			var alpha:Number=0.6;
			var blurX:Number=12;
			var blurY:Number=4;
			var distance:Number=1;
			var strength:Number=1;
			var inner:Boolean=false;
			var knockout:Boolean=false;
			var quality:Number=BitmapFilterQuality.LOW;
			return new DropShadowFilter(distance,angle,color,alpha,blurX,blurY,strength,quality,inner,knockout);
		}
		
		/**
		 * 创建glow滤镜
		 * @return
		 */
		protected  function getGlowFilter():GlowFilter
		{
			var color:Number=0xFFFFFF;
			var alpha:Number=0.8;
			var blurX:Number=15;
			var blurY:Number=15;
			var strength:Number=0.7;
			var inner:Boolean=true;
			var knockout:Boolean=false;
			var quality:Number=BitmapFilterQuality.HIGH;
			return new GlowFilter(color,alpha,blurX,blurY,strength,quality,inner,knockout);
		}
		
		//对一个颜色取其高亮颜色值
		/*
		protected function brightenColour(colour:int,modifier:int):int
		{
			var hex:Array=hexToRGB(colour);
			var red:int=keepInBounds(hex[0] + modifier);
			var green:int=keepInBounds(hex[1] + modifier);
			var blue:int=keepInBounds(hex[2] + modifier);
			return RGBToHex(red,green,blue);
		}
		*/
		
		/**
		 * 根据按钮flag获取显示哪些按钮的数组
		 * @param	hex
		 * @return
		 */
		protected static function ByteToArray(byte:uint):Array
		{
			var Buttons:Array = new Array ;
			Buttons.push(byte & 1);
			Buttons.push((byte & 2) >> 1);
			Buttons.push((byte & 4) >> 2);
			Buttons.push((byte & 8) >> 3);			
			return Buttons;
		}
		
		protected static function hexToRGB(hex:uint):Array
		{
			var Colours:Array=new Array  ;
			Colours.push(hex >> 16);
			var temp:uint=hex ^ Colours[0] << 16;
			Colours.push(temp >> 8);
			Colours.push(temp ^ Colours[1] << 8);
			return Colours;
		}
		
		protected function RGBToHex(uR:int,uG:int,uB:int):int
		{
			var uColor:uint;
			uColor=uR & 255 << 16;
			uColor+= uG & 255 << 8;
			uColor+= uB & 255;
			return uColor;
		}
		
		protected  function keepInBounds(number:int):int
		{
			if (number < 0)
			{
				number=0;
			}
			
			if (number > 255)
			{
				number=255;
			}
			return number;
		}
		
		protected function buttonClickHandler(event:MouseEvent):void
		{
			for (var i:int; i < allButtons.length; i++)
			{
				allButtons[i].removeEventListener(MouseEvent.CLICK, buttonClickHandler);
			}
			
			removeDragHandleer();
			this.parent.removeChild(this);
			if (closeHandler != null)
			{
				if(extendObj != null)
				{
					closeHandler(Number(event.target.name.substr(4)),extendObj);
				}
				else
				{
					closeHandler(Number(event.target.name.substr(4)));
				}
			}
		}
		
		protected function onResize(e:Event):void
		{
			if(background)
			{
				if(this.stage)
				{
					background.width = this.stage.stageWidth;
					background.height = this.stage.stageHeight;
				}
			}
		}

		public function get window():DisplayObjectContainer
		{
			return prompt;
		}

		public function get promptBackground():DisplayObject
		{
			return _promptBackground;
		}
		
		/**
		 * 根据Alert.YES,NO,OK,CANCEL四个参数返回相应按钮
		 * @param flag
		 * 
		 */		
		public function getButtonByFlag(flag:int):GButton
		{
			var button:GButton;
			for each(button in allButtons)
			{
				if(button.name == "btn_" + flag)
				{
					return button;
				}
			}
			return null;
		}
	}
}
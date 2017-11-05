package mortal.game.view.common.alertwins
{
	import com.mui.controls.Alert;
	import com.mui.controls.GAlertWin;
	import com.mui.controls.GButton;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mortal.component.window.BaseWindow;
	import mortal.component.window.SmallWindow;
	import mortal.component.window.WindowEvent;

	public class CustomAlertWin extends GAlertWin
	{
		public function CustomAlertWin(stageWidth:Number, stageHeight:Number)
		{
			super(stageWidth, stageHeight);
		}
		
		/**
		 *覆盖了上级的createPromptBoarder，自定义提示窗口的框
		 */
		override protected function createButtons():Vector.<GButton>
		{
			var allButtons:Vector.<GButton> = new Vector.<GButton>;
			var flagsList:Array = getButtonFlagsList();
			
			if (flagsList[0] == 1)
			{
				allButtons.push(CreateButton(Alert.yesLabel,Alert.YES));
			}
			
			if (flagsList[1] == 1)
			{
				allButtons.push(CreateButton(Alert.noLabel,Alert.NO));
			}
			
			if (flagsList[2] == 1)
			{
				allButtons.push(CreateButton(Alert.okLabel,Alert.OK));
			}
			
			if (flagsList[3] == 1)
			{
				allButtons.push(CreateButton(Alert.calcelLabel,Alert.CANCEL));
			}
			return allButtons;
		}
		
		private function CreateButton(label:String,iFlag:int):GButton
		{
			var btn:GButton = new GButton();
			btn.label = label;
			btn.width = Alert.buttonWidth;
			btn.height = Alert.buttonHeight;
			btn.name = "btn_" + iFlag;
			Alert.buttonStyleName = "Button";
			btn.styleName = Alert.buttonStyleName;
			return btn;
		}
		
		override protected function childrenCreated():void
		{
			if(Alert.title is String)
			{
				//(title as TextField).htmlText = Alert.title;
			}
			else
			{
				if(!Alert.title)
				{
					Alert.title = "提  示";
//					title = GlobalClass.getBitmap("Title_Tips");
				}
				else
				{
					title = Alert.title;
				}
			}
			
			message.multiline = true;
			message.htmlText = Alert.text;
			
			
			var buttonContainer:Sprite = new Sprite();
			var j:int = allButtons.length;
			for (var i:int = 0; i < j; i++)
			{
				var vButton:DisplayObject = allButtons[i];
				vButton.addEventListener(MouseEvent.CLICK,buttonClickHandler);
				buttonContainer.addChild(vButton);
				
				vButton.x = i * (Alert.buttonWidth + 25);
			}
			
			var iconAndMessage:Sprite = new Sprite();
			iconAndMessage.addChild(message);
			if (icon)
			{
				iconAndMessage.addChild(icon);
				message.x = icon.width + 15;
			}
			
			
			var vTotalBoderWidth:int = boarderWidth * 2;
			var myWidth:Number = Math.max(title.width + vTotalBoderWidth, message.width + vTotalBoderWidth + 10, buttonContainer.width + vTotalBoderWidth, minWidth);
			if(myWidth < 300)
			{
				myWidth = 300;
			}
			
			var myHeight:Number = 60 + message.height + Alert.buttonHeight + 45;
			if(myHeight < 200)
			{
				myHeight = 200;
			}
			
//			var middlePaneBg:ScaleBitmap = ResourceConst.getScaleBitmap("WindowCenterB");
//			middlePaneBg.width = myWidth - 25;
//			middlePaneBg.height = myHeight - 48;
//			middlePaneBg.x = 23;
//			middlePaneBg.y = 44;
			
			message.x = 11 + myWidth / 2 - message.width / 2;
			message.y = 55;
			buttonContainer.x = 12 + (myWidth - (Alert.buttonWidth + 25)* allButtons.length + 25) / 2;
			buttonContainer.y = myHeight - 27;//60 + message.height + 15;//message.y + message.height + 20;
			boarder.width = myWidth;
			boarder.height = 150;
			
			_promptBackground = new SmallWindow();
			(_promptBackground as SmallWindow).isForbidenDrag = true;
			(_promptBackground as SmallWindow).closeBtn.visible = false;
			
			var flagsList:Array = getButtonFlagsList();
			if(flagsList[3] == 1)
			{
				//winBg._closeBtn.visible = true;
			}
			
			prompt = new Sprite();
			prompt.addChild(_promptBackground);
//			prompt = winBg;
			title.y = 3;
//			title.y = (30 - title.height)/2 + 5;
			title.x = (myWidth - title.width)/2;
			(_promptBackground as BaseWindow).setSize(myWidth, myHeight);
			if(Alert.title is String)
			{
				(_promptBackground as BaseWindow).title = Alert.title;
			}
			
			addChild(background);
			prompt.addChild(title);
//			prompt.addChild(middlePaneBg);
			prompt.addChild(message);
			prompt.addEventListener(WindowEvent.CLOSE,Close_Handler,false,0,true);
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
				if(closeBtn == null)
				{
					closeBtn = new GButton();
				}
				
				closeBtn.styleName = "CloseButton";
				closeBtn.setSize(19,19);
				closeBtn.label = "";
				closeBtn.addEventListener(MouseEvent.CLICK,onCloseBtnClickHandler);
				prompt.addChild(closeBtn);
				
				closeBtn.x = myWidth - closeBtn.width - 8;
				closeBtn.y = 7;
			}
		}
		
		private function Close_Handler(e:Event):void
		{
			removeDragHandleer();
			if(this.parent)
			{
				this.parent.removeChild(this);
			}
		}
	}
}
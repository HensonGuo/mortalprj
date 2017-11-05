package mortal.game.view.common.alertwins
{
	import com.mui.controls.Alert;
	import com.mui.controls.GAlertWin;
	import com.mui.controls.GButton;
	import com.mui.controls.GCheckBox;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import mortal.component.window.BaseWindow;
	
	public class CheckBoxWin extends GAlertWin
	{
		protected var checkBox:GCheckBox;
		
		public function CheckBoxWin(stageWidth:Number,stageHeight:Number)
		{
			super(stageWidth,stageHeight);
		}
		
		override protected function createChildren():void
		{
//			if(Alert.title == null)
//			{
//				title = GlobalClass.getBitmap(ImagesConst.Title_Tips);
//			}
			
			super.createChildren();
			
			checkBox = new GCheckBox();
			checkBox.styleName = "GCheckBox";
			checkBox.label = Alert.checkBoxLabel;
			checkBox.textField.textColor = 0x00ff00;
			checkBox.width = 120;
			checkBox.height = 22;
		}
		
		override protected function showCloseBtn():void
		{
			
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
			
			
			var vTotalBoderWidth:int = boarderWidth * 2 + 10;
			var myWidth:Number = Math.max(title.width + vTotalBoderWidth, message.width + vTotalBoderWidth, buttonContainer.width + vTotalBoderWidth, minWidth);
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
//			middlePaneBg.width = myWidth - 34;
//			middlePaneBg.height =  myHeight - 52;
//			middlePaneBg.x = 17;
//			middlePaneBg.y = 41;
			
			message.x = 11 + myWidth / 2 - message.width / 2;
			message.y = 55;
			buttonContainer.x = 12 + (myWidth - (Alert.buttonWidth + 25)* allButtons.length + 25) / 2;
			buttonContainer.y = myHeight - 47;//60 + message.height + 10;//message.y + message.height + 20;
			boarder.width = myWidth;
			boarder.height = 130;
			
			_promptBackground = new BgWindow();
			(_promptBackground as BgWindow).isForbidenDrag = true;
			(_promptBackground as BgWindow).closeBtn.visible = false;
			
			var flagsList:Array = getButtonFlagsList();
			if(flagsList[3] == 1)
			{
				//winBg._closeBtn.visible = true;
			}
			
			prompt = new Sprite();
			prompt.addChild(_promptBackground);
			//			prompt = winBg;
//			title.y = (30 - title.height)/2;
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
			if (icon)
			{
				addChild(icon);
			}
			prompt.addChild(buttonContainer);
			addChild(prompt);
			
			prompt.addChild(checkBox);
			checkBox.x = 35;
			checkBox.y = myHeight - 20;
			
			prompt.x = (stageWidth - prompt.width) / 2;
			prompt.y = (stageHeight - prompt.height) / 2;
			
			if(Alert.showCloseBtn)
			{
				closeBtn = new GButton();
				closeBtn.styleName = "CloseButton";
				closeBtn.setSize(19,19);
				closeBtn.label = "";
				closeBtn.addEventListener(MouseEvent.CLICK,onCloseBtnClickHandler);
				prompt.addChild(closeBtn);
				
				closeBtn.x = myWidth - closeBtn.width - 8;
				closeBtn.y = 7;
			}
		}
		
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
		
		override protected function buttonClickHandler(event:MouseEvent):void
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
					closeHandler(Number(event.target.name.substr(4)),checkBox.selected,extendObj);
				}
				else
				{
					closeHandler(Number(event.target.name.substr(4)),checkBox.selected);
				}
			}
		}
		
		override protected function onCloseBtnClickHandler(event:MouseEvent):void
		{
			if(closeHandler != null)
			{
				var flagsList:Array = getButtonFlagsList();
				var flag:int = Alert.CANCEL;
				
				if(flagsList[1] == 1)
				{
					flag = Alert.NO;
				}
				
				if(flagsList[3] == 1)
				{
					flag = Alert.CANCEL;
				}
				
				if(extendObj != null)
				{
					closeHandler(flag,extendObj,checkBox.selected,true);
				}
				else
				{
					closeHandler(flag,checkBox.selected,true);
				}
				closeHandler = null;
			}
			
			super.onCloseBtnClickHandler(event);
		}
		
		private function CreateButton(label:String,iFlag:int):GButton
		{
			var btn:GButton = new GButton();
			btn.label = label;
			btn.width = Alert.buttonWidth;
			btn.height = Alert.buttonHeight;
			btn.name = "btn_" + iFlag;
			if(Alert.buttonStyleName)
			{
				btn.styleName = Alert.buttonStyleName;
				
			}
			else
			{
				btn.styleName = "Button";
			}
			return btn;
		}
		
		/**
		 * 返回某个按钮 
		 * @param name
		 * @return 
		 * 
		 */
		private function getBtnByName(name:int):GButton
		{
			var button:GButton;
			for each(button in allButtons)
			{
				if(button.name == "btn_" + name)
				{
					return button;
				}
			}
			return null;
		}
	}
}


import mortal.component.window.SmallWindow;
import mortal.mvc.interfaces.ILayer;

class BgWindow extends SmallWindow{
	public function BgWindow($layer:ILayer=null)
	{
		super($layer);
	}
	
	override protected function configParams():void
	{
		super.configParams();
		paddingBottom = 65;
	}
}
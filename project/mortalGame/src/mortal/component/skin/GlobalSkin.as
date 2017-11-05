package mortal.component.skin
{
	import com.mui.skins.SkinManager;
	
	import fl.managers.StyleManager;
	
	import mortal.component.gconst.StyleConst;
	import mortal.component.skin.Label.GLabelStyle;
	import mortal.component.skin.button.AddBtnStyle;
	import mortal.component.skin.button.ButtonNewStyle;
	import mortal.component.skin.button.ButtonSmallStyle;
	import mortal.component.skin.button.ChatButtonStyle;
	import mortal.component.skin.button.ChatTabButtonStyle;
	import mortal.component.skin.button.CloseButtonStyle;
	import mortal.component.skin.button.DownButtonStyle;
	import mortal.component.skin.button.EnterButtonStyle;
	import mortal.component.skin.button.FirstPageBtnStyle;
	import mortal.component.skin.button.GRadioButtonStyle;
	import mortal.component.skin.button.GroupButton;
	import mortal.component.skin.button.GroupInviteStyle;
	import mortal.component.skin.button.LastPageBtnStyle;
	import mortal.component.skin.button.MountBtnStyle;
	import mortal.component.skin.button.NextPageButtonStyle;
	import mortal.component.skin.button.PackButtonStyle;
	import mortal.component.skin.button.PageBtnStyle;
	import mortal.component.skin.button.PetHeadCallbackBtnStyle;
	import mortal.component.skin.button.PetHeadOutBtnStyle;
	import mortal.component.skin.button.PetHeadReliveBtnStyle;
	import mortal.component.skin.button.PrevPageButtonStyle;
	import mortal.component.skin.button.RedButtonStyle;
	import mortal.component.skin.button.TabButtonStyle;
	import mortal.component.skin.button.TabarNewStyle;
	import mortal.component.skin.button.TaskCatogeryStyle;
	import mortal.component.skin.button.TextButtonStyle;
	import mortal.component.skin.checkBox.CheckBoxStyle;
	import mortal.component.skin.combobox.GComboboxStyle;
	import mortal.component.skin.numericStepper.NumericStepperStyle;
	import mortal.component.skin.scrollBar.ScrollBarChatStyle;
	import mortal.component.skin.scrollBar.ScrollBarStyle;
	import mortal.component.skin.scrollPane.ChatScrollPaneStyle;
	import mortal.component.skin.scrollPane.ScrollPaneStyle;
	import mortal.component.skin.textArea.GTextAreaStyle;
	import mortal.component.skin.textInput.GTextInputStyle;
	import mortal.component.skin.textInput.GTextInputStyle2;
	import mortal.component.skin.textInput.NoSkinInputStyle;
	import mortal.component.skin.tileList.GTileListStyle;

	public class GlobalSkin
	{
		
		private static var _componentCss:Object={
			MountBtn:MountBtnStyle,
			AddBtn:AddBtnStyle,
			CloseButton:CloseButtonStyle,
			Button:ButtonSmallStyle,
			ButtonNew:ButtonNewStyle,
			PackButton:PackButtonStyle,
			RedButton:RedButtonStyle,
			GroupInviteButton:GroupInviteStyle,
			GroupButton:GroupButton,
			PageBtn:PageBtnStyle,
			TabButton:TabButtonStyle,
			TabButtonNew:TabarNewStyle,
			EnterButton:EnterButtonStyle,
			ChatTabBtn:ChatTabButtonStyle,
			ChatBtn:ChatButtonStyle,
			GComboboxStyle:GComboboxStyle,
			GCheckBox:CheckBoxStyle,
			GLabel:GLabelStyle,
			TileList:GTileListStyle,			//tileList
			NumericStepper:NumericStepperStyle,
			GTextInput:GTextInputStyle,    //公共输入框样式 
			GTextInput2:GTextInputStyle2,  //公共输入框样式2
			NoSkinInput:NoSkinInputStyle,  //透明背景样式
			NextPageButton:NextPageButtonStyle,//下一页按钮样式
			PrevPageButton:PrevPageButtonStyle,//上一页按钮样式
			
			FirstPageButton:FirstPageBtnStyle,//第一页按钮样式
			LastPageButton:LastPageBtnStyle,//最后一页按钮样式
			GScrollPane:ScrollPaneStyle,
			chatScrollPane:ChatScrollPaneStyle,
			ScrollBarNormal:ScrollBarStyle,				//滚动条
			ScrollBarChat:ScrollBarChatStyle,			//聊天滚动条
			GRadioButton:GRadioButtonStyle,
			GTextArea:GTextAreaStyle,					//文本框
			TextButton:TextButtonStyle,					//文本按钮
			DownButton:DownButtonStyle,				//下拉按钮
			TaskCatogeryBtn:TaskCatogeryStyle,  // 任务面板的栏目（主线、直线）
			
			PetHeadCallbackBtn:PetHeadCallbackBtnStyle,
			PetHeadOutBtn:PetHeadOutBtnStyle,
			PetHeadReliveBtn:PetHeadReliveBtnStyle
		}
		
		public function GlobalSkin()
		{
			
		}
		
		public static function initStyleSkin():void
		{
			StyleManager.setStyle("textFormat", StyleConst.defaultTextFormat);
			registerSkin(_componentCss);
		}
		
		public static function registerSkin( skinObject:Object ):void
		{
			for( var key:String in skinObject  )
			{
				SkinManager.addStyleSkin( key , skinObject[key] );
			}
		}
	}
}
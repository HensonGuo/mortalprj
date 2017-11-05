package mortal.game.view.common
{
	import com.gengine.core.IDispose;
	import com.gengine.resource.LoaderManager;
	import com.gengine.resource.info.ImageInfo;
	import com.gengine.utils.pools.ObjectPool;
	import com.mui.controls.GBitmap;
	import com.mui.controls.GButton;
	import com.mui.controls.GCheckBox;
	import com.mui.controls.GComboBox;
	import com.mui.controls.GImageBitmap;
	import com.mui.controls.GLabel;
	import com.mui.controls.GLoadedButton;
	import com.mui.controls.GLoadingButton;
	import com.mui.controls.GNumericStepper;
	import com.mui.controls.GRadioButton;
	import com.mui.controls.GScrollPane;
	import com.mui.controls.GSprite;
	import com.mui.controls.GTabBar;
	import com.mui.controls.GTextArea;
	import com.mui.controls.GTextFiled;
	import com.mui.controls.GTextInput;
	import com.mui.controls.GTileList;
	import com.mui.core.GlobalClass;
	import com.mui.display.ScaleBitmap;
	import com.mui.events.MuiEvent;
	import com.mui.utils.UICompomentPool;
	
	import fl.controls.ScrollBarDirection;
	import fl.controls.ScrollPolicy;
	import fl.data.DataProvider;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import mortal.common.GTextFormat;
	import mortal.common.font.FontUtil;
	import mortal.common.global.GlobalStyle;
	import mortal.common.label.PriceLabel;
	import mortal.component.gconst.FilterConst;
	import mortal.component.gconst.ResourceConst;
	import mortal.component.processbar.PointProcessBar;
	import mortal.component.skin.combobox.comboboxSkin.ComboboxCellRenderer;
	import mortal.component.ui.GConsumeBox;
	import mortal.game.resource.ImagesConst;
	import mortal.game.resource.info.item.ItemData;
	import mortal.game.view.common.button.GLabelButton;
	import mortal.game.view.common.button.SortButton;
	import mortal.game.view.common.button.TimeButton;
	import mortal.game.view.common.display.BitmapNumberText;
	import mortal.game.view.common.item.BaseItem;
	import mortal.game.view.common.pageSelect.PageSelecter;
	import mortal.game.view.wizard.GTabarNew;
	
	public class UIFactory
	{
		public static function sprite(x:Number = 0,y:Number = 0,parent:DisplayObjectContainer = null):Sprite
		{
			var sp:Sprite = UICompomentPool.getUICompoment(Sprite) as Sprite;
			sp.x = x;
			sp.y = y;
			if(parent)
			{
				parent.addChild(sp);
			}
			return sp;
		}
		
		public static function getUICompoment(type:Class,x:Number = 0,y:Number = 0,parent:DisplayObjectContainer = null):*
		{
			var sp:* = UICompomentPool.getUICompoment(type) as type;
			sp.x = x;
			sp.y = y;
			if(parent)
			{
				parent.addChild(sp);
			}
			return sp;
		}
		
		/**
		 * 创建一个textField 
		 * @param text
		 * @param x
		 * @param y
		 * @param width
		 * @param height
		 * @param parent
		 * @param textFormat
		 * @return 
		 * 
		 */		
		public static function textField(text:String = "",x:int = 0,y:int = 0,width:int = 220,height:int = 20,parent:DisplayObjectContainer = null,textFormat:TextFormat = null,useHtml:Boolean=false,mouseWheelEnabled:Boolean=true):GTextFiled
		{
			return UIFactory.gTextField(text,x,y,width,height,parent,textFormat,useHtml,mouseWheelEnabled);
		}
		
		/**
		 * 创建一个textField 
		 * @param text
		 * @param x
		 * @param y
		 * @param width
		 * @param height
		 * @param parent
		 * @param textFormat
		 * @return 
		 * 
		 */		
		public static function gTextField(text:String = "",x:int = 0,y:int = 0,width:int = 220,height:int = 20,parent:DisplayObjectContainer = null,textFormat:TextFormat = null,useHtml:Boolean=false,mouseWheelEnabled:Boolean=true):GTextFiled
		{
			var textField:GTextFiled = UICompomentPool.getUICompoment(GTextFiled) as GTextFiled;
			textField.defaultTextFormat = textFormat?textFormat:GlobalStyle.textFormatPutong;
			textField.x = x;
			textField.y = y;
			if(useHtml){
				textField.htmlText = text;
			}else{
				textField.text = text;
			}
			
			if(height > 0)
			{
				textField.height = height;
			}
			if(width > 0)
			{
				textField.width = width;
			}
			textField.selectable = false;
			textField.multiline = false;
			textField.wordWrap = false;
			textField.embedFonts = false;
			textField.filters = [FilterConst.glowFilter];
			if(parent)
			{
				parent.addChild(textField);
			}
			if(!mouseWheelEnabled)
			{
				textField.mouseWheelEnabled=false;
			}
			
			
			return textField;
		}
		
		public static function textArea(text:String = "",x:int = 0,y:int = 0,width:int = 300,height:int = 300,parent:DisplayObjectContainer = null,styleName:String = "GTextArea"):GTextArea
		{
			var textArea:GTextArea = UICompomentPool.getUICompoment(GTextArea) as GTextArea;
			textArea.x = x;
			textArea.y = y;
			textArea.width = width;
			textArea.height = height;
			textArea.wordWrap = true;
			textArea.editable = false;
			textArea.verticalScrollPolicy = ScrollPolicy.AUTO;
			textArea.horizontalScrollPolicy = ScrollPolicy.OFF;
			if(parent)
			{
				parent.addChild(textArea);
			}
			textArea.styleName = styleName;
			return textArea;
		}
		
		/**
		 * 创建嵌入字的textField 
		 * @param text
		 * @param x
		 * @param y
		 * @param width
		 * @param height
		 * @param parent
		 * 
		 */		
		public static function embedTextFiled(text:String,x:int = 0,y:int = 0,width:int = 220,height:int = 20,parent:DisplayObjectContainer = null,textformat:TextFormat = null):GTextFiled
		{
			var textField:GTextFiled = UICompomentPool.getUICompoment(GTextFiled) as GTextFiled;
			textField.x = x;
			textField.y = y;
			textField.height = height;
			textField.width = width;
			textField.multiline = false;
			textField.wordWrap = false;
			textField.embedFonts = true;
			textField.mouseEnabled = false;
			textField.autoSize = TextFieldAutoSize.NONE;
			textField.filters = [FilterConst.glowFilter];
			if(parent)
			{
				parent.addChild(textField);
			}
			if(textformat)
			{
				textField.defaultTextFormat = textformat;
			}
			else
			{
				textField.defaultTextFormat = GlobalStyle.embedNumberTf;
			}
			textField.text = text;
			return textField;
		}
		
		/**
		 * 创建自动更改大小的GTextFile， 可以用在父容器为UIComponent可实现自动调整距离
		 * @param text
		 * @param mx
		 * @param my
		 * @param mwidth
		 * @param container
		 * @param autoStr
		 * @return 
		 * 
		 */			
		public static function autoSizeGTextFiled(text:String, mx:int, my:int, mwidth:int, container:DisplayObjectContainer, autoStr:String=TextFieldAutoSize.LEFT, leading:int=3):GTextFiled
		{
			var res:GTextFiled = UIFactory.gTextField(text, mx, my, mwidth, 14, container);
			res.wordWrap = true;
			res.multiline = true;
			res.autoSize = autoStr;
			res.mouseEnabled = false;
			res.mouseWheelEnabled = false;
			
			var tf:TextFormat = res.defaultTextFormat;
			tf.leading = leading;
			res.defaultTextFormat = tf;
			
			return res;
		}
		
		/**
		 * 创建一个Gbutton 
		 * @param label
		 * @param x
		 * @param y
		 * @param width
		 * @param height
		 * @param parent
		 * @param styleName
		 * @return 
		 * 
		 */		
		public static function gButton(label:String,x:int = 0,y:int = 0,width:int = 49,height:int = 22,parent:DisplayObjectContainer = null,styleName:String = "Button"):GButton
		{
			var button:GButton = UICompomentPool.getUICompoment(GButton) as GButton;
			button.styleName = styleName;
			button.x = x;
			button.y = y;
			button.enabled = true;
			button.setSize(width, height);
			
			button.textField.filters = [FilterConst.glowFilter];
			button.label = label;
			if(parent)
			{
				parent.addChild(button);
			}
			return button;
		}
		
		/**
		 * 创建一个以美术字作为label的按钮 ， 在下载完资源后， 自己设置label为资源名字
		 * @param type 参考GLabelButton中的枚举
		 * @param buttonStyle 按钮的皮肤， 根据GButton，GloadedButton，GLoadingButton不同而不同
		 * @param x 
		 * @param y
		 * @param width
		 * @param height
		 * @param parent
		 * @return 
		 * 
		 */		
		public static function gLabelButton(labelResName:String=null,type:int=0, buttonStyle:String="GButton", x:int = 0, y:int = 0,
			width:int = 60,height:int = 22, parent:DisplayObjectContainer = null):GLabelButton
		{
			var button:GLabelButton = UICompomentPool.getUICompoment(GLabelButton) as GLabelButton;
			button.setParams(labelResName, type, buttonStyle, width, height);
			button.x = x;
			button.y = y;
			if(parent)
			{
				parent.addChild(button);
			}
			return button;
		}
		
		/**
		 *  
		 * @param label
		 * @param x
		 * @param y
		 * @param width
		 * @param height
		 * @param parent
		 * @param cacheName 需要缓存CD时间的话，设置自己的cacheName(例如背包的整理功能，需要提供一个CacheName), 否则null就可以
		 * @param styleName
		 * @return 
		 * 
		 */		
		public static function timeButton(label:String,x:int = 0,y:int = 0,width:int = 49,height:int = 28,
			parent:DisplayObjectContainer = null, cacheName:String = null, styleName:String = "Button"):TimeButton
		{
			var button:TimeButton = UICompomentPool.getUICompoment(TimeButton) as TimeButton;
			button.styleName = styleName;
			button.x = x;
			button.y = y;
			button.cacheName = cacheName;
			
			button.setSize(width, height);
			
			button.textField.filters = [FilterConst.glowFilter];
			button.label = label;
			if(parent)
			{
				parent.addChild(button);
			}
			return button;
		}
		
		/**
		 * 创建带倒计时的按钮 
		 * @param label
		 * @param x
		 * @param y
		 * @param width
		 * @param height
		 * @param parent
		 * @param styleName
		 * @return 
		 * 
		 */		
		public static function secTimerButton(label:String,x:int = 0,y:int = 0,width:int = 49,height:int = 28,
													parent:DisplayObjectContainer = null, styleName:String = "Button"):SecTimerButton
		{
			var button:SecTimerButton = UICompomentPool.getUICompoment(SecTimerButton) as SecTimerButton;
			button = new SecTimerButton();
			button.styleName = styleName;
			button.x = x;
			button.y = y;
			button.setSize(width, height);
			button.label = label;
			if(parent != null)
			{
				parent.addChild(button);
			}
			return button;
		}
		
		/**
		 * 创建一个帮你加载资源的按钮
		 * @param btnName
		 * @return 
		 * 
		 */
		public static function gLoadingButton(styleName:String = "",x:Number = 0,y:Number = 0,width:Number = -1,height:Number = -1,parent:DisplayObjectContainer = null):GLoadingButton
		{
			var btn:GLoadingButton = UICompomentPool.getUICompoment(GLoadingButton) as GLoadingButton;
			var t:String = styleName.replace("_upSkin", "");
			var rect:Rectangle = ResourceConst._scaleMap[t] as Rectangle;
			if(rect != null)
			{
				btn.my9Gride = rect;
			}
			btn.styleName = styleName;
			btn.label = "";
			btn.x = x;
			btn.y = y;
			if(width > 0)
			{
				btn.width = width;	
			}
			if(height > 0)
			{
				btn.height = height;
			}
			if(parent)
			{
				parent.addChild(btn);
			}
			return btn;
		}
		
		/**
		 * 创建一个先加载完资源才能使用的按钮
		 * @param btnName
		 * @return 
		 * 
		 */
		public static function gLoadedButton(styleName:String = "",x:Number = 0,y:Number = 0,width:Number = -1,height:Number = -1,parent:DisplayObjectContainer = null):GLoadedButton
		{
			var btn:GLoadedButton = UICompomentPool.getUICompoment(GLoadedButton) as GLoadedButton;
			var t:String = styleName.replace("_upSkin", "");
			var rect:Rectangle = ResourceConst._scaleMap[t] as Rectangle;
			if(rect != null)
			{
				btn.my9Gride = rect;
			}
			btn.styleName = styleName;
			btn.label = "";
			btn.x = x;
			btn.y = y;
			if(width > 0)
			{
				btn.width = width;	
			}
			if(height > 0)
			{
				btn.height = height;
			}
			if(parent)
			{
				parent.addChild(btn);
			}
			return btn;
		}
		
		/**
		 * 创建一个GTextInput 
		 * @param x
		 * @param y
		 * @param width
		 * @param height
		 * @param parent
		 * @param styleName
		 * @return 
		 * 
		 */		
		public static function gTextInput(x:int = 0,y:int = 0,width:int = 220,height:int = 20,parent:DisplayObjectContainer = null,styleName:String = "GTextInput"):GTextInput
		{
			var textInput:GTextInput = UICompomentPool.getUICompoment(GTextInput);
			textInput.x = x;
			textInput.y = y;
			textInput.width = width;
			textInput.height = height;
			textInput.restrict = null;
			textInput.maxChars = 999999999;
			textInput.textField.filters = [FilterConst.glowFilter];
			textInput.styleName = styleName;
			textInput.setStyle("textFormat" , GlobalStyle.textFormatBai );
			textInput.mouseEnabled = true;
			textInput.editable = true;
			textInput.textField.wordWrap = true;
			textInput.drawNow();
			if(parent)
			{
				parent.addChild(textInput);
			}
			return textInput;
		}
		
		/**
		 * 创建背景  scaleBitmap
		 * @param x
		 * @param y
		 * @param width
		 * @param height
		 * @param parent
		 * @param bgName
		 * @return 
		 * 
		 */		
		public static function bg(x:int = 0,y:int = 0,width:int = -1,height:int = -1,parent:DisplayObjectContainer = null,bgName:String = "WindowCenterB"):ScaleBitmap
		{
			var bg:ScaleBitmap = ResourceConst.getScaleBitmap(bgName);
			bg.x = x;
			bg.y = y;
			if(width != -1)
			{
				bg.width = width;
			}
			if(height != -1)
			{
				bg.height = height;
			}
			if(parent)
			{
				parent.addChild(bg);
			}
			return bg;
		}
		
		public static function label(htmlText:String,x:int,y:int,width:int = 100,height:int = 25,
										   align:String = TextFormatAlign.LEFT, parent:DisplayObjectContainer = null,
										   boarder:Boolean = false, defaultColor:Number = 0xFFFFFF):GLabel
		{
			var lb:GLabel = UICompomentPool.getUICompoment(GLabel) as GLabel;
			lb.x = x;
			lb.y = y;
			lb.setSize(width, height);
			
			var tf:TextFormat = lb.textField.defaultTextFormat;
			tf.align = align;
			tf.color = defaultColor;
			tf.size = 12;
			lb.setStyle("textFormat", tf);
			lb.htmlText = htmlText;
			lb.mouseChildren = false;
			lb.mouseEnabled = false;
			lb.textField.filters = null;
			
			if(boarder)
			{
				lb.filters = [FilterConst.glowFilter];
			}
			
			if(parent)
			{
				parent.addChild(lb);
			}
			return lb;
		}
		
		public static function priceLabel(htmlText:String,x:int,y:int,width:int = 100,height:int = 25,
												align:String = TextFormatAlign.LEFT, parent:DisplayObjectContainer = null,
												boarder:Boolean = false, defaultColor:Number = 0xFFFFFF):PriceLabel
		{
			var lb:PriceLabel = UICompomentPool.getUICompoment(PriceLabel) as PriceLabel;
			lb.x = x;
			lb.y = y;
			lb.setSize(width, height);
			
			var tf:TextFormat = lb.textField.defaultTextFormat;
			tf.align = align;
			tf.color = defaultColor;
			lb.setStyle("textFormat", tf);
			lb.htmlText = htmlText;
			
			if(boarder)
			{
				lb.filters = [FilterConst.glowFilter];
			}
			
			if(parent)
			{
				parent.addChild(lb);
			}
			return lb;
		}
		
		/**
		 * 创建一个checkBox 
		 * @param label
		 * @param x
		 * @param y
		 * @param width
		 * @param height
		 * @param parent
		 * @param styleName
		 * @return 
		 * 
		 */		
		public static function checkBox(label:String,x:int = 0,y:int = 0,width:int = 100,height:int = 28,parent:DisplayObjectContainer = null,styleName:String = "GCheckBox"):GCheckBox
		{
			var cb:GCheckBox = UICompomentPool.getUICompoment(GCheckBox) as GCheckBox;
			cb.label = label;
			cb.x = x;
			cb.y = y;
			cb.setSize(width, height);
			if(parent)
			{
				parent.addChild(cb);
			}
			cb.styleName = styleName;
			return cb;
		}
		
		/**
		 * 创建一个radionButton
		 * @param label
		 * @param x
		 * @param y
		 * @param width
		 * @param height
		 * @param parent
		 * @param styleName
		 * @return 
		 * 
		 */		
		public static function radioButton(label:String,x:int = 0,y:int = 0,width:int = 100,height:int = 28,parent:DisplayObjectContainer = null,styleName:String = "GRadioButton"):GRadioButton
		{
			var rb:GRadioButton = UICompomentPool.getUICompoment(GRadioButton) as GRadioButton;
			rb.label = label;
			rb.x = x;
			rb.y = y;
			rb.setSize(width, height);
			if(parent)
			{
				parent.addChild(rb);
			}
			rb.styleName = styleName;
			return rb;
		}
		
		/**
		 * 创建一个GTileList 
		 * @param x
		 * @param y
		 * @param width
		 * @param height
		 * @param parent
		 * @param styleName
		 * @return 
		 * 
		 */		
		public static function tileList(x:int = 0,y:int = 0,width:int = 100,height:int = 100,parent:DisplayObjectContainer = null,styleName:String = "TileList"):GTileList
		{
			var tl:GTileList = UICompomentPool.getUICompoment(GTileList) as GTileList;
			tl.scrollPolicy = ScrollPolicy.AUTO;
			tl.direction = ScrollBarDirection.VERTICAL;			
			tl.styleName = styleName;
			tl.setStyle("skin",new Bitmap());
			tl.horizontalGap = 0;
			tl.verticalGap = 0;
			tl.move(x,y);
			tl.setSize(width, height);
			if(parent)
			{
				parent.addChild(tl);
			}
			return tl;
		}
		
		public static function gScrollPanel(x:int = 0,y:int = 0,width:int = 100,height:int = 100,parent:DisplayObjectContainer = null,styleName:String = "GScrollPane"):GScrollPane
		{
			var _pane:GScrollPane = new GScrollPane();
			_pane.styleName = styleName;
			_pane.verticalScrollPolicy = ScrollPolicy.AUTO;
			_pane.horizontalScrollPolicy = ScrollPolicy.OFF;
			_pane.setStyle("skin",new Bitmap());
			_pane.move(x,y);
			_pane.setSize(width, height);
			_pane.scrollDrag = false;
			_pane.focusEnabled = false;
			if(parent)
			{
				parent.addChild(_pane);
			}
			return _pane;
		}
		
		public static function pageSelecter(x:int = 0,y:int = 0,parent:DisplayObjectContainer = null,mode:String = "简单状态"):PageSelecter
		{
			var pageSelecter:PageSelecter = UICompomentPool.getUICompoment(PageSelecter) as PageSelecter;
			pageSelecter.createDisposedChildren();
			pageSelecter.x = x;
			pageSelecter.y = y;
			if(parent)
			{
				parent.addChild(pageSelecter);
			}
			pageSelecter.mode = mode;
			return pageSelecter;
		}
		
		public static function sortButton(x:int = 0,y:int = 0,parent:DisplayObjectContainer = null,mode:int = 1):SortButton
		{
			var sortBtn:SortButton = UICompomentPool.getUICompoment(SortButton) as SortButton;
			sortBtn.createDisposedChildren();
			sortBtn.x = x;
			sortBtn.y = y;
			if(parent)
			{
				parent.addChild(sortBtn);
			}
			sortBtn.mode = mode;
			return sortBtn;
		}
		
		/**
		 * 创建一个带有横幅和地图的sprite titleText为""时不创建标题，否则添加标题
		 * @param titleText
		 * @return 
		 * 
		 */		
		public static function spBannerAndBg(x:int = 0,y:int = 0,width:Number = 200,height:Number = 200,titleText:String = "",parent:DisplayObjectContainer = null,tfTitle:TextFormat = null):Sprite
		{
			var sp:Sprite = UIFactory.sprite();
			sp.mouseEnabled = false;
			UIFactory.bg(0,0,width,height,sp);
			UIFactory.bg(-1,-3,width + 4,35,sp,"RbListHeader");
			
			if(titleText)
			{
				if(!tfTitle)
				{
					tfTitle = new GTextFormat(FontUtil.songtiName,14,0xf0ea3f);
					tfTitle.align = TextFormatAlign.CENTER;
				}
				var tf:TextField = UIFactory.textField("",0,5,width,20,sp,tfTitle);
				tf.htmlText = titleText;
			}
			sp.x = x;
			sp.y = y;
			if(parent)
			{
				parent.addChild(sp);
			}
			return sp;
		}
		
		/**
		 * 创建一个图片 
		 * @param bmpName
		 * @param x
		 * @param y
		 * @param parent
		 * @return 
		 * 
		 */		
		public static function bitmap(bmpName:String = "",x:Number = 0,y:Number = 0,parent:DisplayObjectContainer = null):GBitmap
		{
			var bmp:GBitmap;
			if(bmpName)
			{
				bmp = GlobalClass.getBitmap(bmpName);
			}
			else
			{
				bmp = UICompomentPool.getUICompoment(GBitmap) as GBitmap;
			}
			setObjAttri(bmp,x,y,-1,-1,parent);
			return bmp;
		}
		
		public static function disposeBitmap(bitmap:Bitmap,isReuse:Boolean = true):void
		{
			if(bitmap)
			{
				if(bitmap is ScaleBitmap)
				{
					(bitmap as ScaleBitmap).dispose(isReuse);
				}
				else
				{
					bitmap.x = 0;
					bitmap.y = 0;
					bitmap.bitmapData = null;
					if(isReuse)
					{
						UICompomentPool.disposeUICompoment(bitmap);
					}
				}
			}
		}
		
		/**
		 * 创建一个图片 
		 * @param bmpName
		 * @param x
		 * @param y
		 * @param parent
		 * @return 
		 * 
		 */		
		public static function gBitmap(bmpName:String,x:Number = 0,y:Number = 0,parent:DisplayObjectContainer = null):GBitmap
		{
			var bmp:GBitmap;
			if(bmpName)
			{
				bmp = GlobalClass.getBitmap(bmpName);
			}
			else
			{
				bmp = UICompomentPool.getUICompoment(GBitmap) as GBitmap;
			}
			setObjAttri(bmp,x,y,-1,-1,parent);
			return bmp;
		}
		
		public static function disposeGBitmap(bitmap:GBitmap,isReuse:Boolean = true):void
		{
			if(bitmap)
			{
				bitmap.x = 0;
				bitmap.y = 0;
				bitmap.bitmapData = null;
				if(isReuse)
				{
					UICompomentPool.disposeUICompoment(bitmap);
				}
			}
		}
		
		/**
		 * 创建一个通过加载得到的图片 
		 * @param url
		 * @param x
		 * @param y
		 * @param parent
		 * @return 
		 * 
		 */		
		public static function loadedBitmap(url:String,x:Number = 0,y:Number = 0,parent:DisplayObjectContainer = null):Bitmap
		{
			var bmp:Bitmap = UICompomentPool.getUICompoment(Bitmap);
			setObjAttri(bmp,x,y,-1,-1,parent);
			LoaderManager.instance.load(url,onloaded);
			
			function onloaded(imageInfo:ImageInfo):void
			{
				bmp.bitmapData = imageInfo.bitmapData;
			}
			return bmp;
		}
		
		/**
		 * 创建一个通过加载得到的图片 
		 * @param url
		 * @param x
		 * @param y
		 * @param parent
		 * @return 
		 * 
		 */
		public static function gImageBitmap(url:String,x:Number = 0,y:Number = 0,parent:DisplayObjectContainer = null):GImageBitmap
		{
			var ibmp:GImageBitmap = UICompomentPool.getUICompoment(GImageBitmap);
			ibmp.imgUrl = url;
			setObjAttri(ibmp,x,y,-1,-1,parent);
			return ibmp;
		}
		
		/**
		 * 创建一个填充了颜色的sprite 
		 * @param width
		 * @param height
		 * @param color
		 * @param alpha
		 * @return 
		 * 
		 */
		public static function colorBox(width:Number, height:Number, color:int = 0xFF0000, alpha:Number = 1):Sprite
		{
			var sp:Sprite = UICompomentPool.getUICompoment(Sprite) as Sprite;
			sp.graphics.beginFill(color, alpha);
			sp.graphics.drawRect(0,0,width,height);
			sp.graphics.endFill();
			sp.cacheAsBitmap = true;
			return sp;
		}
		
		/**
		 * 释放一个Sprite 
		 * @param sp
		 * 
		 */
		public static function disposeSprite(sp:Sprite):void
		{
			var length:int = sp.numChildren;
			for(var i:int = length - 1; i >= 0;i--)
			{
				var displayObj:DisplayObject = sp.getChildAt(i);
				sp.removeChildAt(i);
				if(displayObj is IDispose)
				{
					(displayObj as IDispose).dispose();
				}
			}
			if(sp.parent)
			{
				sp.parent.removeChild(sp);
			}
			UICompomentPool.disposeUICompoment(sp);
		}
		
		/**
		 * 创建标题的textField
		 * 
		 */		
		public static function titleTextField(text:String,textFormat:TextFormat = null):GTextFiled
		{
			var textField:GTextFiled = UICompomentPool.getUICompoment(GTextFiled) as GTextFiled;
			textField.defaultTextFormat = textFormat?textFormat:GlobalStyle.windowTitle2;
			textField.filters = [FilterConst.titleFilter,FilterConst.titleShadowFilter];
			textField.selectable = false;
			textField.mouseEnabled = false;
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.htmlText = text;
			return textField;
		}
		
		/**
		 * 创建嵌入字体的textField 
		 * @param text
		 * @param textFormat
		 * @return 
		 * 
		 */		
		public static function embedTitleTextField(htmlText:String):GTextFiled
		{
			var titleLabel:GTextFiled = UICompomentPool.getUICompoment(GTextFiled) as GTextFiled;
			titleLabel.mouseEnabled = false;
			titleLabel.embedFonts = true;
			titleLabel.defaultTextFormat = GlobalStyle.windowTitle;
			titleLabel.selectable = false;
			titleLabel.filters = [FilterConst.titleFilter,FilterConst.titleShadowFilter];
			titleLabel.autoSize = TextFieldAutoSize.LEFT;
			titleLabel.htmlText = htmlText;
			return titleLabel;
		}
		
		/**
		 * 给一个显示对象调整位置大小父对象 
		 * @param obj
		 * @param x
		 * @param y
		 * @param width
		 * @param height
		 * @param parent
		 * 
		 */		
		public static function setObjAttri(obj:DisplayObject,x:Number = 0,y:Number = 0,width:Number = -1,height:Number = -1,parent:DisplayObjectContainer = null):void
		{
			obj.x = x;
			obj.y = y;
			if(width > 0)
			{
				obj.width = width;
			}
			if(height > 0)
			{
				obj.height = height;
			}
			if(parent)
			{
				parent.addChild(obj);
			}
		}
		
		/**
		 *创建标签页 
		 * @param x
		 * @param y
		 * @param tabData
		 * @param buttonWidth
		 * @param height
		 * @param parent
		 * @param onTabBarChangeHandler
		 * @return 
		 * 
		 */		
		public static function gTabBar(x:int,y:int,tabData:Array,buttonWidth:int = 63,height:int = 22,parent:DisplayObjectContainer = null,onTabBarChangeHandler:Function=null,btnStyleName:String = "TabButton"):GTabBar
		{
			var tabBar:GTabBar = UICompomentPool.getUICompoment(GTabBar) as GTabBar;
			tabBar.x = x;
			tabBar.y = y;
			tabBar.buttonWidth = buttonWidth;
			tabBar.buttonStyleName = btnStyleName;
			tabBar.buttonHeight = height;
			tabBar.horizontalGap=2;
			tabBar.buttonFilters=[FilterConst.glowFilter];
			tabBar.dataProvider = tabData;
			if(onTabBarChangeHandler != null)
			{
				tabBar.configEventListener(MuiEvent.GTABBAR_SELECTED_CHANGE, onTabBarChangeHandler);
			}
			if(parent != null)
			{
				parent.addChild(tabBar);
			}
			return tabBar;
		}
		
		public static function gTabBarNew(x:int,y:int,tabData:Array,totalWidth:int,buttonWidth:int = 63,height:int = 22,parent:DisplayObjectContainer = null,onTabBarChangeHandler:Function=null,btnStyleName:String = "TabButton"):GTabarNew
		{
			var tabBar:GTabarNew = UICompomentPool.getUICompoment(GTabarNew) as GTabarNew;
			var aa:Boolean = tabBar.hasEventListener("GTABBAR_SELECTED_CHANGE");
			tabBar.setWidth(totalWidth);
			tabBar.x = x;
			tabBar.y = y;
			tabBar.dataProvider = tabData;
			tabBar.buttonWidth = buttonWidth;
			tabBar.buttonStyleName = btnStyleName;
			tabBar.buttonHeight = height;
			tabBar.horizontalGap=2;
			tabBar.buttonFilters=[FilterConst.glowFilter];
			if(onTabBarChangeHandler != null)
			{
				tabBar.configEventListener(MuiEvent.GTABBAR_SELECTED_CHANGE, onTabBarChangeHandler);
			}
			if(parent != null)
			{
				parent.addChild(tabBar);
			}
			return tabBar;
		}
		
		/**
		 *创建下拉框 
		 * @param x
		 * @param y
		 * @param width
		 * @param height
		 * @param dp
		 * @param parent
		 * @param styleName
		 * @return 
		 * 
		 */		
		public static function gComboBox(x:int,y:int,width:int = 100,height:int = 20,dp:DataProvider = null,parent:DisplayObjectContainer = null,styleName:String = "GComboboxStyle"):GComboBox
		{
			var comboBox:GComboBox = UICompomentPool.getUICompoment(GComboBox) as GComboBox;
			comboBox.move(x,y);
			comboBox.width = width;
			comboBox.height = height;
			comboBox.buttonMode = true;
			comboBox.styleName = styleName;
			comboBox.setStyle("textPadding",0);
			comboBox.drawNow();
			comboBox.dropdown.setStyle("skin",ResourceConst.getScaleBitmap(ImagesConst.ComboBg));
			comboBox.textField.setStyle("textFormat", new GTextFormat("", 12, 0xb1effc,false,false,false,"","",TextFormatAlign.CENTER));
			if(dp)
			{
				comboBox.dataProvider = dp;
			}
			comboBox.selectedIndex = 0;
			if(parent != null)
			{
				parent.addChild(comboBox);
			}
			comboBox.dropdown.setStyle("cellRenderer" , ComboboxCellRenderer);
			return comboBox;
		}
	
		public static function gNumericStepper(x:int, y:int, width:int = 49, height:int = 22, parent:DisplayObjectContainer = null, max:int = 99, min:int = 1, styleName:String = "NumericStepper",textFromat:GTextFormat = null,style:String = "SetMaxNum"):GNumericStepper
		{
			var numstep:GNumericStepper = UICompomentPool.getUICompoment(GNumericStepper) as GNumericStepper;
			numstep.style = style;
			numstep.move(x,y);
			numstep.setSize(width,height);
			numstep.styleName = styleName;
			numstep.drawNow();
//			numstep.textField.setStyle("upSkin", ResourceConst.getScaleBitmap(textBgStyleName));
			numstep.textField.setStyle("textFormat", textFromat);
			numstep.textField.drawNow();
			numstep.maximum = max;
			numstep.minimum = min;
			
			if(parent)
			{
				parent.addChild(numstep);
			}
			
			return numstep;
		}
		
		/**
		 *创建数字输入选择框 
		 * @param x
		 * @param y
		 * @param parent
		 * @param minNum
		 * @param maxNum
		 * 
		 */		
		public static function numInput(x:int,y:int,parent:DisplayObjectContainer = null,minNum:int=1,maxNum:int=99):NumInput
		{
			var numInput:NumInput =  UICompomentPool.getUICompoment(NumInput) as NumInput;
			numInput.x = x;
			numInput.y = y;
			numInput.maxNum = maxNum;
			numInput.minNum = minNum;
			if(parent)
			{
				parent.addChild(numInput);
			}
			return numInput;
		}
		
		/**
		 * 创建倒计时视图 
		 * @param parse
		 * @param x
		 * @param y
		 * @param width
		 * @param height
		 * @param parent
		 * @return 
		 * 
		 */
		public static function secTimeView(parse:String = "mm:ss",x:Number = 0,y:Number = 0,width:Number = 200,height:Number = 20,parent:DisplayObjectContainer = null,textFormat:TextFormat = null):SecTimerView
		{
			var secTimeView:SecTimerView = UICompomentPool.getUICompoment(SecTimerView) as SecTimerView;
			secTimeView.setParse(parse);
			secTimeView.selectable = false;
			secTimeView.mouseEnabled = false;
			if(textFormat)
			{
				secTimeView.defaultTextFormat = textFormat;
			}
			else
			{
				secTimeView.defaultTextFormat = GlobalStyle.textFormatPutong;
			}
			UIFactory.setObjAttri(secTimeView,x,y,width,height,parent);
			return secTimeView;
		}
		
		/**
		 * 创建计时视图 
		 * @param parse
		 * @param x
		 * @param y
		 * @param width
		 * @param height
		 * @param parent
		 * @return 
		 * 
		 */
		public static function secTimeCountView(parse:String = "mm:ss",x:Number = 0,y:Number = 0,
				width:Number = 200,height:Number = 20, parent:DisplayObjectContainer = null,
				textFormat:TextFormat = null):SecTimerCountView
		{
			var secTimeView:SecTimerCountView = UICompomentPool.getUICompoment(SecTimerCountView) as SecTimerCountView;
			secTimeView.setParse(parse);
			secTimeView.selectable = false;
			secTimeView.mouseEnabled = false;
			UIFactory.setObjAttri(secTimeView,x,y,width,height,parent);
			if(textFormat)
			{
				secTimeView.defaultTextFormat = textFormat;
			}
			return secTimeView;
		}
		
		/**
		 * 物品的基础类 
		 * @param itemData 可以是itemCode也可以是ItemData， new ItemData(code)
		 * @param x
		 * @param y
		 * @param width
		 * @param height
		 * @param parent
		 * @return 
		 * 
		 */		
		public static function baseItem(x:int, y:int, width:int, height:int, parent:DisplayObjectContainer=null, itemData:*=null):BaseItem
		{
			var res:BaseItem = UICompomentPool.getUICompoment(BaseItem) as BaseItem;
			res.x = x;
			res.y = y;
			res.width = width;
			res.height = height;
			if(parent != null)
			{
				parent.addChild(res);
			}
			if(itemData != null)
			{
				if(itemData is int)
				{
					res.itemData = new ItemData(itemData);
				}
				else if(itemData is ItemData)
				{
					res.itemData = itemData as ItemData;
				}
			}
			return res;
		}
		
		public static function pointProcessBar(x:int, y:int, width:int, height:int, parent:DisplayObjectContainer=null, 
			bgName:String="PetLifeBg", pointName:String="GreenProcessPoint", maxNum:int=5):PointProcessBar
		{
			var res:PointProcessBar = UICompomentPool.getUICompoment(PointProcessBar);
			res.setParams(bgName, pointName, width, height, maxNum);
			res.x = x;
			res.y = y;
			if(parent)
			{
				parent.addChild(res);
			}
			return res;
		}
		
		/**
		 * 从0-9,()-+这14个字符的美术字 
		 * @param x
		 * @param y
		 * @param urlName 图片资源的名称，如："EquipmentTipsNumber.png"
		 * @param cellWidth 切割的时候每个数字的宽度
		 * @param cellHeight 切割的时候每个数字的高度
		 * @param gap 使用的时候，2个字之间的间隔， 例如：cellWidth = 30， gap=-2， 那么实际上2个字的间隔是：30 + (-2) = 28
		 * @param parent
		 * @return 
		 * 
		 */		
		public static function bitmapNumberText(x:int, y:int, urlName:String, cellWidth:int, cellHeight:int, 
												gap:int=2, parent:DisplayObjectContainer=null,picNum:int = 13):BitmapNumberText
		{
			var res:BitmapNumberText = UICompomentPool.getUICompoment(BitmapNumberText);
			res.picNum = picNum;
			res.setSytleName(urlName, cellWidth, cellHeight, gap);
			res.x = x;
			res.y = y;
			if(parent)
			{
				parent.addChild(res);
			}
			return res;
		}
		
		/**
		 * 消耗品列表 
		 * @param lable  标题
		 * @param x  
		 * @param y
		 * @param gapWide  消耗品之间的间距
		 * @param parent
		 * @return 
		 * 
		 */		
		public static function gConsumeBox(lable:String,x:int,y:int,gapWide:int = 60,parent:DisplayObjectContainer=null):GConsumeBox
		{
			var box:GConsumeBox = UICompomentPool.getUICompoment(GConsumeBox) as GConsumeBox;
			box.x = x;
			box.y = y;
			box.gapWide = gapWide;
			box.label = lable;
			if(parent)
			{
				parent.addChild(box);
			}
			return box;
				
		}
		
//		/**
//		 * 创建一个金钱底板文本  
//		 * @param text
//		 * @param x
//		 * @param y
//		 * @param width
//		 * @param height
//		 * @param parent
//		 * @param textFormat
//		 * @param useHtml
//		 * @param mouseWheelEnabled
//		 * @return 
//		 * 
//		 */		
//		public static function createTextBox( text:String='', x:Number = 0,y:Number = 0,width:Number = 200,height:Number = 20,parent:DisplayObjectContainer = null,textFormat:TextFormat = null,useHtml:Boolean=false,mouseWheelEnabled:Boolean=true ):TextBox
//		{
//			var textbox:TextBox = UICompomentPool.getUICompoment( TextBox ) as TextBox;
//			textbox.x = x;
//			textbox.y = y;
//			textbox.textFieldHeight = height;
//			textbox.textFieldWidth = width;
//			textbox.bgHeight = height;
//			textbox.bgWidth = width;
//			textbox.defaultTextFormat = textFormat?textFormat:GlobalStyle.textFormat1;
//			if( useHtml )
//			{
//				textbox.htmlText = text;
//			}
//			else
//			{
//				textbox.label = text;
//			}
//			if( parent )
//			{
//				parent.addChild( textbox );
//			}
//			if(!mouseWheelEnabled)
//			{
//				textbox.textField.mouseWheelEnabled = false;
//			}
//			return textbox;
//		}
		
//		/**
//		 * 创建角色血条、魔法条一样的进度条
//		 * @param x
//		 * @param y
//		 * @param width
//		 * @param height
//		 * @param parent
//		 * @param barStyle 默认值为蓝色的魔法条， 参考：ProgressBarStyle 
//		 * @return 
//		 * 
//		 */			
//		public static function createProgressBar(x:Number = 0,y:Number = 0,width:Number = 200,height:Number = 20, 
//			parent:DisplayObjectContainer=null, barStyle:String="Mofatiao"):ProgressBase
//		{
//			var bar:ProgressBase = UICompomentPool.getUICompoment( ProgressBase ) as ProgressBase;
//			bar.x = x;
//			bar.y = y;
//			bar.width = width;
//			bar.height = height;
//			bar.progressBarClass = barStyle;
//			bar.setValue(0, 100);
//			if(parent != null)
//			{
//				parent.addChild(bar);
//			}
//			return bar;
//		}
	}
}
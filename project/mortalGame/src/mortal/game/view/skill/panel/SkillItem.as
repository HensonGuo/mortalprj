/**
 * 2014-1-16
 * @author chenriji
 **/
package mortal.game.view.skill.panel
{
	import com.mui.controls.GBitmap;
	import com.mui.core.GlobalClass;
	
	import mortal.common.DisplayUtil;
	import mortal.game.model.ToolTipInfo;
	import mortal.game.resource.ImagesConst;
	import mortal.game.view.common.UIFactory;
	import mortal.game.view.common.cd.CDDataType;
	import mortal.game.view.common.item.CDItem;
	import mortal.game.view.common.tooltip.TooltipType;
	import mortal.game.view.skill.SkillInfo;
	
	public class SkillItem extends CDItem
	{
		public static const TooltipMode_ShowNext:int = 0;
		public static const TooltipMode_CurOnly:int = 1;
		protected var _toolTipMode:int = 1;
		
		public function SkillItem()
		{
			super();
		}
		
		public function get toolTipMode():int
		{
			return _toolTipMode;
		}
		
		public function set toolTipMode(value:int):void
		{
			_toolTipMode = value;
		}
		
		public override function get toolTipData():*
		{
			if(_toolTipMode == TooltipMode_CurOnly)
			{
				return dragSource;
			}
			else
			{
				if(!(_tooltipData is ToolTipInfo))
				{
					_tooltipData = new ToolTipInfo(TooltipType.SkillShowNext, null);
				}
				(_tooltipData as ToolTipInfo).tooltipData = dragSource;
				return _tooltipData;
			}
			return _tooltipData;
		}
		
		protected override function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			_toolTipMode = TooltipMode_CurOnly;
			_isShowLeftTimeEffect = false;
			_isShowFreezingEffect = false;
			_isShowToolTip = true;
			isDropAble = false;
			isDragAble = false;
		}
		
		public function setBg(bgName:String="shortcutItemBg"):void
		{
			if(bgName == null)
			{
				DisplayUtil.removeMe(_bg);
			}
			else
			{
				if(_bg != null)
				{
					_bg.dispose(true);
					_bg = null;
				}
				
				_bg = UIFactory.bg(-1, -1, _width + 6, _height + 6, null, bgName);
				_bg.setSize(_width + 12, _height + 12);
				this.addChildAt(_bg, 0);
			}
		}
		
		public override function setSize(width:Number, height:Number):void
		{
			super.setSize(width, height);
			if(_bg != null && _bg.parent != null)
			{
				_bg.setSize(_width + 2, _height + 2);
			}
		}
		
		public function set skillInfo(info:SkillInfo):void
		{
			setSkillInfo(info);
		}
		
		public function setSkillInfo(info:SkillInfo):void
		{
			if(info == null)
			{
				super.dragSource = null;
				super.source = null;
				super.updateCDEffect(null, CDDataType.skillInfo);
				return;
			}
			super.dragSource = info;
			super.source = info.tSkill.skillIcon + ".jpg";
			super.updateCDEffect(info, CDDataType.skillInfo);
		}
		
		public function setLocked():void
		{
			super.source = GlobalClass.getBitmap(ImagesConst.Locked);
			super.updateCDEffect(null);
			_isShowLeftTimeEffect = false;
			_isShowFreezingEffect = false;
			super.isShowToolTip = false;
			
		}
	}
}
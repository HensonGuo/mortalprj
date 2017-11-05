/**
 * 2014-3-18
 * @author chenriji
 **/
package mortal.component.processbar
{
	import com.gengine.utils.pools.ObjectPool;
	import com.mui.controls.GLabel;
	import com.mui.controls.GSprite;
	import com.mui.controls.GTextFiled;
	import com.mui.display.ScaleBitmap;
	
	import flash.text.TextFormatAlign;
	
	import mortal.common.DisplayUtil;
	import mortal.component.gLinkText.GLinkText;
	import mortal.game.view.common.UIFactory;
	
	/**
	 * 一点一点的进度的进度条，可以设置label 
	 * @author hdkiller
	 * 
	 */	
	public class PointProcessBar extends GSprite
	{
		private var _bg:ScaleBitmap;
		private var _points:Array = [];
		private var _txt:GTextFiled;
		private var _pBgName:String;
		private var _pWidth:int;
		private var _pHeight:int;
		
		private var _maxNum:int;
		private var _curNum:int;
		
		public function PointProcessBar()
		{
			super();
		}
		
		public function get textField():GTextFiled
		{
			return _txt;
		}
		
		public function set label(str:String):void
		{
			_txt.text = str;
		}
		
		public function setParams(bgName:String, pointName:String, $width:int, $height:int, maxNum:int):void
		{
			_pBgName = pointName;
			DisplayUtil.removeMe(_bg);
			_bg = UIFactory.bg(0, 0, $width, $height, this, bgName);
			_pWidth = ($width - 4)/maxNum;
			_pHeight = $height - 4;
			_maxNum = maxNum;
		}
		
		public function setProcess(curNum:int):void
		{
			_curNum = curNum;
			for(var i:int = 0; i < _curNum; i++)
			{
				getPoint(i);
			}
			delNotUse(_points, i);
			updateLayout();
		}
		
		public function updateLayout():void
		{
			for(var i:int = 0; i < _points.length; i++)
			{
				var p:ScaleBitmap = _points[i];
				p.y = 2;
				p.x = 2 + i*(_pWidth + 1);
			}
			_txt.x = _bg.width + 2;
			_txt.y = (_bg.height - _txt.height)/2;
		}
		
		private function getPoint(index:int):ScaleBitmap
		{
			var res:ScaleBitmap = _points[index];
			if(res == null)
			{
				res = UIFactory.bg(0, 0, _pWidth, _pHeight, this, _pBgName);
				pushUIToDisposeVec(res);
				_points[index] = res;
			}
			return res;
		}
		
		private function delNotUse(arr:Array, usedNum:int):void
		{
			if(arr.length <= usedNum)
			{
				return;
			}
			var tmp:int = usedNum;
			for(var i:int = usedNum; i < arr.length; i++)
			{
				var p:ScaleBitmap = arr[i];
				p.dispose(true);
			}
			if(tmp < i && arr.length >= tmp)
			{
				arr.splice(tmp);
			}
		}
		
		protected override function createDisposedChildrenImpl():void
		{
			super.createDisposedChildrenImpl();
			_txt = UIFactory.gTextField("", 0, 0, 100, 25, this);
		}
		
		protected override function disposeImpl(isReuse:Boolean=true):void
		{
			super.disposeImpl(isReuse);
			if(_bg != null)
			{
				_bg.dispose(isReuse);
				_bg = null;
			}
			for each(var p:ScaleBitmap in _points)
			{
				p.dispose(isReuse);
			}
			_txt.dispose(isReuse);
			_txt = null;
			
			_points = null;
		}
	}
}
package mortal.common.font
{
	public class SmallSizeFontName extends FontName
	{
		public function SmallSizeFontName(fontName:String)
		{
			super(fontName);
		}
		
		override public function getFontSize(size:int):int
		{
			return size - 1;
		}
	}
}
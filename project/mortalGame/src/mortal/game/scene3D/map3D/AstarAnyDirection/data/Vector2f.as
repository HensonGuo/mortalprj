/**
 * 2010-1-12
 * @author chenriji
 **/
package mortal.game.scene3D.map3D.AstarAnyDirection.data
{
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/**
	 * Vector2f
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 10.0
	 */
	public class Vector2f
	{
		public var _x:Number;
		public var _y:Number;
		
		
		public function set x(value:Number):void
		{
			this._x = value;
		}
		
		public function set y(value:Number):void
		{
			this._y = value;
		}
		
		
		public function Vector2f(x:Number=0, y:Number=0)
		{
			this.x = x;
			this.y = y;
		}
		
		public function fromPoint(p:Point):void
		{
			this._x = p.x;
			this._y = p.y;
		}
		
		
		/**
		 * <code>length</code> calculates the magnitude of this vector.
		 * 
		 * @return the length or magnitude of the vector.
		 */
		public function length():Number {
			return Math.sqrt(lengthSquared());
		}
		
		/**
		 * <code>lengthSquared</code> calculates the squared value of the
		 * magnitude of the vector.
		 * 
		 * @return the magnitude squared of the vector.
		 */
		public function lengthSquared():Number
		{
			return this._x * this._x + this._y * this._y;
		}
		
		/**
		 * <code>distanceSquared</code> calculates the distance squared between
		 * this vector and vector v.
		 *
		 * @param v the second vector to determine the distance squared.
		 * @return the distance squared between the two vectors.
		 */
		public function distanceSquared(v:Vector2f):Number
		{
			var dx:Number = this._x - v._x;
			var dy:Number = this._y - v._y;
			return Number (dx * dx + dy * dy);
		}
		
		/**
		 * <code>negate</code> returns the negative of this vector. All values are
		 * negated and set to a new vector.
		 * 
		 * @return the negated vector.
		 */
		public function negate():Vector2f {
			return new Vector2f(-this._x, -this._y);
		}
		
		
		/**
		 * <code>addLocal</code> adds a provided vector to this vector internally,
		 * and returns a handle to this vector for easy chaining of calls. If the
		 * provided vector is null, null is returned.
		 * 
		 * @param vec
		 *            the vector to add to this vector.
		 * @return this
		 */
		public function addLocal(vec:Vector2f):Vector2f {
			if (null == vec) {
				//				logger.warning("Provided vector is null, null returned.");
				return null;
			}
			this._x += vec._x;
			this._y += vec._y;
			return this;
		}
		
		/**
		 * <code>subtract</code> subtracts the values of a given vector from those
		 * of this vector creating a new vector object. If the provided vector is
		 * null, an exception is thrown.
		 * 
		 * @param vec
		 *            the vector to subtract from this vector.
		 * @return the result vector.
		 */
		public function subtract(vec:Vector2f, target:Vector2f):void
		{
			target._x = this._x - vec._x;
			target._y = this._y - vec._y;
		}
		
		
		/**
		 * <code>dot</code> calculates the dot product of this vector with a
		 * provided vector. If the provided vector is null, 0 is returned.
		 * 
		 * @param vec
		 *            the vector to dot with this vector.
		 * @return the resultant dot product of this vector and a given vector.
		 */
		public function dot(vec:Vector2f):Number {
			if (null == vec) {
				//				logger.warning("Provided vector is null, 0 returned.");
				return 0;
			}
			return this._x * vec._x + this._y * vec._y;
		}
		
		/**
		 * 叉乘 
		 * @param vec
		 * @return 
		 * 
		 */		
		public function crossMult(vec:Vector2f):Number
		{
			return this._x*vec._y - this._y*vec._x;
		}
	}
}
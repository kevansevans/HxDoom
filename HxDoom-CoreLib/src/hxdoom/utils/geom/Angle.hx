package hxdoom.utils.geom;

/**
 * Abstract Haxe float that treats it's value as a 360 degree circle. Going over 360 will overflow back to 0, and going below 0 will underflow back to 360.
 * Treat as Haxe float otherwise.
 * @author Kaelan
 */
abstract Angle(Float) to Float from Float from Int
{
	@:dox(hide) public inline function new(_v:Float) {
		this = adjust(_v);
	}
	@:dox(hide) @:op(A + B)
	public inline function add(B:Float) {
		return adjust(this + B);
	}
	@:dox(hide) @:op(A += B)
	public inline function addeq(B:Float) {
		return adjust(this += B);
	}
	@:dox(hide) @:op(A - B)
	public inline function sub(B:Float) {
		return adjust(this - B);
	}
	@:dox(hide) @:op(A -= B)
	public inline function subeq(B:Float) {
		return adjust(this - B);
	}
	@:dox(hide) @:op(A * B)
	public inline function mult(B:Float) {
		return adjust(this * B);
	}
	@:dox(hide) @:op(A *= B)
	public inline function multeq(B:Float) {
		return adjust(this *= B);
	}
	@:dox(hide) @:op(A / B)
	public inline function div(B:Float) {
		return adjust(this / B);
	}
	@:dox(hide) @:op(A /= B)
	public inline function diveq(B:Float) {
		return adjust(this /= B);
	}
	@:dox(hide) @:op(++A)
	public inline function preinc() {
		if (this == 360) this = 0;
		return this;
	}
	@:dox(hide) @:op(A++)
	public inline function postinc() {
		return adjust(this++);
	}
	@:dox(hide) @:op(--A)
	public inline function predec() {
		if (this == 0) this = 360;
		return this;
	}
	@:dox(hide) @:op(A--)
	public inline function postdec() {
		return adjust(this--);
	}
	@:dox(hide) @:op(A >= B)
	public inline function greaterThanAndEqual(_b:Float) {
		return (this > _b || this == _b);
	}
	@:dox(hide) @:op(A <= B)
	public inline function lessThanAndEqual(_b:Float) {
		return (this < _b || this == _b);
	}
	@:dox(hide) @:op(A > B)
	public inline function greaterThan(_b:Float) {
		return (this > _b);
	}
	@:dox(hide) @:op(A < B)
	public inline function lessThan(_b:Float) {
		return (this < _b);
	}
	/**
	 * Returns itself as a Float instead of Angle.
	 * @return
	 */
	public inline function asValue():Float {
		return cast(this, Float);
	}
	/**
	 * Returns itself as a Float and converts to Radians.
	 * @return
	 */
	public inline function toRadians():Float {
		return (this * (Math.PI / 180));
	}
	@:dox(hide) static inline function adjust(_v:Float):Float {
		if (_v > 360) while(_v > 360) _v -= 360;
		if (_v < 0) while(_v < 0) _v += 360;
		return _v;
	}
}
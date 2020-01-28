package hxdoom.abstracts;

/**
 * ...
 * @author Kaelan
 */
abstract Angle(Float) to Float from Float from Int
{
	public inline function new(_v:Float) {
		this = _v;
	}
	@:noCompletion @:op(A + B)
	public inline function add(B:Float) {
		return adjust(this + B);
	}
	@:op(A += B)
	public inline function addeq(B:Float) {
		return adjust(this += B);
	}
	@:op(A - B)
	public inline function sub(B:Float) {
		return adjust(this - B);
	}
	@:op(A -= B)
	public inline function subeq(B:Float) {
		return adjust(this - B);
	}
	@:op(A * B)
	public inline function mult(B:Float) {
		return adjust(this * B);
	}
	@:op(A *= B)
	public inline function multeq(B:Float) {
		return adjust(this *= B);
	}
	@:op(A / B)
	public inline function div(B:Float) {
		return adjust(this / B);
	}
	@:op(A /= B)
	public inline function diveq(B:Float) {
		return adjust(this /= B);
	}
	@:op(++A)
	public inline function preinc() {
		return this;
	}
	@:op(A++)
	public inline function postinc() {
		return adjust(this++);
	}
	@:op(--A)
	public inline function predec() {
		return this;
	}
	@:op(A--)
	public inline function postdec() {
		return adjust(this--);
	}
	@:op(A >= B)
	public inline function greaterThanAndEqual(_b:Float) {
		return (this > _b || this == _b);
	}
	@:op(A <= B)
	public inline function lessThanAndEqual(_b:Float) {
		return (this < _b || this == _b);
	}
	@:op(A > B)
	public inline function greaterThan(_b:Float) {
		return (this > _b);
	}
	@:op(A < B)
	public inline function lessThan(_b:Float) {
		return (this < _b);
	}
	public inline function asValue():Float {
		return cast(this, Float);
	}
	public inline function toRadians():Float {
		return (this * (Math.PI / 180));
	}
	static inline function adjust(_v:Float):Float {
		if (_v > 360) _v -= 360;
		if (_v < 0) _v += 360;
		return _v;
	}
}
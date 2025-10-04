extends Object
## A class with some helper methods
class_name SkunkyHelper


## a is the current value[br]
## b is the target value[br]
## delta is current delta time[br]
## half_life is the amount of seconds until the value goes halfway to the target
static func lerp_smooth(a: float, b: float, delta: float, half_life: float) -> float:
	return lerp(a,b, 1 - pow(2, -delta / half_life));

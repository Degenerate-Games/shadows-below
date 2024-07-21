class_name ColorValue

var value: int:
  get:
    return value
  set(val):
    value = clamp(val, 0, 255)

func _init(val: int):
  self.value = val

func increment():
  self.value += 1

func decrement():
  self.value -= 1

func add(val: int):
  self.value += val

func subtract(val: int):
  self.value -= val

func invert():
  return ColorValue.new(255 - self.value)

func normalize():
  return remap(self.value, 0.0, 255.0, 0.25, 1.0)

func normalize_with_max(cmax: int):
  return remap(self.value, 0.0, cmax, 0.25, 1.0)
